package com.levelog.arena.repo;

import com.levelog.arena.domain.tasksession.TaskSession;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TaskSessionRepo extends JpaRepository<TaskSession, Long> {
    Optional<TaskSession> findFirstByUserIdAndEndedAtIsNullOrderByStartedAtDesc(String userId);

    List<TaskSession> findByTaskIdAndUserIdOrderByStartedAtDesc(Integer taskId, String userId);

    Optional<TaskSession> findByIdAndUserId(Long id, String userId);
}
