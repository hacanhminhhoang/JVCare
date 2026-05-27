package com.jvcare.dao;

import com.jvcare.model.Appointment;
import com.jvcare.model.Doctor;
import com.jvcare.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.Time;
import java.sql.SQLException;
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
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "ORDER BY CASE WHEN a.status = 'PENDING' THEN 1 WHEN a.status = 'CONFIRMED' THEN 2 ELSE 3 END, a.appointment_date ASC, a.appointment_time ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
    
    // 1. Phân trang gốc
    public List<Appointment> getAppointmentsWithPagination(int offset, int limit) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "ORDER BY a.appointment_date DESC, a.appointment_time DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToAppointment(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Phân trang cho Bác sĩ (Kèm lọc Tab & Giới hạn hiển thị đúng của Bác sĩ đó)
    public List<Appointment> getAppointmentsWithPagination(int doctorId, String statusFilter, int offset, int limit) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "WHERE 1=1 ";
                     
        if ("PENDING".equals(statusFilter)) {
            sql += " AND a.status = 'PENDING' ";
        } else if ("CONFIRMED".equals(statusFilter) || "COMPLETED".equals(statusFilter)) {
            sql += " AND a.doctor_id = ? AND a.status = ? ";
        } else {
            // Tab Tất cả: Lấy Pending của hệ thống + Các lịch đã gán cho bác sĩ này
            sql += " AND (a.doctor_id = ? OR a.status = 'PENDING') ";
        }
        
        // Sắp xếp: Pending lên đầu, sau đó đến ngày giờ gần nhất
        sql += " ORDER BY CASE WHEN a.status = 'PENDING' THEN 1 WHEN a.status = 'CONFIRMED' THEN 2 ELSE 3 END, " +
               "a.appointment_date ASC, a.appointment_time ASC " +
               "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
               
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if ("CONFIRMED".equals(statusFilter) || "COMPLETED".equals(statusFilter)) {
                ps.setInt(paramIndex++, doctorId);
                ps.setString(paramIndex++, statusFilter);
            } else if (statusFilter == null || "all".equals(statusFilter)) {
                ps.setInt(paramIndex++, doctorId);
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToAppointment(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Tìm kiếm (Dành cho SearchServlet)
    public List<Appointment> searchAppointments(String keyword) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "LEFT JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "LEFT JOIN users u ON d.user_id = u.user_id " +
                     "WHERE p.full_name LIKE ? OR a.reason LIKE ? OR a.status LIKE ? " +
                     "ORDER BY a.appointment_date DESC";
                     
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToAppointment(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số appointments (Gốc)
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
    
    /**
     * Đếm tổng số appointments cho Bác sĩ (Kèm lọc Tab)
     */
    public int getTotalAppointments(int doctorId, String statusFilter) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM appointments a WHERE 1=1 ";
        
        if ("PENDING".equals(statusFilter)) {
            sql += " AND a.status = 'PENDING' ";
        } else if ("CONFIRMED".equals(statusFilter) || "COMPLETED".equals(statusFilter)) {
            sql += " AND a.doctor_id = ? AND a.status = ? ";
        } else {
            sql += " AND (a.doctor_id = ? OR a.status = 'PENDING') ";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if ("CONFIRMED".equals(statusFilter) || "COMPLETED".equals(statusFilter)) {
                ps.setInt(paramIndex++, doctorId);
                ps.setString(paramIndex++, statusFilter);
            } else if (statusFilter == null || "all".equals(statusFilter)) {
                ps.setInt(paramIndex++, doctorId);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return count;
    }

    public boolean checkDuplicateAppointment(
        int patientId,
        Date appointmentDate,
        Time appointmentTime) {

        String sql = "SELECT * FROM appointments "
            + "WHERE patient_id = ? "
            + "AND appointment_date = ? "
            + "AND appointment_time = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ps.setDate(2, appointmentDate);
            ps.setTime(3, appointmentTime);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true;
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<String> getAvailableTimeSlots(
            Date appointmentDate,
            int doctorId) {

        List<String> slots = new ArrayList<>();

        slots.add("08:00");
        slots.add("09:00");
        slots.add("10:00");
        slots.add("11:00");
        slots.add("13:00");
        slots.add("14:00");
        slots.add("15:00");
        slots.add("16:00");

        String sql = "SELECT appointment_time "
                + "FROM appointments "
                + "WHERE doctor_id = ? "
                + "AND appointment_date = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setDate(2, appointmentDate);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                String bookedTime
                        = rs.getTime("appointment_time")
                                .toString()
                                .substring(0, 5);

                slots.remove(bookedTime);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return slots;
    }

    public boolean cancelAppointment(
            int appointmentId,
            int patientId) {

        String sql = "UPDATE Appointments "
                + "SET status = 'Cancelled' "
                + "WHERE appointment_id = ? "
                + "AND patient_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ps.setInt(2, patientId);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<String[]> getAppointmentsByPatient(int patientId) {

        List<String[]> list = new ArrayList<>();

        String sql = "SELECT appointment_date, appointment_time, status, reason "
                + "FROM appointments WHERE patient_id = ? "
                + "ORDER BY appointment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                String[] row = new String[4];

                row[0] = rs.getString("appointment_date");
                row[1] = rs.getString("appointment_time");
                row[2] = rs.getString("status");
                row[3] = rs.getString("reason");

                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();

        String sql = "SELECT * FROM appointments ORDER BY appointment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Appointment a = new Appointment();

                a.setAppointmentId(rs.getInt("appointment_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setAppointmentDate(rs.getDate("appointment_date"));
                a.setAppointmentTime(rs.getTime("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setReason(rs.getString("reason"));

                list.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean confirmAppointment(int appointmentId) {

        String sql = "UPDATE appointments SET status='CONFIRMED' WHERE appointment_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT d.doctor_id, d.specialization, u.full_name " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE u.status = 'ACTIVE' " +
                     "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setFullName(rs.getString("full_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctors.add(doctor);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return doctors;
    }

}