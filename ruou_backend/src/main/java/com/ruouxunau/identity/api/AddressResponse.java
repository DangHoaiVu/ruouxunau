package com.ruouxunau.identity.api;

import com.ruouxunau.identity.domain.AddressEntity;

public record AddressResponse(
        String id,
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

    public static AddressResponse from(AddressEntity address) {
        return new AddressResponse(
                address.getId(), address.getReceiverName(), address.getPhone(),
                address.getProvinceCode(), address.getProvinceName(),
                address.getDistrictCode(), address.getDistrictName(),
                address.getWardCode(), address.getWardName(), address.getDetail(),
                address.isDefaultAddress());
    }
}
