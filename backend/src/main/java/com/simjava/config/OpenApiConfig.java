package com.simjava.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;
import java.util.List;

@Configuration
public class OpenApiConfig {
    
    @Value("${app.name:Sistem Manajemen Sekolah}")
    private String appName;
    
    @Value("${app.version:1.0.0}")
    private String appVersion;
    
    @Value("${server.servlet.context-path:/api}")
    private String contextPath;
    
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title(appName + " API Documentation")
                        .version(appVersion)
                        .description("API Documentation for Sistem Manajemen Sekolah (School Management System)")
                        .contact(new Contact()
                                .name("SIM Java Development Team")
                                .email("support@simjava.com")
                                .url("https://simjava.com"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("https://www.apache.org/licenses/LICENSE-2.0")))
                .servers(getServers())
                .components(new Components()
                        .addSecuritySchemes("bearerAuth", new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")
                                .description("JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"")))
                .addSecurityItem(new SecurityRequirement().addList("bearerAuth"));
    }
    
    private List<Server> getServers() {
        Server localServer = new Server()
                .url(contextPath)
                .description("Local Server");
        
        Server devServer = new Server()
                .url("https://dev-api.simjava.com" + contextPath)
                .description("Development Server");
        
        Server prodServer = new Server()
                .url("https://api.simjava.com" + contextPath)
                .description("Production Server");
        
        return Arrays.asList(localServer, devServer, prodServer);
    }
} 