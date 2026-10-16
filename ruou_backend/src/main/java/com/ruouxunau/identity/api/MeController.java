package com.ruouxunau.identity.api;

import com.ruouxunau.identity.service.AddressService;
import com.ruouxunau.identity.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/v1/me")
public class MeController {

    private final AuthService authService;
    private final AddressService addressService;

    public MeController(AuthService authService, AddressService addressService) {
        this.authService = authService;
        this.addressService = addressService;
    }

    @GetMapping
    UserResponse me(@AuthenticationPrincipal Jwt jwt) {
        return authService.currentUser(jwt.getSubject());
    }

    @PatchMapping
    UserResponse updateMe(@AuthenticationPrincipal Jwt jwt, @Valid @RequestBody UpdateProfileRequest request) {
        return authService.updateProfile(jwt.getSubject(), request);
    }

    @GetMapping("/addresses")
    List<AddressResponse> addresses(@AuthenticationPrincipal Jwt jwt) {
        return addressService.list(jwt.getSubject());
    }

    @PostMapping("/addresses")
    ResponseEntity<AddressResponse> createAddress(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody AddressRequest request) {
        AddressResponse response = addressService.create(jwt.getSubject(), request);
        return ResponseEntity.created(URI.create("/api/v1/me/addresses/" + response.id())).body(response);
    }

    @PatchMapping("/addresses/{addressId}")
    AddressResponse updateAddress(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String addressId,
            @Valid @RequestBody AddressRequest request) {
        return addressService.update(jwt.getSubject(), addressId, request);
    }

    @DeleteMapping("/addresses/{addressId}")
    ResponseEntity<Void> deleteAddress(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable String addressId) {
        addressService.delete(jwt.getSubject(), addressId);
        return ResponseEntity.noContent().build();
    }
}
