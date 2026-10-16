package com.ruouxunau.identity.service;

import com.ruouxunau.identity.config.AuthProperties;
import com.ruouxunau.shared.exception.ServiceUnavailableException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class PasswordResetMailService {

    private static final Logger log = LoggerFactory.getLogger(PasswordResetMailService.class);

    private final JavaMailSender mailSender;
    private final AuthProperties properties;

    public PasswordResetMailService(JavaMailSender mailSender, AuthProperties properties) {
        this.mailSender = mailSender;
        this.properties = properties;
    }

    void send(String recipient, String rawToken) {
        if (properties.mailFrom() == null || properties.mailFrom().isBlank()) {
            throw unavailable();
        }
        String resetLink = UriComponentsBuilder.fromUriString(properties.passwordResetUrl())
                .queryParam("token", rawToken)
                .build()
                .encode()
                .toUriString();

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(properties.mailFrom());
        message.setTo(recipient);
        message.setSubject("Đặt lại mật khẩu Rượu Xứ Nẫu");
        message.setText("""
                Bạn vừa yêu cầu đặt lại mật khẩu Rượu Xứ Nẫu.

                Mở liên kết sau để đặt mật khẩu mới (liên kết chỉ sử dụng một lần):
                %s

                Nếu bạn không thực hiện yêu cầu này, hãy bỏ qua email.
                """.formatted(resetLink));
        try {
            mailSender.send(message);
        } catch (MailException exception) {
            log.error("Password reset email delivery failed", exception);
            throw unavailable();
        }
    }

    private ServiceUnavailableException unavailable() {
        return new ServiceUnavailableException(
                "EMAIL_SERVICE_UNAVAILABLE", "Dịch vụ email tạm thời không khả dụng, vui lòng thử lại sau");
    }
}
