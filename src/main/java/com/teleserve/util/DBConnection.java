package com.teleserve.util;

import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Application-wide DB connection source. Initialized once from ServletContext (context-params);
 * getInstance() returns the singleton, getConnection() returns a new Connection per call.
 * Caller is responsible for closing connections (e.g. try-with-resources).
 */
public class DBConnection {

    private static final String PARAM_URL = "db.url";
    private static final String PARAM_USER = "db.user";
    private static final String PARAM_PASSWORD = "db.password";
    private static final String PARAM_DRIVER = "db.driver";

    private static volatile DBConnection instance;

    private final String url;
    private final String user;
    private final String password;

    private DBConnection(String url, String user, String password) {
        this.url = url;
        this.user = user;
        this.password = password != null ? password : "";
    }

    /**
     * Initializes the singleton from context init params. Call from ServletContextListener.
     */
    public static void init(ServletContext ctx) {
        if (ctx == null) {
            throw new IllegalArgumentException("ServletContext cannot be null");
        }
        String driver = ctx.getInitParameter(PARAM_DRIVER);
        if (driver != null && !driver.isEmpty()) {
            try {
                Class.forName(driver);
            } catch (ClassNotFoundException e) {
                throw new IllegalStateException("JDBC driver not found: " + driver, e);
            }
        }
        String url = ctx.getInitParameter(PARAM_URL);
        String user = ctx.getInitParameter(PARAM_USER);
        String password = ctx.getInitParameter(PARAM_PASSWORD);
        if (url == null || url.isEmpty()) {
            throw new IllegalStateException("Missing context-param: " + PARAM_URL);
        }
        instance = new DBConnection(url, user, password);
    }

    public static DBConnection getInstance() {
        if (instance == null) {
            throw new IllegalStateException("DBConnection not initialized. Call init(ServletContext) in context listener.");
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        if (user != null && !user.isEmpty()) {
            return DriverManager.getConnection(url, user, password);
        }
        return DriverManager.getConnection(url);
    }
}
