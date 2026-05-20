package com.jvcare.dao;

import com.jvcare.model.Prescription;
import com.jvcare.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PrescriptionDAO {

    public List<Prescription> getPrescriptionsByPatientId(int patientId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT p.prescription_id, p.patient_id, p.prescription_date, m.medication_name, pd.dosage, pd.instructions " +
                     "FROM prescriptions p " +
                     "JOIN prescription_details pd ON p.prescription_id = pd.prescription_id " +
                     "JOIN medications m ON pd.medication_id = m.medication_id " +
                     "WHERE p.patient_id = ? " +
                     "ORDER BY p.prescription_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Prescription p = new Prescription();
                p.setPrescriptionId(rs.getInt("prescription_id"));
                p.setPatientId(rs.getInt("patient_id"));
                p.setPrescriptionDate(rs.getTimestamp("prescription_date"));
                p.setMedicationName(rs.getString("medication_name"));
                p.setDosage(rs.getString("dosage"));
                p.setInstructions(rs.getString("instructions"));
                list.add(p);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return list;
    }
}
