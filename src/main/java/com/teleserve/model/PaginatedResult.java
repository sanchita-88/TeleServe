package com.teleserve.model;

import java.util.List;

public class PaginatedResult<T> {
    private List<T> data;
    private int currentPage;
    private int totalPages;
    private int totalRecords;

    public PaginatedResult() {}

    public PaginatedResult(List<T> data, int currentPage, int totalPages, int totalRecords) {
        this.data = data;
        this.currentPage = currentPage;
        this.totalPages = totalPages;
        this.totalRecords = totalRecords;
    }

    public List<T> getData() { return data; }
    public void setData(List<T> data) { this.data = data; }
    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
    public int getTotalRecords() { return totalRecords; }
    public void setTotalRecords(int totalRecords) { this.totalRecords = totalRecords; }
}