package com.ruouxunau.identity.repository;

import com.ruouxunau.identity.domain.AddressEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface AddressRepository extends JpaRepository<AddressEntity, String> {
    List<AddressEntity> findAllByUserIdOrderByDefaultAddressDescCreatedAtDesc(String userId);
    Optional<AddressEntity> findByIdAndUserId(String id, String userId);
    long countByUserId(String userId);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("""
            update AddressEntity address
               set address.defaultAddress = false,
                   address.updatedAt = :updatedAt
             where address.userId = :userId
               and address.defaultAddress = true
            """)
    int clearDefaultForUser(@Param("userId") String userId, @Param("updatedAt") java.time.Instant updatedAt);
}
