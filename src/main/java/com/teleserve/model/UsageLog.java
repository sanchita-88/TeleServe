package com.teleserve.model;

import java.sql.Date;

public class UsageLog {
    private int logId;
    private int userId;
    private Date date;
    private double dataUsedMb;

    public UsageLog() {}

    public UsageLog(int logId, int userId, Date date, double dataUsedMb) {
        this.logId = logId;
        this.userId = userId;
        this.date = date;
        this.dataUsedMb = dataUsedMb;
    }

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public double getDataUsedMb() { return dataUsedMb; }
    public void setDataUsedMb(double dataUsedMb) { this.dataUsedMb = dataUsedMb; }
}