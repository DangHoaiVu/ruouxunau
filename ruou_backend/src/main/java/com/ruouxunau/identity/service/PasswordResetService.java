package com.ruouxunau.identity.service;

import com.ruouxunau.identity.api.ForgotPasswordRequest;
import com.ruouxunau.identity.api.ResetPasswordRequest;
import com.ruouxunau.identity.config.AuthProperties;
import com.ruouxunau.identity.domain.PasswordResetTokenEntity;
import com.ruouxunau.identity.domain.UserEntity;
import com.ruouxunau.identity.domain.UserStatus;
import com.ruouxunau.identity.repository.PasswordResetTokenRepository;
import com.ruouxunau.identity.repository.RefreshTokenRepository;
import com.ruouxunau.identity.repository.UserRepository;
import com.ruouxunau.shared.exception.BadRequestException;
import com.ruouxunau.shared.persistence.IdGenerator;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Instant;
import java.util.Locale;

@Service
public class PasswordResetService {

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository resetTokenRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordResetMailService mailService;
    private final SecureTokenCodec tokenCodec;
    private final PasswordPolicy passwordPolicy;
    private final PasswordEncoder passwordEncoder;
    private final AuthProperties properties;
    private final Clock clock;

    public PasswordResetService(
            UserRepository userRepository,
            PasswordResetTokenRepository resetTokenRepository,
            RefreshTokenRepository refreshTokenRepository,
            PasswordResetMailService mailService,
            SecureTokenCodec tokenCodec,
            PasswordPolicy passwordPolicy,
            PasswordEncoder passwordEncoder,
            AuthProperties properties,
            Clock clock) {
        this.userRepository = userRepository;
        this.resetTokenRepository = resetTokenRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.mailService = mailService;
        this.tokenCodec = tokenCodec;
        this.passwordPolicy = passwordPolicy;
        this.passwordEncoder = passwordEncoder;
        this.properties = properties;
        this.clock = clock;
    }

    @Transactional
    public void request(ForgotPasswordRequest request) {
        String email = request.email().trim().toLowerCase(Locale.ROOT);
        UserEntity user = userRepository.findByEmail(email)
                .filter(candidate -> candidate.getStatus() == UserStatus.ACTIVE)
                .orElse(null);
        if (user == null) {
            return;
        }

        Instant now = clock.instant();
        resetTokenRepository.consumeOpenForUser(user.getId(), now);
        String rawToken = tokenCodec.newToken();
        resetTokenRepository.saveAndFlush(new PasswordResetTokenEntity(
                IdGenerator.newUlid(clock), user.getId(), tokenCodec.hash(rawToken),
                now.plus(properties.passwordResetTtl()), now));
        mailService.send(user.getEmail(), rawToken);
    }

    @Transactional
    public void reset(ResetPasswordRequest request) {
        Instant now = clock.instant();
        PasswordResetTokenEntity token = resetTokenRepository.findForUpdateByTokenHash(tokenCodec.hash(request.token()))
                .filter(candidate -> candidate.isUsableAt(now))
                .orElseThrow(this::invalidToken);
        UserEntity user = userRepository.findById(token.getUserId())
                .filter(candidate -> candidate.getStatus() == UserStatus.ACTIVE)
                .orElseThrow(this::invalidToken);

        passwordPolicy.validateNew(request.newPassword());
        user.changePassword(passwordEncoder.encode(request.newPassword()), now);
        token.consume(now);
        resetTokenRepository.consumeOpenForUser(user.getId(), now);
        refreshTokenRepository.revokeAllForUser(user.getId(), now);
    }

    private BadRequestException invalidToken() {
        return new BadRequestException(
                "PASSWORD_RESET_TOKEN_INVALID", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn");
    }
}
