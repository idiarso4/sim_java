package com.simjava.controller;

import com.simjava.dto.NotificationRequest;
import com.simjava.dto.TokenRegistrationRequest;
import com.simjava.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @PostMapping("/token")
    public ResponseEntity<Map<String, Object>> registerToken(@Valid @RequestBody TokenRegistrationRequest request) {
        boolean success = notificationService.subscribeToTopic(request.getToken(), "all");
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", success);
        response.put("message", success ? "Token registered successfully" : "Failed to register token");
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/send")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> sendNotification(@Valid @RequestBody NotificationRequest request) {
        boolean success = false;
        
        if (request.getToken() != null) {
            // Send to specific device
            success = notificationService.sendNotification(
                    request.getToken(), 
                    request.getTitle(), 
                    request.getBody(), 
                    request.getData());
        } else if (request.getTokens() != null && !request.getTokens().isEmpty()) {
            // Send to multiple devices
            int successCount = notificationService.sendNotificationToMultipleDevices(
                    request.getTokens(), 
                    request.getTitle(), 
                    request.getBody(), 
                    request.getData());
            success = successCount > 0;
        } else if (request.getTopic() != null) {
            // Send to topic
            success = notificationService.sendNotificationToTopic(
                    request.getTopic(), 
                    request.getTitle(), 
                    request.getBody(), 
                    request.getData());
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", success);
        response.put("message", success ? "Notification sent successfully" : "Failed to send notification");
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/topic/subscribe")
    public ResponseEntity<Map<String, Object>> subscribeToTopic(@Valid @RequestBody TokenRegistrationRequest request) {
        boolean success = notificationService.subscribeToTopic(request.getToken(), request.getTopic());
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", success);
        response.put("message", success ? "Subscribed to topic successfully" : "Failed to subscribe to topic");
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/topic/unsubscribe")
    public ResponseEntity<Map<String, Object>> unsubscribeFromTopic(@Valid @RequestBody TokenRegistrationRequest request) {
        boolean success = notificationService.unsubscribeFromTopic(request.getToken(), request.getTopic());
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", success);
        response.put("message", success ? "Unsubscribed from topic successfully" : "Failed to unsubscribe from topic");
        
        return ResponseEntity.ok(response);
    }
} 