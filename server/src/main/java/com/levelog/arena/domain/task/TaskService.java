package com.levelog.arena.domain.task;

import com.levelog.arena.domain.task.dto.CreateTaskRequest;
import com.levelog.arena.domain.task.dto.TaskRequest;
import com.levelog.arena.domain.task.dto.TaskResponse;
import com.levelog.arena.domain.task.dto.UpdateTaskRequest;
import com.levelog.arena.repo.TaskRepository;
import org.springframework.stereotype.Service;
import java.time.ZonedDateTime;
import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class TaskService {

        private final TaskRepository taskRepository;

        public TaskService(TaskRepository taskRepository) {
                this.taskRepository = taskRepository;
        }

        public List<TaskResponse> findAll() {
                return taskRepository.findAll().stream()
                                .map(t -> new TaskResponse(t.getId(), t.getTitle(), t.getCategory(),
                                                t.getStartDate(), t.getEndDate(), t.isDeleteFlg(),
                                                t.isDone(), t.getCreateTime()))
                                .toList();
        }

        public TaskResponse findById(Integer id) {
                Task task = taskRepository.findById(id)
                                .orElseThrow(() -> new RuntimeException("Task not found"));
                return new TaskResponse(task.getId(), task.getTitle(), task.getCategory(),
                                task.getStartDate(), task.getEndDate(), task.isDeleteFlg(),
                                task.isDone(), task.getCreateTime());
        }

        public TaskResponse create(CreateTaskRequest req) {
                Task task = new Task(req.title(), req.category(), req.startDate(), req.endDate(),
                                req.isDeleteFlg(), req.isDone());
                Task saved = taskRepository.save(task);
                return new TaskResponse(saved.getId(), saved.getTitle(), saved.getCategory(),
                                saved.getStartDate(), saved.getEndDate(), saved.isDeleteFlg(),
                                saved.isDone(), saved.getCreateTime());
        }

        public TaskResponse update(Integer id, UpdateTaskRequest req) {
                Task task = taskRepository.findById(id)
                                .orElseThrow(() -> new RuntimeException("Task not found"));

                task.setTitle(req.title());
                task.setCategory(req.category());
                task.setStartDate(req.startDate());
                task.setEndDate(req.endDate());
                task.setDeleteFlg(Boolean.TRUE.equals(req.isDeleteFlg()));
                task.setDone(Boolean.TRUE.equals(req.isDone()));
                task.setUpdateTime(ZonedDateTime.now());

                Task saved = taskRepository.save(task);

                return new TaskResponse(saved.getId(), saved.getTitle(), saved.getCategory(),
                                saved.getStartDate(), saved.getEndDate(), saved.isDeleteFlg(),
                                saved.isDone(), saved.getCreateTime());
        }

}

