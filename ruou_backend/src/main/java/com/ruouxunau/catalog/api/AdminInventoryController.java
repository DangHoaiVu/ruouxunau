package com.ruouxunau.catalog.api;

import com.ruouxunau.shared.audit.AuditService;
import com.ruouxunau.shared.exception.BadRequestException;
import com.ruouxunau.shared.exception.ResourceNotFoundException;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/admin/inventory")
@PreAuthorize("hasAuthority('CATALOG_MANAGE')")
public class AdminInventoryController {
    private final JdbcTemplate jdbc;
    private final AuditService audit;
    private final Clock clock;

    public AdminInventoryController(JdbcTemplate jdbc, AuditService audit, Clock clock) {
        this.jdbc = jdbc;
        this.audit = audit;
        this.clock = clock;
    }

    @GetMapping("/variants")
    @Transactional(readOnly = true)
    public List<VariantStock> variants() {
        return jdbc.query("""
                SELECT v.id, v.sku, v.stock_quantity, p.id AS product_id, p.name AS product_name
                FROM product_variants v JOIN products p ON p.id = v.product_id
                WHERE v.deleted_at IS NULL AND p.deleted_at IS NULL
                ORDER BY p.name, v.volume_ml, v.id
                """, (rs, ignored) -> new VariantStock(
                rs.getString("id"), rs.getString("product_id"), rs.getString("product_name"),
                rs.getString("sku"), rs.getInt("stock_quantity")));
    }

    @GetMapping("/variants/{id}/movements")
    @Transactional(readOnly = true)
    public List<Movement> movements(@PathVariable String id) {
        return jdbc.query("""
                SELECT id, delta, balance_after, reason, actor_id, movement_type, created_at
                FROM inventory_movements WHERE variant_id = ?
                ORDER BY id DESC LIMIT 50
                """, (rs, ignored) -> new Movement(
                rs.getLong("id"), rs.getInt("delta"), rs.getInt("balance_after"),
                rs.getString("reason"), rs.getString("actor_id"), rs.getString("movement_type"),
                rs.getTimestamp("created_at").toInstant()), id);
    }

    @PostMapping("/variants/{id}/adjustments")
    @Transactional
    public VariantStock adjust(@AuthenticationPrincipal Jwt jwt, @PathVariable String id,
                               @Valid @RequestBody Adjustment request) {
        VariantStock before = jdbc.query("""
                SELECT v.id, v.sku, v.stock_quantity, p.id AS product_id, p.name AS product_name
                FROM product_variants v JOIN products p ON p.id = v.product_id
                WHERE v.id = ? AND v.deleted_at IS NULL AND p.deleted_at IS NULL
                FOR UPDATE
                """, rs -> rs.next() ? new VariantStock(
                rs.getString("id"), rs.getString("product_id"), rs.getString("product_name"),
                rs.getString("sku"), rs.getInt("stock_quantity")) : null, id);
        if (before == null) {
            throw new ResourceNotFoundException("VARIANT_NOT_FOUND", "Không tìm thấy biến thể sản phẩm");
        }
        int updatedStock = checkedBalance(before.stock(), request.delta());
        jdbc.update("""
                UPDATE product_variants
                SET stock_quantity = ?, version = version + 1, updated_at = ?
                WHERE id = ?
                """, updatedStock, clock.instant(), id);
        jdbc.update("""
                INSERT INTO inventory_movements
                    (variant_id, delta, balance_after, reason, actor_id, movement_type, created_at)
                VALUES (?, ?, ?, ?, ?, 'ADJUSTMENT', ?)
                """, id, request.delta(), updatedStock, request.reason().trim(), jwt.getSubject(), clock.instant());
        VariantStock after = new VariantStock(id, before.productId(), before.productName(), before.sku(), updatedStock);
        audit.record(jwt.getSubject(), "INVENTORY_ADJUSTED", "PRODUCT_VARIANT", id,
                Map.of("stock", before.stock()), Map.of("stock", updatedStock, "delta", request.delta(),
                        "reason", request.reason().trim()));
        return after;
    }

    static int checkedBalance(int current, int delta) {
        if (delta == 0) {
            throw new BadRequestException("INVALID_STOCK_DELTA", "Số lượng điều chỉnh phải khác 0");
        }
        long balance = (long) current + delta;
        if (balance < 0 || balance > Integer.MAX_VALUE) {
            throw new BadRequestException("INVALID_STOCK_BALANCE", "Tồn sau điều chỉnh không hợp lệ");
        }
        return (int) balance;
    }

    public record Adjustment(@NotNull Integer delta, @NotBlank @Size(min = 5, max = 255) String reason) {}
    public record VariantStock(String id, String productId, String productName, String sku, int stock) {}
    public record Movement(long id, int delta, int balanceAfter, String reason, String actorId,
                           String movementType, Instant createdAt) {}
}
