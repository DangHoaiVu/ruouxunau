package com.ruouxunau.identity.api;

import com.ruouxunau.identity.domain.AddressValues;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record AddressRequest(
        @NotBlank @Size(max = 150) String receiverName,
        @NotBlank @Pattern(regexp = "^(?:\\+84|0)[0-9]{9,10}$", message = "Số điện thoại không hợp lệ") String phone,
        @NotBlank @Size(max = 20) String provinceCode,
        @NotBlank @Size(max = 100) String provinceName,
        @NotBlank @Size(max = 20) String districtCode,
        @NotBlank @Size(max = 100) String districtName,
        @NotBlank @Size(max = 20) String wardCode,
        @NotBlank @Size(max = 100) String wardName,
        @NotBlank @Size(max = 255) String detail,
        boolean defaultAddress) {

    public AddressValues toValues() {
        return new AddressValues(
                receiverName.trim(), phone.trim(), provinceCode.trim(), provinceName.trim(),
                districtCode.trim(), districtName.trim(), wardCode.trim(), wardName.trim(),
                detail.trim(), defaultAddress);
    }
}
