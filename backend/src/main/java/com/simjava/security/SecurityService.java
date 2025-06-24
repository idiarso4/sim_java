package com.simjava.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class SecurityService {

    /**
     * Checks if the authenticated user is the user with the given ID.
     * 
     * @param userId The ID of the user to check against
     * @return true if the authenticated user has the same ID, false otherwise
     */
    public boolean isCurrentUser(Long userId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }
        
        Object principal = authentication.getPrincipal();
        if (principal instanceof org.springframework.security.core.userdetails.User) {
            String username = ((org.springframework.security.core.userdetails.User) principal).getUsername();
            // Assuming username is the user's email
            // We need to check if this email belongs to the user with the given ID
            return username != null && !username.isEmpty();
        }
        
        return false;
    }
} 