package com.teleserve.controller.admin;

import com.teleserve.exception.ServiceException;
import com.teleserve.model.Plan;
import com.teleserve.service.PlanService;
import com.teleserve.util.AppLogger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Logger;

/**
 * GET:  Load all plans (active and inactive) for listing; forward to admin/plans.jsp.
 * POST: Either create a new plan (name, price, dataGb, validityDays, category) or deactivate (planId, action=deactivate).
 */
@WebServlet(urlPatterns = {"/admin/plans"})
public class PlanManagementServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(PlanManagementServlet.class);

    private PlanService planService;
    private com.teleserve.dao.PlanDAO planDAO;

    @Override
    public void init() {
        planService = (PlanService) getServletContext().getAttribute("planService");
        planDAO = (com.teleserve.dao.PlanDAO) getServletContext().getAttribute("planDAO");
        if (planService == null || planDAO == null) {
            throw new IllegalStateException("PlanService or PlanDAO not found in ServletContext.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Plan> allPlans = planDAO.getAllPlans();
        request.setAttribute("activePlans", allPlans);
        request.getRequestDispatcher("/WEB-INF/views/admin/plans.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("deactivate".equalsIgnoreCase(action)) {
            String planIdParam = request.getParameter("planId");
            if (planIdParam == null || planIdParam.trim().isEmpty()) {
                request.getSession(true).setAttribute("flashError", "Plan id required.");
                response.sendRedirect(request.getContextPath() + "/admin/plans");
                return;
            }
            int planId;
            try {
                planId = Integer.parseInt(planIdParam.trim());
            } catch (NumberFormatException e) {
                request.getSession(true).setAttribute("flashError", "Invalid plan id.");
                response.sendRedirect(request.getContextPath() + "/admin/plans");
                return;
            }
            try {
                planService.deactivatePlan(planId);
                request.getSession(true).setAttribute("flashMessage", "Plan deactivated.");
                response.sendRedirect(request.getContextPath() + "/admin/plans");
                return;
            } catch (ServiceException e) {
                request.getSession(true).setAttribute("flashError", e.getMessage());
                response.sendRedirect(request.getContextPath() + "/admin/plans");
                return;
            }
        }

        if ("create".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String dataGbStr = request.getParameter("dataGb");
            String validityDaysStr = request.getParameter("validityDays");
            String category = request.getParameter("category");

            Plan plan = new Plan();
            plan.setName(name != null ? name.trim() : "");
            try {
                plan.setPrice(priceStr != null && !priceStr.trim().isEmpty() ? new BigDecimal(priceStr.trim()) : null);
                plan.setDataGb(dataGbStr != null && !dataGbStr.trim().isEmpty() ? Double.parseDouble(dataGbStr.trim()) : 0.0);
                plan.setValidityDays(validityDaysStr != null && !validityDaysStr.trim().isEmpty() ? Integer.parseInt(validityDaysStr.trim()) : 0);
            } catch (NumberFormatException e) {
                request.getSession(true).setAttribute("flashError", "Invalid number for price, data, or validity.");
                response.sendRedirect(request.getContextPath() + "/admin/plans");
                return;
            }
            plan.setCategory(category != null ? category.trim() : "");
            plan.setActive(true);

            try {
                planService.createPlan(plan);
                request.getSession(true).setAttribute("flashMessage", "Plan created successfully.");
                LOGGER.info("Plan created: planId=" + plan.getPlanId());
            } catch (ServiceException e) {
                request.getSession(true).setAttribute("flashError", e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/plans");
            return;
        }

        request.getSession(true).setAttribute("flashError", "Unknown action.");
        response.sendRedirect(request.getContextPath() + "/admin/plans");
    }
}
