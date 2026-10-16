package com.ruouxunau.identity.config;

import com.nimbusds.jose.jwk.source.ImmutableSecret;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtValidators;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Configuration
@EnableMethodSecurity
public class SecurityConfiguration {

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http, SecurityProblemWriter problemWriter) throws Exception {
        return http
                .csrf(csrf -> csrf.disable())
                .cors(cors -> {})
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers("/actuator/health/**", "/v3/api-docs/**", "/swagger-ui.html", "/swagger-ui/**").permitAll()
                        .requestMatchers(HttpMethod.POST,
                                "/api/v1/auth/register",
                                "/api/v1/auth/login",
                                "/api/v1/auth/refresh",
                                "/api/v1/auth/logout",
                                "/api/v1/auth/forgot-password",
                                "/api/v1/auth/reset-password").permitAll()
                        .requestMatchers(HttpMethod.GET,
                                "/api/v1/categories",
                                "/api/v1/products",
                                "/api/v1/products/**",
                                "/api/v1/article-categories",
                                "/api/v1/articles",
                                "/api/v1/articles/**",
                                "/api/v1/showcase").permitAll()
                        .requestMatchers(HttpMethod.GET, "/uploads/**").permitAll()
                        .requestMatchers("/api/v1/admin/**").hasAuthority("ADMIN_ACCESS")
                        .requestMatchers("/api/v1/**").authenticated()
                        .anyRequest().denyAll())
                .oauth2ResourceServer(oauth -> oauth
                        .jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter()))
                        .authenticationEntryPoint((request, response, exception) -> problemWriter.write(
                                request, response, HttpStatus.UNAUTHORIZED,
                                "AUTHENTICATION_REQUIRED", "Vui lòng đăng nhập để tiếp tục"))
                        .accessDeniedHandler((request, response, exception) -> problemWriter.write(
                                request, response, HttpStatus.FORBIDDEN,
                                "ACCESS_DENIED", "Bạn không có quyền thực hiện thao tác này")))
                .exceptionHandling(exceptions -> exceptions
                        .authenticationEntryPoint((request, response, exception) -> problemWriter.write(
                                request, response, HttpStatus.UNAUTHORIZED,
                                "AUTHENTICATION_REQUIRED", "Vui lòng đăng nhập để tiếp tục"))
                        .accessDeniedHandler((request, response, exception) -> problemWriter.write(
                                request, response, HttpStatus.FORBIDDEN,
                                "ACCESS_DENIED", "Bạn không có quyền thực hiện thao tác này")))
                .build();
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    @Bean
    SecretKey jwtSecretKey(AuthProperties properties) {
        return new SecretKeySpec(properties.jwtSecret().getBytes(StandardCharsets.UTF_8), "HmacSHA256");
    }

    @Bean
    JwtEncoder jwtEncoder(SecretKey secretKey) {
        return new NimbusJwtEncoder(new ImmutableSecret<>(secretKey));
    }

    @Bean
    JwtDecoder jwtDecoder(SecretKey secretKey, AuthProperties properties) {
        NimbusJwtDecoder decoder = NimbusJwtDecoder.withSecretKey(secretKey).build();
        decoder.setJwtValidator(JwtValidators.createDefaultWithIssuer(properties.issuer()));
        return decoder;
    }

    private JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(this::authoritiesFrom);
        return converter;
    }

    private Collection<GrantedAuthority> authoritiesFrom(Jwt jwt) {
        List<GrantedAuthority> authorities = new ArrayList<>();
        List<String> permissions = jwt.getClaimAsStringList("permissions");
        List<String> roles = jwt.getClaimAsStringList("roles");
        if (permissions != null) {
            permissions.stream().map(SimpleGrantedAuthority::new).forEach(authorities::add);
        }
        if (roles != null) {
            roles.stream().map(role -> new SimpleGrantedAuthority("ROLE_" + role)).forEach(authorities::add);
        }
        return authorities;
    }
}
