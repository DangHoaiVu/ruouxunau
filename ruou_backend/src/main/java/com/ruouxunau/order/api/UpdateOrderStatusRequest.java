package com.ruouxunau.order.api;

import com.ruouxunau.order.domain.OrderStatus;
import jakarta.validation.constraints.NotNull;

public record UpdateOrderStatusRequest(@NotNull OrderStatus status) {}
