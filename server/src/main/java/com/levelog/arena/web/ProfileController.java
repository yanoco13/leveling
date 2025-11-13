package com.levelog.arena.web;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class ProfileController {
    record Avatar(String name, String portraitUrl, int level, String title) {
    }
    record Attributes(int str, int _int, int vit) {
    }
    record AbilityLv(int str, int _int, int vit) {
    }
    record Leveling(AbilityLv abilityLv, int overallLv) {
    }
    record ProfileDto(Avatar avatar, Attributes attributes, Leveling leveling) {
    }

    @GetMapping("/profile")
    public ProfileDto profile() {
        return new ProfileDto(new Avatar("Hero", null, 5, "Adept"), new Attributes(110, 80, 60),
                new Leveling(new AbilityLv(6, 5, 5), 5));
    }
}
