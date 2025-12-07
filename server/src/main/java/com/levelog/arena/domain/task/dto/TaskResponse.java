package com.levelog.arena.domain.task.dto;

import java.time.ZonedDateTime;

public record TaskResponse(Integer id, String title, String category, ZonedDateTime startDate,
        ZonedDateTime endDate, Boolean isDone, ZonedDateTime createdAt) {
}
