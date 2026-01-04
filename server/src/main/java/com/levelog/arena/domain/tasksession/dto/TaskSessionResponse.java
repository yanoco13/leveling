package com.levelog.arena.domain.tasksession.dto;

import java.time.ZonedDateTime;

public record TaskSessionResponse(Long id, Integer taskId, String userId, ZonedDateTime startedAt,
        ZonedDateTime endedAt, Long durationSec) {
}
