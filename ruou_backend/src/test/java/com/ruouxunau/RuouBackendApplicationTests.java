package com.ruouxunau;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.jdbc.core.JdbcTemplate;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.mysql.MySQLContainer;

import static org.assertj.core.api.Assertions.assertThat;

@Testcontainers(disabledWithoutDocker = true)
@SpringBootTest(properties = "app.auth.jwt-secret=test-only-secret-with-more-than-32-characters")
class RuouBackendApplicationTests {

    @Container
    @ServiceConnection
    static final MySQLContainer MYSQL = new MySQLContainer("mysql:8.4.11")
            .withDatabaseName("binh_dinh_wine")
            .withUsername("ruou_test")
            .withPassword("test_password");

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void contextLoads() {
        assertThat(jdbcTemplate).isNotNull();
    }

    @Test
    void flywayCreatesFoundationTables() {
        Integer tableCount = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM information_schema.tables
                WHERE table_schema = DATABASE()
                  AND table_name IN ('audit_logs', 'idempotency_records', 'flyway_schema_history')
                """, Integer.class);

        assertThat(tableCount).isEqualTo(3);
    }

    @Test
    void flywayCreatesIdentityTablesWithoutDemoUsers() {
        Integer identityTableCount = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM information_schema.tables
                WHERE table_schema = DATABASE()
                  AND table_name IN ('users', 'roles', 'permissions', 'user_roles',
                                     'role_permissions', 'refresh_tokens', 'addresses',
                                     'password_reset_tokens', 'auth_rate_limits')
                """, Integer.class);
        Integer userCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users", Integer.class);

        assertThat(identityTableCount).isEqualTo(9);
        assertThat(userCount).isZero();
    }
}
