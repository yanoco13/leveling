package com.levelog.arena.domain.task.dto;

import java.util.UUID;
import java.time.LocalDateTime;

public record TaskResponse(UUID id, String title, String category, LocalDateTime createdAt) {
}
