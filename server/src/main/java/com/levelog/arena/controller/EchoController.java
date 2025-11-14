package com.levelog.arena.controller;

import java.util.Map;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;

@RestController
@RequestMapping("/api") // そのまま
@ConditionalOnProperty(name = "security.disable", havingValue = "true") // 起動確認用のみ有効
public class EchoController {

    @GetMapping("/echo")
    public Map<String, Object> echo(Jwt jwt) {
        return Map.of("sub", jwt != null ? jwt.getSubject() : "anonymous", "ts",
                System.currentTimeMillis());
    }
}
