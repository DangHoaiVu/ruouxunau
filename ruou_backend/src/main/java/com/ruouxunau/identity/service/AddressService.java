package com.ruouxunau.identity.service;

import com.ruouxunau.identity.api.AddressRequest;
import com.ruouxunau.identity.api.AddressResponse;
import com.ruouxunau.identity.domain.AddressEntity;
import com.ruouxunau.identity.repository.AddressRepository;
import com.ruouxunau.shared.exception.ConflictException;
import com.ruouxunau.shared.exception.ResourceNotFoundException;
import com.ruouxunau.shared.persistence.IdGenerator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Instant;
import java.util.List;

@Service
public class AddressService {

    private static final int MAX_ADDRESSES_PER_USER = 10;

    private final AddressRepository addressRepository;
    private final Clock clock;

    public AddressService(AddressRepository addressRepository, Clock clock) {
        this.addressRepository = addressRepository;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public List<AddressResponse> list(String userId) {
        return addressRepository.findAllByUserIdOrderByDefaultAddressDescCreatedAtDesc(userId).stream()
                .map(AddressResponse::from)
                .toList();
    }

    @Transactional
    public AddressResponse create(String userId, AddressRequest request) {
        long count = addressRepository.countByUserId(userId);
        if (count >= MAX_ADDRESSES_PER_USER) {
            throw new ConflictException(
                    "ADDRESS_LIMIT_REACHED",
                    "Mỗi tài khoản được lưu tối đa " + MAX_ADDRESSES_PER_USER + " địa chỉ");
        }

        Instant now = clock.instant();
        boolean makeDefault = request.defaultAddress() || count == 0;
        if (makeDefault) {
            addressRepository.clearDefaultForUser(userId, now);
        }
        AddressEntity address = new AddressEntity(
                IdGenerator.newUlid(clock), userId,
                new com.ruouxunau.identity.domain.AddressValues(
                        request.receiverName().trim(), request.phone().trim(),
                        request.provinceCode().trim(), request.provinceName().trim(),
                        request.districtCode().trim(), request.districtName().trim(),
                        request.wardCode().trim(), request.wardName().trim(), request.detail().trim(), makeDefault),
                now);
        return AddressResponse.from(addressRepository.save(address));
    }

    @Transactional
    public AddressResponse update(String userId, String addressId, AddressRequest request) {
        AddressEntity existing = loadOwned(userId, addressId);
        Instant now = clock.instant();
        if (request.defaultAddress() && !existing.isDefaultAddress()) {
            addressRepository.clearDefaultForUser(userId, now);
            existing = loadOwned(userId, addressId);
        }
        existing.update(request.toValues(), now);
        return AddressResponse.from(existing);
    }

    @Transactional
    public void delete(String userId, String addressId) {
        AddressEntity address = loadOwned(userId, addressId);
        boolean wasDefault = address.isDefaultAddress();
        addressRepository.delete(address);
        addressRepository.flush();
        if (wasDefault) {
            addressRepository.findAllByUserIdOrderByDefaultAddressDescCreatedAtDesc(userId).stream()
                    .findFirst()
                    .ifPresent(next -> next.makeDefault(clock.instant()));
        }
    }

    private AddressEntity loadOwned(String userId, String addressId) {
        return addressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("ADDRESS_NOT_FOUND", "Không tìm thấy địa chỉ"));
    }
}
