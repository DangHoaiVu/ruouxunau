-- Presentation fields belong to persisted catalog/CMS records, not to the Angular bundle.
ALTER TABLE products
    ADD COLUMN material VARCHAR(255) NULL AFTER short_description,
    ADD COLUMN badge VARCHAR(80) NULL AFTER material,
    ADD COLUMN featured BOOLEAN NOT NULL DEFAULT FALSE AFTER badge,
    ADD COLUMN tasting_notes JSON NULL AFTER featured;

ALTER TABLE product_variants
    DROP CHECK ck_variants_weight;

ALTER TABLE product_variants
    ADD CONSTRAINT ck_variants_weight CHECK (weight_gram >= 0),
    ADD COLUMN stock_quantity INT NOT NULL DEFAULT 0 AFTER weight_gram,
    ADD CONSTRAINT ck_variants_stock_nonnegative CHECK (stock_quantity >= 0);

ALTER TABLE articles
    ADD COLUMN byline VARCHAR(150) NULL AFTER excerpt,
    ADD COLUMN reading_minutes INT NULL AFTER byline,
    ADD COLUMN featured BOOLEAN NOT NULL DEFAULT FALSE AFTER reading_minutes,
    ADD CONSTRAINT ck_articles_reading_minutes CHECK (reading_minutes IS NULL OR reading_minutes > 0);

CREATE TABLE site_assets (
    asset_key   VARCHAR(100) NOT NULL,
    media_id    CHAR(26) NOT NULL,
    updated_at  TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (asset_key),
    CONSTRAINT fk_site_assets_media FOREIGN KEY (media_id) REFERENCES media (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
