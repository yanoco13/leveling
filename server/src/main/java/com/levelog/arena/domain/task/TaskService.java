package com.levelog.arena.domain.task;

import com.levelog.arena.domain.task.dto.TaskRequest;
import com.levelog.arena.domain.task.dto.TaskResponse;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class TaskService {
    private final List<Task> tasks = new CopyOnWriteArrayList<>();

    public List<TaskResponse> findAll() {
        return tasks.stream()
                .map(t -> new TaskResponse(t.getId(), t.getTitle(), t.getCategory(), t.getCreatedAt()))
                .toList();
    }

    public TaskResponse create(TaskRequest req) {
        Task task = new Task(req.title(), req.category());
        tasks.add(task);
        return new TaskResponse(task.getId(), task.getTitle(), task.getCategory(), task.getCreatedAt());
    }
}
