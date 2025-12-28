package com.levelog.arena.repo;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.levelog.arena.domain.task.Task;

public interface TaskRepo extends JpaRepository<Task, Long> {
    public List<Task> findAll();

    public Optional<Task> findByIdAndUserId(Integer id, String userId);
}
