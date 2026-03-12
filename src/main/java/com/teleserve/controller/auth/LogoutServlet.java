package com.teleserve.controller.auth;

import com.teleserve.dao.UserDAO;
import com.teleserve.model.User;
import com.teleserve.util.AppLogger;
import com.teleserve.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(LogoutServlet.class);
    private static final String REMEMBER_COOKIE = "teleserve_remember";

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = (UserDAO) getServletContext().getAttribute("userDAO");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Clear remember token from DB
        if (session != null && userDAO != null) {
            User user = SessionUtil.getCurrentUser(session);
            if (user != null) {
                userDAO.updateRememberToken(user.getUserId(), null);
            }
            SessionUtil.invalidate(session);
        }

        // Clear the cookie
        Cookie cookie = new Cookie(REMEMBER_COOKIE, "");
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setHttpOnly(true);
        response.addCookie(cookie);

        request.getSession(true).setAttribute("flashMessage", "You have been logged out.");
        LOGGER.info("User logged out, remember cookie cleared");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}