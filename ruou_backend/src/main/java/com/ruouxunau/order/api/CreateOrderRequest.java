package com.ruouxunau.order.api;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.util.List;

public record CreateOrderRequest(
        @NotEmpty @Size(max = 50) List<@Valid Item> items,
        @NotBlank @Size(min = 2, max = 150) String receiverName,
        @NotBlank @Pattern(regexp = "^(?:\\+84|0)[0-9]{9,10}$") String phone,
        @NotBlank @Size(max = 255) String addressDetail,
        @NotBlank @Size(max = 100) String wardName,
        @NotBlank @Size(max = 100) String districtName,
        @NotBlank @Size(max = 100) String provinceName,
        @Size(max = 500) String note) {

    public record Item(
            @NotBlank @Size(max = 26) String variantId,
            @Min(1) @Max(100) int quantity) {}
}
