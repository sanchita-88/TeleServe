package com.teleserve.exception;

/**
 * Unchecked exception for DAO layer failures (e.g. SQL errors, no rows affected).
 */
public class DAOException extends RuntimeException {

    public DAOException(String message) {
        super(message);
    }

    public DAOException(String message, Throwable cause) {
        super(message, cause);
    }
}