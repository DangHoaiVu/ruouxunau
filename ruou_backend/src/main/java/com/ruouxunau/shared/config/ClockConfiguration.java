package com.ruouxunau.shared.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Clock;

@Configuration(proxyBeanMethods = false)
class ClockConfiguration {

    @Bean
    Clock utcClock() {
        return Clock.systemUTC();
    }
}

