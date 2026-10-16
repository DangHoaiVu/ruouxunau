-- Baseline migration intentionally contains no demo or seed data.
-- Business tables are introduced by reviewed, forward-only migrations.

CREATE TABLE audit_logs (
    id                  CHAR(26)      NOT NULL,
    actor_id            CHAR(26)      NULL,
    action              VARCHAR(100)  NOT NULL,
    entity_type         VARCHAR(100)  NOT NULL,
    entity_id           VARCHAR(100)  NULL,
    before_json         JSON          NULL,
    after_json          JSON          NULL,
    trace_id            VARCHAR(64)   NOT NULL,
    created_at          TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    INDEX idx_audit_entity (entity_type, entity_id),
    INDEX idx_audit_actor_created (actor_id, created_at),
    INDEX idx_audit_trace (trace_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE idempotency_records (
    id                  CHAR(26)      NOT NULL,
    idempotency_key     VARCHAR(100)  NOT NULL,
    user_id             CHAR(26)      NOT NULL,
    operation           VARCHAR(100)  NOT NULL,
    request_hash        CHAR(64)      NOT NULL,
    response_status     SMALLINT      NULL,
    response_body       JSON          NULL,
    expires_at          TIMESTAMP(6)  NOT NULL,
    created_at          TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_idempotency_scope (user_id, operation, idempotency_key),
    INDEX idx_idempotency_expiry (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

