package com.teleserve.service;

import com.teleserve.dao.UsageLogDAO;
import com.teleserve.model.Plan;
import com.teleserve.model.UsageLog;

import java.util.List;
import java.util.logging.Logger;

public class UsageAnalyticsService {

    private static final Logger logger = Logger.getLogger(UsageAnalyticsService.class.getName());
    private final UsageLogDAO usageLogDAO;

    public UsageAnalyticsService(UsageLogDAO usageLogDAO) {
        this.usageLogDAO = usageLogDAO;
    }

    public double getDailyAverageUsageMb(int userId) {
        logger.info("Calculating daily average usage for userId=" + userId);
        List<UsageLog> logs = usageLogDAO.getLast90DaysUsage(userId);
        if (logs == null || logs.isEmpty()) return 0.0;
        double total = logs.stream().mapToDouble(UsageLog::getDataUsedMb).sum();
        return total / logs.size();
    }

    public double getMonthlyEstimatedUsageGb(int userId) {
        double dailyAvgMb = getDailyAverageUsageMb(userId);
        double monthlyMb = dailyAvgMb * 30;
        return monthlyMb / 1024.0;
    }

    public double getPlanUtilizationPercent(int userId, double planDataGb) {
        logger.info("Calculating plan utilization for userId=" + userId);
        if (planDataGb <= 0) return 0.0;
        double usedGb = getMonthlyEstimatedUsageGb(userId);
        double percent = (usedGb / planDataGb) * 100.0;
        return Math.min(percent, 100.0);
    }

    /**
     * Rule-based plan suggestion — NOT machine learning.
     * Calculates estimated monthly GB need from usage history,
     * then finds the cheapest active plan that covers that need.
     */
    public Plan suggestBestPlan(int userId, List<Plan> availablePlans) {
        logger.info("Suggesting best plan for userId=" + userId);

        double estimatedMonthlyGb = getMonthlyEstimatedUsageGb(userId);
        logger.info("Estimated monthly usage: " + estimatedMonthlyGb + " GB");

        Plan bestPlan = null;
        for (Plan plan : availablePlans) {
            if (plan.getDataGb() >= estimatedMonthlyGb) {
                if (bestPlan == null || plan.getPrice().compareTo(bestPlan.getPrice()) < 0) {
                    bestPlan = plan;
                }
            }
        }

        if (bestPlan == null && !availablePlans.isEmpty()) {
            bestPlan = availablePlans.stream()
                    .max((a, b) -> Double.compare(a.getDataGb(), b.getDataGb()))
                    .orElse(null);
        }

        return bestPlan;
    }
}