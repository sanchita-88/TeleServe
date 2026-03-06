package com.teleserve.dao;

import com.teleserve.exception.DAOException;
import com.teleserve.model.PaginatedResult;
import com.teleserve.model.Plan;
import com.teleserve.model.Recharge;
import com.teleserve.util.AppLogger;
import com.teleserve.util.DBConnection;
import com.teleserve.util.PaginationUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RechargeDAO {

    private static final Logger LOGGER = AppLogger.getLogger(RechargeDAO.class);

    private static final String INSERT_SQL =
            "INSERT INTO recharges (user_id, plan_id, amount_paid, recharged_at, expiry_date, status) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String COUNT_BY_USER_SQL = "SELECT COUNT(*) FROM recharges WHERE user_id = ?";
    private static final String COUNT_ALL_SQL = "SELECT COUNT(*) FROM recharges";
    private static final String SUM_REVENUE_SQL = "SELECT COALESCE(SUM(amount_paid), 0) FROM recharges WHERE status = 'SUCCESS'";
    private static final String SELECT_BY_USER_PAGED_SQL =
            "SELECT r.recharge_id, r.user_id, r.plan_id, r.amount_paid, r.recharged_at, r.expiry_date, r.status, " +
            "p.plan_id AS p_plan_id, p.name AS p_name, p.price AS p_price, p.data_gb AS p_data_gb, " +
            "p.validity_days AS p_validity_days, p.category AS p_category, p.is_active AS p_is_active, p.created_at AS p_created_at " +
            "FROM recharges r JOIN plans p ON r.plan_id = p.plan_id WHERE r.user_id = ? ORDER BY r.recharged_at DESC LIMIT ? OFFSET ?";
    private static final String SELECT_LATEST_BY_USER_SQL =
            "SELECT r.recharge_id, r.user_id, r.plan_id, r.amount_paid, r.recharged_at, r.expiry_date, r.status, " +
            "p.plan_id AS p_plan_id, p.name AS p_name, p.price AS p_price, p.data_gb AS p_data_gb, " +
            "p.validity_days AS p_validity_days, p.category AS p_category, p.is_active AS p_is_active, p.created_at AS p_created_at " +
            "FROM recharges r JOIN plans p ON r.plan_id = p.plan_id WHERE r.user_id = ? ORDER BY r.recharged_at DESC LIMIT 1";
    private static final String SELECT_ALL_PAGED_SQL =
            "SELECT r.recharge_id, r.user_id, r.plan_id, r.amount_paid, r.recharged_at, r.expiry_date, r.status, " +
            "p.plan_id AS p_plan_id, p.name AS p_name, p.price AS p_price, p.data_gb AS p_data_gb, " +
            "p.validity_days AS p_validity_days, p.category AS p_category, p.is_active AS p_is_active, p.created_at AS p_created_at " +
            "FROM recharges r JOIN plans p ON r.plan_id = p.plan_id ORDER BY r.recharged_at DESC LIMIT ? OFFSET ?";

    public void createRecharge(Recharge r) {
        LOGGER.info("Creating recharge userId=" + r.getUserId() + " planId=" + r.getPlanId());
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
            Timestamp at = r.getRechargedAt() != null ? r.getRechargedAt() : new Timestamp(System.currentTimeMillis());
            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getPlanId());
            ps.setBigDecimal(3, r.getAmountPaid() != null ? r.getAmountPaid() : BigDecimal.ZERO);
            ps.setTimestamp(4, at);
            ps.setDate(5, r.getExpiryDate());
            ps.setString(6, r.getStatus());
            if (ps.executeUpdate() == 0) throw new DAOException("Creating recharge failed.");
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    r.setRechargeId(rs.getInt(1));
                    r.setRechargedAt(at);
                } else throw new DAOException("Creating recharge failed, no ID.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating recharge", e);
            throw new DAOException("Error creating recharge", e);
        }
    }

    public int getTotalRechargeCount() {
        LOGGER.info("Getting total recharge count");
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_ALL_SQL);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total recharge count", e);
            throw new DAOException("Error getting total recharge count", e);
        }
        return 0;
    }

    public BigDecimal getTotalRevenue() {
        LOGGER.info("Getting total revenue");
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SUM_REVENUE_SQL);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total revenue", e);
            throw new DAOException("Error getting total revenue", e);
        }
        return BigDecimal.ZERO;
    }

    public PaginatedResult<Recharge> getRechargesByUserId(int userId, int page, int pageSize) {
        LOGGER.info("Getting recharges userId=" + userId + " page=" + page);
        List<Recharge> list = new ArrayList<>();
        int total;
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement countPs = conn.prepareStatement(COUNT_BY_USER_SQL);
             PreparedStatement dataPs = conn.prepareStatement(SELECT_BY_USER_PAGED_SQL)) {
            countPs.setInt(1, userId);
            try (ResultSet rs = countPs.executeQuery()) {
                rs.next();
                total = rs.getInt(1);
            }
            int offset = PaginationUtil.getOffset(page, pageSize);
            dataPs.setInt(1, userId);
            dataPs.setInt(2, pageSize);
            dataPs.setInt(3, offset);
            try (ResultSet rs = dataPs.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recharges by user", e);
            throw new DAOException("Error getting recharges", e);
        }
        return new PaginatedResult<>(list, page, PaginationUtil.getTotalPages(total, pageSize), total);
    }

    public Optional<Recharge> getLatestRechargeByUserId(int userId) {
        LOGGER.info("Getting latest recharge userId=" + userId);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_LATEST_BY_USER_SQL)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting latest recharge", e);
            throw new DAOException("Error getting latest recharge", e);
        }
        return Optional.empty();
    }

    public PaginatedResult<Recharge> getAllRecharges(int page, int pageSize) {
        LOGGER.info("Getting all recharges page=" + page);
        List<Recharge> list = new ArrayList<>();
        int total;
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement countPs = conn.prepareStatement(COUNT_ALL_SQL);
             PreparedStatement dataPs = conn.prepareStatement(SELECT_ALL_PAGED_SQL)) {
            try (ResultSet rs = countPs.executeQuery()) {
                rs.next();
                total = rs.getInt(1);
            }
            int offset = PaginationUtil.getOffset(page, pageSize);
            dataPs.setInt(1, pageSize);
            dataPs.setInt(2, offset);
            try (ResultSet rs = dataPs.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all recharges", e);
            throw new DAOException("Error getting all recharges", e);
        }
        return new PaginatedResult<>(list, page, PaginationUtil.getTotalPages(total, pageSize), total);
    }

     private Recharge mapRow(ResultSet rs) throws SQLException {
        Recharge r = new Recharge();
        r.setRechargeId(rs.getInt("recharge_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setPlanId(rs.getInt("plan_id"));
        r.setAmountPaid(rs.getBigDecimal("amount_paid"));
        r.setRechargedAt(rs.getTimestamp("recharged_at"));
        r.setExpiryDate(rs.getDate("expiry_date"));
        r.setStatus(rs.getString("status"));
        Plan p = new Plan();
        p.setPlanId(rs.getInt("p_plan_id"));
        p.setName(rs.getString("p_name"));
        p.setPrice(rs.getBigDecimal("p_price"));
        p.setDataGb(rs.getDouble("p_data_gb"));
        p.setValidityDays(rs.getInt("p_validity_days"));
        p.setCategory(rs.getString("p_category"));
        p.setActive(rs.getBoolean("p_is_active"));
        p.setCreatedAt(rs.getTimestamp("p_created_at"));
        r.setPlan(p);
        return r;
    }
}
