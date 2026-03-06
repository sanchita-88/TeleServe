package com.teleserve.listener;

import com.teleserve.dao.PlanDAO;
import com.teleserve.dao.RechargeDAO;
import com.teleserve.dao.UsageLogDAO;
import com.teleserve.dao.UserDAO;
import com.teleserve.service.AdminService;
import com.teleserve.service.AuthService;
import com.teleserve.service.PlanService;
import com.teleserve.service.RechargeService;
import com.teleserve.service.UsageAnalyticsService;
import com.teleserve.util.AppLogger;
import com.teleserve.util.DBConnection;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * Initializes application-wide resources when the web application starts.
 * Initializes DBConnection and registers DAOs and Services in ServletContext
 * so Servlets can obtain them in init().
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger LOGGER = AppLogger.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Application context initializing");
        ServletContext ctx = sce.getServletContext();
        try {
            DBConnection.init(ctx);
            LOGGER.info("DBConnection initialized");

            UserDAO userDAO = new UserDAO();
            PlanDAO planDAO = new PlanDAO();
            RechargeDAO rechargeDAO = new RechargeDAO();
            UsageLogDAO usageLogDAO = new UsageLogDAO();

            ctx.setAttribute("userDAO", userDAO);
            ctx.setAttribute("planDAO", planDAO);
            ctx.setAttribute("rechargeDAO", rechargeDAO);
            ctx.setAttribute("usageLogDAO", usageLogDAO);

            AuthService authService = new AuthService(userDAO);
            PlanService planService = new PlanService(planDAO);
            RechargeService rechargeService = new RechargeService(rechargeDAO, planService);
            UsageAnalyticsService usageAnalyticsService = new UsageAnalyticsService(usageLogDAO);
            AdminService adminService = new AdminService(userDAO, rechargeDAO);

            ctx.setAttribute("authService", authService);
            ctx.setAttribute("planService", planService);
            ctx.setAttribute("rechargeService", rechargeService);
            ctx.setAttribute("usageAnalyticsService", usageAnalyticsService);
            ctx.setAttribute("adminService", adminService);

            LOGGER.info("Application context initialized successfully");
        } catch (Exception e) {
            LOGGER.severe("Failed to initialize application context: " + e.getMessage());
            throw new IllegalStateException("Application startup failed", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Application context destroyed");
    }
}
