package com.levelog.arena.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
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
        // if (securityDisable) {
        // 🔹 無認証モード：すべて許可
        http.csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(a -> a.anyRequest().permitAll());
        // ★ oauth2ResourceServer(jwt) は設定しない！
        return http.build();
        // }

        // 🔹 認証モード：/actuator/health 以外はJWT必須
        // http.authorizeHttpRequests(
        // a -> a.requestMatchers("/actuator/health").permitAll())
        // .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt ->
        // jwt.decoder(firebaseJwtDecoder)));

        // return http.build();
    }
}
