package com.levelog.arena.domain.task;

import java.time.LocalDateTime;
import java.util.UUID;

public class Task {
    private UUID id = UUID.randomUUID();
    private String title;
    private String category;
    private LocalDateTime createdAt = LocalDateTime.now();

    public Task(String title, String category) {
        this.title = title;
        this.category = category;
    }

    public UUID getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getCategory() {
        return category;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
