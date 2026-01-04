package com.levelog.arena.repo;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.levelog.arena.domain.status.Status;

public interface StatusRepo extends JpaRepository<Status, String> {

}
