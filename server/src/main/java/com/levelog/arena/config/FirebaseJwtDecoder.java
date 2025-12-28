package com.levelog.arena.config;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@Component
public class FirebaseJwtDecoder implements JwtDecoder {

    @Override
    public Jwt decode(String token) throws JwtException {
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(token);

            Map<String, Object> headers = Map.of("alg", "RS256", "typ", "JWT");
            Map<String, Object> claims = new HashMap<>(decodedToken.getClaims());

            String uid = decodedToken.getUid();

            // ✅ 追加：Spring Security が name として使えるように subject を入れる
            claims.putIfAbsent("sub", uid);
            // ついでに取りやすい名前でも入れておくと便利
            claims.putIfAbsent("uid", uid);

            Instant issuedAt = Instant.ofEpochSecond(((Number) claims.get("iat")).longValue());
            Instant expiresAt = Instant.ofEpochSecond(((Number) claims.get("exp")).longValue());

            return new Jwt(token, issuedAt, expiresAt, headers, claims);
        } catch (Exception e) {
            throw new JwtException("Firebase token verification failed: " + e.getMessage(), e);
        }
    }
}
