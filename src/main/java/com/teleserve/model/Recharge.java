package com.teleserve.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Recharge {
    private int rechargeId;
    private int userId;
    private int planId;
    private BigDecimal amountPaid;
    private Timestamp rechargedAt;
    private Date expiryDate;
    private String status;
    private Plan plan;

    public Recharge() {}

    public Recharge(int rechargeId, int userId, int planId, BigDecimal amountPaid,
                    Timestamp rechargedAt, Date expiryDate, String status) {
        this.rechargeId = rechargeId;
        this.userId = userId;
        this.planId = planId;
        this.amountPaid = amountPaid;
        this.rechargedAt = rechargedAt;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    public int getRechargeId() { return rechargeId; }
    public void setRechargeId(int rechargeId) { this.rechargeId = rechargeId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }
    public BigDecimal getAmountPaid() { return amountPaid; }
    public void setAmountPaid(BigDecimal amountPaid) { this.amountPaid = amountPaid; }
    public Timestamp getRechargedAt() { return rechargedAt; }
    public void setRechargedAt(Timestamp rechargedAt) { this.rechargedAt = rechargedAt; }
    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Plan getPlan() { return plan; }
    public void setPlan(Plan plan) { this.plan = plan; }
}