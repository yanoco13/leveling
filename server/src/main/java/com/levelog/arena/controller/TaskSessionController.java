package com.levelog.arena.controller;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.levelog.arena.domain.tasksession.TaskSessionService;
import com.levelog.arena.domain.tasksession.dto.TaskSessionResponse;

@RestController
@RequestMapping("/api")
public class TaskSessionController {

    private final TaskSessionService service;

    public TaskSessionController(TaskSessionService service) {
        this.service = service;
    }

    @PostMapping("/tasks/{taskId}/sessions/start")
    public TaskSessionResponse start(@PathVariable Integer taskId, Authentication auth) {
        String userId = auth.getName();
        return service.start(taskId, userId);
    }

    @PostMapping("/task-sessions/{sessionId}/stop")
    public TaskSessionResponse stop(@PathVariable Long sessionId, Authentication auth) {
        String userId = auth.getName();
        return service.stop(sessionId, userId);
    }

    @GetMapping("/task-sessions/running")
    public TaskSessionResponse running(Authentication auth) {
        String userId = auth.getName();
        return service.getRunning(userId);
    }
}
