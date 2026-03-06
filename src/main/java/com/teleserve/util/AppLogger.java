package com.teleserve.util;

import java.util.logging.Logger;

/**
 * Centralized logger factory. Returns standard java.util.logging.Logger for the given class.
 */
public final class AppLogger {

    private AppLogger() {
    }

    public static Logger getLogger(Class<?> clazz) {
        return Logger.getLogger(clazz.getName());
    }
}
