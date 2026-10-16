package com.ruouxunau.shared.exception;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.OptimisticLockingFailureException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.HandlerMethodValidationException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.net.URI;
import java.time.Instant;
import java.util.List;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BusinessException.class)
    ResponseEntity<ProblemDetail> handleBusiness(BusinessException exception, HttpServletRequest request) {
        return response(exception.status(), exception.code(), exception.getMessage(), request, List.of());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<ProblemDetail> handleValidation(MethodArgumentNotValidException exception, HttpServletRequest request) {
        List<Map<String, String>> errors = exception.getBindingResult().getFieldErrors().stream()
                .map(error -> Map.of(
                        "field", error.getField(),
                        "message", error.getDefaultMessage() == null ? "Giá trị không hợp lệ" : error.getDefaultMessage()))
                .toList();
        return response(HttpStatus.BAD_REQUEST, "VALIDATION_FAILED", "Dữ liệu gửi lên không hợp lệ", request, errors);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    ResponseEntity<ProblemDetail> handleConstraint(ConstraintViolationException exception, HttpServletRequest request) {
        List<Map<String, String>> errors = exception.getConstraintViolations().stream()
                .map(error -> Map.of("field", error.getPropertyPath().toString(), "message", error.getMessage()))
                .toList();
        return response(HttpStatus.BAD_REQUEST, "VALIDATION_FAILED", "Dữ liệu gửi lên không hợp lệ", request, errors);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    ResponseEntity<ProblemDetail> handleUnreadable(HttpMessageNotReadableException exception, HttpServletRequest request) {
        return response(HttpStatus.BAD_REQUEST, "MALFORMED_REQUEST", "Nội dung yêu cầu không đọc được", request, List.of());
    }

    @ExceptionHandler({
            MethodArgumentTypeMismatchException.class,
            MissingServletRequestParameterException.class,
            HandlerMethodValidationException.class
    })
    ResponseEntity<ProblemDetail> handleRequestParameter(Exception exception, HttpServletRequest request) {
        return response(HttpStatus.BAD_REQUEST, "INVALID_REQUEST_PARAMETER", "Tham số yêu cầu không hợp lệ", request, List.of());
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    ResponseEntity<ProblemDetail> handleDataConflict(DataIntegrityViolationException exception, HttpServletRequest request) {
        log.warn("Database constraint rejected the request", exception);
        return response(HttpStatus.CONFLICT, "RESOURCE_CONFLICT", "Dữ liệu xung đột với bản ghi hiện có", request, List.of());
    }

    @ExceptionHandler(OptimisticLockingFailureException.class)
    ResponseEntity<ProblemDetail> handleConcurrentUpdate(
            OptimisticLockingFailureException exception,
            HttpServletRequest request) {
        return response(HttpStatus.CONFLICT, "CONCURRENT_UPDATE", "Dữ liệu vừa được thay đổi, vui lòng tải lại và thử lại", request, List.of());
    }

    @ExceptionHandler({NoResourceFoundException.class, NoHandlerFoundException.class})
    ResponseEntity<ProblemDetail> handleNotFound(Exception exception, HttpServletRequest request) {
        return response(HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND", "Không tìm thấy tài nguyên", request, List.of());
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    ResponseEntity<ProblemDetail> handleMethodNotAllowed(
            HttpRequestMethodNotSupportedException exception,
            HttpServletRequest request) {
        return response(HttpStatus.METHOD_NOT_ALLOWED, "METHOD_NOT_ALLOWED", "Phương thức HTTP không được hỗ trợ", request, List.of());
    }

    @ExceptionHandler(HttpMediaTypeNotSupportedException.class)
    ResponseEntity<ProblemDetail> handleUnsupportedMediaType(
            HttpMediaTypeNotSupportedException exception,
            HttpServletRequest request) {
        return response(HttpStatus.UNSUPPORTED_MEDIA_TYPE, "UNSUPPORTED_MEDIA_TYPE", "Định dạng nội dung không được hỗ trợ", request, List.of());
    }

    @ExceptionHandler(Exception.class)
    ResponseEntity<ProblemDetail> handleUnexpected(Exception exception, HttpServletRequest request) {
        log.error("Unhandled exception", exception);
        return response(HttpStatus.INTERNAL_SERVER_ERROR, "INTERNAL_ERROR", "Hệ thống đang gặp sự cố, vui lòng thử lại", request, List.of());
    }

    private ResponseEntity<ProblemDetail> response(
            HttpStatus status,
            String code,
            String detail,
            HttpServletRequest request,
            List<Map<String, String>> errors) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(status, detail);
        problem.setType(URI.create("https://api.ruouxunau.vn/problems/" + code.toLowerCase().replace('_', '-')));
        problem.setTitle(status.getReasonPhrase());
        problem.setInstance(URI.create(request.getRequestURI()));
        problem.setProperty("code", code);
        problem.setProperty("traceId", MDC.get("traceId"));
        problem.setProperty("timestamp", Instant.now());
        problem.setProperty("errors", errors);
        return ResponseEntity.status(status).body(problem);
    }
}

