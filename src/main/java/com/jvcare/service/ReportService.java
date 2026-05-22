package com.jvcare.service;

import com.jvcare.dao.StatisticsDAO;
import com.jvcare.dto.ReportDTO;
import com.jvcare.exception.BusinessException;

import java.util.*;

/**
 * Service Layer cho Report - chứa business logic tạo báo cáo
 */
public class ReportService {
    
    private StatisticsDAO statisticsDAO;
    
    public ReportService() {
        this.statisticsDAO = new StatisticsDAO();
    }
    
    /**
     * Tạo báo cáo appointments
     */
    public ReportDTO generateAppointmentReport(Map<String, Object> filters) 
            throws BusinessException {
        try {
            ReportDTO report = new ReportDTO();
            report.setReportType("appointments");
            report.setReportDate(java.time.LocalDate.now().toString());
            report.setFilters(filters != null ? filters : new HashMap<>());
            
            // Lấy dữ liệu thống kê
            Map<String, Integer> appointmentsByStatus = statisticsDAO.getAppointmentsByStatus();
            
            // Chuyển dữ liệu thành danh sách báo cáo
            List<Map<String, Object>> data = new ArrayList<>();
            for (Map.Entry<String, Integer> entry : appointmentsByStatus.entrySet()) {
                Map<String, Object> row = new HashMap<>();
                row.put("status", entry.getKey());
                row.put("count", entry.getValue());
                data.add(row);
            }
            report.setData(data);
            
            // Tính toán summary
            Map<String, Object> summary = new HashMap<>();
            int total = appointmentsByStatus.values().stream()
                    .mapToInt(Integer::intValue).sum();
            summary.put("totalAppointments", total);
            summary.put("pendingCount", appointmentsByStatus.getOrDefault("PENDING", 0));
            summary.put("completedCount", appointmentsByStatus.getOrDefault("COMPLETED", 0));
            summary.put("cancelledCount", appointmentsByStatus.getOrDefault("CANCELLED", 0));
            
            if (total > 0) {
                double completionRate = (double) appointmentsByStatus.getOrDefault("COMPLETED", 0) / total * 100;
                summary.put("completionRate", String.format("%.1f%%", completionRate));
            } else {
                summary.put("completionRate", "0%");
            }
            report.setSummary(summary);
            
            return report;
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tạo báo cáo appointments", e);
        }
    }
    
    /**
     * Tạo báo cáo bác sĩ
     */
    public ReportDTO generateDoctorReport(Map<String, Object> filters) 
            throws BusinessException {
        try {
            ReportDTO report = new ReportDTO();
            report.setReportType("doctors");
            report.setReportDate(java.time.LocalDate.now().toString());
            report.setFilters(filters != null ? filters : new HashMap<>());
            
            // Lấy hiệu suất bác sĩ
            List<Map<String, Object>> doctorPerformance = statisticsDAO.getDoctorPerformance();
            report.setData(doctorPerformance);
            
            // Summary
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalDoctors", doctorPerformance.size());
            
            int totalAppointments = doctorPerformance.stream()
                    .mapToInt(d -> (int) d.getOrDefault("totalAppointments", 0))
                    .sum();
            int totalRecords = doctorPerformance.stream()
                    .mapToInt(d -> (int) d.getOrDefault("totalRecords", 0))
                    .sum();
            summary.put("totalAppointments", totalAppointments);
            summary.put("totalRecords", totalRecords);
            
            if (!doctorPerformance.isEmpty()) {
                summary.put("avgAppointmentsPerDoctor", totalAppointments / doctorPerformance.size());
            }
            report.setSummary(summary);
            
            return report;
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tạo báo cáo bác sĩ", e);
        }
    }
    
    /**
     * Tạo báo cáo bệnh nhân
     */
    public ReportDTO generatePatientReport(Map<String, Object> filters) 
            throws BusinessException {
        try {
            ReportDTO report = new ReportDTO();
            report.setReportType("patients");
            report.setReportDate(java.time.LocalDate.now().toString());
            report.setFilters(filters != null ? filters : new HashMap<>());
            
            Map<String, Integer> patientStats = statisticsDAO.getPatientStatistics();
            
            List<Map<String, Object>> data = new ArrayList<>();
            Map<String, Object> genderRow = new HashMap<>();
            genderRow.put("male", patientStats.getOrDefault("malePatients", 0));
            genderRow.put("female", patientStats.getOrDefault("femalePatients", 0));
            genderRow.put("total", patientStats.getOrDefault("totalPatients", 0));
            data.add(genderRow);
            report.setData(data);
            
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalPatients", patientStats.getOrDefault("totalPatients", 0));
            summary.put("malePatients", patientStats.getOrDefault("malePatients", 0));
            summary.put("femalePatients", patientStats.getOrDefault("femalePatients", 0));
            report.setSummary(summary);
            
            return report;
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tạo báo cáo bệnh nhân", e);
        }
    }
}
