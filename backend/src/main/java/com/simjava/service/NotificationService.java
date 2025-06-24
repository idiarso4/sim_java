package com.simjava.service;

import java.util.List;
import java.util.Map;

public interface NotificationService {
    
    /**
     * Send a notification to a single device
     * 
     * @param token FCM token of the device
     * @param title Notification title
     * @param body Notification body
     * @param data Additional data to send with the notification
     * @return True if the notification was sent successfully
     */
    boolean sendNotification(String token, String title, String body, Map<String, String> data);
    
    /**
     * Send a notification to multiple devices
     * 
     * @param tokens List of FCM tokens
     * @param title Notification title
     * @param body Notification body
     * @param data Additional data to send with the notification
     * @return Number of successfully sent notifications
     */
    int sendNotificationToMultipleDevices(List<String> tokens, String title, String body, Map<String, String> data);
    
    /**
     * Send a notification to a topic
     * 
     * @param topic Topic name
     * @param title Notification title
     * @param body Notification body
     * @param data Additional data to send with the notification
     * @return True if the notification was sent successfully
     */
    boolean sendNotificationToTopic(String topic, String title, String body, Map<String, String> data);
    
    /**
     * Subscribe a device to a topic
     * 
     * @param token FCM token of the device
     * @param topic Topic name
     * @return True if the subscription was successful
     */
    boolean subscribeToTopic(String token, String topic);
    
    /**
     * Unsubscribe a device from a topic
     * 
     * @param token FCM token of the device
     * @param topic Topic name
     * @return True if the unsubscription was successful
     */
    boolean unsubscribeFromTopic(String token, String topic);
} 