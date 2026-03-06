package com.teleserve.service;

import com.teleserve.dao.RechargeDAO;
import com.teleserve.exception.ServiceException;
import com.teleserve.model.PaginatedResult;
import com.teleserve.model.Plan;
import com.teleserve.model.Recharge;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.logging.Logger;

public class RechargeService {

    private static final Logger logger = Logger.getLogger(RechargeService.class.getName());
    private static final int PAGE_SIZE = 10;

    private final RechargeDAO rechargeDAO;
    private final PlanService planService;

    public RechargeService(RechargeDAO rechargeDAO, PlanService planService) {
        this.rechargeDAO = rechargeDAO;
        this.planService = planService;
    }

    public Recharge processRecharge(int userId, int planId) throws ServiceException {
        logger.info("Processing recharge for userId=" + userId + " planId=" + planId);

        Plan plan = planService.getPlanById(planId);

        if (!plan.isActive()) {
            throw new ServiceException("Selected plan is no longer active.");
        }

        LocalDate today = LocalDate.now();
        LocalDate expiry = today.plusDays(plan.getValidityDays());

        Recharge recharge = new Recharge();
        recharge.setUserId(userId);
        recharge.setPlanId(planId);
        recharge.setAmountPaid(plan.getPrice());
        recharge.setExpiryDate(Date.valueOf(expiry));
        recharge.setStatus("SUCCESS");

        rechargeDAO.createRecharge(recharge);
        logger.info("Recharge successful for userId=" + userId);

        return rechargeDAO.getLatestRechargeByUserId(userId)
                .orElseThrow(() -> new ServiceException("Recharge failed. Please try again."));
    }

    public PaginatedResult<Recharge> getRechargeHistory(int userId, int page) {
        logger.info("Fetching recharge history for userId=" + userId + " page=" + page);
        return rechargeDAO.getRechargesByUserId(userId, page, PAGE_SIZE);
    }

    public PaginatedResult<Recharge> getAllRecharges(int page) {
        logger.info("Fetching all recharges, page=" + page);
        return rechargeDAO.getAllRecharges(page, PAGE_SIZE);
    }
}