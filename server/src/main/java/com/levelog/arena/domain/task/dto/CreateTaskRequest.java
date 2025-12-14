package com.levelog.arena.domain.task.dto;

import java.time.ZonedDateTime;

public record CreateTaskRequest(String title, String category, ZonedDateTime startDate,
                ZonedDateTime endDate, Boolean isDeleteFlg, Boolean isDone) {
}
