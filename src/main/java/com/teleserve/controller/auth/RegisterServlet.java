package com.teleserve.controller.auth;

import com.teleserve.exception.ServiceException;
import com.teleserve.model.User;
import com.teleserve.service.AuthService;
import com.teleserve.util.AppLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * GET:  Show registration form (forward to auth/register.jsp).
 * POST: Register user via AuthService; on success set flash message and redirect to /login;
 *       on failure set error attribute and forward to auth/register.jsp.
 */
@WebServlet(urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(RegisterServlet.class);

    private AuthService authService;

    @Override
    public void init() {
        authService = (AuthService) getServletContext().getAttribute("authService");
        if (authService == null) {
            throw new IllegalStateException("AuthService not found in ServletContext.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = authService.register(fullName, phone, email, password);
            HttpSession session = request.getSession(true);
            session.setAttribute("flashMessage", "Registration successful. Please log in.");
            LOGGER.info("User registered: userId=" + user.getUserId());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        } catch (ServiceException e) {
            LOGGER.warning("Registration failed: " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}
