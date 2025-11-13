package com.levelog.arena.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Configuration
public class FirebaseConfig {

    @Value("${SECURITY_DISABLE:false}")
    private boolean securityDisable;

    @Value("${FIREBASE_CREDENTIALS_JSON_BASE64:}")
    private String firebaseCredentialsBase64;

    @PostConstruct
    public void initFirebase() throws Exception {
        if (securityDisable) {
            // 無認証モードではFirebase初期化をスキップ
            System.out.println("🔥 Firebase init skipped (SECURITY_DISABLE=true)");
            return;
        }

        if (FirebaseApp.getApps().isEmpty()) {
            if (firebaseCredentialsBase64 == null || firebaseCredentialsBase64.isBlank()) {
                throw new IllegalStateException("FIREBASE_CREDENTIALS_JSON_BASE64 not set");
            }

            byte[] jsonBytes = Base64.getDecoder().decode(firebaseCredentialsBase64);
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(
                            GoogleCredentials.fromStream(new ByteArrayInputStream(jsonBytes)))
                    .build();
            FirebaseApp.initializeApp(options);
            System.out.println("✅ Firebase initialized");
        }
    }
}
