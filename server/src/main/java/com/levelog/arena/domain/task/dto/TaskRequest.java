package com.levelog.arena.domain.task.dto;

import java.time.LocalDate;
import java.time.ZonedDateTime;

public record TaskRequest(Integer id, String userId, String title, String category,
                ZonedDateTime startDate, ZonedDateTime endDate, Boolean isDeleteFlg,
                Boolean isDone) {
}
