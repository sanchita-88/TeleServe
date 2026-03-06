package com.teleserve.service;

import com.teleserve.dao.RechargeDAO;
import com.teleserve.dao.UserDAO;
import com.teleserve.model.DashboardStats;
import com.teleserve.util.AppLogger;

import java.math.BigDecimal;
import java.util.logging.Logger;

public class AdminService {

    private static final Logger LOGGER = AppLogger.getLogger(AdminService.class);

    private final UserDAO userDAO;
    private final RechargeDAO rechargeDAO;

    public AdminService(UserDAO userDAO, RechargeDAO rechargeDAO) {
        this.userDAO = userDAO;
        this.rechargeDAO = rechargeDAO;
    }

    public DashboardStats getDashboardStats() {
        LOGGER.info("Fetching admin dashboard stats");
        int totalUsers = userDAO.getTotalUserCount();
        int totalRecharges = rechargeDAO.getTotalRechargeCount();
        BigDecimal totalRevenue = rechargeDAO.getTotalRevenue();
        return new DashboardStats(totalUsers, totalRecharges,
                totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
    }
}
