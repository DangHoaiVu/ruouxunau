package com.ruouxunau.shared.exception;

import org.springframework.http.HttpStatus;

public final class ConflictException extends BusinessException {

    public ConflictException(String code, String message) {
        super(HttpStatus.CONFLICT, code, message);
    }
}

