package com.ruouxunau.identity.repository;

import com.ruouxunau.identity.domain.RoleEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<RoleEntity, String> {
    Optional<RoleEntity> findByCode(String code);
}
