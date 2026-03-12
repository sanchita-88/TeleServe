package com.teleserve.dao;

import com.teleserve.exception.DAOException;
import com.teleserve.model.PaginatedResult;
import com.teleserve.model.User;
import com.teleserve.util.AppLogger;
import com.teleserve.util.DBConnection;
import com.teleserve.util.PaginationUtil;

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

public class UserDAO {

    private static final Logger LOGGER = AppLogger.getLogger(UserDAO.class);

    private static final String INSERT_USER_SQL =
            "INSERT INTO users (full_name, phone, email, password_hash, role, status, created_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_BY_EMAIL_SQL =
            "SELECT user_id, full_name, phone, email, password_hash, role, status, created_at " +
            "FROM users WHERE email = ?";
    private static final String SELECT_BY_PHONE_SQL =
            "SELECT user_id, full_name, phone, email, password_hash, role, status, created_at " +
            "FROM users WHERE phone = ?";
    private static final String SELECT_BY_ID_SQL =
            "SELECT user_id, full_name, phone, email, password_hash, role, status, created_at " +
            "FROM users WHERE user_id = ?";
    private static final String COUNT_USERS_SQL = "SELECT COUNT(*) FROM users";
    private static final String SELECT_ALL_PAGED_SQL =
            "SELECT user_id, full_name, phone, email, password_hash, role, status, created_at " +
            "FROM users ORDER BY created_at DESC LIMIT ? OFFSET ?";
    private static final String UPDATE_STATUS_SQL = "UPDATE users SET status = ? WHERE user_id = ?";
    private static final String UPDATE_REMEMBER_TOKEN_SQL =
            "UPDATE users SET remember_token = ? WHERE user_id = ?";
    private static final String SELECT_BY_REMEMBER_TOKEN_SQL =
            "SELECT user_id, full_name, phone, email, password_hash, role, status, created_at " +
            "FROM users WHERE remember_token = ? AND status = 'ACTIVE'";

    public void createUser(User user) {
        LOGGER.info("Creating new user with email=" + user.getEmail());
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_USER_SQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
            Timestamp createdAt = user.getCreatedAt() != null ? user.getCreatedAt() : new Timestamp(System.currentTimeMillis());
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());
            ps.setTimestamp(7, createdAt);
            if (ps.executeUpdate() == 0) throw new DAOException("Creating user failed, no rows affected.");
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                    user.setCreatedAt(createdAt);
                    LOGGER.info("User created with userId=" + user.getUserId());
                } else throw new DAOException("Creating user failed, no ID obtained.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating user", e);
            throw new DAOException("Error creating user", e);
        }
    }

    public Optional<User> findByEmail(String email) {
        LOGGER.info("Finding user by email=" + email);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_EMAIL_SQL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by email", e);
            throw new DAOException("Error finding user by email", e);
        }
        return Optional.empty();
    }

    public Optional<User> findByPhone(String phone) {
        LOGGER.info("Finding user by phone=" + phone);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_PHONE_SQL)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by phone", e);
            throw new DAOException("Error finding user by phone", e);
        }
        return Optional.empty();
    }

    public Optional<User> findById(int userId) {
        LOGGER.info("Finding user by id=" + userId);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID_SQL)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by id", e);
            throw new DAOException("Error finding user by id", e);
        }
        return Optional.empty();
    }

    public int getTotalUserCount() {
        LOGGER.info("Getting total user count");
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_USERS_SQL);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total user count", e);
            throw new DAOException("Error getting total user count", e);
        }
        return 0;
    }

    public PaginatedResult<User> getAllUsers(int page, int pageSize) {
        LOGGER.info("Getting all users page=" + page + " pageSize=" + pageSize);
        List<User> list = new ArrayList<>();
        int total;
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement countPs = conn.prepareStatement(COUNT_USERS_SQL);
             PreparedStatement dataPs = conn.prepareStatement(SELECT_ALL_PAGED_SQL)) {
            try (ResultSet rs = countPs.executeQuery()) {
                rs.next();
                total = rs.getInt(1);
            }
            int offset = PaginationUtil.getOffset(page, pageSize);
            dataPs.setInt(1, pageSize);
            dataPs.setInt(2, offset);
            try (ResultSet rs = dataPs.executeQuery()) {
                while (rs.next()) list.add(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting users", e);
            throw new DAOException("Error getting users", e);
        }
        return new PaginatedResult<>(list, page, PaginationUtil.getTotalPages(total, pageSize), total);
    }

    public void updateStatus(int userId, String status) {
        LOGGER.info("Updating user status userId=" + userId + " status=" + status);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_STATUS_SQL)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user status", e);
            throw new DAOException("Error updating user status", e);
        }
    }

    public void updateRememberToken(int userId, String token) {
        LOGGER.info("Updating remember token for userId=" + userId);
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_REMEMBER_TOKEN_SQL)) {
            ps.setString(1, token);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating remember token", e);
            throw new DAOException("Error updating remember token", e);
        }
    }

    public Optional<User> findByRememberToken(String token) {
        LOGGER.info("Finding user by remember token");
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_REMEMBER_TOKEN_SQL)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user by remember token", e);
            throw new DAOException("Error finding user by remember token", e);
        }
        return Optional.empty();
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}