package com.levelog.arena.domain.task;

import com.levelog.arena.domain.reward.Reward;
import com.levelog.arena.domain.status.Status;
import com.levelog.arena.domain.task.dto.CreateTaskRequest;

import com.levelog.arena.domain.task.dto.TaskResponse;
import com.levelog.arena.domain.task.dto.UpdateTaskRequest;
import com.levelog.arena.repo.StatusRepo;
import com.levelog.arena.repo.TaskRepo;
import com.levelog.arena.repo.UserRepo;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import java.time.ZonedDateTime;
import java.util.*;

@Service
public class TaskService {

        private final TaskRepo taskRepository;

        private final TaskRepo taskRepo;
        private final TaskRewardPolicy rewardPolicy;
        private final StatusRepo statusRepo;

        private final UserRepo userRepo;

        public TaskService(TaskRepo taskRepository, TaskRepo taskRepo, UserRepo userRepo,
                        TaskRewardPolicy rewardPolicy, StatusRepo statusRepo) {
                this.taskRepository = taskRepository;
                this.taskRepo = taskRepo;
                this.userRepo = userRepo;
                this.rewardPolicy = rewardPolicy;
                this.statusRepo = statusRepo;
        }

        public List<TaskResponse> findAll(String userId) {
                return taskRepository.findAll().stream()
                                .map(t -> new TaskResponse(t.getId(), t.getUserId(), t.getTitle(),
                                                t.getCategory(), t.getStartDate(), t.getEndDate(),
                                                t.isDeleteFlg(), t.isDone(), t.getCreateTime()))
                                .toList();
        }

        public TaskResponse findById(Integer id, String userId) {
                Task task = taskRepository.findByIdAndUserId(id, userId)
                                .orElseThrow(() -> new RuntimeException("Task not found"));
                return new TaskResponse(task.getId(), task.getUserId(), task.getTitle(),
                                task.getCategory(), task.getStartDate(), task.getEndDate(),
                                task.isDeleteFlg(), task.isDone(), task.getCreateTime());
        }

        public TaskResponse create(CreateTaskRequest req, String userId) {
                Task task = new Task(req.title(), req.category(), req.startDate(), req.endDate(),
                                req.isDeleteFlg(), req.isDone());
                Task saved = taskRepository.save(task);
                return new TaskResponse(saved.getId(), saved.getUserId(), saved.getTitle(),
                                saved.getCategory(), saved.getStartDate(), saved.getEndDate(),
                                saved.isDeleteFlg(), saved.isDone(), saved.getCreateTime());
        }

        public TaskResponse update(Integer id, UpdateTaskRequest req, String userId) {
                Task task = taskRepository.findByIdAndUserId(id, userId)
                                .orElseThrow(() -> new RuntimeException("Task not found"));

                task.setTitle(req.title());
                task.setCategory(req.category());
                task.setStartDate(req.startDate());
                task.setEndDate(req.endDate());
                task.setDeleteFlg(Boolean.TRUE.equals(req.isDeleteFlg()));
                task.setDone(Boolean.TRUE.equals(req.isDone()));
                task.setUpdateTime(ZonedDateTime.now());

                Task saved = taskRepository.save(task);

                return new TaskResponse(saved.getId(), saved.getUserId(), saved.getTitle(),
                                saved.getCategory(), saved.getStartDate(), saved.getEndDate(),
                                saved.isDeleteFlg(), saved.isDone(), saved.getCreateTime());
        }

        @Transactional
        public void completeTask(Integer taskId, String userId) {
                Task task = taskRepo.findByIdAndUserId(taskId, userId).orElseThrow();

                // 二重完了（＝二重加算）防止
                if (task.isDone())
                        return; // or throw new IllegalStateException("already done");

                // 本当は「タスクがそのユーザーのものか」もチェックしたい（TaskにuserIdが無いのが少し危ない）
                Status status = statusRepo.findById(userId).orElseThrow();

                task.setDone(true);
                task.setUpdateTime(ZonedDateTime.now());

                Reward reward = rewardPolicy.calculate(task);
                status.applyReward(reward);

                // JPAならトランザクション内で自動反映される
        }

}
