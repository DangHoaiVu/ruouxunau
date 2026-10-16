CREATE TABLE users (
    id                      CHAR(26)      NOT NULL,
    email                   VARCHAR(254)  NOT NULL,
    password_hash           VARCHAR(100)  NOT NULL,
    full_name               VARCHAR(150)  NOT NULL,
    phone                   VARCHAR(20)   NULL,
    status                  VARCHAR(20)   NOT NULL,
    age_confirmed_at        TIMESTAMP(6)  NOT NULL,
    failed_login_attempts   INT           NOT NULL DEFAULT 0,
    locked_until            TIMESTAMP(6)  NULL,
    version                 BIGINT        NOT NULL DEFAULT 0,
    created_at              TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at              TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_users_email (email),
    INDEX idx_users_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE roles (
    id          CHAR(26)      NOT NULL,
    code        VARCHAR(60)   NOT NULL,
    name        VARCHAR(100)  NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_roles_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE permissions (
    id          CHAR(26)      NOT NULL,
    code        VARCHAR(80)   NOT NULL,
    description VARCHAR(255)  NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_permissions_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE user_roles (
    user_id CHAR(26) NOT NULL,
    role_id CHAR(26) NOT NULL,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE role_permissions (
    role_id       CHAR(26) NOT NULL,
    permission_id CHAR(26) NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE refresh_tokens (
    id                      CHAR(26)      NOT NULL,
    user_id                 CHAR(26)      NOT NULL,
    family_id               CHAR(26)      NOT NULL,
    token_hash              CHAR(64)      NOT NULL,
    replaced_by_token_hash  CHAR(64)      NULL,
    expires_at              TIMESTAMP(6)  NOT NULL,
    revoked_at              TIMESTAMP(6)  NULL,
    last_used_at            TIMESTAMP(6)  NULL,
    created_at              TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_refresh_token_hash (token_hash),
    INDEX idx_refresh_user (user_id),
    INDEX idx_refresh_family (family_id),
    INDEX idx_refresh_expiry (expires_at),
    CONSTRAINT fk_refresh_tokens_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE addresses (
    id              CHAR(26)      NOT NULL,
    user_id         CHAR(26)      NOT NULL,
    receiver_name   VARCHAR(150)  NOT NULL,
    phone           VARCHAR(20)   NOT NULL,
    province_code   VARCHAR(20)   NOT NULL,
    province_name   VARCHAR(100)  NOT NULL,
    district_code   VARCHAR(20)   NOT NULL,
    district_name   VARCHAR(100)  NOT NULL,
    ward_code       VARCHAR(20)   NOT NULL,
    ward_name       VARCHAR(100)  NOT NULL,
    detail          VARCHAR(255)  NOT NULL,
    is_default      BOOLEAN       NOT NULL DEFAULT FALSE,
    version         BIGINT        NOT NULL DEFAULT 0,
    created_at      TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    INDEX idx_addresses_user (user_id),
    CONSTRAINT fk_addresses_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- System reference data, not demo data. IDs are stable across environments.
INSERT INTO roles (id, code, name) VALUES
    ('00000000000000000000000001', 'CUSTOMER', 'Khách hàng'),
    ('00000000000000000000000002', 'ADMIN', 'Quản trị viên');

INSERT INTO permissions (id, code, description) VALUES
    ('10000000000000000000000001', 'ADMIN_ACCESS', 'Truy cập khu vực quản trị'),
    ('10000000000000000000000002', 'USER_MANAGE', 'Quản lý tài khoản và phân quyền'),
    ('10000000000000000000000003', 'CATALOG_MANAGE', 'Quản lý danh mục và sản phẩm'),
    ('10000000000000000000000004', 'INVENTORY_MANAGE', 'Quản lý kho'),
    ('10000000000000000000000005', 'ORDER_MANAGE', 'Quản lý đơn hàng'),
    ('10000000000000000000000006', 'PAYMENT_RECONCILE', 'Đối soát thanh toán'),
    ('10000000000000000000000007', 'PAYMENT_REFUND', 'Hoàn tiền'),
    ('10000000000000000000000008', 'ARTICLE_MANAGE', 'Quản lý và xuất bản bài viết'),
    ('10000000000000000000000009', 'AUDIT_READ', 'Xem nhật ký kiểm toán');

INSERT INTO role_permissions (role_id, permission_id)
SELECT '00000000000000000000000002', id FROM permissions;
