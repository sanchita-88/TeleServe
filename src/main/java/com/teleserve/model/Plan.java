package com.teleserve.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Plan {
    private int planId;
    private String name;
    private BigDecimal price;
    private double dataGb;
    private int validityDays;
    private String category;
    private boolean isActive;
    private Timestamp createdAt;

    public Plan() {}

    public Plan(int planId, String name, BigDecimal price, double dataGb,
                int validityDays, String category, boolean isActive, Timestamp createdAt) {
        this.planId = planId;
        this.name = name;
        this.price = price;
        this.dataGb = dataGb;
        this.validityDays = validityDays;
        this.category = category;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public double getDataGb() { return dataGb; }
    public void setDataGb(double dataGb) { this.dataGb = dataGb; }
    public int getValidityDays() { return validityDays; }
    public void setValidityDays(int validityDays) { this.validityDays = validityDays; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}