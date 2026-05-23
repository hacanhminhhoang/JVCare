package com.jvcare.util;

public class PaginationUtil {
    
    private int currentPage;
    private int pageSize;
    private int totalItems;
    private int totalPages;
    
    public PaginationUtil(int currentPage, int pageSize, int totalItems) {
        this.currentPage = currentPage > 0 ? currentPage : 1;
        this.pageSize = pageSize > 0 ? pageSize : 10;
        this.totalItems = totalItems;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);
    }
    
    public int getOffset() {
        return (currentPage - 1) * pageSize;
    }
    
    public int getLimit() {
        return pageSize;
    }
    
    public boolean hasPrevious() {
        return currentPage > 1;
    }
    
    public boolean hasNext() {
        return currentPage < totalPages;
    }
    
    public int getPreviousPage() {
        return hasPrevious() ? currentPage - 1 : 1;
    }
    
    public int getNextPage() {
        return hasNext() ? currentPage + 1 : totalPages;
    }
    
    // Getters
    public int getCurrentPage() { return currentPage; }
    public int getPageSize() { return pageSize; }
    public int getTotalItems() { return totalItems; }
    public int getTotalPages() { return totalPages; }
    
    /**
     * Generate HTML pagination links
     */
    public String generatePaginationHTML(String baseUrl) {
        StringBuilder html = new StringBuilder();
        html.append("<nav><ul class='pagination'>");
        
        // Previous button
        if (hasPrevious()) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?page=").append(getPreviousPage()).append("'>Previous</a>");
            html.append("</li>");
        }
        
        // Page numbers
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, currentPage + 2);
        
        for (int i = startPage; i <= endPage; i++) {
            html.append("<li class='page-item ").append(i == currentPage ? "active" : "").append("'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?page=").append(i).append("'>").append(i).append("</a>");
            html.append("</li>");
        }
        
        // Next button
        if (hasNext()) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?page=").append(getNextPage()).append("'>Next</a>");
            html.append("</li>");
        }
        
        html.append("</ul></nav>");
        return html.toString();
    }
}
