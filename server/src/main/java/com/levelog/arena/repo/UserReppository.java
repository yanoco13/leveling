
package com.levelog.arena.repo;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.levelog.arena.domain.user.User;

public interface UserReppository extends JpaRepository<User, Long> {
    public List<User> findByUserId(String userId);

    public List<User> findAll();

}
