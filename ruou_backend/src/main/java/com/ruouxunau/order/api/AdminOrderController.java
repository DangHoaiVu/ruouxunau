package com.ruouxunau.order.api;

import com.ruouxunau.order.domain.OrderStatus;
import com.ruouxunau.order.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/admin/orders")
@PreAuthorize("hasAuthority('ORDER_MANAGE')")
public class AdminOrderController {
    private final OrderService service;

    public AdminOrderController(OrderService service) { this.service = service; }

    @GetMapping
    List<OrderResponse> orders(@RequestParam(required = false) OrderStatus status,
                               @RequestParam(required = false, name = "q") String query) {
        return service.adminOrders(status, query);
    }

    @GetMapping("/{id}")
    OrderResponse order(@PathVariable String id) { return service.adminOrder(id); }

    @PatchMapping("/{id}/status")
    OrderResponse status(@AuthenticationPrincipal Jwt jwt, @PathVariable String id,
                         @Valid @RequestBody UpdateOrderStatusRequest request) {
        return service.updateStatus(jwt.getSubject(), id, request.status());
    }

    @DeleteMapping("/{id}")
    ResponseEntity<Void> archive(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        service.archive(jwt.getSubject(), id);
        return ResponseEntity.noContent().build();
    }
}
