package com.levelog.arena.controller;

import com.levelog.arena.domain.task.TaskService;
import com.levelog.arena.domain.task.dto.CreateTaskRequest;
import com.levelog.arena.domain.task.dto.TaskResponse;
import com.levelog.arena.domain.task.dto.UpdateTaskRequest;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {
    private final TaskService service;

    public TaskController(TaskService service) {
        this.service = service;
    }

    private static String uid(Authentication auth) {
        JwtAuthenticationToken jwt = (JwtAuthenticationToken) auth;
        System.out.println("name=" + auth.getName());
        System.out.println("sub=" + jwt.getToken().getSubject());
        return jwt.getToken().getSubject();
    }

    @GetMapping
    public List<TaskResponse> list(Authentication auth) {
        return service.findAll(uid(auth));
    }

    @PutMapping("/{id}")
    public TaskResponse update(@PathVariable Integer id, @RequestBody UpdateTaskRequest req,
            Authentication auth) {
        return service.update(id, req, uid(auth));
    }

    @PostMapping("/{id}/complete")
    public void complete(@PathVariable Integer id, Authentication auth) {
        service.completeTask(id, uid(auth));
    }

    // @GetMapping
    // public List<TaskResponse> list(Authentication auth) {
    // String userId = auth.getName();
    // return service.findAll(userId); // ユーザーごとに絞る
    // }

    @PostMapping
    public TaskResponse create(@RequestBody CreateTaskRequest req, Authentication auth) {
        JwtAuthenticationToken jwt = (JwtAuthenticationToken) auth;
        String uid = jwt.getToken().getSubject(); // ← sub
        return service.create(req, uid);
    }

    // @PutMapping("/{id}")
    // public TaskResponse update(@PathVariable Integer id, @RequestBody UpdateTaskRequest req,
    // Authentication auth) {
    // String userId = auth.getName();
    // return service.update(id, req, userId); // “自分のタスクか”チェック込み
    // }

    // // ✅ 完了は別エンドポイントにする
    // @PostMapping("/{id}/complete")
    // public void complete(@PathVariable Integer id, Authentication auth) {
    // String userId = auth.getName();
    // System.out.println("###############################");
    // System.out.println(userId);
    // service.completeTask(id, userId);
    // }
}
