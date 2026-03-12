package com.teleserve.controller.auth;

import com.teleserve.dao.UserDAO;
import com.teleserve.exception.ServiceException;
import com.teleserve.model.User;
import com.teleserve.service.AuthService;
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
import java.util.UUID;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(LoginServlet.class);
    private static final String REMEMBER_COOKIE = "teleserve_remember";
    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 30; // 30 days

    private AuthService authService;
    private UserDAO userDAO;

    @Override
    public void init() {
        authService = (AuthService) getServletContext().getAttribute("authService");
        userDAO = (UserDAO) getServletContext().getAttribute("userDAO");
        if (authService == null) {
            throw new IllegalStateException("AuthService not found in ServletContext.");
        }
        if (userDAO == null) {
            throw new IllegalStateException("UserDAO not found in ServletContext.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        try {
            User user = authService.login(email, password);
            HttpSession session = request.getSession(true);
            SessionUtil.setCurrentUser(session, user);

            // Handle Remember Me
            if ("on".equals(rememberMe)) {
                String token = UUID.randomUUID().toString();
                userDAO.updateRememberToken(user.getUserId(), token);
                Cookie cookie = new Cookie(REMEMBER_COOKIE, token);
                cookie.setMaxAge(COOKIE_MAX_AGE);
                cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                cookie.setHttpOnly(true);
                response.addCookie(cookie);
                LOGGER.info("Remember Me cookie set for userId=" + user.getUserId());
            }

            LOGGER.info("User logged in: userId=" + user.getUserId());
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
        } catch (ServiceException e) {
            LOGGER.warning("Login failed: " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}