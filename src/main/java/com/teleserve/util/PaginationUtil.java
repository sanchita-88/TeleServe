package com.teleserve.util;

/**
 * Helpers for pagination: offset and total pages.
 */
public final class PaginationUtil {

    private PaginationUtil() {
    }

    /**
     * Returns the row offset for 1-based page and given page size.
     */
    public static int getOffset(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        return (page - 1) * pageSize;
    }

    /**
     * Returns total number of pages for given total count and page size.
     */
    public static int getTotalPages(int totalCount, int pageSize) {
        if (pageSize < 1) pageSize = 10;
        return totalCount == 0 ? 1 : (int) Math.ceil((double) totalCount / pageSize);
    }
}
