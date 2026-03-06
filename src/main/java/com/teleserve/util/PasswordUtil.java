package com.teleserve.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;

/**
 * Password hashing and verification using PBKDF2 with HMAC-SHA256.
 * No external dependencies; uses JRE built-ins.
 */
public final class PasswordUtil {

    private static final int SALT_LENGTH = 16;
    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256;
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String SALT_HASH_DELIMITER = ":";

    private PasswordUtil() {
    }

    /**
     * Hashes a plain-text password with a random salt. Returns a string "salt:hash" for storage.
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null) {
            throw new IllegalArgumentException("Password cannot be null");
        }
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        byte[] hash = pbkdf2(plainPassword.toCharArray(), salt);
        String saltB64 = Base64.getEncoder().encodeToString(salt);
        String hashB64 = Base64.getEncoder().encodeToString(hash);
        return saltB64 + SALT_HASH_DELIMITER + hashB64;
    }

    /**
     * Verifies a plain-text password against a stored "salt:hash" value.
     */
    public static boolean verify(String plainPassword, String storedSaltAndHash) {
        if (plainPassword == null || storedSaltAndHash == null) {
            return false;
        }
        int delim = storedSaltAndHash.indexOf(SALT_HASH_DELIMITER);
        if (delim <= 0 || delim >= storedSaltAndHash.length() - 1) {
            return false;
        }
        String saltB64 = storedSaltAndHash.substring(0, delim);
        String hashB64 = storedSaltAndHash.substring(delim + 1);
        byte[] salt;
        byte[] expectedHash;
        try {
            salt = Base64.getDecoder().decode(saltB64);
            expectedHash = Base64.getDecoder().decode(hashB64);
        } catch (IllegalArgumentException e) {
            return false;
        }
        byte[] actualHash = pbkdf2(plainPassword.toCharArray(), salt);
        return constantTimeEquals(expectedHash, actualHash);
    }

    private static byte[] pbkdf2(char[] password, byte[] salt) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            return factory.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("Password hashing failed", e);
        }
    }

    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a.length != b.length) return false;
        int diff = 0;
        for (int i = 0; i < a.length; i++) {
            diff |= a[i] ^ b[i];
        }
        return diff == 0;
    }
    public static String hashPassword(String plainPassword) {
        return hash(plainPassword);
    }

    public static boolean verifyPassword(String plainPassword, String storedSaltAndHash) {
        return verify(plainPassword, storedSaltAndHash);
    }
}
