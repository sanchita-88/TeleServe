package com.teleserve.filter;

import com.teleserve.dao.UserDAO;
import com.teleserve.model.User;
import com.teleserve.util.AppLogger;
import com.teleserve.util.SessionUtil;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;
import java.util.logging.Logger;

@WebFilter(urlPatterns = {"/user/*", "/admin/*"})
public class AuthFilter implements Filter {

    private static final Logger LOGGER = AppLogger.getLogger(AuthFilter.class);
    private static final String REMEMBER_COOKIE = "teleserve_remember";

    private UserDAO userDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        ServletContext ctx = filterConfig.getServletContext();
        userDAO = (UserDAO) ctx.getAttribute("userDAO");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        User user = SessionUtil.getCurrentUser(req.getSession(false));

        // Try auto-login from Remember Me cookie
        if (user == null && userDAO != null) {
            user = tryRememberMe(req);
            if (user != null) {
                HttpSession session = req.getSession(true);
                SessionUtil.setCurrentUser(session, user);
                LOGGER.info("Auto-login via remember cookie: userId=" + user.getUserId());
            }
        }

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

    @Override
    public void destroy() {
    }

    private User tryRememberMe(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies == null) return null;
        for (Cookie cookie : cookies) {
            if (REMEMBER_COOKIE.equals(cookie.getName())) {
                String token = cookie.getValue();
                if (token != null && !token.isEmpty()) {
                    Optional<User> optUser = userDAO.findByRememberToken(token);
                    return optUser.orElse(null);
                }
            }
        }
        return null;
    }
}