package com.ruouxunau.identity.repository;

import com.ruouxunau.identity.domain.UserEntity;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<UserEntity, String> {

    boolean existsByEmail(String email);
    boolean existsByRolesCode(String roleCode);

    @EntityGraph(attributePaths = {"roles", "roles.permissions"})
    Optional<UserEntity> findByEmail(String email);

    @Override
    @EntityGraph(attributePaths = {"roles", "roles.permissions"})
    Optional<UserEntity> findById(String id);
}
