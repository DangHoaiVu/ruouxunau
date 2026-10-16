package com.ruouxunau.shared.exception;

import org.springframework.http.HttpStatus;

public final class BadRequestException extends BusinessException {
    public BadRequestException(String code, String message) {
        super(HttpStatus.BAD_REQUEST, code, message);
    }
}
