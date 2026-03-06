package com.teleserve.exception;

/**
 * Checked exception for service layer business rule failures (e.g. invalid credentials, duplicate email).
 */
public class ServiceException extends Exception {

    public ServiceException(String message) {
        super(message);
    }

    public ServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}
