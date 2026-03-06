package com.teleserve.filter;

import com.teleserve.model.User;
import com.teleserve.util.AppLogger;
import com.teleserve.util.SessionUtil;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Protects /user/* and /admin/*: requires a logged-in user; /admin/* also requires role "admin".
 * Unauthenticated or unauthorized requests are redirected to /login.
 */
@WebFilter(urlPatterns = {"/user/*", "/admin/*"})
public class AuthFilter implements Filter {

    private static final Logger LOGGER = AppLogger.getLogger(AuthFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        User user = SessionUtil.getCurrentUser(req.getSession(false));

        if (user == null) {
            LOGGER.fine("Unauthenticated access to " + req.getRequestURI() + " -> redirect to login");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getRequestURI();
        String contextPath = req.getContextPath();
        String pathInfo = path.substring(contextPath.length());

        if (pathInfo.startsWith("/admin/")) {
            if (!"admin".equalsIgnoreCase(user.getRole())) {
                LOGGER.fine("User " + user.getUserId() + " attempted admin access without admin role");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
