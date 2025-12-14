package com.levelog.arena.domain.user.dto;

import java.time.ZonedDateTime;

public record UserRequest(String id, String displayName, String email, ZonedDateTime createTime,
        ZonedDateTime updateTime) {

}
