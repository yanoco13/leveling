package com.levelog.arena.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import com.levelog.arena.domain.task.Task;

public interface TaskRepository extends JpaRepository<Task, Long> {
}
