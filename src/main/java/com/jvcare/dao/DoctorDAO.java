package com.jvcare.dao;

import com.jvcare.model.Doctor;
import com.jvcare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {
    
    /**
     * Lấy tất cả doctors với thông tin từ bảng users
     */
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT d.doctor_id, d.user_id, d.specialization, " +
                     "u.full_name, u.email, u.phone, u.status " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy doctor theo ID
     */
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT d.doctor_id, d.user_id, d.specialization, " +
                     "u.full_name, u.email, u.phone, u.status " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE d.doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDoctor(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy doctor theo user_id
     */
    public Doctor getDoctorByUserId(int userId) {
        String sql = "SELECT d.doctor_id, d.user_id, d.specialization, " +
                     "u.full_name, u.email, u.phone, u.status " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE d.user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDoctor(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Tạo doctor mới
     */
    public boolean createDoctor(Doctor doctor) {
        String sql = "INSERT INTO doctors (user_id, specialization) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, doctor.getUserId());
            ps.setString(2, doctor.getSpecialization());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    doctor.setDoctorId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Cập nhật doctor
     */
    public boolean updateDoctor(Doctor doctor) {
        String sql = "UPDATE doctors SET specialization = ? WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, doctor.getSpecialization());
            ps.setInt(2, doctor.getDoctorId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa doctor
     */
    public boolean deleteDoctor(int doctorId) {
        String sql = "DELETE FROM doctors WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tìm kiếm doctors
     */
    public List<Doctor> searchDoctors(String keyword) {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT d.doctor_id, d.user_id, d.specialization, " +
                     "u.full_name, u.email, u.phone, u.status " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE u.full_name LIKE ? OR d.specialization LIKE ? OR u.email LIKE ? " +
                     "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Đếm tổng số doctors
     */
    public int getTotalDoctors() {
        String sql = "SELECT COUNT(*) FROM doctors";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Map ResultSet to Doctor object
     */
    private Doctor mapResultSetToDoctor(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctorId(rs.getInt("doctor_id"));
        doctor.setUserId(rs.getInt("user_id"));
        doctor.setSpecialization(rs.getString("specialization"));
        doctor.setFullName(rs.getString("full_name"));
        doctor.setEmail(rs.getString("email"));
        doctor.setPhone(rs.getString("phone"));
        doctor.setStatus(rs.getString("status"));
        return doctor;
    }
}
