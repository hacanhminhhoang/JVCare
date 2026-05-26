package com.jvcare.dao;

import com.jvcare.model.Patient;
import com.jvcare.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;

public class PatientDAO {

    public List<Patient> getAllPatients() {
        List<Patient> list = new ArrayList<>();
        // LEFT JOIN because some patients might not have a user account
        String sql = "SELECT p.*, u.full_name as u_name, u.phone as u_phone FROM patients p LEFT JOIN users u ON p.user_id = u.user_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return list;
    }

    public Patient getPatientById(int patientId) {
        String sql = "SELECT p.*, u.full_name as u_name, u.phone as u_phone FROM patients p LEFT JOIN users u ON p.user_id = u.user_id WHERE p.patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createPatient(Patient p) {
        String sql = "INSERT INTO patients (patient_code, full_name, date_of_birth, gender, phone, email, address, allergies, chronic_diseases, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "BN-" + System.currentTimeMillis()); // Generate random code
            ps.setString(2, p.getFullName());
            ps.setDate(3, p.getDateOfBirth());
            ps.setString(4, p.getGender() != null ? p.getGender() : "OTHER");
            ps.setString(5, p.getPhone());
            ps.setString(6, p.getPhone() + "@jvcare.vn"); // fake email
            ps.setString(7, p.getAddress());
            ps.setString(8, p.getAllergies());
            ps.setString(9, p.getChronicDiseases());
            ps.setString(10, p.getAvatarUrl());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePatient(Patient p) {
        String sql = "UPDATE patients SET full_name=?, date_of_birth=?, gender=?, phone=?, address=?, allergies=?, chronic_diseases=?, avatar_url=?, id_card=? WHERE patient_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getFullName());
            ps.setDate(2, p.getDateOfBirth());
            ps.setString(3, p.getGender());
            ps.setString(4, p.getPhone());
            ps.setString(5, p.getAddress());
            ps.setString(6, p.getAllergies());
            ps.setString(7, p.getChronicDiseases());
            ps.setString(8, p.getAvatarUrl());
            ps.setString(9, p.getIdCard());
            ps.setInt(10, p.getPatientId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePatient(int patientId) {
        String sql = "DELETE FROM patients WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tìm kiếm patients theo keyword
     */
    public List<Patient> searchPatients(String keyword) {
        List<Patient> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name as u_name, u.phone as u_phone " +
                     "FROM patients p LEFT JOIN users u ON p.user_id = u.user_id " +
                     "WHERE p.full_name LIKE ? OR p.patient_code LIKE ? OR p.email LIKE ? OR p.phone LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Đếm tổng số patients
     */
    public int getTotalPatients() {
        String sql = "SELECT COUNT(*) FROM patients";
        
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

    public Patient getPatientByUserId(int userId) {
        String sql = "SELECT p.*, u.full_name as u_name, u.phone as u_phone " +
                     "FROM patients p " +
                     "LEFT JOIN users u ON p.user_id = u.user_id " +
                     "WHERE p.user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePatientProfile(Patient patient) {
        String sql = "UPDATE patients SET " +
                     "full_name=?, date_of_birth=?, gender=?, " +
                     "phone=?, address=?, allergies=?, " +
                     "chronic_diseases=?, avatar_url=? " +
                     "WHERE patient_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, patient.getFullName());
            ps.setDate(2, patient.getDateOfBirth());
            ps.setString(3, patient.getGender());
            ps.setString(4, patient.getPhone());
            ps.setString(5, patient.getAddress());
            ps.setString(6, patient.getAllergies());
            ps.setString(7, patient.getChronicDiseases());
            ps.setString(8, patient.getAvatarUrl());
            ps.setInt(9, patient.getPatientId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setPatientId(rs.getInt("patient_id"));
        
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) p.setUserId(userId);
        
        p.setPatientCode(rs.getString("patient_code"));
        
        // Use patients table full_name if available, else users table
        String pName = rs.getString("full_name");
        if (pName == null || pName.isEmpty()) pName = rs.getString("u_name");
        p.setFullName(pName);
        
        p.setDateOfBirth(rs.getDate("date_of_birth"));
        p.setGender(rs.getString("gender"));
        
        String pPhone = rs.getString("phone");
        if (pPhone == null || pPhone.isEmpty()) pPhone = rs.getString("u_phone");
        p.setPhone(pPhone);
        
        p.setEmail(rs.getString("email"));
        p.setAddress(rs.getString("address"));
        p.setAllergies(rs.getString("allergies"));
        p.setChronicDiseases(rs.getString("chronic_diseases"));
        
        try {
            // Read from patients table now
            p.setAvatarUrl(rs.getString("avatar_url"));
            p.setIdCard(rs.getString("id_card"));
        } catch (Exception e) {}
        
        return p;
    }
}
