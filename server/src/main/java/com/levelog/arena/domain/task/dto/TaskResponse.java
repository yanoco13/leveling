package com.levelog.arena.domain.task.dto;

import java.time.ZonedDateTime;

public record TaskResponse(Integer id, String userId, String title, String category,
        ZonedDateTime startDate, ZonedDateTime endDate, Boolean isDeleteFlg, Boolean isDone,
        ZonedDateTime createdAt) {
}
