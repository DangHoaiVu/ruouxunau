package com.ruouxunau.identity.api;

import com.ruouxunau.identity.domain.PermissionEntity;
import com.ruouxunau.identity.domain.RoleEntity;
import com.ruouxunau.identity.domain.UserEntity;

import java.util.List;

public record UserResponse(
        String id,
        String email,
        String fullName,
        String phone,
        List<String> roles,
        List<String> permissions) {

    public static UserResponse from(UserEntity user) {
        List<String> roles = user.getRoles().stream()
                .map(RoleEntity::getCode)
                .sorted()
                .toList();
        List<String> permissions = user.getRoles().stream()
                .flatMap(role -> role.getPermissions().stream())
                .map(PermissionEntity::getCode)
                .distinct()
                .sorted()
                .toList();
        return new UserResponse(
                user.getId(), user.getEmail(), user.getFullName(), user.getPhone(), roles, permissions);
    }
}
