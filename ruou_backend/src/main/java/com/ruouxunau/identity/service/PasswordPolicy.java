package com.ruouxunau.identity.service;

import com.ruouxunau.shared.exception.BadRequestException;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;

@Component
public class PasswordPolicy {

    private static final Pattern HAS_UPPERCASE = Pattern.compile(".*\\p{Lu}.*");
    private static final Pattern HAS_LOWERCASE = Pattern.compile(".*\\p{Ll}.*");
    private static final Pattern HAS_DIGIT = Pattern.compile(".*\\d.*");

    public void validateNew(String password) {
        int byteLength = password.getBytes(StandardCharsets.UTF_8).length;
        if (password.length() < 12
                || byteLength > 72
                || !HAS_UPPERCASE.matcher(password).matches()
                || !HAS_LOWERCASE.matcher(password).matches()
                || !HAS_DIGIT.matcher(password).matches()) {
            throw new BadRequestException(
                    "WEAK_PASSWORD",
                    "Mật khẩu phải dài 12–72 byte và có chữ hoa, chữ thường, chữ số");
        }
    }

    public boolean canVerify(String password) {
        return password.getBytes(StandardCharsets.UTF_8).length <= 72;
    }
}
