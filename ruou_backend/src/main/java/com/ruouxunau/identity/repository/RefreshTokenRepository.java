package com.ruouxunau.identity.repository;

import com.ruouxunau.identity.domain.RefreshTokenEntity;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshTokenEntity, String> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select token from RefreshTokenEntity token where token.tokenHash = :tokenHash")
    Optional<RefreshTokenEntity> findForUpdateByTokenHash(@Param("tokenHash") String tokenHash);

    @Modifying
    @Query("""
            update RefreshTokenEntity token
               set token.revokedAt = :revokedAt
             where token.familyId = :familyId
               and token.revokedAt is null
            """)
    int revokeFamily(@Param("familyId") String familyId, @Param("revokedAt") Instant revokedAt);

    @Modifying
    @Query("""
            update RefreshTokenEntity token
               set token.revokedAt = :revokedAt
             where token.userId = :userId
               and token.revokedAt is null
            """)
    int revokeAllForUser(@Param("userId") String userId, @Param("revokedAt") Instant revokedAt);

    @Modifying
    @Query("delete from RefreshTokenEntity token where token.expiresAt < :threshold")
    int deleteExpiredBefore(@Param("threshold") Instant threshold);
}
