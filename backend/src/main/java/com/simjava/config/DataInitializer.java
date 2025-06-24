package com.simjava.config;

import com.simjava.domain.security.User;
import com.simjava.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    @Override
    public void run(String... args) throws Exception {
        if (userRepository.findByEmail("admin@admin.com").isEmpty()) {
            User admin = new User();
            admin.setName("Admin");
            admin.setEmail("admin@admin.com");
            admin.setPassword(passwordEncoder.encode("password"));
            admin.setUserType("admin");
            admin.setRole("super_admin");
            admin.setStatus("aktif");
            userRepository.save(admin);
            log.info("Created ADMIN user");
        }
    }
} 