package com.teleserve.dao;

import com.teleserve.exception.DAOException;
import com.teleserve.model.Plan;
import com.teleserve.util.AppLogger;
import com.teleserve.util.DBConnection;

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

public class PlanDAO {

    private static final Logger LOGGER = AppLogger.getLogger(PlanDAO.class);

    private static final String SELECT_ALL_ACTIVE_SQL =
            "SELECT plan_id, name, price, data_gb, validity_days, category, is_active, created_at " +
            "FROM plans WHERE is_active = 1 ORDER BY price ASC";
    private static final String SELECT_ALL_SQL =
            "SELECT plan_id, name, price, data_gb, validity_days, category, is_active, created_at " +
            "FROM plans ORDER BY is_active DESC, price ASC";
    private static final String SELECT_BY_ID_SQL =
            "SELECT plan_id, name, price, data_gb, validity_days, category, is_active, created_at " +
            "FROM plans WHERE plan_id = ?";
    private static final String INSERT_PLAN_SQL =
            "INSERT INTO plans (name, price, data_gb, validity_days, category, is_active, created_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PLAN_SQL =
            "UPDATE plans SET name = ?, price = ?, data_gb = ?, validity_days = ?, category = ?, is_active = ? WHERE plan_id = ?";
    private static final String DEACTIVATE_PLAN_SQL = "UPDATE plans SET is_active = 0 WHERE plan_id = ?";

    public List<Plan> getAllActivePlans() {
        LOGGER.info("Getting all active plans");
        List<Plan> list = new ArrayList<>();
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_ACTIVE_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowToPlan(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting active plans", e);
            throw new DAOException("Error getting active plans", e);
        }
        return list;
    }

    public List<Plan> getAllPlans() {
        LOGGER.info("Getting all plans");
        List<Plan> list = new ArrayList<>();
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRowToPlan(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all plans", e);
            throw new DAOException("Error getting all plans", e);
        }
        return list;
    }

    public Optional<Plan> getPlanById(int planId) {
        LOGGER.info("Getting plan by id=" + planId);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID_SQL)) {
            ps.setInt(1, planId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRowToPlan(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting plan by id", e);
            throw new DAOException("Error getting plan", e);
        }
        return Optional.empty();
    }

    public void createPlan(Plan plan) {
        LOGGER.info("Creating plan: " + plan.getName());
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_PLAN_SQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
            Timestamp createdAt = plan.getCreatedAt() != null ? plan.getCreatedAt() : new Timestamp(System.currentTimeMillis());
            ps.setString(1, plan.getName());
            ps.setBigDecimal(2, plan.getPrice() != null ? plan.getPrice() : BigDecimal.ZERO);
            ps.setDouble(3, plan.getDataGb());
            ps.setInt(4, plan.getValidityDays());
            ps.setString(5, plan.getCategory());
            ps.setBoolean(6, plan.isActive());
            ps.setTimestamp(7, createdAt);
            if (ps.executeUpdate() == 0) throw new DAOException("Creating plan failed.");
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    plan.setPlanId(rs.getInt(1));
                    plan.setCreatedAt(createdAt);
                } else throw new DAOException("Creating plan failed, no ID.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating plan", e);
            throw new DAOException("Error creating plan", e);
        }
    }

    public void updatePlan(Plan plan) {
        LOGGER.info("Updating plan id=" + plan.getPlanId());
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PLAN_SQL)) {
            ps.setString(1, plan.getName());
            ps.setBigDecimal(2, plan.getPrice() != null ? plan.getPrice() : BigDecimal.ZERO);
            ps.setDouble(3, plan.getDataGb());
            ps.setInt(4, plan.getValidityDays());
            ps.setString(5, plan.getCategory());
            ps.setBoolean(6, plan.isActive());
            ps.setInt(7, plan.getPlanId());
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating plan", e);
            throw new DAOException("Error updating plan", e);
        }
    }

    public void deactivatePlan(int planId) {
        LOGGER.info("Deactivating plan id=" + planId);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(DEACTIVATE_PLAN_SQL)) {
            ps.setInt(1, planId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deactivating plan", e);
            throw new DAOException("Error deactivating plan", e);
        }
    }

     private Plan mapRowToPlan(ResultSet rs) throws SQLException {
        Plan p = new Plan();
        p.setPlanId(rs.getInt("plan_id"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setDataGb(rs.getDouble("data_gb"));
        p.setValidityDays(rs.getInt("validity_days"));
        p.setCategory(rs.getString("category"));
        p.setActive(rs.getBoolean("is_active"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
