# HƯỚNG DẪN TASK 2: DOCTOR - QUẢN LÝ BỆNH ÁN & ĐƠN THUỐC

## 📋 TỔNG QUAN
Phát triển chức năng cho bác sĩ tạo và quản lý bệnh án, đơn thuốc cho bệnh nhân sau khi hoàn thành lịch hẹn.

**Độ khó:** ⭐⭐⭐⭐⭐ (Khá - Khó)  
**Thời gian ước tính:** 3-4 tuần

---

## 🗂️ CẤU TRÚC FILE CẦN TẠO/CẬP NHẬT

```
src/main/java/com/jvcare/
├── controller/
│   ├── DoctorMedicalRecordServlet.java    [MỚI]
│   ├── DoctorPrescriptionServlet.java     [MỚI]
│   └── DoctorAppointmentDetailServlet.java [CẬP NHẬT]
├── dao/
│   ├── MedicalRecordDAO.java              [CẬP NHẬT]
│   └── PrescriptionDAO.java               [CẬP NHẬT]

src/main/webapp/WEB-INF/views/doctor/
├── medical_records.jsp                    [MỚI]
├── medical_record_form.jsp                [MỚI]
├── medical_record_detail.jsp              [MỚI]
├── prescription_form.jsp                  [MỚI]
└── print_prescription.jsp                 [MỚI]
```

---

## 📝 BƯỚC 1: CẬP NHẬT MEDICAL RECORD DAO

**File:** `src/main/java/com/jvcare/dao/MedicalRecordDAO.java`

Thêm các methods sau vào file hiện có:

```java
package com.jvcare.dao;

import com.jvcare.model.MedicalRecord;
import com.jvcare.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicalRecordDAO {
    
    // Method đã có: getRecordsByPatientId(int patientId)
    // Method đã có: createRecord(MedicalRecord record)
    
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
```



---

## 📝 BƯỚC 2: CẬP NHẬT PRESCRIPTION DAO

**File:** `src/main/java/com/jvcare/dao/PrescriptionDAO.java`

```java
package com.jvcare.dao;

import com.jvcare.model.Prescription;
import com.jvcare.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrescriptionDAO {
    
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
```

---

## 📝 BƯỚC 3: TẠO DOCTOR MEDICAL RECORD SERVLET

**File:** `src/main/java/com/jvcare/controller/DoctorMedicalRecordServlet.java`

```java
package com.jvcare.controller;

import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.dao.PrescriptionDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.MedicalRecord;
import com.jvcare.model.Prescription;
import com.jvcare.model.Appointment;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/medical-records")
public class DoctorMedicalRecordServlet extends HttpServlet {
    
    private MedicalRecordDAO recordDAO = new MedicalRecordDAO();
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("detail".equals(action)) {
            showRecordDetail(request, response, user);
        } else if ("create".equals(action)) {
            showCreateForm(request, response, user);
        } else if ("edit".equals(action)) {
            showEditForm(request, response, user);
        } else {
            listRecords(request, response, user);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createRecord(request, response, user);
        } else if ("update".equals(action)) {
            updateRecord(request, response, user);
        }
    }
    
    private void listRecords(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        // Get doctor_id from user
        int doctorId = getDoctorIdFromUser(user);
        
        List<MedicalRecord> records = recordDAO.getRecordsByDoctorId(doctorId);
        
        request.setAttribute("records", records);
        request.getRequestDispatcher("/WEB-INF/views/doctor/medical_records.jsp")
               .forward(request, response);
    }
    
    private void showRecordDetail(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int recordId = Integer.parseInt(request.getParameter("id"));
        
        MedicalRecord record = recordDAO.getRecordById(recordId);
        List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByRecordId(recordId);
        
        if (record == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        request.setAttribute("record", record);
        request.setAttribute("prescriptions", prescriptions);
        request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_detail.jsp")
               .forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        
        if (appointmentIdStr != null) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            request.setAttribute("appointment", appointment);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
               .forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int recordId = Integer.parseInt(request.getParameter("id"));
        MedicalRecord record = recordDAO.getRecordById(recordId);
        
        if (record == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        request.setAttribute("record", record);
        request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
               .forward(request, response);
    }
    
    private void createRecord(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int doctorId = getDoctorIdFromUser(user);
        
        // Get form data
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String appointmentIdStr = request.getParameter("appointmentId");
        String diagnosis = request.getParameter("diagnosis");
        String treatmentPlan = request.getParameter("treatmentPlan");
        String notes = request.getParameter("notes");
        String bloodPressure = request.getParameter("bloodPressure");
        
        MedicalRecord record = new MedicalRecord();
        record.setPatientId(patientId);
        record.setDoctorId(doctorId);
        record.setDiagnosis(diagnosis);
        record.setTreatmentPlan(treatmentPlan);
        record.setNotes(notes);
        record.setBloodPressure(bloodPressure);
        
        // Optional fields
        try {
            record.setHeartRate(Integer.parseInt(request.getParameter("heartRate")));
        } catch (Exception e) {}
        
        try {
            record.setTemperature(Double.parseDouble(request.getParameter("temperature")));
        } catch (Exception e) {}
        
        try {
            record.setWeight(Double.parseDouble(request.getParameter("weight")));
        } catch (Exception e) {}
        
        try {
            record.setHeight(Double.parseDouble(request.getParameter("height")));
        } catch (Exception e) {}
        
        int recordId;
        if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            recordId = recordDAO.createRecordFromAppointment(appointmentId, doctorId, record);
        } else {
            recordDAO.createRecord(record);
            recordId = -1; // TODO: Get generated ID
        }
        
        if (recordId > 0) {
            response.sendRedirect(request.getContextPath() + "/doctor/medical-records?action=detail&id=" + recordId);
        } else {
            response.sendRedirect(request.getContextPath() + "/doctor/medical-records");
        }
    }
    
    private void updateRecord(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int doctorId = getDoctorIdFromUser(user);
        int recordId = Integer.parseInt(request.getParameter("recordId"));
        
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(recordId);
        record.setDoctorId(doctorId);
        record.setDiagnosis(request.getParameter("diagnosis"));
        record.setTreatmentPlan(request.getParameter("treatmentPlan"));
        record.setNotes(request.getParameter("notes"));
        record.setBloodPressure(request.getParameter("bloodPressure"));
        
        try {
            record.setHeartRate(Integer.parseInt(request.getParameter("heartRate")));
        } catch (Exception e) {}
        
        try {
            record.setTemperature(Double.parseDouble(request.getParameter("temperature")));
        } catch (Exception e) {}
        
        try {
            record.setWeight(Double.parseDouble(request.getParameter("weight")));
        } catch (Exception e) {}
        
        try {
            record.setHeight(Double.parseDouble(request.getParameter("height")));
        } catch (Exception e) {}
        
        boolean success = recordDAO.updateRecord(record);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/doctor/medical-records?action=detail&id=" + recordId);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private int getDoctorIdFromUser(User user) {
        // TODO: Query doctor_id from doctors table using user_id
        // For now, return a placeholder
        return 1;
    }
}
```



---

## 📝 BƯỚC 4: TẠO DOCTOR PRESCRIPTION SERVLET

**File:** `src/main/java/com/jvcare/controller/DoctorPrescriptionServlet.java`

```java
package com.jvcare.controller;

import com.jvcare.dao.PrescriptionDAO;
import com.jvcare.model.Prescription;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/doctor/prescriptions")
public class DoctorPrescriptionServlet extends HttpServlet {
    
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkDoctorAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deletePrescription(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkDoctorAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createPrescription(request, response);
        } else if ("update".equals(action)) {
            updatePrescription(request, response);
        }
    }
    
    private void createPrescription(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int recordId = Integer.parseInt(request.getParameter("recordId"));
        
        Prescription prescription = new Prescription();
        prescription.setRecordId(recordId);
        prescription.setMedicationName(request.getParameter("medicationName"));
        prescription.setDosage(request.getParameter("dosage"));
        prescription.setFrequency(request.getParameter("frequency"));
        prescription.setDurationDays(Integer.parseInt(request.getParameter("durationDays")));
        prescription.setInstructions(request.getParameter("instructions"));
        
        boolean success = prescriptionDAO.createPrescription(prescription);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + 
                "/doctor/medical-records?action=detail&id=" + recordId);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void updatePrescription(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int prescriptionId = Integer.parseInt(request.getParameter("prescriptionId"));
        int recordId = Integer.parseInt(request.getParameter("recordId"));
        
        Prescription prescription = new Prescription();
        prescription.setPrescriptionId(prescriptionId);
        prescription.setMedicationName(request.getParameter("medicationName"));
        prescription.setDosage(request.getParameter("dosage"));
        prescription.setFrequency(request.getParameter("frequency"));
        prescription.setDurationDays(Integer.parseInt(request.getParameter("durationDays")));
        prescription.setInstructions(request.getParameter("instructions"));
        
        boolean success = prescriptionDAO.updatePrescription(prescription);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + 
                "/doctor/medical-records?action=detail&id=" + recordId);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void deletePrescription(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int prescriptionId = Integer.parseInt(request.getParameter("id"));
        int recordId = Integer.parseInt(request.getParameter("recordId"));
        
        boolean success = prescriptionDAO.deletePrescription(prescriptionId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + 
                "/doctor/medical-records?action=detail&id=" + recordId);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int prescriptionId = Integer.parseInt(request.getParameter("id"));
        Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
        
        request.setAttribute("prescription", prescription);
        request.getRequestDispatcher("/WEB-INF/views/doctor/prescription_form.jsp")
               .forward(request, response);
    }
    
    private boolean checkDoctorAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        
        return true;
    }
}
```

---

## 📝 BƯỚC 5: TẠO JSP - DANH SÁCH BỆNH ÁN

**File:** `src/main/webapp/WEB-INF/views/doctor/medical_records.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách Bệnh án - JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Danh sách Bệnh án</h2>
            <a href="${pageContext.request.contextPath}/doctor/index" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>
        
        <!-- Search box -->
        <div class="row mb-3">
            <div class="col-md-6">
                <input type="text" id="searchInput" class="form-control" 
                       placeholder="Tìm kiếm bệnh nhân, mã bệnh án...">
            </div>
        </div>
        
        <!-- Records table -->
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th>Mã BA</th>
                        <th>Mã BN</th>
                        <th>Bệnh nhân</th>
                        <th>Ngày khám</th>
                        <th>Chẩn đoán</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="record" items="${records}">
                        <tr>
                            <td>#${record.recordId}</td>
                            <td>${record.patientCode}</td>
                            <td>${record.patientName}</td>
                            <td>
                                <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy HH:mm" />
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${record.diagnosis.length() > 50}">
                                        ${record.diagnosis.substring(0, 50)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${record.diagnosis}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/doctor/medical-records?action=detail&id=${record.recordId}" 
                                   class="btn btn-sm btn-primary">
                                    <i class="bi bi-eye"></i> Xem
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/medical-records?action=edit&id=${record.recordId}" 
                                   class="btn btn-sm btn-warning">
                                    <i class="bi bi-pencil"></i> Sửa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty records}">
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                Chưa có bệnh án nào
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Simple search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        });
    </script>
</body>
</html>
```



---

## 📝 BƯỚC 6: TẠO JSP - FORM BỆNH ÁN

**File:** `src/main/webapp/WEB-INF/views/doctor/medical_record_form.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${record != null ? 'Sửa' : 'Tạo'} Bệnh án - JVCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>${record != null ? 'Sửa' : 'Tạo'} Bệnh án</h2>
        
        <form method="post" action="${pageContext.request.contextPath}/doctor/medical-records">
            <input type="hidden" name="action" value="${record != null ? 'update' : 'create'}">
            <c:if test="${record != null}">
                <input type="hidden" name="recordId" value="${record.recordId}">
            </c:if>
            <c:if test="${appointment != null}">
                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                <input type="hidden" name="patientId" value="${appointment.patientId}">
            </c:if>
            
            <!-- Patient Info (readonly) -->
            <c:if test="${appointment != null}">
                <div class="alert alert-info">
                    <strong>Bệnh nhân:</strong> ${appointment.patientName} - 
                    <strong>Lý do khám:</strong> ${appointment.reason}
                </div>
            </c:if>
            
            <!-- Vital Signs -->
            <div class="card mb-3">
                <div class="card-header">Chỉ số sinh tồn</div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="form-label">Huyết áp</label>
                            <input type="text" name="bloodPressure" class="form-control" 
                                   value="${record.bloodPressure}" placeholder="120/80">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Nhịp tim (bpm)</label>
                            <input type="number" name="heartRate" class="form-control" 
                                   value="${record.heartRate}" placeholder="75">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Nhiệt độ (°C)</label>
                            <input type="number" step="0.1" name="temperature" class="form-control" 
                                   value="${record.temperature}" placeholder="36.5">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Cân nặng (kg)</label>
                            <input type="number" step="0.1" name="weight" class="form-control" 
                                   value="${record.weight}" placeholder="65.5">
                        </div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-md-3">
                            <label class="form-label">Chiều cao (cm)</label>
                            <input type="number" step="0.1" name="height" class="form-control" 
                                   value="${record.height}" placeholder="170">
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Diagnosis -->
            <div class="mb-3">
                <label class="form-label">Chẩn đoán *</label>
                <textarea name="diagnosis" class="form-control" rows="3" required>${record.diagnosis}</textarea>
            </div>
            
            <!-- Treatment Plan -->
            <div class="mb-3">
                <label class="form-label">Phương án điều trị *</label>
                <textarea name="treatmentPlan" class="form-control" rows="4" required>${record.treatmentPlan}</textarea>
            </div>
            
            <!-- Notes -->
            <div class="mb-3">
                <label class="form-label">Ghi chú</label>
                <textarea name="notes" class="form-control" rows="3">${record.notes}</textarea>
            </div>
            
            <button type="submit" class="btn btn-primary">Lưu bệnh án</button>
            <a href="${pageContext.request.contextPath}/doctor/medical-records" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

---

## 📝 BƯỚC 7: TẠO JSP - CHI TIẾT BỆNH ÁN & ĐƠN THUỐC

**File:** `src/main/webapp/WEB-INF/views/doctor/medical_record_detail.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Bệnh án - JVCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Chi tiết Bệnh án #${record.recordId}</h2>
            <div>
                <a href="${pageContext.request.contextPath}/doctor/medical-records?action=edit&id=${record.recordId}" 
                   class="btn btn-warning">Sửa</a>
                <a href="${pageContext.request.contextPath}/doctor/medical-records" 
                   class="btn btn-secondary">Quay lại</a>
            </div>
        </div>
        
        <!-- Patient Info -->
        <div class="card mb-3">
            <div class="card-header bg-primary text-white">Thông tin bệnh nhân</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Mã BN:</strong> ${record.patientCode}</p>
                        <p><strong>Họ tên:</strong> ${record.patientName}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Ngày khám:</strong> 
                            <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy HH:mm" />
                        </p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Vital Signs -->
        <div class="card mb-3">
            <div class="card-header">Chỉ số sinh tồn</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <p><strong>Huyết áp:</strong> ${record.bloodPressure}</p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Nhịp tim:</strong> ${record.heartRate} bpm</p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Nhiệt độ:</strong> ${record.temperature}°C</p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Cân nặng:</strong> ${record.weight} kg</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Diagnosis & Treatment -->
        <div class="card mb-3">
            <div class="card-header">Chẩn đoán & Điều trị</div>
            <div class="card-body">
                <p><strong>Chẩn đoán:</strong></p>
                <p>${record.diagnosis}</p>
                
                <p><strong>Phương án điều trị:</strong></p>
                <p>${record.treatmentPlan}</p>
                
                <c:if test="${not empty record.notes}">
                    <p><strong>Ghi chú:</strong></p>
                    <p>${record.notes}</p>
                </c:if>
            </div>
        </div>
        
        <!-- Prescriptions -->
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Đơn thuốc</span>
                <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#addMedicationModal">
                    + Thêm thuốc
                </button>
            </div>
            <div class="card-body">
                <c:if test="${empty prescriptions}">
                    <p class="text-muted">Chưa có thuốc nào trong đơn</p>
                </c:if>
                
                <c:if test="${not empty prescriptions}">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên thuốc</th>
                                <th>Liều lượng</th>
                                <th>Tần suất</th>
                                <th>Số ngày</th>
                                <th>Hướng dẫn</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${prescriptions}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${p.medicationName}</td>
                                    <td>${p.dosage}</td>
                                    <td>${p.frequency}</td>
                                    <td>${p.durationDays}</td>
                                    <td>${p.instructions}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/doctor/prescriptions?action=delete&id=${p.prescriptionId}&recordId=${record.recordId}" 
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('Xóa thuốc này?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                    <a href="${pageContext.request.contextPath}/doctor/medical-records/print?id=${record.recordId}" 
                       class="btn btn-primary" target="_blank">
                        <i class="bi bi-printer"></i> In đơn thuốc
                    </a>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Add Medication Modal -->
    <div class="modal fade" id="addMedicationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/doctor/prescriptions">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm thuốc</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="recordId" value="${record.recordId}">
                        
                        <div class="mb-3">
                            <label class="form-label">Tên thuốc *</label>
                            <input type="text" name="medicationName" class="form-control" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Liều lượng *</label>
                            <input type="text" name="dosage" class="form-control" placeholder="500mg" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Tần suất *</label>
                            <input type="text" name="frequency" class="form-control" placeholder="3 lần/ngày" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Số ngày *</label>
                            <input type="number" name="durationDays" class="form-control" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Hướng dẫn sử dụng</label>
                            <textarea name="instructions" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

---

## 🧪 TESTING CHECKLIST

- [ ] Tạo bệnh án mới từ appointment
- [ ] Cập nhật bệnh án
- [ ] Xem chi tiết bệnh án
- [ ] Thêm thuốc vào đơn
- [ ] Sửa thông tin thuốc
- [ ] Xóa thuốc khỏi đơn
- [ ] In đơn thuốc
- [ ] Validate required fields
- [ ] Chỉ doctor mới truy cập được

---

## 📚 SQL QUERIES HỮU ÍCH

```sql
-- Lấy bệnh án với thông tin bệnh nhân và bác sĩ
SELECT mr.*, p.full_name as patient_name, p.patient_code,
       u.full_name as doctor_name, d.specialization
FROM medical_records mr
JOIN patients p ON mr.patient_id = p.patient_id
LEFT JOIN doctors d ON mr.doctor_id = d.doctor_id
LEFT JOIN users u ON d.user_id = u.user_id
WHERE mr.record_id = ?;

-- Lấy đơn thuốc của bệnh án
SELECT * FROM prescriptions 
WHERE record_id = ? 
ORDER BY prescription_id;

-- Thống kê số bệnh án theo bác sĩ
SELECT d.doctor_id, u.full_name, COUNT(mr.record_id) as total_records
FROM doctors d
JOIN users u ON d.user_id = u.user_id
LEFT JOIN medical_records mr ON d.doctor_id = mr.doctor_id
GROUP BY d.doctor_id, u.full_name
ORDER BY total_records DESC;
```

---

## ✅ DELIVERABLES

- [ ] 2 Servlets (DoctorMedicalRecordServlet, DoctorPrescriptionServlet)
- [ ] 2 DAOs updated (MedicalRecordDAO, PrescriptionDAO)
- [ ] 5 JSP files
- [ ] Print prescription template
- [ ] Test data SQL
- [ ] README documentation

