package com.levelog.arena.domain.task.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record TaskRequest(String title, String category, LocalDateTime startDate,
        LocalDateTime endDate) {
}
