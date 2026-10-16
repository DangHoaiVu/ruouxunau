package com.ruouxunau.order.service;

import com.ruouxunau.order.api.CreateOrderRequest;
import com.ruouxunau.order.api.OrderResponse;
import com.ruouxunau.order.domain.OrderStatus;
import com.ruouxunau.shared.audit.AuditService;
import com.ruouxunau.shared.exception.BadRequestException;
import com.ruouxunau.shared.exception.ConflictException;
import com.ruouxunau.shared.exception.ResourceNotFoundException;
import com.ruouxunau.shared.persistence.IdGenerator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

@Service
public class OrderService {

    private static final DateTimeFormatter ORDER_DATE = DateTimeFormatter.ofPattern("yyyyMMdd").withZone(ZoneOffset.UTC);
    private final JdbcTemplate jdbc;
    private final AuditService audit;
    private final Clock clock;

    public OrderService(JdbcTemplate jdbc, AuditService audit, Clock clock) {
        this.jdbc = jdbc;
        this.audit = audit;
        this.clock = clock;
    }

    @Transactional
    public OrderResponse create(String userId, CreateOrderRequest request) {
        UserSnapshot user = jdbc.query("SELECT email FROM users WHERE id = ? AND status = 'ACTIVE'",
                rs -> rs.next() ? new UserSnapshot(rs.getString("email")) : null, userId);
        if (user == null) throw new ResourceNotFoundException("USER_NOT_FOUND", "Không tìm thấy tài khoản đang hoạt động");

        Map<String, Integer> quantities = new TreeMap<>();
        for (CreateOrderRequest.Item item : request.items()) {
            quantities.merge(item.variantId(), item.quantity(), Integer::sum);
        }
        if (quantities.values().stream().anyMatch(quantity -> quantity > 100)) {
            throw new BadRequestException("INVALID_ORDER_QUANTITY", "Số lượng của một sản phẩm không được vượt quá 100");
        }

        List<VariantSnapshot> variants = new ArrayList<>();
        BigDecimal subtotal = BigDecimal.ZERO;
        for (Map.Entry<String, Integer> entry : quantities.entrySet()) {
            VariantSnapshot variant = lockVariant(entry.getKey());
            if (variant == null) {
                throw new ResourceNotFoundException("VARIANT_NOT_FOUND", "Một sản phẩm trong giỏ không còn tồn tại");
            }
            if (variant.stock() < entry.getValue()) {
                throw new ConflictException("INSUFFICIENT_STOCK",
                        variant.productName() + " chỉ còn " + variant.stock() + " sản phẩm");
            }
            VariantSnapshot selected = variant.withQuantity(entry.getValue());
            variants.add(selected);
            subtotal = subtotal.add(selected.price().multiply(BigDecimal.valueOf(selected.quantity())));
        }

        Instant now = clock.instant();
        String orderId = IdGenerator.newUlid(clock);
        String orderNumber = "RXN-" + ORDER_DATE.format(now) + "-" + orderId.substring(20);
        jdbc.update("""
                INSERT INTO orders
                    (id, order_number, user_id, customer_name, customer_email, customer_phone,
                     address_detail, ward_name, district_name, province_name, customer_note,
                     subtotal, shipping_fee, total_amount, payment_method, status, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, 'COD', 'NEW', ?, ?)
                """, orderId, orderNumber, userId, request.receiverName().trim(), user.email(), request.phone().trim(),
                request.addressDetail().trim(), request.wardName().trim(), request.districtName().trim(),
                request.provinceName().trim(), blankToNull(request.note()), subtotal, subtotal, now, now);

        for (VariantSnapshot variant : variants) {
            BigDecimal lineTotal = variant.price().multiply(BigDecimal.valueOf(variant.quantity()));
            jdbc.update("""
                    INSERT INTO order_items
                        (id, order_id, product_id, variant_id, sku, product_name, variant_label,
                         image_url, unit_price, quantity, line_total)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """, IdGenerator.newUlid(clock), orderId, variant.productId(), variant.id(), variant.sku(),
                    variant.productName(), variant.volumeMl() + " ml · " + variant.alcoholPercent() + "% vol",
                    variant.imageUrl(), variant.price(), variant.quantity(), lineTotal);
            int balance = variant.stock() - variant.quantity();
            jdbc.update("UPDATE product_variants SET stock_quantity = ?, version = version + 1, updated_at = ? WHERE id = ?",
                    balance, now, variant.id());
            jdbc.update("""
                    INSERT INTO inventory_movements
                        (variant_id, delta, balance_after, reason, actor_id, movement_type, created_at)
                    VALUES (?, ?, ?, ?, ?, 'ORDER_PLACED', ?)
                    """, variant.id(), -variant.quantity(), balance, "Đặt đơn " + orderNumber, userId, now);
        }
        audit.record(userId, "ORDER_CREATED", "ORDER", orderId, null,
                Map.of("orderNumber", orderNumber, "total", subtotal, "itemCount", variants.size()));
        return load(orderId);
    }

    @Transactional(readOnly = true)
    public List<OrderResponse> mine(String userId) {
        return ids("SELECT id FROM orders WHERE user_id = ? AND deleted_at IS NULL ORDER BY created_at DESC", userId)
                .stream().map(this::load).toList();
    }

    @Transactional(readOnly = true)
    public OrderResponse mine(String userId, String orderId) {
        String id = jdbc.query("SELECT id FROM orders WHERE id = ? AND user_id = ? AND deleted_at IS NULL",
                rs -> rs.next() ? rs.getString(1) : null, orderId, userId);
        if (id == null) throw new ResourceNotFoundException("ORDER_NOT_FOUND", "Không tìm thấy đơn hàng");
        return load(id);
    }

    @Transactional(readOnly = true)
    public List<OrderResponse> adminOrders(OrderStatus status, String query) {
        StringBuilder sql = new StringBuilder("SELECT id FROM orders WHERE deleted_at IS NULL");
        List<Object> args = new ArrayList<>();
        if (status != null) { sql.append(" AND status = ?"); args.add(status.name()); }
        if (query != null && !query.isBlank()) {
            sql.append(" AND (order_number LIKE ? OR customer_name LIKE ? OR customer_phone LIKE ?)");
            String value = "%" + query.trim() + "%";
            args.add(value); args.add(value); args.add(value);
        }
        sql.append(" ORDER BY created_at DESC LIMIT 200");
        return jdbc.query(sql.toString(), (rs, ignored) -> rs.getString(1), args.toArray())
                .stream().map(this::load).toList();
    }

    @Transactional(readOnly = true)
    public OrderResponse adminOrder(String id) { return load(id); }

    @Transactional
    public OrderResponse updateStatus(String actorId, String id, OrderStatus next) {
        OrderStatus current = jdbc.query("SELECT status FROM orders WHERE id = ? AND deleted_at IS NULL FOR UPDATE",
                rs -> rs.next() ? OrderStatus.valueOf(rs.getString(1)) : null, id);
        if (current == null) throw new ResourceNotFoundException("ORDER_NOT_FOUND", "Không tìm thấy đơn hàng");
        if (current == next) return load(id);
        if (!allowedNext(current).contains(next)) {
            throw new ConflictException("INVALID_ORDER_TRANSITION",
                    "Không thể chuyển đơn từ " + current + " sang " + next);
        }
        Instant now = clock.instant();
        if (next == OrderStatus.CANCELLED) restoreInventory(actorId, id, now);
        jdbc.update("UPDATE orders SET status = ?, version = version + 1, updated_at = ? WHERE id = ?",
                next.name(), now, id);
        audit.record(actorId, "ORDER_STATUS_CHANGED", "ORDER", id,
                Map.of("status", current.name()), Map.of("status", next.name()));
        return load(id);
    }

    @Transactional
    public void archive(String actorId, String id) {
        OrderResponse before = load(id);
        jdbc.update("UPDATE orders SET deleted_at = ?, updated_at = ? WHERE id = ?", clock.instant(), clock.instant(), id);
        audit.record(actorId, "ORDER_ARCHIVED", "ORDER", id, Map.of("status", before.status().name()), null);
    }

    private void restoreInventory(String actorId, String orderId, Instant now) {
        List<RestoreItem> items = jdbc.query("SELECT variant_id, quantity FROM order_items WHERE order_id = ? ORDER BY variant_id",
                (rs, ignored) -> new RestoreItem(rs.getString(1), rs.getInt(2)), orderId);
        for (RestoreItem item : items) {
            Integer current = jdbc.query("SELECT stock_quantity FROM product_variants WHERE id = ? FOR UPDATE",
                    rs -> rs.next() ? rs.getInt(1) : null, item.variantId());
            if (current == null) continue;
            int balance = Math.addExact(current, item.quantity());
            jdbc.update("UPDATE product_variants SET stock_quantity = ?, version = version + 1, updated_at = ? WHERE id = ?",
                    balance, now, item.variantId());
            jdbc.update("""
                    INSERT INTO inventory_movements
                        (variant_id, delta, balance_after, reason, actor_id, movement_type, created_at)
                    VALUES (?, ?, ?, ?, ?, 'ORDER_CANCELLED', ?)
                    """, item.variantId(), item.quantity(), balance, "Hoàn tồn do hủy đơn " + orderId, actorId, now);
        }
    }

    private VariantSnapshot lockVariant(String id) {
        return jdbc.query("""
                SELECT v.id, v.product_id, v.sku, v.volume_ml, v.alcohol_percent, v.price,
                       v.stock_quantity, p.name, m.url
                FROM product_variants v
                JOIN products p ON p.id = v.product_id
                LEFT JOIN media m ON m.id = p.primary_media_id
                WHERE v.id = ? AND v.deleted_at IS NULL AND v.status = 'ACTIVE'
                  AND p.deleted_at IS NULL AND p.status = 'ACTIVE'
                FOR UPDATE
                """, rs -> rs.next() ? new VariantSnapshot(
                rs.getString("id"), rs.getString("product_id"), rs.getString("sku"),
                rs.getInt("volume_ml"), rs.getBigDecimal("alcohol_percent"), rs.getBigDecimal("price"),
                rs.getInt("stock_quantity"), rs.getString("name"), rs.getString("url"), 0) : null, id);
    }

    private OrderResponse load(String id) {
        OrderRow order = jdbc.query("""
                SELECT id, order_number, user_id, customer_name, customer_email, customer_phone,
                       address_detail, ward_name, district_name, province_name, customer_note,
                       subtotal, shipping_fee, total_amount, payment_method, status, created_at, updated_at
                FROM orders WHERE id = ? AND deleted_at IS NULL
                """, rs -> rs.next() ? new OrderRow(
                rs.getString("id"), rs.getString("order_number"), rs.getString("user_id"),
                rs.getString("customer_name"), rs.getString("customer_email"), rs.getString("customer_phone"),
                rs.getString("address_detail"), rs.getString("ward_name"), rs.getString("district_name"),
                rs.getString("province_name"), rs.getString("customer_note"), rs.getBigDecimal("subtotal"),
                rs.getBigDecimal("shipping_fee"), rs.getBigDecimal("total_amount"), rs.getString("payment_method"),
                OrderStatus.valueOf(rs.getString("status")), rs.getTimestamp("created_at").toInstant(),
                rs.getTimestamp("updated_at").toInstant()) : null, id);
        if (order == null) throw new ResourceNotFoundException("ORDER_NOT_FOUND", "Không tìm thấy đơn hàng");
        List<OrderResponse.Item> items = jdbc.query("""
                SELECT id, product_id, variant_id, sku, product_name, variant_label, image_url,
                       unit_price, quantity, line_total
                FROM order_items WHERE order_id = ? ORDER BY id
                """, (rs, ignored) -> new OrderResponse.Item(
                rs.getString("id"), rs.getString("product_id"), rs.getString("variant_id"), rs.getString("sku"),
                rs.getString("product_name"), rs.getString("variant_label"), rs.getString("image_url"),
                rs.getBigDecimal("unit_price"), rs.getInt("quantity"), rs.getBigDecimal("line_total")), id);
        return order.toResponse(items);
    }

    private List<String> ids(String sql, Object... args) {
        return jdbc.query(sql, (rs, ignored) -> rs.getString(1), args);
    }

    private static EnumSet<OrderStatus> allowedNext(OrderStatus current) {
        return switch (current) {
            case NEW -> EnumSet.of(OrderStatus.CONFIRMED, OrderStatus.CANCELLED);
            case CONFIRMED -> EnumSet.of(OrderStatus.SHIPPING, OrderStatus.CANCELLED);
            case SHIPPING -> EnumSet.of(OrderStatus.COMPLETED);
            case COMPLETED, CANCELLED -> EnumSet.noneOf(OrderStatus.class);
        };
    }

    private static String blankToNull(String value) { return value == null || value.isBlank() ? null : value.trim(); }

    private record UserSnapshot(String email) {}
    private record RestoreItem(String variantId, int quantity) {}
    private record VariantSnapshot(String id, String productId, String sku, int volumeMl,
                                   BigDecimal alcoholPercent, BigDecimal price, int stock,
                                   String productName, String imageUrl, int quantity) {
        VariantSnapshot withQuantity(int value) {
            return new VariantSnapshot(id, productId, sku, volumeMl, alcoholPercent, price, stock, productName, imageUrl, value);
        }
    }
    private record OrderRow(String id, String orderNumber, String userId, String customerName,
                            String customerEmail, String customerPhone, String addressDetail,
                            String wardName, String districtName, String provinceName, String customerNote,
                            BigDecimal subtotal, BigDecimal shippingFee, BigDecimal totalAmount,
                            String paymentMethod, OrderStatus status, Instant createdAt, Instant updatedAt) {
        OrderResponse toResponse(List<OrderResponse.Item> items) {
            return new OrderResponse(id, orderNumber, userId, customerName, customerEmail, customerPhone,
                    addressDetail, wardName, districtName, provinceName, customerNote, subtotal, shippingFee,
                    totalAmount, paymentMethod, status, createdAt, updatedAt, items);
        }
    }
}
