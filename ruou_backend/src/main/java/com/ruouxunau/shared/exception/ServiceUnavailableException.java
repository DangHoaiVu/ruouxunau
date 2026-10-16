package com.ruouxunau.shared.exception;

import org.springframework.http.HttpStatus;

public final class ServiceUnavailableException extends BusinessException {
    public ServiceUnavailableException(String code, String message) {
        super(HttpStatus.SERVICE_UNAVAILABLE, code, message);
    }
}
