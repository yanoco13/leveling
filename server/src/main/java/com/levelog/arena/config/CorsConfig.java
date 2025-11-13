// src/main/java/com/levelog/arena/config/CorsConfig.java
package com.levelog.arena.config;

import org.springframework.context.annotation.*;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry r) {
        r.addMapping("/**").allowedMethods("*").allowedOrigins("http://localhost",
                "http://localhost:3000", "http://localhost:5173");
    }
}
