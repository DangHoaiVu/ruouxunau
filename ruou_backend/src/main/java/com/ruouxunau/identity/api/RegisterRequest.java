package com.ruouxunau.identity.api;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
        @NotBlank @Email @Size(max = 254) String email,
        @NotBlank @Size(min = 12, max = 72) String password,
        @NotBlank @Size(min = 2, max = 150) String fullName,
        @AssertTrue(message = "Bạn phải xác nhận đã đủ 18 tuổi") boolean ageConfirmed) {
}
