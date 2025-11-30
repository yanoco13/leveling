package com.levelog.arena.domain.task;

import java.time.LocalDateTime;
import com.google.api.client.util.DateTime;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;

@Entity
@Table(name = "tasks")
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String title;
    private String category;
    private LocalDateTime startDate;
    private LocalDateTime endDate;

    private LocalDateTime createTime = LocalDateTime.now();
    private LocalDateTime updateTime = LocalDateTime.now();

    public Task() {}

    public Task(String title, String category, LocalDateTime startDate, LocalDateTime endDate) {
        this.title = title;
        this.category = category;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // getter
    public Integer getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public LocalDateTime getStarTime() {
        return startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public String getCategory() {
        return category;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    // setter
    public void setTitle(String title) {
        this.title = title;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }
}
