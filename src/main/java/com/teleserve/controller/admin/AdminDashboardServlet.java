package com.teleserve.controller.admin;

import com.teleserve.model.DashboardStats;
import com.teleserve.service.AdminService;
import com.teleserve.util.AppLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * GET: Load admin dashboard stats (total users, total recharges, revenue); forward to admin/dashboard.jsp.
 */
@WebServlet(urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(AdminDashboardServlet.class);

    private AdminService adminService;

    @Override
    public void init() {
        adminService = (AdminService) getServletContext().getAttribute("adminService");
        if (adminService == null) {
            throw new IllegalStateException("AdminService not found in ServletContext.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardStats stats = adminService.getDashboardStats();
        request.setAttribute("stats", stats);
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
