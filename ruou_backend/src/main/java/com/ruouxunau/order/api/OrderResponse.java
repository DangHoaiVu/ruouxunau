package com.ruouxunau.order.api;

import com.ruouxunau.order.domain.OrderStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

public record OrderResponse(
        String id,
        String orderNumber,
        String userId,
        String customerName,
        String customerEmail,
        String customerPhone,
        String addressDetail,
        String wardName,
        String districtName,
        String provinceName,
        String customerNote,
        BigDecimal subtotal,
        BigDecimal shippingFee,
        BigDecimal totalAmount,
        String paymentMethod,
        OrderStatus status,
        Instant createdAt,
        Instant updatedAt,
        List<Item> items) {

    public record Item(
            String id,
            String productId,
            String variantId,
            String sku,
            String productName,
            String variantLabel,
            String imageUrl,
            BigDecimal unitPrice,
            int quantity,
            BigDecimal lineTotal) {}
}
