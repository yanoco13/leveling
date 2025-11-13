package com.levelog.arena.web;

import com.levelog.arena.domain.task.TaskService;
import com.levelog.arena.domain.task.dto.TaskRequest;
import com.levelog.arena.domain.task.dto.TaskResponse;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {
    private final TaskService service;

    public TaskController(TaskService service) {
        this.service = service;
    }

    @GetMapping
    public List<TaskResponse> list() {
        return service.findAll();
    }

    @PostMapping
    public TaskResponse create(@RequestBody TaskRequest req) {
        return service.create(req);
    }
}
