package com.simjava.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.io.InputStream;

/**
 * Firebase configuration class.
 * Note: This is a placeholder implementation until the Firebase Admin SDK dependency is properly resolved.
 * The actual initialization of Firebase is commented out to prevent compilation errors.
 */
@Configuration
public class FirebaseConfig {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseConfig.class);

    @Value("${app.firebase.config-file:firebase-service-account.json}")
    private String firebaseConfigPath;

    @Value("${app.firebase.database-url:#{null}}")
    private String firebaseDatabaseUrl;

    @PostConstruct
    public void initialize() {
        try {
            // Load the service account file
            InputStream serviceAccount = new ClassPathResource(firebaseConfigPath).getInputStream();
            logger.info("Firebase configuration file loaded successfully");
            
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                        .setDatabaseUrl(firebaseDatabaseUrl)
                        .build();
                FirebaseApp.initializeApp(options);
                logger.info("Firebase application has been initialized");
            }
        } catch (IOException e) {
            logger.error("Error initializing Firebase: {}", e.getMessage());
        }
    }
} 