package com.ruouxunau.identity.domain;

public record AddressValues(
        String receiverName,
        String phone,
        String provinceCode,
        String provinceName,
        String districtCode,
        String districtName,
        String wardCode,
        String wardName,
        String detail,
        boolean defaultAddress) {
}
