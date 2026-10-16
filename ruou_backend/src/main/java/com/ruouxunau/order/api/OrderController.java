package com.ruouxunau.order.api;

import com.ruouxunau.order.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {
    private final OrderService service;

    public OrderController(OrderService service) { this.service = service; }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    OrderResponse create(@AuthenticationPrincipal Jwt jwt, @Valid @RequestBody CreateOrderRequest request) {
        return service.create(jwt.getSubject(), request);
    }

    @GetMapping
    List<OrderResponse> mine(@AuthenticationPrincipal Jwt jwt) { return service.mine(jwt.getSubject()); }

    @GetMapping("/{id}")
    OrderResponse mine(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        return service.mine(jwt.getSubject(), id);
    }
}
