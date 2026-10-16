-- Demo commerce flow: COD orders and categorized local media.

ALTER TABLE media
    ADD COLUMN category VARCHAR(20) NOT NULL DEFAULT 'OTHER' AFTER mime_type,
    ADD COLUMN original_filename VARCHAR(255) NULL AFTER category,
    ADD INDEX idx_media_category_created (category, created_at);

UPDATE media m
SET m.category = 'BANNER'
WHERE EXISTS (SELECT 1 FROM site_assets sa WHERE sa.media_id = m.id);

UPDATE media m
SET m.category = 'PRODUCT'
WHERE m.category = 'OTHER' AND (
    EXISTS (SELECT 1 FROM product_images pi WHERE pi.media_id = m.id)
    OR EXISTS (SELECT 1 FROM products p WHERE p.primary_media_id = m.id)
);

UPDATE media m
SET m.category = 'ARTICLE'
WHERE m.category = 'OTHER'
  AND EXISTS (SELECT 1 FROM articles a WHERE a.featured_media_id = m.id);

CREATE TABLE orders (
    id              CHAR(26)      NOT NULL,
    order_number    VARCHAR(30)   NOT NULL,
    user_id         CHAR(26)      NOT NULL,
    customer_name   VARCHAR(150)  NOT NULL,
    customer_email  VARCHAR(254)  NOT NULL,
    customer_phone  VARCHAR(20)   NOT NULL,
    address_detail  VARCHAR(255)  NOT NULL,
    ward_name       VARCHAR(100)  NOT NULL,
    district_name   VARCHAR(100)  NOT NULL,
    province_name   VARCHAR(100)  NOT NULL,
    customer_note   VARCHAR(500)  NULL,
    subtotal        DECIMAL(19,2) NOT NULL,
    shipping_fee    DECIMAL(19,2) NOT NULL DEFAULT 0,
    total_amount    DECIMAL(19,2) NOT NULL,
    payment_method  VARCHAR(20)   NOT NULL DEFAULT 'COD',
    status          VARCHAR(20)   NOT NULL DEFAULT 'NEW',
    version         BIGINT        NOT NULL DEFAULT 0,
    created_at      TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at      TIMESTAMP(6)  NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at      TIMESTAMP(6)  NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_orders_number (order_number),
    INDEX idx_orders_user_created (user_id, created_at),
    INDEX idx_orders_status_created (status, created_at),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users (id),
    CONSTRAINT ck_orders_subtotal CHECK (subtotal >= 0),
    CONSTRAINT ck_orders_shipping CHECK (shipping_fee >= 0),
    CONSTRAINT ck_orders_total CHECK (total_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE order_items (
    id              CHAR(26)      NOT NULL,
    order_id        CHAR(26)      NOT NULL,
    product_id      CHAR(26)      NOT NULL,
    variant_id      CHAR(26)      NOT NULL,
    sku             VARCHAR(80)   NOT NULL,
    product_name    VARCHAR(180)  NOT NULL,
    variant_label   VARCHAR(100)  NOT NULL,
    image_url       VARCHAR(2048) NULL,
    unit_price      DECIMAL(19,2) NOT NULL,
    quantity        INT           NOT NULL,
    line_total      DECIMAL(19,2) NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_order_items_order (order_id),
    INDEX idx_order_items_variant (variant_id),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders (id),
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products (id),
    CONSTRAINT fk_order_items_variant FOREIGN KEY (variant_id) REFERENCES product_variants (id),
    CONSTRAINT ck_order_items_price CHECK (unit_price >= 0),
    CONSTRAINT ck_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT ck_order_items_total CHECK (line_total >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
