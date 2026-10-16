package com.ruouxunau.catalog.api;

import com.ruouxunau.shared.exception.BadRequestException;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class AdminInventoryControllerTest {
    @Test
    void appliesPositiveAndNegativeAdjustments() {
        assertEquals(13, AdminInventoryController.checkedBalance(10, 3));
        assertEquals(7, AdminInventoryController.checkedBalance(10, -3));
    }

    @Test
    void rejectsZeroOrNegativeBalance() {
        assertThrows(BadRequestException.class, () -> AdminInventoryController.checkedBalance(10, 0));
        assertThrows(BadRequestException.class, () -> AdminInventoryController.checkedBalance(10, -11));
    }

    @Test
    void rejectsIntegerOverflow() {
        assertThrows(BadRequestException.class,
                () -> AdminInventoryController.checkedBalance(Integer.MAX_VALUE, 1));
    }
}
