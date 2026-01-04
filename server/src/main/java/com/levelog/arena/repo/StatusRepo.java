package com.levelog.arena.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import com.levelog.arena.domain.status.Status;

public interface StatusRepo extends JpaRepository<Status, String> {

}
