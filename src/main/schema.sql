-- TeleServe Database Schema
-- Tables: users, plans, recharges, usage_log
-- Note: This is mock data only, no real telecom network integration

USE teleserve;

-- -----------------------------------------------
-- TABLE: plans (create before users due to FK)
-- -----------------------------------------------
CREATE TABLE plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    data_gb DECIMAL(10,2) NOT NULL,
    validity_days INT NOT NULL,
    category ENUM('PREPAID','POSTPAID') NOT NULL DEFAULT 'PREPAID',
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- TABLE: users
-- -----------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
    status ENUM('ACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- TABLE: recharges
-- -----------------------------------------------
CREATE TABLE recharges (
    recharge_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    recharged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATE NOT NULL,
    status ENUM('SUCCESS','FAILED','PENDING') NOT NULL DEFAULT 'SUCCESS',
    CONSTRAINT fk_recharge_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_recharge_plan FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE RESTRICT
);

-- -----------------------------------------------
-- TABLE: usage_log
-- -----------------------------------------------
CREATE TABLE usage_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    data_used_mb DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_usage_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- -----------------------------------------------
-- INDEXES
-- -----------------------------------------------
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_recharges_user_id ON recharges(user_id);
CREATE INDEX idx_recharges_recharged_at ON recharges(recharged_at);
CREATE INDEX idx_usage_log_user_date ON usage_log(user_id, date);

-- -----------------------------------------------
-- SEED DATA: plans
-- -----------------------------------------------
INSERT INTO plans (name, price, data_gb, validity_days, category) VALUES
('Basic 1GB',  99.00,  1.0,  28, 'PREPAID'),
('Starter 2GB', 149.00, 2.0, 28, 'PREPAID'),
('Value 5GB',  199.00,  5.0,  28, 'PREPAID'),
('Popular 10GB', 299.00, 10.0, 28, 'PREPAID'),
('Premium 20GB', 499.00, 20.0, 56, 'PREPAID'),
('Unlimited Lite', 399.00, 40.0, 28, 'PREPAID'),
('Unlimited Pro', 599.00, 75.0, 56, 'PREPAID'),
('Postpaid 10GB', 349.00, 10.0, 30, 'POSTPAID'),
('Postpaid 20GB', 599.00, 20.0, 30, 'POSTPAID'),
('Postpaid Unlimited', 999.00, 100.0, 30, 'POSTPAID');

-- -----------------------------------------------
-- SEED DATA: users (passwords are BCrypt of 'password123')
-- -----------------------------------------------
INSERT INTO users (full_name, phone, email, password_hash, role, status) VALUES
('Admin User',    '9000000001', 'admin@teleserve.com',  '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'ADMIN', 'ACTIVE'),
('Rahul Sharma',  '9000000002', 'rahul@example.com',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE'),
('Priya Patel',   '9000000003', 'priya@example.com',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE'),
('Amit Singh',    '9000000004', 'amit@example.com',    '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE'),
('Sneha Iyer',    '9000000005', 'sneha@example.com',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE'),
('Vikram Nair',   '9000000006', 'vikram@example.com',  '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE'),
('Anjali Mehta',  '9000000007', 'anjali@example.com',  '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE'),
('Rohan Gupta',   '9000000008', 'rohan@example.com',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE'),
('Kavya Reddy',   '9000000009', 'kavya@example.com',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'SUSPENDED'),
('Arjun Joshi',   '9000000010', 'arjun@example.com',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOe6j5xTmx.HNqJLpfWo8RfKmFjN9bUAC', 'USER',  'ACTIVE');

-- -----------------------------------------------
-- SEED DATA: recharges
-- -----------------------------------------------
INSERT INTO recharges (user_id, plan_id, amount_paid, recharged_at, expiry_date, status) VALUES
(2, 3, 199.00, '2026-02-01', '2026-03-01', 'SUCCESS'),
(2, 4, 299.00, '2026-03-01', '2026-03-29', 'SUCCESS'),
(3, 2, 149.00, '2026-02-10', '2026-03-10', 'SUCCESS'),
(4, 5, 499.00, '2026-02-15', '2026-04-12', 'SUCCESS'),
(5, 6, 399.00, '2026-02-20', '2026-03-20', 'SUCCESS'),
(6, 1, 99.00,  '2026-02-25', '2026-03-25', 'SUCCESS'),
(7, 7, 599.00, '2026-02-01', '2026-03-29', 'SUCCESS'),
(8, 3, 199.00, '2026-02-18', '2026-03-18', 'SUCCESS'),
(10, 4, 299.00, '2026-02-22', '2026-03-22', 'SUCCESS'),
(2, 1, 99.00,  '2026-01-01', '2026-01-29', 'SUCCESS');

-- -----------------------------------------------
-- SEED DATA: usage_log
-- -----------------------------------------------
INSERT INTO usage_log (user_id, date, data_used_mb) VALUES
(2, '2026-02-01', 512.00),
(2, '2026-02-02', 768.00),
(2, '2026-02-03', 300.00),
(2, '2026-02-04', 1024.00),
(2, '2026-02-05', 450.00),
(3, '2026-02-01', 200.00),
(3, '2026-02-02', 350.00),
(3, '2026-02-03', 180.00),
(4, '2026-02-01', 900.00),
(4, '2026-02-02', 1100.00);
