package com.levelog.arena.domain.master.dto;

public record StatusItem(
    String code,
    String label,
    Integer value,
    Integer sortOrder,
    String icon,
    String color
) {}