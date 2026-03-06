package com.teleserve.service;

import com.teleserve.dao.PlanDAO;
import com.teleserve.exception.ServiceException;
import com.teleserve.model.Plan;

import java.util.List;
import java.util.logging.Logger;

public class PlanService {

    private static final Logger logger = Logger.getLogger(PlanService.class.getName());
    private final PlanDAO planDAO;

    public PlanService(PlanDAO planDAO) {
        this.planDAO = planDAO;
    }

    public List<Plan> getAllActivePlans() {
        logger.info("Fetching all active plans.");
        return planDAO.getAllActivePlans();
    }

    public Plan getPlanById(int planId) throws ServiceException {
        logger.info("Fetching plan by id: " + planId);
        return planDAO.getPlanById(planId)
                .orElseThrow(() -> new ServiceException("Plan not found or inactive."));
    }

    public void createPlan(Plan plan) throws ServiceException {
        logger.info("Creating plan: " + plan.getName());
        if (plan.getName() == null || plan.getName().trim().isEmpty())
            throw new ServiceException("Plan name is required.");
        if (plan.getPrice() == null)
            throw new ServiceException("Plan price is required.");
        if (plan.getDataGb() <= 0)
            throw new ServiceException("Data must be greater than 0.");
        if (plan.getValidityDays() <= 0)
            throw new ServiceException("Validity must be greater than 0.");
        planDAO.createPlan(plan);
        logger.info("Plan created: " + plan.getName());
    }

    public void deactivatePlan(int planId) throws ServiceException {
        logger.info("Deactivating plan: " + planId);
        planDAO.getPlanById(planId)
                .orElseThrow(() -> new ServiceException("Plan not found."));
        planDAO.deactivatePlan(planId);
        logger.info("Plan deactivated: " + planId);
    }
}