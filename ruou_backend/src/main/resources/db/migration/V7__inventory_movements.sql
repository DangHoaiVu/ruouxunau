-- Keep an auditable history of every stock change. Existing approved quantities
-- become opening balances; no quantity is invented or altered by this migration.
CREATE TABLE inventory_movements (
    id             BIGINT NOT NULL AUTO_INCREMENT,
    variant_id     CHAR(26) NOT NULL,
    delta          INT NOT NULL,
    balance_after  INT NOT NULL,
    reason         VARCHAR(255) NOT NULL,
    actor_id       CHAR(26) NULL,
    movement_type  VARCHAR(20) NOT NULL,
    created_at     TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id),
    INDEX idx_inventory_variant_time (variant_id, id),
    CONSTRAINT fk_inventory_variant FOREIGN KEY (variant_id) REFERENCES product_variants (id),
    CONSTRAINT fk_inventory_actor FOREIGN KEY (actor_id) REFERENCES users (id),
    CONSTRAINT ck_inventory_delta CHECK (delta <> 0),
    CONSTRAINT ck_inventory_balance CHECK (balance_after >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO inventory_movements (variant_id, delta, balance_after, reason, movement_type)
SELECT id, stock_quantity, stock_quantity, 'Tồn đã lưu trước khi mở sổ kho', 'OPENING'
FROM product_variants
WHERE stock_quantity > 0 AND deleted_at IS NULL;
