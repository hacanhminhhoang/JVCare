package com.jvcare.dao;

import com.jvcare.model.Appointment;
import com.jvcare.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        // Join with doctors and users to get doctor info
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "WHERE a.patient_id = ? " +
                     "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapRowToAppointment(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAllAppointmentsForDoctor(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        // Get all PENDING appointments OR appointments assigned to this doctor
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "WHERE a.status = 'PENDING' OR a.doctor_id = ? " +
                     "ORDER BY CASE WHEN a.status = 'PENDING' THEN 1 WHEN a.status = 'CONFIRMED' THEN 2 ELSE 3 END, a.appointment_date ASC, a.appointment_time ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapRowToAppointment(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "WHERE a.appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToAppointment(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Appointment mapRowToAppointment(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("appointment_id"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setDoctorId(rs.getInt("doctor_id"));
        a.setAppointmentDate(rs.getDate("appointment_date"));
        a.setAppointmentTime(rs.getTime("appointment_time"));
        a.setStatus(rs.getString("status"));
        a.setReason(rs.getString("reason"));
        a.setNotes(rs.getString("notes"));
        a.setDiagnosis(rs.getString("diagnosis"));
        a.setPatientCondition(rs.getString("patient_condition"));
        a.setAdvice(rs.getString("advice"));
        a.setPatientName(rs.getString("patient_name"));
        a.setDoctorName(rs.getString("doctor_name"));
        a.setDoctorSpecialization(rs.getString("specialization"));
        return a;
    }

    public boolean createAppointment(Appointment a) {
        String sql = "INSERT INTO appointments (patient_id, appointment_date, appointment_time, status, reason) VALUES (?, ?, ?, 'PENDING', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, a.getPatientId());
            ps.setDate(2, a.getAppointmentDate());
            ps.setTime(3, a.getAppointmentTime());
            ps.setString(4, a.getReason());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateAppointment(Appointment a) {
        String sql = "UPDATE appointments SET appointment_date=?, appointment_time=?, reason=? WHERE appointment_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, a.getAppointmentDate());
            ps.setTime(2, a.getAppointmentTime());
            ps.setString(3, a.getReason());
            ps.setInt(4, a.getAppointmentId());
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignDoctor(int appointmentId, int doctorId) {
        String sql = "UPDATE appointments SET doctor_id=?, status='CONFIRMED' WHERE appointment_id=? AND status='PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean completeAppointment(int appointmentId, int doctorId, String diagnosis, String condition, String advice) {
        String sql = "UPDATE appointments SET status='COMPLETED', diagnosis=?, patient_condition=?, advice=? WHERE appointment_id=? AND doctor_id=? AND status='CONFIRMED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, diagnosis);
            ps.setString(2, condition);
            ps.setString(3, advice);
            ps.setInt(4, appointmentId);
            ps.setInt(5, doctorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteAppointment(int appointmentId) {
        String sql = "DELETE FROM appointments WHERE appointment_id=? AND status='PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Đếm tổng số appointments
     */
    public int getTotalAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments";
        
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
}
