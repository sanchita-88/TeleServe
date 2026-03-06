package com.teleserve.controller.admin;

import com.teleserve.model.PaginatedResult;
import com.teleserve.model.User;
import com.teleserve.util.AppLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * GET:  Load paginated user list; forward to admin/users.jsp.
 * POST: Update user status (userId, action=suspend|activate); redirect back to /admin/users with flash.
 */
@WebServlet(urlPatterns = {"/admin/users"})
public class UserManagementServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(UserManagementServlet.class);

    private static final int PAGE_SIZE = 10;

    private com.teleserve.dao.UserDAO userDAO;

    @Override
    public void init() {
        userDAO = (com.teleserve.dao.UserDAO) getServletContext().getAttribute("userDAO");
        if (userDAO == null) {
            throw new IllegalStateException("UserDAO not found in ServletContext.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        int page = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        PaginatedResult<User> result = userDAO.getAllUsers(page, PAGE_SIZE);
        request.setAttribute("userResult", result);
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdParam = request.getParameter("userId");
        String action = request.getParameter("action");

        if (userIdParam == null || action == null) {
            request.getSession(true).setAttribute("flashError", "Missing parameters.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdParam.trim());
        } catch (NumberFormatException e) {
            request.getSession(true).setAttribute("flashError", "Invalid user id.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        String newStatus;
        if ("suspend".equalsIgnoreCase(action)) {
            newStatus = "SUSPENDED";
        } else if ("activate".equalsIgnoreCase(action)) {
            newStatus = "ACTIVE";
        } else {
            request.getSession(true).setAttribute("flashError", "Invalid action.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            userDAO.updateStatus(userId, newStatus);
            request.getSession(true).setAttribute("flashMessage", "User status updated successfully.");
            LOGGER.info("User status updated: userId=" + userId + " status=" + newStatus);
        } catch (Exception e) {
            LOGGER.warning("Failed to update user status: " + e.getMessage());
            request.getSession(true).setAttribute("flashError", "Failed to update user status.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
