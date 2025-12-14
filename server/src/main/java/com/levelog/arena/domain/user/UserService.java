package com.levelog.arena.domain.user;

import java.util.List;
import org.springframework.stereotype.Service;
import com.levelog.arena.repo.UserReppository;

@Service
public class UserService {
    private final UserReppository userReppository;

    public UserService(UserReppository userReppository) {
        this.userReppository = userReppository;
    }

    public List<User> getUsersByUserId(String userId) {
        return userReppository.findByUserId(userId);
    }

    public List<User> getAllUsers() {
        return userReppository.findAll();
    }
}
