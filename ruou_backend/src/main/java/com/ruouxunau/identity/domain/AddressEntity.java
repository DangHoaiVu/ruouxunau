package com.ruouxunau.identity.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Version;

import java.time.Instant;

@Entity
@Table(name = "addresses")
public class AddressEntity {

    @Id
    @Column(length = 26, nullable = false, updatable = false)
    private String id;

    @Column(name = "user_id", length = 26, nullable = false, updatable = false)
    private String userId;

    @Column(name = "receiver_name", length = 150, nullable = false)
    private String receiverName;

    @Column(length = 20, nullable = false)
    private String phone;

    @Column(name = "province_code", length = 20, nullable = false)
    private String provinceCode;

    @Column(name = "province_name", length = 100, nullable = false)
    private String provinceName;

    @Column(name = "district_code", length = 20, nullable = false)
    private String districtCode;

    @Column(name = "district_name", length = 100, nullable = false)
    private String districtName;

    @Column(name = "ward_code", length = 20, nullable = false)
    private String wardCode;

    @Column(name = "ward_name", length = 100, nullable = false)
    private String wardName;

    @Column(length = 255, nullable = false)
    private String detail;

    @Column(name = "is_default", nullable = false)
    private boolean defaultAddress;

    @Version
    @Column(nullable = false)
    private long version;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected AddressEntity() {
    }

    public AddressEntity(String id, String userId, AddressValues values, Instant now) {
        this.id = id;
        this.userId = userId;
        apply(values, now);
        this.createdAt = now;
    }

    public void update(AddressValues values, Instant now) {
        apply(values, now);
    }

    public void makeDefault(Instant now) {
        defaultAddress = true;
        updatedAt = now;
    }

    public void clearDefault(Instant now) {
        defaultAddress = false;
        updatedAt = now;
    }

    private void apply(AddressValues values, Instant now) {
        receiverName = values.receiverName();
        phone = values.phone();
        provinceCode = values.provinceCode();
        provinceName = values.provinceName();
        districtCode = values.districtCode();
        districtName = values.districtName();
        wardCode = values.wardCode();
        wardName = values.wardName();
        detail = values.detail();
        defaultAddress = values.defaultAddress();
        updatedAt = now;
    }

    public String getId() { return id; }
    public String getUserId() { return userId; }
    public String getReceiverName() { return receiverName; }
    public String getPhone() { return phone; }
    public String getProvinceCode() { return provinceCode; }
    public String getProvinceName() { return provinceName; }
    public String getDistrictCode() { return districtCode; }
    public String getDistrictName() { return districtName; }
    public String getWardCode() { return wardCode; }
    public String getWardName() { return wardName; }
    public String getDetail() { return detail; }
    public boolean isDefaultAddress() { return defaultAddress; }
}
