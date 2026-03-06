package com.teleserve.controller.user;

import com.teleserve.exception.ServiceException;
import com.teleserve.model.Plan;
import com.teleserve.model.Recharge;
import com.teleserve.model.User;
import com.teleserve.service.PlanService;
import com.teleserve.service.RechargeService;
import com.teleserve.service.UsageAnalyticsService;
import com.teleserve.util.AppLogger;
import com.teleserve.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

/**
 * GET: Load current user from session, latest recharge (active plan), usage summary
 *      (daily avg GB, utilization %), and plan suggestion; forward to user/dashboard.jsp.
 */
@WebServlet(urlPatterns = {"/user/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(DashboardServlet.class);

    private PlanService planService;
    private RechargeService rechargeService;
    private UsageAnalyticsService usageAnalyticsService;

    @Override
    public void init() {
        planService = (PlanService) getServletContext().getAttribute("planService");
        rechargeService = (RechargeService) getServletContext().getAttribute("rechargeService");
        usageAnalyticsService = (UsageAnalyticsService) getServletContext().getAttribute("usageAnalyticsService");
        if (planService == null || rechargeService == null || usageAnalyticsService == null) {
            throw new IllegalStateException("Required services not found in ServletContext.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = SessionUtil.getCurrentUser(request.getSession(false));
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = user.getUserId();
        request.setAttribute("user", user);

        Optional<Recharge> latestRecharge = rechargeService.getRechargeHistory(userId, 1).getData().stream().findFirst();
        latestRecharge.ifPresent(r -> {
            request.setAttribute("currentRecharge", r);
            request.setAttribute("currentPlan", r.getPlan());
        });

        double dailyAvgGb = 0.0;
        double utilizationPercent = 0.0;
        Plan suggestedPlan = null;
        try {
             List<Plan> activePlans = planService.getAllActivePlans();
            double dailyAvgMb = usageAnalyticsService.getDailyAverageUsageMb(userId);
            dailyAvgGb = dailyAvgMb / 1024.0;
            Plan currentPlan = latestRecharge.map(Recharge::getPlan).orElse(null);
            double planDataGb = currentPlan != null ? currentPlan.getDataGb() : 0.0;
            utilizationPercent = usageAnalyticsService.getPlanUtilizationPercent(userId, planDataGb);
            suggestedPlan = usageAnalyticsService.suggestBestPlan(userId, activePlans);
        } catch (Exception e) {
            LOGGER.warning("Usage analytics failed for userId=" + userId + ": " + e.getMessage());
        }
        request.setAttribute("dailyAvgUsageGb", dailyAvgGb);
        request.setAttribute("utilizationPercent", utilizationPercent);
        request.setAttribute("suggestedPlan", suggestedPlan);

        request.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(request, response);
    }
}
