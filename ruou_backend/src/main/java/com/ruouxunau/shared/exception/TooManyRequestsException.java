package com.ruouxunau.shared.exception;

import org.springframework.http.HttpStatus;

public class TooManyRequestsException extends BusinessException {
    public TooManyRequestsException(String code, String message) {
        super(HttpStatus.TOO_MANY_REQUESTS, code, message);
    }
}
