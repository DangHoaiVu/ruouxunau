package com.ruouxunau.identity.api;

import com.ruouxunau.identity.config.AuthProperties;
import com.ruouxunau.identity.service.AuthService;
import com.ruouxunau.identity.service.IssuedSession;
import com.ruouxunau.identity.service.PasswordResetService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;
    private final AuthProperties properties;
    private final PasswordResetService passwordResetService;

    public AuthController(
            AuthService authService,
            AuthProperties properties,
            PasswordResetService passwordResetService) {
        this.authService = authService;
        this.properties = properties;
        this.passwordResetService = passwordResetService;
    }

    @PostMapping("/register")
    ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        return sessionResponse(authService.register(request), HttpStatus.CREATED);
    }

    @PostMapping("/login")
    ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        return sessionResponse(authService.login(request), HttpStatus.OK);
    }

    @PostMapping("/refresh")
    ResponseEntity<AuthResponse> refresh(HttpServletRequest request) {
        return sessionResponse(authService.refresh(readRefreshCookie(request)), HttpStatus.OK);
    }

    @PostMapping("/logout")
    ResponseEntity<Void> logout(HttpServletRequest request) {
        authService.logout(readRefreshCookie(request));
        return ResponseEntity.noContent()
                .header(HttpHeaders.SET_COOKIE, expiredRefreshCookie().toString())
                .build();
    }

    @PostMapping("/forgot-password")
    ResponseEntity<Void> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        passwordResetService.request(request);
        return ResponseEntity.accepted().build();
    }

    @PostMapping("/reset-password")
    ResponseEntity<Void> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        passwordResetService.reset(request);
        return ResponseEntity.noContent().build();
    }

    private ResponseEntity<AuthResponse> sessionResponse(IssuedSession session, HttpStatus status) {
        AuthResponse body = new AuthResponse(
                "Bearer", session.accessToken(), session.accessTokenExpiresAt(), session.user());
        return ResponseEntity.status(status)
                .header(HttpHeaders.SET_COOKIE, refreshCookie(session).toString())
                .body(body);
    }

    private ResponseCookie refreshCookie(IssuedSession session) {
        return ResponseCookie.from(properties.refreshCookieName(), session.refreshToken())
                .httpOnly(true)
                .secure(properties.secureCookie())
                .sameSite("Lax")
                .path("/api/v1/auth")
                .maxAge(properties.refreshTokenTtl())
                .build();
    }

    private ResponseCookie expiredRefreshCookie() {
        return ResponseCookie.from(properties.refreshCookieName(), "")
                .httpOnly(true)
                .secure(properties.secureCookie())
                .sameSite("Lax")
                .path("/api/v1/auth")
                .maxAge(0)
                .build();
    }

    private String readRefreshCookie(HttpServletRequest request) {
        if (request.getCookies() == null) {
            return null;
        }
        return Arrays.stream(request.getCookies())
                .filter(cookie -> properties.refreshCookieName().equals(cookie.getName()))
                .map(Cookie::getValue)
                .findFirst()
                .orElse(null);
    }
}
