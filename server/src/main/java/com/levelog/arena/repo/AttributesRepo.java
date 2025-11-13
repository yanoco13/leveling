package com.levelog.arena.repo;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import com.levelog.arena.domain.Attributes;

public interface AttributesRepo extends JpaRepository<Attributes, UUID> {
}
