package com.teleserve.model;

import java.math.BigDecimal;

/**
 * POJO for admin dashboard summary statistics.
 */
public class DashboardStats {

    private int totalUsers;
    private int totalRecharges;
    private BigDecimal totalRevenue;

    public DashboardStats() {
    }

    public DashboardStats(int totalUsers, int totalRecharges, BigDecimal totalRevenue) {
        this.totalUsers = totalUsers;
        this.totalRecharges = totalRecharges;
        this.totalRevenue = totalRevenue;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalRecharges() {
        return totalRecharges;
    }

    public void setTotalRecharges(int totalRecharges) {
        this.totalRecharges = totalRecharges;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
