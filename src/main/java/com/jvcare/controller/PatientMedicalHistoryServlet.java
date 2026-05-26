package com.jvcare.controller;

import com.jvcare.dto.PatientDTO;
import com.jvcare.dto.MedicalRecordDTO;
import com.jvcare.service.PatientService;
import com.jvcare.service.MedicalRecordService;
import com.jvcare.model.User;
import com.jvcare.exception.BusinessException;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/patient/medical-history")
public class PatientMedicalHistoryServlet extends HttpServlet {

    private PatientService patientService;
    private MedicalRecordService recordService;

    @Override
    public void init() {
        patientService = new PatientService();
        recordService = new MedicalRecordService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkPatientAccess(request, response)) return;

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            PatientDTO patient = patientService.getPatientByUserId(user.getUserId());
            if (patient == null) {
                request.setAttribute("error", "Chưa có thông tin hồ sơ bệnh nhân.");
                request.getRequestDispatcher("/WEB-INF/views/patient/medical_history.jsp").forward(request, response);
                return;
            }

            String recordIdStr = request.getParameter("id");
            if (recordIdStr != null && !recordIdStr.trim().isEmpty()) {
                // View specific record detail
                int recordId = Integer.parseInt(recordIdStr);
                MedicalRecordDTO record = recordService.getRecordWithPrescriptions(recordId);
                
                // Security check: Make sure this record belongs to the patient
                if (record == null || record.getPatientId() != patient.getPatientId()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập hồ sơ bệnh án này.");
                    return;
                }
                
                request.setAttribute("patient", patient);
                request.setAttribute("record", record);
                request.getRequestDispatcher("/WEB-INF/views/patient/medical_history_detail.jsp").forward(request, response);
            } else {
                // View history list
                List<MedicalRecordDTO> history = patientService.getMedicalHistory(patient.getPatientId());
                request.setAttribute("patient", patient);
                request.setAttribute("history", history);
                request.getRequestDispatcher("/WEB-INF/views/patient/medical_history.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/patient/medical_history.jsp").forward(request, response);
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
