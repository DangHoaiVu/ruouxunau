package com.ruouxunau.identity.api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record UpdateProfileRequest(
        @NotBlank @Size(min = 2, max = 150) String fullName,
        @Pattern(regexp = "^(?:\\+84|0)[0-9]{9,10}$", message = "Số điện thoại không hợp lệ") String phone) {
}
