package com.ruouxunau.shared.web;

import org.junit.jupiter.api.Test;
import org.slf4j.MDC;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.assertj.core.api.Assertions.assertThat;

class TraceIdFilterTest {

    private final TraceIdFilter filter = new TraceIdFilter();

    @Test
    void keepsAValidClientTraceId() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        request.addHeader(TraceIdFilter.HEADER_NAME, "checkout-request-123");

        filter.doFilter(request, response, new MockFilterChain());

        assertThat(response.getHeader(TraceIdFilter.HEADER_NAME)).isEqualTo("checkout-request-123");
        assertThat(MDC.get("traceId")).isNull();
    }

    @Test
    void replacesAnUnsafeTraceId() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        request.addHeader(TraceIdFilter.HEADER_NAME, "invalid trace id with spaces");

        filter.doFilter(request, response, new MockFilterChain());

        assertThat(response.getHeader(TraceIdFilter.HEADER_NAME))
                .matches("[a-f0-9]{32}")
                .isNotEqualTo("invalid trace id with spaces");
        assertThat(MDC.get("traceId")).isNull();
    }
}
