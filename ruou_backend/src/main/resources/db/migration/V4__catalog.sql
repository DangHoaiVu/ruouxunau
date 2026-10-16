-- Catalog schema. This migration contains no sample products or media.

CREATE TABLE categories (
    id          CHAR(26)      NOT NULL,
    name        VARCHAR(120)  NOT NULL,
    slug        VARCHAR(140)  NOT NULL,
    description VARCHAR(500)  NULL,
    status      VARCHAR(20)   NOT NULL,
    sort_order  INT           NOT NULL DEFAULT 0,
    version     BIGINT        NOT NULL DEFAULT 0,
    created_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at  TIMESTAMP(6)  NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_categories_slug (slug),
    INDEX idx_categories_public (status, deleted_at, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE producers (
    id          CHAR(26)      NOT NULL,
    name        VARCHAR(160)  NOT NULL,
    legal_name  VARCHAR(200)  NULL,
    origin      VARCHAR(200)  NULL,
    contact     VARCHAR(1000) NULL,
    status      VARCHAR(20)   NOT NULL,
    version     BIGINT        NOT NULL DEFAULT 0,
    created_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at  TIMESTAMP(6)  NULL,
    PRIMARY KEY (id),
    INDEX idx_producers_status (status, deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE products (
    id                    CHAR(26)      NOT NULL,
    category_id           CHAR(26)      NOT NULL,
    producer_id           CHAR(26)      NULL,
    name                  VARCHAR(180)  NOT NULL,
    slug                  VARCHAR(200)  NOT NULL,
    short_description     VARCHAR(500)  NULL,
    description           TEXT          NOT NULL,
    storage_instructions  VARCHAR(1000) NULL,
    origin                VARCHAR(200)  NULL,
    status                VARCHAR(20)   NOT NULL,
    seo_title             VARCHAR(180)  NULL,
    seo_description       VARCHAR(320)  NULL,
    version               BIGINT        NOT NULL DEFAULT 0,
    created_at            TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at            TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at            TIMESTAMP(6)  NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_products_slug (slug),
    INDEX idx_products_public (status, deleted_at, created_at),
    INDEX idx_products_category (category_id, status, deleted_at),
    INDEX idx_products_producer (producer_id),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories (id),
    CONSTRAINT fk_products_producer FOREIGN KEY (producer_id) REFERENCES producers (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE product_variants (
    id                  CHAR(26)      NOT NULL,
    product_id          CHAR(26)      NOT NULL,
    sku                 VARCHAR(80)   NOT NULL,
    barcode             VARCHAR(80)   NULL,
    volume_ml           INT           NOT NULL,
    alcohol_percent     DECIMAL(5,2)  NOT NULL,
    price               DECIMAL(19,2) NOT NULL,
    compare_price       DECIMAL(19,2) NULL,
    weight_gram         INT           NOT NULL,
    status              VARCHAR(20)   NOT NULL,
    version             BIGINT        NOT NULL DEFAULT 0,
    created_at          TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at          TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at          TIMESTAMP(6)  NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_product_variants_sku (sku),
    UNIQUE KEY uk_product_variants_barcode (barcode),
    INDEX idx_variants_product (product_id, status, deleted_at),
    CONSTRAINT ck_variants_volume CHECK (volume_ml > 0),
    CONSTRAINT ck_variants_alcohol CHECK (alcohol_percent >= 0 AND alcohol_percent <= 100),
    CONSTRAINT ck_variants_price CHECK (price >= 0),
    CONSTRAINT ck_variants_compare_price CHECK (compare_price IS NULL OR compare_price >= price),
    CONSTRAINT ck_variants_weight CHECK (weight_gram > 0),
    CONSTRAINT fk_variants_product FOREIGN KEY (product_id) REFERENCES products (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE media (
    id          CHAR(26)      NOT NULL,
    url         VARCHAR(2048) NOT NULL,
    storage_key VARCHAR(500)  NULL,
    mime_type   VARCHAR(100)  NOT NULL,
    width       INT           NULL,
    height      INT           NULL,
    alt_text    VARCHAR(255)  NOT NULL,
    checksum    CHAR(64)      NULL,
    created_at  TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_media_storage_key (storage_key),
    INDEX idx_media_checksum (checksum),
    CONSTRAINT ck_media_width CHECK (width IS NULL OR width > 0),
    CONSTRAINT ck_media_height CHECK (height IS NULL OR height > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE product_images (
    product_id CHAR(26) NOT NULL,
    media_id   CHAR(26) NOT NULL,
    sort_order INT      NOT NULL DEFAULT 0,
    is_primary BOOLEAN  NOT NULL DEFAULT FALSE,
    PRIMARY KEY (product_id, media_id),
    INDEX idx_product_images_order (product_id, sort_order),
    INDEX idx_product_images_primary (product_id, is_primary),
    CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    CONSTRAINT fk_product_images_media FOREIGN KEY (media_id) REFERENCES media (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
