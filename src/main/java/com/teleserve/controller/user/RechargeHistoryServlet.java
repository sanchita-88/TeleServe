package com.teleserve.controller.user;

import com.teleserve.exception.ServiceException;
import com.teleserve.model.PaginatedResult;
import com.teleserve.model.Recharge;
import com.teleserve.model.User;
import com.teleserve.service.RechargeService;
import com.teleserve.util.AppLogger;
import com.teleserve.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * GET: Load paginated recharge history for current user; forward to user/history.jsp.
 */
@WebServlet(urlPatterns = {"/user/history"})
public class RechargeHistoryServlet extends HttpServlet {

    private static final Logger LOGGER = AppLogger.getLogger(RechargeHistoryServlet.class);

    private RechargeService rechargeService;

    @Override
    public void init() {
        rechargeService = (RechargeService) getServletContext().getAttribute("rechargeService");
        if (rechargeService == null) {
            throw new IllegalStateException("RechargeService not found in ServletContext.");
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

        String pageParam = request.getParameter("page");
        int page = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {
            }
        }

        try {
            PaginatedResult<Recharge> result = rechargeService.getRechargeHistory(user.getUserId(), page);
            request.setAttribute("rechargeResult", result);
            request.getRequestDispatcher("/WEB-INF/views/user/history.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.warning("Failed to load recharge history: " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/shared/error.jsp").forward(request, response);
        }
    }
}
