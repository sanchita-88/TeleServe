package com.teleserve.controller.auth;

import com.teleserve.exception.ServiceException;
import com.teleserve.model.User;
import com.teleserve.service.AuthService;
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
 * GET:  Show login form (forward to auth/login.jsp).
 * POST: Validate credentials via AuthService; on success set user in session and redirect to /user/dashboard;
 *       on failure set error attribute and forward to auth/login.jsp.
 */
@WebServlet(urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(LoginServlet.class);

    private AuthService authService;

    @Override
    public void init() {
        authService = (AuthService) getServletContext().getAttribute("authService");
        if (authService == null) {
            throw new IllegalStateException("AuthService not found in ServletContext. Ensure ContextListener sets it.");
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

        try {
            User user = authService.login(email, password);
            HttpSession session = request.getSession(true);
            SessionUtil.setCurrentUser(session, user);
            LOGGER.info("User logged in: userId=" + user.getUserId());
            response.sendRedirect(request.getContextPath() + "/user/dashboard");
            return;
        } catch (ServiceException e) {
            LOGGER.warning("Login failed: " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
