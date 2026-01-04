package com.levelog.arena.domain.tasksession;

import jakarta.persistence.*;
import java.time.ZonedDateTime;

@Entity
@Table(name = "task_sessions")
public class TaskSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "task_id", nullable = false)
    private Integer taskId;

    @Column(name = "user_id", nullable = false)
    private String userId;

    @Column(name = "started_at", nullable = false)
    private ZonedDateTime startedAt;

    @Column(name = "ended_at")
    private ZonedDateTime endedAt;

    @Column(name = "duration_sec", nullable = false)
    private Long durationSec = 0L;

    @Column(name = "create_time", updatable = false)
    private ZonedDateTime createTime;

    @Column(name = "update_time")
    private ZonedDateTime updateTime;

    public TaskSession() {}

    public TaskSession(Integer taskId, String userId, ZonedDateTime startedAt) {
        this.taskId = taskId;
        this.userId = userId;
        this.startedAt = startedAt;
    }

    @PrePersist
    void onCreate() {
        createTime = ZonedDateTime.now();
        updateTime = createTime;
    }

    @PreUpdate
    void onUpdate() {
        updateTime = ZonedDateTime.now();
    }

    public boolean isRunning() {
        return endedAt == null;
    }

    // getter/setter（必要分だけ）
    public Long getId() {
        return id;
    }

    public Integer getTaskId() {
        return taskId;
    }

    public String getUserId() {
        return userId;
    }

    public ZonedDateTime getStartedAt() {
        return startedAt;
    }

    public ZonedDateTime getEndedAt() {
        return endedAt;
    }

    public Long getDurationSec() {
        return durationSec;
    }

    public void stop(ZonedDateTime endedAt, long durationSec) {
        this.endedAt = endedAt;
        this.durationSec = durationSec;
    }
}
