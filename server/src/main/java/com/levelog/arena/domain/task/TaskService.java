package com.levelog.arena.domain.task;

import com.levelog.arena.domain.task.dto.TaskRequest;
import com.levelog.arena.domain.task.dto.TaskResponse;
import com.levelog.arena.repo.TaskRepository;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class TaskService {

    private final TaskRepository taskRepository;

    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    public List<TaskResponse> findAll() {
        return taskRepository.findAll().stream().map(
                t -> new TaskResponse(t.getId(), t.getTitle(), t.getCategory(), t.getCreateTime()))
                .toList();
    }

    public TaskResponse create(TaskRequest req) {
        Task task = new Task(req.title(), req.category(), req.startDate(), req.endDate());
        Task saved = taskRepository.save(task);
        return new TaskResponse(saved.getId(), saved.getTitle(), saved.getCategory(),
                saved.getCreateTime());
    }
}

