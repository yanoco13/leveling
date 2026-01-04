package com.levelog.arena.domain.tasksession;

import com.levelog.arena.domain.reward.Reward;
import com.levelog.arena.domain.status.Status;
import com.levelog.arena.domain.status.StatusService;
import com.levelog.arena.domain.task.Task;
import com.levelog.arena.domain.task.TaskRewardPolicy;
import com.levelog.arena.domain.tasksession.dto.TaskSessionResponse;
import com.levelog.arena.repo.TaskRepo;
import com.levelog.arena.repo.TaskSessionRepo;
import com.levelog.arena.repo.StatusRepo;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Duration;
import java.time.ZonedDateTime;

@Service
public class TaskSessionService {

    private final TaskRepo taskRepo;
    private final TaskSessionRepo sessionRepo;
    private final TaskRewardPolicy rewardPolicy;
    private final StatusService statusService;
    private final StatusRepo statusRepo;

    public TaskSessionService(TaskRepo taskRepo, TaskSessionRepo sessionRepo,
            TaskRewardPolicy rewardPolicy, StatusService statusService, StatusRepo statusRepo) {
        this.taskRepo = taskRepo;
        this.sessionRepo = sessionRepo;
        this.rewardPolicy = rewardPolicy;
        this.statusService = statusService;
        this.statusRepo = statusRepo;
    }

    @Transactional
    public TaskSessionResponse start(Integer taskId, String userId) {
        // タスクが自分のものか確認
        Task task = taskRepo.findByIdAndUserId(taskId, userId).orElseThrow(
                () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Task not found"));

        // 既に走ってるセッションがあれば弾く（好みで自動停止でもOK）
        sessionRepo.findFirstByUserIdAndEndedAtIsNullOrderByStartedAtDesc(userId).ifPresent(s -> {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Session already running");
        });

        TaskSession session = new TaskSession(task.getId(), userId, ZonedDateTime.now());
        TaskSession saved = sessionRepo.save(session);

        return toDto(saved);
    }

    @Transactional
    public TaskSessionResponse stop(Long sessionId, String userId) {
        TaskSession session = sessionRepo.findByIdAndUserId(sessionId, userId).orElseThrow(
                () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Session not found"));

        if (!session.isRunning())
            return toDto(session);

        // duration確定（サーバ時刻）
        ZonedDateTime ended = ZonedDateTime.now();
        long sec = Math.max(0, Duration.between(session.getStartedAt(), ended).getSeconds());
        session.stop(ended, sec);

        // status加算（1ユーザー1行をUPDATEで積み上げ）
        Task task = taskRepo.findByIdAndUserId(session.getTaskId(), userId).orElseThrow(
                () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Task not found"));

        long minutes = sec / 60;
        Reward reward = rewardPolicy.calculate(task.getCategory(), minutes);

        Status status = statusService.getOrCreateEntity(userId);
        status.applyReward(reward);
        statusRepo.save(status); // ←まずは明示save推奨（安定したらdirty checkingでもOK）

        return toDto(session);
    }

    @Transactional(readOnly = true)
    public TaskSessionResponse getRunning(String userId) {
        TaskSession s = sessionRepo.findFirstByUserIdAndEndedAtIsNullOrderByStartedAtDesc(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "No running session"));
        return toDto(s);
    }

    private TaskSessionResponse toDto(TaskSession s) {
        return new TaskSessionResponse(s.getId(), s.getTaskId(), s.getUserId(), s.getStartedAt(),
                s.getEndedAt(), s.getDurationSec());
    }
}
