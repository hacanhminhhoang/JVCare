package com.jvcare.dao;

import com.jvcare.model.MedicalRecord;
import com.jvcare.util.DBConnection;
import java.sql.*;
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

    /**
     * Lấy chi tiết một bệnh án theo ID
     */
    public MedicalRecord getRecordById(int recordId) {
        String sql = "SELECT mr.*, p.full_name as patient_name, p.patient_code, " +
                     "u.full_name as doctor_name, d.specialization " +
                     "FROM medical_records mr " +
                     "JOIN patients p ON mr.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "WHERE mr.record_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recordId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRecord(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy tất cả bệnh án của một bác sĩ
     */
    public List<MedicalRecord> getRecordsByDoctorId(int doctorId) {
        List<MedicalRecord> records = new ArrayList<>();
        String sql = "SELECT mr.*, p.full_name as patient_name, p.patient_code " +
                     "FROM medical_records mr " +
                     "JOIN patients p ON mr.patient_id = p.patient_id " +
                     "WHERE mr.doctor_id = ? " +
                     "ORDER BY mr.visit_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                records.add(mapResultSetToRecord(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return records;
    }
    
    /**
     * Cập nhật bệnh án
     */
    public boolean updateRecord(MedicalRecord record) {
        String sql = "UPDATE medical_records SET " +
                     "diagnosis=?, treatment_plan=?, notes=?, " +
                     "blood_pressure=?, heart_rate=?, temperature=?, " +
                     "weight=?, height=? " +
                     "WHERE record_id=? AND doctor_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, record.getDiagnosis());
            ps.setString(2, record.getTreatmentPlan());
            ps.setString(3, record.getNotes());
            ps.setString(4, record.getBloodPressure());
            
            if (record.getHeartRate() > 0) {
                ps.setInt(5, record.getHeartRate());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            
            if (record.getTemperature() > 0) {
                ps.setDouble(6, record.getTemperature());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            
            if (record.getWeight() > 0) {
                ps.setDouble(7, record.getWeight());
            } else {
                ps.setNull(7, Types.DECIMAL);
            }
            
            if (record.getHeight() > 0) {
                ps.setDouble(8, record.getHeight());
            } else {
                ps.setNull(8, Types.DECIMAL);
            }
            
            ps.setInt(9, record.getRecordId());
            ps.setInt(10, record.getDoctorId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tạo bệnh án từ appointment
     */
    public int createRecordFromAppointment(int appointmentId, int doctorId, MedicalRecord record) {
        String sql = "INSERT INTO medical_records " +
                     "(patient_id, doctor_id, appointment_id, visit_date, " +
                     "diagnosis, treatment_plan, notes, blood_pressure, " +
                     "heart_rate, temperature, weight, height) " +
                     "VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, record.getPatientId());
            ps.setInt(2, doctorId);
            ps.setInt(3, appointmentId);
            ps.setString(4, record.getDiagnosis());
            ps.setString(5, record.getTreatmentPlan());
            ps.setString(6, record.getNotes());
            ps.setString(7, record.getBloodPressure());
            
            if (record.getHeartRate() > 0) {
                ps.setInt(8, record.getHeartRate());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            
            if (record.getTemperature() > 0) {
                ps.setDouble(9, record.getTemperature());
            } else {
                ps.setNull(9, Types.DECIMAL);
            }
            
            if (record.getWeight() > 0) {
                ps.setDouble(10, record.getWeight());
            } else {
                ps.setNull(10, Types.DECIMAL);
            }
            
            if (record.getHeight() > 0) {
                ps.setDouble(11, record.getHeight());
            } else {
                ps.setNull(11, Types.DECIMAL);
            }
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Return record_id
                }
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    private MedicalRecord mapResultSetToRecord(ResultSet rs) throws SQLException {
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setPatientId(rs.getInt("patient_id"));
        record.setDoctorId(rs.getInt("doctor_id"));
        
        try {
            record.setAppointmentId(rs.getInt("appointment_id"));
        } catch (Exception e) {}
        
        record.setVisitDate(rs.getTimestamp("visit_date"));
        record.setDiagnosis(rs.getString("diagnosis"));
        record.setTreatmentPlan(rs.getString("treatment_plan"));
        record.setNotes(rs.getString("notes"));
        record.setBloodPressure(rs.getString("blood_pressure"));
        record.setHeartRate(rs.getInt("heart_rate"));
        record.setTemperature(rs.getDouble("temperature"));
        record.setWeight(rs.getDouble("weight"));
        record.setHeight(rs.getDouble("height"));
        
        // Extra fields from JOIN
        try {
            record.setPatientName(rs.getString("patient_name"));
            record.setPatientCode(rs.getString("patient_code"));
            record.setDoctorName(rs.getString("doctor_name"));
        } catch (Exception e) {}
        
        return record;
    }
}
