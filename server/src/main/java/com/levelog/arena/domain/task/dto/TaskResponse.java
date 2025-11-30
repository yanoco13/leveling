package com.levelog.arena.domain.task.dto;

import java.time.LocalDateTime;

public record TaskResponse(Integer id, String title, String category, LocalDateTime createdAt) {
}
