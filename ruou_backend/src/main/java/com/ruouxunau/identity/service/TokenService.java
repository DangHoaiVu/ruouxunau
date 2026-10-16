package com.ruouxunau.identity.service;

import com.ruouxunau.identity.api.UserResponse;
import com.ruouxunau.identity.config.AuthProperties;
import com.ruouxunau.identity.domain.RefreshTokenEntity;
import com.ruouxunau.identity.domain.UserEntity;
import com.ruouxunau.identity.domain.UserStatus;
import com.ruouxunau.identity.repository.RefreshTokenRepository;
import com.ruouxunau.identity.repository.UserRepository;
import com.ruouxunau.shared.exception.UnauthorizedException;
import com.ruouxunau.shared.persistence.IdGenerator;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;

import java.time.Clock;
import java.time.Instant;

@Service
public class TokenService {

    private final JwtEncoder jwtEncoder;
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;
    private final AuthProperties properties;
    private final Clock clock;
    private final SecureTokenCodec tokenCodec;

    public TokenService(
            JwtEncoder jwtEncoder,
            RefreshTokenRepository refreshTokenRepository,
            UserRepository userRepository,
            AuthProperties properties,
            Clock clock,
            SecureTokenCodec tokenCodec) {
        this.jwtEncoder = jwtEncoder;
        this.refreshTokenRepository = refreshTokenRepository;
        this.userRepository = userRepository;
        this.properties = properties;
        this.clock = clock;
        this.tokenCodec = tokenCodec;
    }

    IssuedSession create(UserEntity user) {
        return create(user, IdGenerator.newUlid(clock));
    }

    IssuedSession rotate(String rawToken) {
        Instant now = clock.instant();
        String currentHash = tokenCodec.hash(rawToken);
        RefreshTokenEntity current = refreshTokenRepository.findForUpdateByTokenHash(currentHash)
                .orElseThrow(this::invalidRefreshToken);

        if (current.getRevokedAt() != null) {
            refreshTokenRepository.revokeFamily(current.getFamilyId(), now);
            throw invalidRefreshToken();
        }
        if (!current.isUsableAt(now)) {
            current.revoke(now);
            throw invalidRefreshToken();
        }

        UserEntity user = userRepository.findById(current.getUserId())
                .filter(candidate -> candidate.getStatus() == UserStatus.ACTIVE)
                .orElseThrow(this::invalidRefreshToken);

        String nextRawToken = tokenCodec.newToken();
        String nextHash = tokenCodec.hash(nextRawToken);
        current.rotateTo(nextHash, now);
        Instant refreshExpiresAt = now.plus(properties.refreshTokenTtl());
        refreshTokenRepository.save(new RefreshTokenEntity(
                IdGenerator.newUlid(clock), user.getId(), current.getFamilyId(), nextHash,
                refreshExpiresAt, now));

        return buildSession(user, nextRawToken, refreshExpiresAt, now);
    }

    void revokeFamily(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            return;
        }
        refreshTokenRepository.findForUpdateByTokenHash(tokenCodec.hash(rawToken))
                .ifPresent(token -> refreshTokenRepository.revokeFamily(token.getFamilyId(), clock.instant()));
    }

    private IssuedSession create(UserEntity user, String familyId) {
        Instant now = clock.instant();
        String rawToken = tokenCodec.newToken();
        Instant refreshExpiresAt = now.plus(properties.refreshTokenTtl());
        refreshTokenRepository.save(new RefreshTokenEntity(
                IdGenerator.newUlid(clock), user.getId(), familyId, tokenCodec.hash(rawToken), refreshExpiresAt, now));
        return buildSession(user, rawToken, refreshExpiresAt, now);
    }

    private IssuedSession buildSession(UserEntity user, String refreshToken, Instant refreshExpiresAt, Instant now) {
        UserResponse userResponse = UserResponse.from(user);
        Instant accessExpiresAt = now.plus(properties.accessTokenTtl());
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer(properties.issuer())
                .issuedAt(now)
                .expiresAt(accessExpiresAt)
                .subject(user.getId())
                .claim("email", user.getEmail())
                .claim("name", user.getFullName())
                .claim("roles", userResponse.roles())
                .claim("permissions", userResponse.permissions())
                .build();
        JwsHeader header = JwsHeader.with(MacAlgorithm.HS256).build();
        String accessToken = jwtEncoder.encode(JwtEncoderParameters.from(header, claims)).getTokenValue();
        return new IssuedSession(accessToken, accessExpiresAt, refreshToken, refreshExpiresAt, userResponse);
    }

    private UnauthorizedException invalidRefreshToken() {
        return new UnauthorizedException("REFRESH_TOKEN_INVALID", "Phiên đăng nhập không hợp lệ hoặc đã hết hạn");
    }
}
