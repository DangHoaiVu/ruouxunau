package com.ruouxunau.identity.config;

import com.ruouxunau.identity.domain.RoleEntity;
import com.ruouxunau.identity.domain.UserEntity;
import com.ruouxunau.identity.repository.RoleRepository;
import com.ruouxunau.identity.repository.UserRepository;
import com.ruouxunau.identity.service.PasswordPolicy;
import com.ruouxunau.shared.persistence.IdGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Instant;
import java.util.Locale;

@Component
public class AdminBootstrap implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(AdminBootstrap.class);

    private final BootstrapAdminProperties properties;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordPolicy passwordPolicy;
    private final PasswordEncoder passwordEncoder;
    private final Clock clock;

    public AdminBootstrap(
            BootstrapAdminProperties properties,
            UserRepository userRepository,
            RoleRepository roleRepository,
            PasswordPolicy passwordPolicy,
            PasswordEncoder passwordEncoder,
            Clock clock) {
        this.properties = properties;
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordPolicy = passwordPolicy;
        this.passwordEncoder = passwordEncoder;
        this.clock = clock;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        if (!properties.enabled()) {
            return;
        }
        if (userRepository.existsByRolesCode("ADMIN")) {
            log.info("Admin bootstrap skipped because an admin account already exists");
            return;
        }
        if (properties.email() == null || properties.email().isBlank()
                || properties.password() == null || properties.password().isBlank()) {
            throw new IllegalStateException(
                    "BOOTSTRAP_ADMIN_EMAIL and BOOTSTRAP_ADMIN_PASSWORD are required when bootstrap is enabled");
        }

        String email = properties.email().trim().toLowerCase(Locale.ROOT);
        if (userRepository.existsByEmail(email)) {
            throw new IllegalStateException("The bootstrap admin email belongs to an existing non-admin account");
        }
        passwordPolicy.validateNew(properties.password());
        RoleEntity adminRole = roleRepository.findByCode("ADMIN")
                .orElseThrow(() -> new IllegalStateException("ADMIN role is missing"));
        Instant now = clock.instant();
        String fullName = properties.fullName() == null || properties.fullName().isBlank()
                ? "Quản trị viên"
                : properties.fullName().trim();
        userRepository.save(new UserEntity(
                IdGenerator.newUlid(clock), email, passwordEncoder.encode(properties.password()),
                fullName, now, adminRole, now));
        log.info("Initial admin account created; disable bootstrap and remove its password environment variable");
    }
}
