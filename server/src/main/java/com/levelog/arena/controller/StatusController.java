package com.levelog.arena.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import com.levelog.arena.domain.status.StatusService;
import com.levelog.arena.domain.status.dto.StatusReponse;


@Controller
@RequestMapping("/api/status")
public class StatusController {
    private final StatusService statusService;

    public StatusController(StatusService statusService) {
        this.statusService = statusService;
    }

    @GetMapping("/{userId}")
    public StatusReponse getStatus(@PathVariable String userId) {
        return statusService.getOrCreate(userId);
    }

}
