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
        prescription.setRecordId(recordId);
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
