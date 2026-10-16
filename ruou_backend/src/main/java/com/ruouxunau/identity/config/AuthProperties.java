package com.ruouxunau.identity.config;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

import java.time.Duration;

@Validated
@ConfigurationProperties("app.auth")
public record AuthProperties(
        @NotBlank String issuer,
        @NotBlank @Size(min = 32) String jwtSecret,
        @NotNull Duration accessTokenTtl,
        @NotNull Duration refreshTokenTtl,
        @NotBlank String refreshCookieName,
        boolean secureCookie,
        @Min(3) int loginMaxFailures,
        @NotNull Duration loginLockDuration,
        @NotNull Duration passwordResetTtl,
        @NotBlank String passwordResetUrl,
        String mailFrom) {
}
