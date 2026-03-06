package com.teleserve.dao;

import com.teleserve.exception.DAOException;
import com.teleserve.model.UsageLog;
import com.teleserve.util.AppLogger;
import com.teleserve.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UsageLogDAO {

    private static final Logger LOGGER = AppLogger.getLogger(UsageLogDAO.class);

    private static final String INSERT_SQL = "INSERT INTO usage_log (user_id, date, data_used_mb) VALUES (?, ?, ?)";
    private static final String LAST_90_DAYS_SQL =
            "SELECT log_id, user_id, date, data_used_mb FROM usage_log " +
            "WHERE user_id = ? AND date >= CURRENT_DATE - INTERVAL 90 DAY ORDER BY date ASC";
    private static final String MONTHLY_AGG_SQL =
            "SELECT DATE_FORMAT(date, '%Y-%m') AS month_label, SUM(data_used_mb) / 1024 AS gb_used " +
            "FROM usage_log WHERE user_id = ? GROUP BY month_label ORDER BY month_label ASC";

    public void insertLog(UsageLog log) {
        LOGGER.info("Inserting usage log userId=" + log.getUserId());
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            Date d = log.getDate() != null ? log.getDate() : new Date(System.currentTimeMillis());
            ps.setInt(1, log.getUserId());
            ps.setDate(2, d);
            ps.setDouble(3, log.getDataUsedMb());
            if (ps.executeUpdate() == 0) throw new DAOException("Inserting usage log failed.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting usage log", e);
            throw new DAOException("Error inserting usage log", e);
        }
    }

    public List<UsageLog> getLast90DaysUsage(int userId) {
        LOGGER.info("Getting last 90 days usage userId=" + userId);
        List<UsageLog> list = new ArrayList<>();
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(LAST_90_DAYS_SQL)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting last 90 days usage", e);
            throw new DAOException("Error getting usage logs", e);
        }
        return list;
    }

    public Map<String, Double> getMonthlyAggregatedUsage(int userId) {
        LOGGER.info("Getting monthly aggregated usage userId=" + userId);
        Map<String, Double> map = new LinkedHashMap<>();
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(MONTHLY_AGG_SQL)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) map.put(rs.getString("month_label"), rs.getDouble("gb_used"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting monthly usage", e);
            throw new DAOException("Error getting monthly aggregated usage", e);
        }
        return map;
    }

    private UsageLog mapRow(ResultSet rs) throws SQLException {
        UsageLog log = new UsageLog();
        log.setLogId(rs.getInt("log_id"));
        log.setUserId(rs.getInt("user_id"));
        log.setDate(rs.getDate("date"));
        log.setDataUsedMb(rs.getDouble("data_used_mb"));
        return log;
    }
}
