package com.ruouxunau.catalog.api;

import com.ruouxunau.catalog.domain.PublicationStatus;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

public record VariantRequest(
        @NotBlank @Size(max = 26) String productId,
        @NotBlank @Size(max = 80)
        @Pattern(regexp = "[A-Za-z0-9._-]+", message = "SKU chứa ký tự không hợp lệ")
        String sku,
        @Size(max = 80) String barcode,
        @Min(1) int volumeMl,
        @NotNull @DecimalMin("0.00") @DecimalMax("100.00") BigDecimal alcoholPercent,
        @NotNull @DecimalMin("0.00") BigDecimal price,
        @DecimalMin("0.00") BigDecimal comparePrice,
        @Min(0) int weightGram,
        @NotNull PublicationStatus status) {

    @AssertTrue(message = "Giá so sánh phải lớn hơn hoặc bằng giá bán")
    public boolean isComparePriceValid() {
        return comparePrice == null || price == null || comparePrice.compareTo(price) >= 0;
    }
}
