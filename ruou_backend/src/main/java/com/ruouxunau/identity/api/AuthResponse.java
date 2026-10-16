package com.ruouxunau.identity.api;

import java.time.Instant;

public record AuthResponse(
        String tokenType,
        String accessToken,
        Instant accessTokenExpiresAt,
        UserResponse user) {
}
