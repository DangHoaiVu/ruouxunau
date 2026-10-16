package com.ruouxunau.identity.service;

import com.ruouxunau.identity.api.LoginRequest;
import com.ruouxunau.identity.api.RegisterRequest;
import com.ruouxunau.identity.api.UpdateProfileRequest;
import com.ruouxunau.identity.api.UserResponse;
import com.ruouxunau.identity.config.AuthProperties;
import com.ruouxunau.identity.domain.RoleEntity;
import com.ruouxunau.identity.domain.UserEntity;
import com.ruouxunau.identity.domain.UserStatus;
import com.ruouxunau.identity.repository.RoleRepository;
import com.ruouxunau.identity.repository.UserRepository;
import com.ruouxunau.shared.exception.ConflictException;
import com.ruouxunau.shared.exception.ResourceNotFoundException;
import com.ruouxunau.shared.exception.TooManyRequestsException;
import com.ruouxunau.shared.exception.UnauthorizedException;
import com.ruouxunau.shared.persistence.IdGenerator;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Instant;
import java.util.Locale;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;
    private final AuthProperties properties;
    private final PasswordPolicy passwordPolicy;
    private final Clock clock;
    private final String dummyPasswordHash;

    public AuthService(
            UserRepository userRepository,
            RoleRepository roleRepository,
            PasswordEncoder passwordEncoder,
            TokenService tokenService,
            AuthProperties properties,
            PasswordPolicy passwordPolicy,
            Clock clock) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
        this.properties = properties;
        this.passwordPolicy = passwordPolicy;
        this.clock = clock;
        this.dummyPasswordHash = passwordEncoder.encode("not-a-real-user-password");
    }

    @Transactional
    public IssuedSession register(RegisterRequest request) {
        String email = normalizeEmail(request.email());
        if (userRepository.existsByEmail(email)) {
            throw new ConflictException("EMAIL_ALREADY_EXISTS", "Email đã được sử dụng");
        }
        passwordPolicy.validateNew(request.password());

        RoleEntity customerRole = roleRepository.findByCode("CUSTOMER")
                .orElseThrow(() -> new IllegalStateException("CUSTOMER role is missing"));
        Instant now = clock.instant();
        UserEntity user = new UserEntity(
                IdGenerator.newUlid(clock), email, passwordEncoder.encode(request.password()),
                request.fullName().trim(), now, customerRole, now);
        userRepository.saveAndFlush(user);
        return tokenService.create(user);
    }

    @Transactional(noRollbackFor = {UnauthorizedException.class, TooManyRequestsException.class})
    public IssuedSession login(LoginRequest request) {
        String email = normalizeEmail(request.email());
        if (!passwordPolicy.canVerify(request.password())) {
            throw invalidCredentials();
        }
        UserEntity user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            passwordEncoder.matches(request.password(), dummyPasswordHash);
            throw invalidCredentials();
        }

        Instant now = clock.instant();
        if (user.getStatus() != UserStatus.ACTIVE) {
            throw new UnauthorizedException("ACCOUNT_DISABLED", "Tài khoản đã bị vô hiệu hóa");
        }
        if (user.isLockedAt(now)) {
            throw new TooManyRequestsException(
                    "ACCOUNT_TEMPORARILY_LOCKED", "Tài khoản tạm khóa do đăng nhập sai nhiều lần");
        }
        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            user.recordFailedLogin(now, properties.loginMaxFailures(), properties.loginLockDuration());
            userRepository.save(user);
            throw invalidCredentials();
        }

        user.recordSuccessfulLogin(now);
        return tokenService.create(user);
    }

    @Transactional(noRollbackFor = UnauthorizedException.class)
    public IssuedSession refresh(String refreshToken) {
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new UnauthorizedException("REFRESH_TOKEN_REQUIRED", "Không tìm thấy phiên đăng nhập");
        }
        return tokenService.rotate(refreshToken);
    }

    @Transactional
    public void logout(String refreshToken) {
        tokenService.revokeFamily(refreshToken);
    }

    @Transactional(readOnly = true)
    public UserResponse currentUser(String userId) {
        return UserResponse.from(loadActiveUser(userId));
    }

    @Transactional
    public UserResponse updateProfile(String userId, UpdateProfileRequest request) {
        UserEntity user = loadActiveUser(userId);
        String phone = request.phone() == null || request.phone().isBlank() ? null : request.phone().trim();
        user.updateProfile(request.fullName().trim(), phone, clock.instant());
        return UserResponse.from(user);
    }

    private UserEntity loadActiveUser(String userId) {
        return userRepository.findById(userId)
                .filter(user -> user.getStatus() == UserStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("USER_NOT_FOUND", "Không tìm thấy tài khoản"));
    }

    private String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }

    private UnauthorizedException invalidCredentials() {
        return new UnauthorizedException("INVALID_CREDENTIALS", "Email hoặc mật khẩu không đúng");
    }
}
