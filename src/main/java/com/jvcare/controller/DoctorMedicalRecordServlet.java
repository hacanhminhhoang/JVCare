package com.jvcare.controller;

import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.dao.PrescriptionDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.MedicalRecord;
import com.jvcare.model.Prescription;
import com.jvcare.model.Appointment;
import com.jvcare.model.User;
import com.jvcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
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
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("doctor_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1; // Fallback placeholder
    }
}
