package com.teleserve.controller.auth;

import com.teleserve.util.AppLogger;
import com.teleserve.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * GET:  Invalidate session, set flash message, redirect to /login.
 */
@WebServlet(urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(LogoutServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            SessionUtil.invalidate(session);
        }
        request.getSession(true).setAttribute("flashMessage", "You have been logged out.");
        LOGGER.info("User logged out");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
