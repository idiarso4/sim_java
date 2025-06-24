package com.simjava.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import javax.annotation.PostConstruct;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Configuration
public class FirebaseConfig {

    @Value("${firebase.credentials.type}")
    private String type;

    @Value("${firebase.credentials.project_id}")
    private String projectId;

    @Value("${firebase.credentials.private_key_id}")
    private String privateKeyId;

    @Value("${firebase.credentials.private_key}")
    private String privateKey;

    @Value("${firebase.credentials.client_email}")
    private String clientEmail;

    @Value("${firebase.credentials.client_id}")
    private String clientId;

    @Value("${firebase.credentials.auth_uri}")
    private String authUri;

    @Value("${firebase.credentials.token_uri}")
    private String tokenUri;

    @Value("${firebase.credentials.auth_provider_x509_cert_url}")
    private String authProviderCertUrl;

    @Value("${firebase.credentials.client_x509_cert_url}")
    private String clientCertUrl;

    @Value("${firebase.database.url}")
    private String databaseUrl;

    @PostConstruct
    public void initializeFirebase() throws IOException {
        String credentialsJson = String.format(
            """
            {
              "type": "%s",
              "project_id": "%s",
              "private_key_id": "%s",
              "private_key": "%s",
              "client_email": "%s",
              "client_id": "%s",
              "auth_uri": "%s",
              "token_uri": "%s",
              "auth_provider_x509_cert_url": "%s",
              "client_x509_cert_url": "%s"
            }
            """,
            type, projectId, privateKeyId, privateKey, clientEmail, clientId,
            authUri, tokenUri, authProviderCertUrl, clientCertUrl
        );

        try (InputStream serviceAccount = new ByteArrayInputStream(credentialsJson.getBytes(StandardCharsets.UTF_8))) {
            FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .setDatabaseUrl(databaseUrl)
                .build();

            FirebaseApp.initializeApp(options);
        }
    }
}
