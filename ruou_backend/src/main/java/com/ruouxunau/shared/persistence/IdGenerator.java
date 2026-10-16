package com.ruouxunau.shared.persistence;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.time.Clock;

public final class IdGenerator {

    private static final char[] CROCKFORD_BASE32 = "0123456789ABCDEFGHJKMNPQRSTVWXYZ".toCharArray();
    private static final BigInteger MASK = BigInteger.valueOf(31);
    private static final SecureRandom RANDOM = new SecureRandom();

    private IdGenerator() {
    }

    public static String newUlid(Clock clock) {
        byte[] value = new byte[16];
        long timestamp = clock.millis();
        for (int index = 5; index >= 0; index--) {
            value[index] = (byte) timestamp;
            timestamp >>>= 8;
        }
        byte[] randomness = new byte[10];
        RANDOM.nextBytes(randomness);
        System.arraycopy(randomness, 0, value, 6, randomness.length);

        BigInteger number = new BigInteger(1, value);
        char[] encoded = new char[26];
        for (int index = encoded.length - 1; index >= 0; index--) {
            encoded[index] = CROCKFORD_BASE32[number.and(MASK).intValue()];
            number = number.shiftRight(5);
        }
        return new String(encoded);
    }
}
