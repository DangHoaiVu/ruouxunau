package com.ruouxunau.identity.service;

import com.ruouxunau.identity.api.UserResponse;

import java.time.Instant;

public record IssuedSession(
        String accessToken,
        Instant accessTokenExpiresAt,
        String refreshToken,
        Instant refreshTokenExpiresAt,
        UserResponse user) {
}
