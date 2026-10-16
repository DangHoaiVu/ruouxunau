package com.ruouxunau.shared.audit;

import com.ruouxunau.shared.persistence.IdGenerator;
import org.slf4j.MDC;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import tools.jackson.databind.ObjectMapper;

import java.time.Clock;

@Service
public class AuditService {

    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper;
    private final Clock clock;

    public AuditService(JdbcTemplate jdbcTemplate, ObjectMapper objectMapper, Clock clock) {
        this.jdbcTemplate = jdbcTemplate;
        this.objectMapper = objectMapper;
        this.clock = clock;
    }

    public void record(String actorId, String action, String entityType, String entityId,
                       Object before, Object after) {
        String traceId = MDC.get("traceId");
        jdbcTemplate.update("""
                insert into audit_logs
                    (id, actor_id, action, entity_type, entity_id, before_json, after_json, trace_id, created_at)
                values (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                IdGenerator.newUlid(clock), actorId, action, entityType, entityId,
                json(before), json(after), traceId == null ? "system" : traceId, clock.instant());
    }

    private String json(Object value) {
        return value == null ? null : objectMapper.writeValueAsString(value);
    }
}
