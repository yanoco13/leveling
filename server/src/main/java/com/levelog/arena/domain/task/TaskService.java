package com.levelog.arena.domain.task;

import com.levelog.arena.domain.reward.Reward;
import com.levelog.arena.domain.status.Status;
import com.levelog.arena.domain.status.StatusService;
import com.levelog.arena.domain.task.dto.CreateTaskRequest;
import com.levelog.arena.domain.task.dto.TaskResponse;
import com.levelog.arena.domain.task.dto.UpdateTaskRequest;
import com.levelog.arena.repo.TaskRepo;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.ZonedDateTime;
import java.util.List;

@Service
public class TaskService {

        private final TaskRepo taskRepo;
        private final TaskRewardPolicy rewardPolicy;
        private final StatusService statusService;

        public TaskService(TaskRepo taskRepo, TaskRewardPolicy rewardPolicy,
                        StatusService statusService) {
                this.taskRepo = taskRepo;
                this.rewardPolicy = rewardPolicy;
                this.statusService = statusService;
        }

        public List<TaskResponse> findAll(String userId) {
                return taskRepo.findByUserId(userId).stream()
                                .map(t -> new TaskResponse(t.getId(), t.getUserId(), t.getTitle(),
                                                t.getCategory(), t.getStartDate(), t.getEndDate(),
                                                t.isDeleteFlg(), t.isDone(), t.getCreateTime()))
                                .toList();
        }

        public TaskResponse findById(Integer id, String userId) {
                Task task = taskRepo.findByIdAndUserId(id, userId)
                                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                                                "Task not found"));
                return new TaskResponse(task.getId(), task.getUserId(), task.getTitle(),
                                task.getCategory(), task.getStartDate(), task.getEndDate(),
                                task.isDeleteFlg(), task.isDone(), task.getCreateTime());
        }

        public TaskResponse create(CreateTaskRequest req, String userId) {
                Task task = new Task(req.title(), req.category(), req.startDate(), req.endDate(),
                                req.isDeleteFlg(), req.isDone());
                task.setUserId(userId);

                Task saved = taskRepo.save(task);
                return new TaskResponse(saved.getId(), saved.getUserId(), saved.getTitle(),
                                saved.getCategory(), saved.getStartDate(), saved.getEndDate(),
                                saved.isDeleteFlg(), saved.isDone(), saved.getCreateTime());
        }

        public TaskResponse update(Integer id, UpdateTaskRequest req, String userId) {
                Task task = taskRepo.findByIdAndUserId(id, userId)
                                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                                                "Task not found"));

                task.setTitle(req.title());
                task.setCategory(req.category());
                task.setStartDate(req.startDate());
                task.setEndDate(req.endDate());
                task.setDeleteFlg(Boolean.TRUE.equals(req.isDeleteFlg()));
                task.setDone(Boolean.TRUE.equals(req.isDone()));
                task.setUpdateTime(ZonedDateTime.now());

                Task saved = taskRepo.save(task);
                return new TaskResponse(saved.getId(), saved.getUserId(), saved.getTitle(),
                                saved.getCategory(), saved.getStartDate(), saved.getEndDate(),
                                saved.isDeleteFlg(), saved.isDone(), saved.getCreateTime());
        }

        // @Transactional
        // public void completeTask(Integer taskId, String userId) {
        // Task task = taskRepo.findByIdAndUserId(taskId, userId)
        // .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
        // "Task not found"));

        // if (task.isDone())
        // return;

        // Status status = statusService.getOrCreateEntity(userId);

        // task.setDone(true);
        // task.setUpdateTime(ZonedDateTime.now());

        // Reward reward = rewardPolicy.calculate(task);
        // System.out.println("reward=" + reward); // RewardがrecordならtoString出る
        // status.applyReward(reward);
        // System.out.println(
        // "after apply str=" + status.getStr() + " agi=" + status.getAgi());

        // status.applyReward(reward);
        // }

        @Transactional
        public void completeTask(Integer taskId, String userId) {
                Task task = taskRepo.findByIdAndUserId(taskId, userId)
                                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                                                "Task not found"));

                if (task.isDone())
                        return;

                // ✅ 1ユーザー1行を取得（無ければ初回だけ作成）
                Status status = statusService.getOrCreateEntity(userId);

                // ✅ タスク完了
                task.setDone(true);
                task.setUpdateTime(ZonedDateTime.now());

                // ✅ 報酬加算（UPDATEで積み上げ）
                Reward reward = rewardPolicy.calculate(task);
                status.applyReward(reward);

                // ✅ 切り分け期間は明示saveでもOK（安定したら消してOK）
                // taskRepo.save(task);
                // statusRepo.save(status);
        }
}
