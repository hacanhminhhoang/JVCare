package com.jvcare.dao;

import com.jvcare.model.Prescription;
import com.jvcare.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrescriptionDAO {
    
    /**
     * Lấy tất cả đơn thuốc của một bệnh nhân (bảo toàn phương thức cũ)
     */
    public List<Prescription> getPrescriptionsByPatientId(int patientId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT p.*, mr.patient_id, mr.visit_date as prescription_date " +
                     "FROM prescriptions p " +
                     "JOIN medical_records mr ON p.record_id = mr.record_id " +
                     "WHERE mr.patient_id = ? " +
                     "ORDER BY mr.visit_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Prescription p = mapResultSetToPrescription(rs);
                try {
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setPrescriptionDate(rs.getTimestamp("prescription_date"));
                } catch (Exception e) {}
                list.add(p);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy tất cả đơn thuốc của một bệnh án
     */
    public List<Prescription> getPrescriptionsByRecordId(int recordId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE record_id = ? ORDER BY prescription_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Thêm thuốc vào đơn
     */
    public boolean createPrescription(Prescription prescription) {
        String sql = "INSERT INTO prescriptions " +
                     "(record_id, medication_name, dosage, frequency, duration_days, instructions) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, prescription.getRecordId());
            ps.setString(2, prescription.getMedicationName());
            ps.setString(3, prescription.getDosage());
            ps.setString(4, prescription.getFrequency());
            ps.setInt(5, prescription.getDurationDays());
            ps.setString(6, prescription.getInstructions());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Cập nhật thông tin thuốc
     */
    public boolean updatePrescription(Prescription prescription) {
        String sql = "UPDATE prescriptions SET " +
                     "medication_name=?, dosage=?, frequency=?, " +
                     "duration_days=?, instructions=? " +
                     "WHERE prescription_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, prescription.getMedicationName());
            ps.setString(2, prescription.getDosage());
            ps.setString(3, prescription.getFrequency());
            ps.setInt(4, prescription.getDurationDays());
            ps.setString(5, prescription.getInstructions());
            ps.setInt(6, prescription.getPrescriptionId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa thuốc khỏi đơn
     */
    public boolean deletePrescription(int prescriptionId) {
        String sql = "DELETE FROM prescriptions WHERE prescription_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, prescriptionId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Lấy chi tiết một prescription
     */
    public Prescription getPrescriptionById(int prescriptionId) {
        String sql = "SELECT * FROM prescriptions WHERE prescription_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, prescriptionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPrescription(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private Prescription mapResultSetToPrescription(ResultSet rs) throws SQLException {
        Prescription p = new Prescription();
        p.setPrescriptionId(rs.getInt("prescription_id"));
        p.setRecordId(rs.getInt("record_id"));
        p.setMedicationName(rs.getString("medication_name"));
        p.setDosage(rs.getString("dosage"));
        p.setFrequency(rs.getString("frequency"));
        p.setDurationDays(rs.getInt("duration_days"));
        p.setInstructions(rs.getString("instructions"));
        return p;
    }
}
