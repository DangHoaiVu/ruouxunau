package com.ruouxunau.shared.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration(proxyBeanMethods = false)
class WebConfiguration implements WebMvcConfigurer {

    private final CorsProperties corsProperties;
    private final String uploadDirectory;

    WebConfiguration(CorsProperties corsProperties,
                     @Value("${app.media.upload-dir:uploads}") String uploadDirectory) {
        this.corsProperties = corsProperties;
        this.uploadDirectory = uploadDirectory;
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins(corsProperties.allowedOrigins().toArray(String[]::new))
                .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                .allowedHeaders("Authorization", "Content-Type", "Idempotency-Key", "X-Trace-Id")
                .exposedHeaders("X-Trace-Id")
                .allowCredentials(true)
                .maxAge(3600);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String location = java.nio.file.Path.of(uploadDirectory).toAbsolutePath().normalize().toUri().toString();
        registry.addResourceHandler("/uploads/**").addResourceLocations(location);
    }
}

