package com.levelog.arena.domain.task;

import java.time.ZonedDateTime;
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
    private ZonedDateTime startDate;
    private ZonedDateTime endDate;
    private boolean isDone = false;
    private ZonedDateTime createTime = ZonedDateTime.now();
    private ZonedDateTime updateTime = ZonedDateTime.now();

    public Task() {}

    public Task(String title, String category, ZonedDateTime startDate, ZonedDateTime endDate,
            boolean isDone) {
        this.title = title;
        this.category = category;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isDone = isDone;
    }

    // getter
    public Integer getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public ZonedDateTime getStartDate() {
        return startDate;
    }

    public ZonedDateTime getEndDate() {
        return endDate;
    }

    public String getCategory() {
        return category;
    }

    public ZonedDateTime getCreateTime() {
        return createTime;
    }

    public ZonedDateTime getUpdateTime() {
        return updateTime;
    }

    public boolean isDone() {
        return isDone;
    }

    // setter
    public void setTitle(String title) {
        this.title = title;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setStartDate(ZonedDateTime startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(ZonedDateTime endDate) {
        this.endDate = endDate;
    }

    public void setCreateTime(ZonedDateTime createTime) {
        this.createTime = createTime;
    }

    public void setUpdateTime(ZonedDateTime updateTime) {
        this.updateTime = updateTime;
    }

    public void setDone(boolean done) {
        isDone = done;
    }
}
