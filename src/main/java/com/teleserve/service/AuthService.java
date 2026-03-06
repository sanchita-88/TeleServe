package com.teleserve.service;

import com.teleserve.dao.UserDAO;
import com.teleserve.exception.ServiceException;
import com.teleserve.model.User;
import com.teleserve.util.PasswordUtil;

import java.util.Optional;
import java.util.logging.Logger;

public class AuthService {

    private static final Logger logger = Logger.getLogger(AuthService.class.getName());
    private final UserDAO userDAO;

    public AuthService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public User register(String fullName, String phone, String email, String password) throws ServiceException {
        logger.info("Registering user: " + email);

        if (fullName == null || fullName.trim().isEmpty()) throw new ServiceException("Full name is required.");
        if (phone == null || phone.trim().isEmpty()) throw new ServiceException("Phone is required.");
        if (email == null || email.trim().isEmpty()) throw new ServiceException("Email is required.");
        if (password == null || password.length() < 6) throw new ServiceException("Password must be at least 6 characters.");

        if (userDAO.findByEmail(email).isPresent()) throw new ServiceException("Email already registered.");
        if (userDAO.findByPhone(phone).isPresent()) throw new ServiceException("Phone number already registered.");

        User user = new User();
        user.setFullName(fullName.trim());
        user.setPhone(phone.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setRole("USER");
        user.setStatus("ACTIVE");

        userDAO.createUser(user);
        logger.info("User registered successfully: " + email);
        return userDAO.findByEmail(email).orElseThrow(() -> new ServiceException("Registration failed."));
    }

    public User login(String email, String password) throws ServiceException {
        logger.info("Login attempt: " + email);

        if (email == null || email.trim().isEmpty()) throw new ServiceException("Email is required.");
        if (password == null || password.trim().isEmpty()) throw new ServiceException("Password is required.");

        Optional<User> optUser = userDAO.findByEmail(email.trim().toLowerCase());
        if (optUser.isEmpty()) throw new ServiceException("Invalid email or password.");

        User user = optUser.get();

        if (!PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            throw new ServiceException("Invalid email or password.");
        }

        if ("SUSPENDED".equals(user.getStatus())) {
            throw new ServiceException("Your account has been suspended. Please contact support.");
        }

        logger.info("Login successful: " + email);
        return user;
    }
}