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
            Instant issuedAt = Instant.ofEpochSecond((long) decodedToken.getClaims().get("iat"));
            Instant expiresAt = Instant.ofEpochSecond((long) decodedToken.getClaims().get("exp"));

            return new Jwt(token, issuedAt, expiresAt, headers, claims);
        } catch (Exception e) {
            throw new JwtException("Firebase token verification failed: " + e.getMessage(), e);
        }
    }
}
