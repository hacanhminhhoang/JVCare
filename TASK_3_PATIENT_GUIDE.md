# HƯỚNG DẪN TASK 3: PATIENT - ĐẶT LỊCH & QUẢN LÝ HỒ SƠ

## 📋 TỔNG QUAN
Phát triển chức năng cho bệnh nhân đặt lịch khám, quản lý hồ sơ cá nhân và xem lịch sử khám bệnh.

**Độ khó:** ⭐⭐⭐ (Trung bình)  
**Thời gian ước tính:** 2 tuần

---

## 🗂️ CẤU TRÚC FILE CẦN TẠO/CẬP NHẬT

```
src/main/java/com/jvcare/
├── controller/
│   ├── PatientBookAppointmentServlet.java     [MỚI]
│   ├── PatientProfileServlet.java             [MỚI]
│   └── PatientMedicalHistoryServlet.java      [MỚI]
├── dao/
│   ├── AppointmentDAO.java                    [CẬP NHẬT]
│   └── PatientDAO.java                        [CẬP NHẬT]

src/main/webapp/WEB-INF/views/patient/
├── book_appointment.jsp                       [MỚI]
├── profile.jsp                                [MỚI]
├── medical_history.jsp                        [MỚI]
└── medical_history_detail.jsp                 [MỚI]
```

---

## 📝 BƯỚC 1: CẬP NHẬT APPOINTMENT DAO

**File:** `src/main/java/com/jvcare/dao/AppointmentDAO.java`

Thêm các methods sau:

```java
/**
 * Lấy các khung giờ còn trống trong ngày
 */
public List<String> getAvailableTimeSlots(Date date, int doctorId) {
    List<String> availableSlots = new ArrayList<>();
    List<String> allSlots = Arrays.asList(
        "08:00", "08:30", "09:00", "09:30", "10:00", "10:30",
        "11:00", "11:30", "13:00", "13:30", "14:00", "14:30",
        "15:00", "15:30", "16:00", "16:30", "17:00"
    );
    
    // Get booked slots
    String sql = "SELECT appointment_time FROM appointments " +
                 "WHERE appointment_date = ? AND doctor_id = ? " +
                 "AND status != 'CANCELLED'";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setDate(1, date);
        ps.setInt(2, doctorId);
        ResultSet rs = ps.executeQuery();
        
        List<String> bookedSlots = new ArrayList<>();
        while (rs.next()) {
            Time time = rs.getTime("appointment_time");
            bookedSlots.add(time.toString().substring(0, 5));
        }
        
        // Filter available slots
        for (String slot : allSlots) {
            if (!bookedSlots.contains(slot)) {
                availableSlots.add(slot);
            }
        }
        
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    
    return availableSlots;
}

/**
 * Kiểm tra trùng lịch hẹn
 */
public boolean checkDuplicateAppointment(int patientId, Date date, Time time) {
    String sql = "SELECT COUNT(*) FROM appointments " +
                 "WHERE patient_id = ? AND appointment_date = ? " +
                 "AND appointment_time = ? AND status != 'CANCELLED'";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, patientId);
        ps.setDate(2, date);
        ps.setTime(3, time);
        
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    return false;
}

/**
 * Hủy lịch hẹn (chỉ PENDING)
 */
public boolean cancelAppointment(int appointmentId, int patientId) {
    String sql = "UPDATE appointments SET status='CANCELLED' " +
                 "WHERE appointment_id=? AND patient_id=? AND status='PENDING'";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, appointmentId);
        ps.setInt(2, patientId);
        return ps.executeUpdate() > 0;
        
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
    return false;
}

/**
 * Lấy danh sách bác sĩ
 */
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
```

---

## 📝 BƯỚC 2: CẬP NHẬT PATIENT DAO

**File:** `src/main/java/com/jvcare/dao/PatientDAO.java`

Thêm methods:

```java
/**
 * Lấy patient từ user_id
 */
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

/**
 * Cập nhật profile bệnh nhân
 */
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
```

---

## 📝 BƯỚC 3: TẠO PATIENT BOOK APPOINTMENT SERVLET

**File:** `src/main/java/com/jvcare/controller/PatientBookAppointmentServlet.java`

```java
package com.jvcare.controller;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.model.Appointment;
import com.jvcare.model.Patient;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet("/patient/book-appointment")
public class PatientBookAppointmentServlet extends HttpServlet {
    
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkPatientAccess(request, response)) return;
        
        User user = (User) request.getSession().getAttribute("user");
        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        
        // Get list of doctors
        List<Doctor> doctors = appointmentDAO.getAllDoctors();
        
        request.setAttribute("patient", patient);
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/WEB-INF/views/patient/book_appointment.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkPatientAccess(request, response)) return;
        
        User user = (User) request.getSession().getAttribute("user");
        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        
        try {
            Date appointmentDate = Date.valueOf(request.getParameter("appointmentDate"));
            Time appointmentTime = Time.valueOf(request.getParameter("appointmentTime") + ":00");
            String reason = request.getParameter("reason");
            
            // Check duplicate
            if (appointmentDAO.checkDuplicateAppointment(patient.getPatientId(), 
                    appointmentDate, appointmentTime)) {
                request.setAttribute("error", "Bạn đã có lịch hẹn vào thời gian này!");
                doGet(request, response);
                return;
            }
            
            Appointment appointment = new Appointment();
            appointment.setPatientId(patient.getPatientId());
            appointment.setAppointmentDate(appointmentDate);
            appointment.setAppointmentTime(appointmentTime);
            appointment.setReason(reason);
            
            boolean success = appointmentDAO.createAppointment(appointment);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + 
                    "/patient/appointments?success=true");
            } else {
                request.setAttribute("error", "Đặt lịch thất bại!");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            doGet(request, response);
        }
    }
    
    private boolean checkPatientAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        return true;
    }
}
```

