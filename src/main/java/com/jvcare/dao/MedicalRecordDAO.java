package com.jvcare.dao;

import com.jvcare.model.MedicalRecord;
import com.jvcare.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MedicalRecordDAO {
    
    public List<MedicalRecord> getRecordsByPatientId(int patientId) {
        List<MedicalRecord> records = new ArrayList<>();
        String sql = "SELECT * FROM medical_records WHERE patient_id = ? ORDER BY visit_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                MedicalRecord record = new MedicalRecord();
                record.setRecordId(rs.getInt("record_id"));
                record.setRecordCode(rs.getString("record_code"));
                record.setPatientId(rs.getInt("patient_id"));
                record.setDoctorId(rs.getInt("doctor_id"));
                record.setVisitDate(rs.getTimestamp("visit_date"));
                record.setChiefComplaint(rs.getString("chief_complaint"));
                record.setPresentIllness(rs.getString("present_illness"));
                record.setMedicalHistory(rs.getString("medical_history"));
                record.setDiagnosis(rs.getString("diagnosis"));
                record.setTreatmentPlan(rs.getString("treatment_plan"));
                record.setStatus(rs.getString("status"));
                record.setVitalSigns(rs.getString("vital_signs"));
                records.add(record);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return records;
    }

    public boolean createRecord(MedicalRecord record) {
        String sql = "INSERT INTO medical_records (patient_id, doctor_id, visit_date, chief_complaint, diagnosis, treatment_plan, status, record_code, vital_signs) VALUES (?, ?, ?, ?, ?, ?, 'COMPLETED', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, record.getPatientId());
            ps.setInt(2, record.getDoctorId());
            ps.setTimestamp(3, record.getVisitDate());
            ps.setString(4, record.getChiefComplaint());
            ps.setString(5, record.getDiagnosis());
            ps.setString(6, record.getTreatmentPlan());
            ps.setString(7, "REC-" + System.currentTimeMillis());
            ps.setString(8, record.getVitalSigns());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
}
