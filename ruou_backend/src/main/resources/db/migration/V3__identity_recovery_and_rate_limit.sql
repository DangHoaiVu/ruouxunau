CREATE TABLE password_reset_tokens (
    id          CHAR(26)      NOT NULL,
    user_id     CHAR(26)      NOT NULL,
    token_hash  CHAR(64)      NOT NULL,
    expires_at  TIMESTAMP(6)  NOT NULL,
    consumed_at TIMESTAMP(6)  NULL,
    created_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_password_reset_hash (token_hash),
    INDEX idx_password_reset_user (user_id),
    INDEX idx_password_reset_expiry (expires_at),
    CONSTRAINT fk_password_reset_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE auth_rate_limits (
    scope_key          CHAR(64)      NOT NULL,
    window_started_at  TIMESTAMP(6)  NOT NULL,
    attempt_count      INT           NOT NULL,
    updated_at         TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (scope_key),
    INDEX idx_auth_rate_window (window_started_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
