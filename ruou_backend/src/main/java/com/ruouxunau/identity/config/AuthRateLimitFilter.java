package com.ruouxunau.identity.config;

import com.ruouxunau.identity.service.AuthRateLimitService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.Duration;
import java.util.Map;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 20)
public class AuthRateLimitFilter extends OncePerRequestFilter {

    private static final Map<String, Limit> LIMITS = Map.of(
            "/api/v1/auth/login", new Limit("login", 20, Duration.ofMinutes(1)),
            "/api/v1/auth/register", new Limit("register", 5, Duration.ofHours(1)),
            "/api/v1/auth/forgot-password", new Limit("forgot-password", 5, Duration.ofHours(1)),
            "/api/v1/auth/reset-password", new Limit("reset-password", 10, Duration.ofHours(1)),
            "/api/v1/auth/refresh", new Limit("refresh", 60, Duration.ofMinutes(1)));

    private final AuthRateLimitService rateLimitService;
    private final SecurityProblemWriter problemWriter;

    public AuthRateLimitFilter(AuthRateLimitService rateLimitService, SecurityProblemWriter problemWriter) {
        this.rateLimitService = rateLimitService;
        this.problemWriter = problemWriter;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !"POST".equalsIgnoreCase(request.getMethod()) || !LIMITS.containsKey(request.getRequestURI());
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        Limit limit = LIMITS.get(request.getRequestURI());
        if (!rateLimitService.tryAcquire(limit.action(), request.getRemoteAddr(), limit.maxAttempts(), limit.window())) {
            response.setHeader("Retry-After", Long.toString(limit.window().toSeconds()));
            problemWriter.write(
                    request, response, HttpStatus.TOO_MANY_REQUESTS,
                    "RATE_LIMIT_EXCEEDED", "Bạn thao tác quá nhanh, vui lòng thử lại sau");
            return;
        }
        filterChain.doFilter(request, response);
    }

    private record Limit(String action, int maxAttempts, Duration window) {
    }
}
