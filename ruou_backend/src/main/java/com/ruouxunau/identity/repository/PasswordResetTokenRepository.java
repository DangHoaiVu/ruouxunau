package com.ruouxunau.identity.repository;

import com.ruouxunau.identity.domain.PasswordResetTokenEntity;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.Optional;

public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetTokenEntity, String> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select token from PasswordResetTokenEntity token where token.tokenHash = :tokenHash")
    Optional<PasswordResetTokenEntity> findForUpdateByTokenHash(@Param("tokenHash") String tokenHash);

    @Modifying
    @Query("""
            update PasswordResetTokenEntity token
               set token.consumedAt = :consumedAt
             where token.userId = :userId
               and token.consumedAt is null
            """)
    int consumeOpenForUser(@Param("userId") String userId, @Param("consumedAt") Instant consumedAt);
}
