package com.jvcare.dao;

import com.jvcare.util.DBConnection;
import java.sql.*;
import java.util.*;

public class StatisticsDAO {
    
    /**
     * Tổng số users theo role
     */
    public Map<String, Integer> getUserCountByRole() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT role, COUNT(*) as total FROM users GROUP BY role";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                result.put(rs.getString("role"), rs.getInt("total"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Tổng số appointments
     */
    public int getTotalAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments";
        return executeCountQuery(sql);
    }
    
    /**
     * Appointments theo status
     */
    public Map<String, Integer> getAppointmentsByStatus() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as total FROM appointments GROUP BY status";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                result.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Appointments theo tháng trong năm
     */
    public Map<Integer, Integer> getAppointmentsByMonth(int year) {
        Map<Integer, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT MONTH(appointment_date) as month, COUNT(*) as total " +
                     "FROM appointments " +
                     "WHERE YEAR(appointment_date) = ? " +
                     "GROUP BY MONTH(appointment_date) " +
                     "ORDER BY month";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                result.put(rs.getInt("month"), rs.getInt("total"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Hiệu suất bác sĩ (số lịch hẹn, bệnh án)
     */
    public List<Map<String, Object>> getDoctorPerformance() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT d.doctor_id, u.full_name, d.specialization, " +
                     "COUNT(DISTINCT a.appointment_id) as total_appointments, " +
                     "COUNT(DISTINCT mr.record_id) as total_records " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "LEFT JOIN appointments a ON d.doctor_id = a.doctor_id " +
                     "LEFT JOIN medical_records mr ON d.doctor_id = mr.doctor_id " +
                     "GROUP BY d.doctor_id, u.full_name, d.specialization " +
                     "ORDER BY total_appointments DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> doctor = new HashMap<>();
                doctor.put("doctorId", rs.getInt("doctor_id"));
                doctor.put("fullName", rs.getString("full_name"));
                doctor.put("specialization", rs.getString("specialization"));
                doctor.put("totalAppointments", rs.getInt("total_appointments"));
                doctor.put("totalRecords", rs.getInt("total_records"));
                result.add(doctor);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Thống kê cho doctor dashboard
     */
    public Map<String, Integer> getDoctorStatistics(int doctorId) {
        Map<String, Integer> stats = new HashMap<>();
        
        // Appointments hôm nay
        String sql1 = "SELECT COUNT(*) FROM appointments " +
                      "WHERE doctor_id = ? AND appointment_date = CAST(GETDATE() AS DATE)";
        stats.put("todayAppointments", executeCountQuery(sql1, doctorId));
        
        // Tổng bệnh nhân đã khám
        String sql2 = "SELECT COUNT(DISTINCT patient_id) FROM appointments " +
                      "WHERE doctor_id = ? AND status = 'COMPLETED'";
        stats.put("totalPatients", executeCountQuery(sql2, doctorId));
        
        // Tổng bệnh án
        String sql3 = "SELECT COUNT(*) FROM medical_records WHERE doctor_id = ?";
        stats.put("totalRecords", executeCountQuery(sql3, doctorId));
        
        // Pending appointments
        String sql4 = "SELECT COUNT(*) FROM appointments " +
                      "WHERE doctor_id = ? AND status = 'PENDING'";
        stats.put("pendingAppointments", executeCountQuery(sql4, doctorId));
        
        return stats;
    }
    
    /**
     * Thống kê bệnh nhân
     */
    public Map<String, Integer> getPatientStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        
        stats.put("totalPatients", executeCountQuery("SELECT COUNT(*) FROM patients"));
        stats.put("malePatients", executeCountQuery(
            "SELECT COUNT(*) FROM patients WHERE gender = 'MALE'"));
        stats.put("femalePatients", executeCountQuery(
            "SELECT COUNT(*) FROM patients WHERE gender = 'FEMALE'"));
        
        return stats;
    }
    
    /**
     * Helper method để execute count query
     */
    private int executeCountQuery(String sql, Object... params) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
