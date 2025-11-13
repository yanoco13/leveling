package com.levelog.arena.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class MeController {

  @Value("${SECURITY_DISABLE:false}")
  private boolean securityDisable;

  @GetMapping("/me")
  public ResponseEntity<?> me(@AuthenticationPrincipal Jwt jwt) {
    if (securityDisable) {
      // 🔹 無認証モード：ダミー情報を返す
      return ResponseEntity.ok(Map.of("uid", "local-dev", "email", "dev@example.com", "name", "You",
          "mode", "dev-no-auth"));
    }

    if (jwt == null) {
      return ResponseEntity.status(401).body(Map.of("error", "unauthorized"));
    }

    return ResponseEntity.ok(Map.of("uid", jwt.getSubject(), "email", jwt.getClaimAsString("email"),
        "name", jwt.getClaimAsString("name"), "mode", "auth"));
  }
}
