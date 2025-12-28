package com.levelog.arena.repo;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.levelog.arena.domain.master.MasterItem;

public interface MasterItemRepo extends JpaRepository<MasterItem, Long> {
    List<MasterItem> findByMasterTypeIdAndIsActiveTrueOrderBySortOrder(Long masterTypeId);
}

