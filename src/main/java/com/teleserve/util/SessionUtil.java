package com.teleserve.util;

import com.teleserve.model.User;

import javax.servlet.http.HttpSession;

/**
 * Session attribute helpers for current user and invalidation.
 */
public final class SessionUtil {

    private static final String CURRENT_USER = "currentUser";

    private SessionUtil() {
    }

    public static void setCurrentUser(HttpSession session, User user) {
        if (session != null) {
            session.setAttribute(CURRENT_USER, user);
        }
    }

    /**
     * Returns the current user from the session, or null if not logged in.
     */
    public static User getCurrentUser(HttpSession session) {
        if (session == null) return null;
        Object attr = session.getAttribute(CURRENT_USER);
        return attr instanceof User ? (User) attr : null;
    }

    /**
     * Invalidates the session (e.g. on logout).
     */
    public static void invalidate(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }
}
