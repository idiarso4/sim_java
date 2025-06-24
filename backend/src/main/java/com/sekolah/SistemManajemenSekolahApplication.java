package com.sekolah;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaAuditing
@ComponentScan(basePackages = {"com.sekolah", "com.simjava"})
@EnableJpaRepositories(basePackages = "com.simjava.repository")
@EntityScan(basePackages = "com.simjava.domain")
public class SistemManajemenSekolahApplication {

    public static void main(String[] args) {
        SpringApplication.run(SistemManajemenSekolahApplication.class, args);
    }
} 