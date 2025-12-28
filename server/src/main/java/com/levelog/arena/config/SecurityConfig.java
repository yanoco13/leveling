package com.levelog.arena.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Value("${SECURITY_DISABLE:false}")
    private boolean securityDisable;

    private final FirebaseJwtDecoder firebaseJwtDecoder;

    public SecurityConfig(FirebaseJwtDecoder firebaseJwtDecoder) {
        this.firebaseJwtDecoder = firebaseJwtDecoder;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        System.out.println("SECURITY_DISABLE=" + securityDisable);

        http.csrf(csrf -> csrf.disable());

        if (securityDisable) {
            // 🔹 無認証モード：すべて許可（ローカル開発用）
            http.authorizeHttpRequests(a -> a.anyRequest().permitAll());
            return http.build();
        }

        // 🔹 認証モード：health だけ公開、それ以外はJWT必須
        http.authorizeHttpRequests(a -> a.requestMatchers("/actuator/health").permitAll()
                .anyRequest().authenticated());

        http.oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.decoder(firebaseJwtDecoder)));

        return http.build();
    }
}
