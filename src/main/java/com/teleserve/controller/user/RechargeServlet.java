package com.teleserve.controller.user;

import com.teleserve.exception.ServiceException;
import com.teleserve.model.Plan;
import com.teleserve.model.Recharge;
import com.teleserve.model.User;
import com.teleserve.service.PlanService;
import com.teleserve.service.RechargeService;
import com.teleserve.util.AppLogger;
import com.teleserve.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * GET:  Load active plans, forward to user/recharge.jsp.
 * POST: Process recharge (planId); on success set flash and redirect to /user/history;
 *       on failure set error and forward to user/recharge.jsp.
 */
@WebServlet(urlPatterns = {"/user/recharge"})
public class RechargeServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(RechargeServlet.class);

    private PlanService planService;
    private RechargeService rechargeService;

    @Override
    public void init() {
        planService = (PlanService) getServletContext().getAttribute("planService");
        rechargeService = (RechargeService) getServletContext().getAttribute("rechargeService");
        if (planService == null || rechargeService == null) {
            throw new IllegalStateException("Required services not found in ServletContext.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Plan> plans = planService.getAllActivePlans();
        request.setAttribute("plans", plans);
        request.getRequestDispatcher("/WEB-INF/views/user/recharge.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = SessionUtil.getCurrentUser(request.getSession(false));
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String planIdParam = request.getParameter("planId");
        if (planIdParam == null || planIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please select a plan.");
            doGet(request, response);
            return;
        }

        int planId;
        try {
            planId = Integer.parseInt(planIdParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid plan selected.");
            doGet(request, response);
            return;
        }

        try {
            Recharge recharge = rechargeService.processRecharge(user.getUserId(), planId);
            request.getSession(true).setAttribute("flashMessage",
                    "Recharge successful. Plan active until " + recharge.getExpiryDate() + ".");
            LOGGER.info("Recharge processed for userId=" + user.getUserId() + " rechargeId=" + recharge.getRechargeId());
            response.sendRedirect(request.getContextPath() + "/user/history");
            return;
        } catch (Exception e) {
            LOGGER.warning("Recharge failed: " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("plans", planService.getAllActivePlans());
            request.getRequestDispatcher("/WEB-INF/views/user/recharge.jsp").forward(request, response);
        }
    }
}
