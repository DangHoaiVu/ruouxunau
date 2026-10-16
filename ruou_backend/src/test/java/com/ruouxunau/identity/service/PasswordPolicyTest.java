package com.ruouxunau.identity.service;

import com.ruouxunau.shared.exception.BadRequestException;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class PasswordPolicyTest {

    private final PasswordPolicy policy = new PasswordPolicy();

    @Test
    void acceptsStrongPassword() {
        assertThatCode(() -> policy.validateNew("RuouXuNau2026!")).doesNotThrowAnyException();
    }

    @Test
    void rejectsWeakAndBcryptOversizedPasswords() {
        assertThatThrownBy(() -> policy.validateNew("123456789012"))
                .isInstanceOf(BadRequestException.class);
        assertThatThrownBy(() -> policy.validateNew("Aa1" + "x".repeat(70)))
                .isInstanceOf(BadRequestException.class);
    }
}
