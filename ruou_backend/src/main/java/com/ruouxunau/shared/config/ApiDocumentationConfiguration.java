package com.ruouxunau.shared.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
class ApiDocumentationConfiguration {

    @Bean
    OpenAPI ruouXuNauOpenApi() {
        return new OpenAPI().info(new Info()
                .title("Rượu Xứ Nẫu API")
                .description("REST API cho storefront, tài khoản và cổng quản trị Rượu Xứ Nẫu")
                .version("v1")
                .contact(new Contact().name("Rượu Xứ Nẫu")));
    }
}

