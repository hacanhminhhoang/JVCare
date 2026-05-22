package com.jvcare.service;

import com.jvcare.dao.StatisticsDAO;
import com.jvcare.dto.StatisticsDTO;
import com.jvcare.exception.BusinessException;

import java.util.List;
import java.util.Map;

/**
 * Service Layer cho Statistics - chứa business logic thống kê
 */
public class StatisticsService {
    
    private StatisticsDAO statisticsDAO;
    
    public StatisticsService() {
        this.statisticsDAO = new StatisticsDAO();
    }
    
    /**
     * Lấy thống kê cho Admin Dashboard
     */
    public StatisticsDTO getAdminStatistics() throws BusinessException {
        try {
            StatisticsDTO stats = new StatisticsDTO();
            
            // User statistics
            Map<String, Integer> usersByRole = statisticsDAO.getUserCountByRole();
            stats.setTotalAdmins(usersByRole.getOrDefault("ADMIN", 0));
            stats.setTotalDoctors(usersByRole.getOrDefault("DOCTOR", 0));
            stats.setTotalPatients(usersByRole.getOrDefault("PATIENT", 0));
            stats.setTotalUsers(stats.getTotalAdmins() + 
                               stats.getTotalDoctors() + 
                               stats.getTotalPatients());
            
            // Appointment statistics
            Map<String, Integer> appointmentsByStatus = 
                statisticsDAO.getAppointmentsByStatus();
            stats.setPendingAppointments(
                appointmentsByStatus.getOrDefault("PENDING", 0));
            stats.setConfirmedAppointments(
                appointmentsByStatus.getOrDefault("CONFIRMED", 0));
            stats.setCompletedAppointments(
                appointmentsByStatus.getOrDefault("COMPLETED", 0));
            stats.setCancelledAppointments(
                appointmentsByStatus.getOrDefault("CANCELLED", 0));
            stats.setTotalAppointments(
                stats.getPendingAppointments() + 
                stats.getConfirmedAppointments() + 
                stats.getCompletedAppointments() + 
                stats.getCancelledAppointments());
            
            // Chart data
            int currentYear = java.time.Year.now().getValue();
            stats.setAppointmentsByMonth(
                statisticsDAO.getAppointmentsByMonth(currentYear));
            stats.setAppointmentsByStatus(appointmentsByStatus);
            stats.setUsersByRole(usersByRole);
            
            return stats;
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê admin", e);
        }
    }
    
    /**
     * Lấy thống kê cho Doctor Dashboard
     */
    public StatisticsDTO getDoctorStatistics(int doctorId) 
            throws BusinessException {
        try {
            if (doctorId <= 0) {
                throw new BusinessException("Doctor ID không hợp lệ");
            }
            
            Map<String, Integer> stats = 
                statisticsDAO.getDoctorStatistics(doctorId);
            
            StatisticsDTO dto = new StatisticsDTO();
            dto.setTotalAppointments(stats.getOrDefault("todayAppointments", 0));
            dto.setTotalPatients(stats.getOrDefault("totalPatients", 0));
            dto.setTotalRecords(stats.getOrDefault("totalRecords", 0));
            dto.setPendingAppointments(stats.getOrDefault("pendingAppointments", 0));
            
            return dto;
            
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê bác sĩ", e);
        }
    }
    
    /**
     * Lấy hiệu suất của các bác sĩ
     */
    public List<Map<String, Object>> getDoctorPerformance() 
            throws BusinessException {
        try {
            return statisticsDAO.getDoctorPerformance();
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy hiệu suất bác sĩ", e);
        }
    }
    
    /**
     * Lấy thống kê users theo role
     */
    public Map<String, Integer> getUserCountByRole() throws BusinessException {
        try {
            return statisticsDAO.getUserCountByRole();
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê users", e);
        }
    }
    
    /**
     * Lấy thống kê appointments theo status
     */
    public Map<String, Integer> getAppointmentsByStatus() throws BusinessException {
        try {
            return statisticsDAO.getAppointmentsByStatus();
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê appointments", e);
        }
    }
    
    /**
     * Lấy thống kê appointments theo tháng
     */
    public Map<Integer, Integer> getAppointmentsByMonth(int year) throws BusinessException {
        try {
            if (year < 2000 || year > 2100) {
                throw new BusinessException("Năm không hợp lệ");
            }
            return statisticsDAO.getAppointmentsByMonth(year);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê theo tháng", e);
        }
    }
    
    /**
     * Lấy thống kê bệnh nhân
     */
    public Map<String, Integer> getPatientStatistics() throws BusinessException {
        try {
            return statisticsDAO.getPatientStatistics();
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê bệnh nhân", e);
        }
    }
}
