package com.jvcare.dto;

import java.util.List;
import java.util.Map;

public class ReportDTO {
    private String reportType; // appointments, doctors, patients
    private String reportDate;
    private Map<String, Object> filters;
    private List<Map<String, Object>> data;
    private Map<String, Object> summary;

    public ReportDTO() {}

    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }

    public String getReportDate() { return reportDate; }
    public void setReportDate(String reportDate) { this.reportDate = reportDate; }

    public Map<String, Object> getFilters() { return filters; }
    public void setFilters(Map<String, Object> filters) { this.filters = filters; }

    public List<Map<String, Object>> getData() { return data; }
    public void setData(List<Map<String, Object>> data) { this.data = data; }

    public Map<String, Object> getSummary() { return summary; }
    public void setSummary(Map<String, Object> summary) { this.summary = summary; }
}
