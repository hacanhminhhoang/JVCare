package com.jvcare.controller;

import com.jvcare.dao.PatientDAO;
import com.jvcare.model.Patient;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/patients")
public class AdminPatientServlet extends HttpServlet {
    
    private PatientDAO patientDAO = new PatientDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra authentication và authorization
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            viewPatient(request, response);
        } else if ("create".equals(action)) {
            showCreateForm(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("delete".equals(action)) {
            deletePatient(request, response);
        } else if ("search".equals(action)) {
            searchPatients(request, response);
        } else {
            listPatients(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách patients
     */
    private void listPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int page = 1;
        int pageSize = 12;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) { page = 1; }
        }
        if (page < 1) page = 1;
        
        List<Patient> allPatients = patientDAO.getAllPatients();
        int totalPatients = allPatients.size();
        int totalPages = (int) Math.ceil((double) totalPatients / pageSize);
        if (totalPages < 1) totalPages = 1;
        
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalPatients);
        List<Patient> patients = (start < totalPatients) ? allPatients.subList(start, end) : new java.util.ArrayList<>();
        
        // Lấy thông báo success nếu có
        String success = request.getParameter("success");
        if (success != null) {
            switch (success) {
                case "created":
                    request.setAttribute("successMessage", "Tạo bệnh nhân thành công!");
                    break;
                case "updated":
                    request.setAttribute("successMessage", "Cập nhật bệnh nhân thành công!");
                    break;
                case "deleted":
                    request.setAttribute("successMessage", "Xóa bệnh nhân thành công!");
                    break;
            }
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/patients.jsp").forward(request, response);
    }
    
    /**
     * Xem chi tiết patient
     */
    private void viewPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int patientId = Integer.parseInt(request.getParameter("id"));
        Patient patient = patientDAO.getPatientById(patientId);
        
        if (patient == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bệnh nhân không tồn tại");
            return;
        }
        
        request.setAttribute("patient", patient);
        request.getRequestDispatcher("/WEB-INF/views/admin/patient_detail.jsp").forward(request, response);
    }
    
    /**
     * Tìm kiếm patients
     */
    private void searchPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            listPatients(request, response);
            return;
        }
        
        List<Patient> allFound = patientDAO.searchPatients(keyword);
        int totalPatients = allFound.size();
        int pageSize = 12;
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) { page = 1; }
        }
        if (page < 1) page = 1;
        int totalPages = (int) Math.ceil((double) totalPatients / pageSize);
        if (totalPages < 1) totalPages = 1;
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalPatients);
        List<Patient> patients = (start < totalPatients) ? allFound.subList(start, end) : new java.util.ArrayList<>();
        
        request.setAttribute("patients", patients);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/patients.jsp").forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/patient_form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int patientId = Integer.parseInt(request.getParameter("id"));
        Patient patient = patientDAO.getPatientById(patientId);
        
        if (patient == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bệnh nhân không tồn tại");
            return;
        }
        
        request.setAttribute("patient", patient);
        request.getRequestDispatcher("/WEB-INF/views/admin/patient_form.jsp").forward(request, response);
    }
    
    private void deletePatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("id"));
            patientDAO.deletePatient(patientId);
            response.sendRedirect(request.getContextPath() + "/admin/patients?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/patients?error=delete_failed");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createPatient(request, response);
        } else if ("update".equals(action)) {
            updatePatient(request, response);
        } else if ("search".equals(action)) {
            searchPatients(request, response);
        }
    }
    
    private void createPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Patient patient = new Patient();
            patient.setFullName(request.getParameter("fullName"));
            String dobStr = request.getParameter("dateOfBirth");
            if (dobStr != null && !dobStr.isEmpty()) {
                patient.setDateOfBirth(Date.valueOf(dobStr));
            }
            patient.setGender(request.getParameter("gender"));
            patient.setPhone(request.getParameter("phone"));
            patient.setEmail(request.getParameter("email"));
            patient.setAddress(request.getParameter("address"));
            patient.setAllergies(request.getParameter("allergies"));
            patient.setChronicDiseases(request.getParameter("chronicDiseases"));
            patient.setIdCard(request.getParameter("idCard"));
            
            if (patientDAO.createPatient(patient)) {
                response.sendRedirect(request.getContextPath() + "/admin/patients?success=created");
            } else {
                request.setAttribute("error", "Không thể tạo bệnh nhân");
                showCreateForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showCreateForm(request, response);
        }
    }
    
    private void updatePatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            Patient patient = patientDAO.getPatientById(patientId);
            if (patient == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            patient.setFullName(request.getParameter("fullName"));
            String dobStr = request.getParameter("dateOfBirth");
            if (dobStr != null && !dobStr.isEmpty()) {
                patient.setDateOfBirth(Date.valueOf(dobStr));
            }
            patient.setGender(request.getParameter("gender"));
            patient.setPhone(request.getParameter("phone"));
            patient.setEmail(request.getParameter("email"));
            patient.setAddress(request.getParameter("address"));
            patient.setAllergies(request.getParameter("allergies"));
            patient.setChronicDiseases(request.getParameter("chronicDiseases"));
            patient.setIdCard(request.getParameter("idCard"));
            
            if (patientDAO.updatePatient(patient)) {
                response.sendRedirect(request.getContextPath() + "/admin/patients?success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật bệnh nhân");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    /**
     * Kiểm tra quyền truy cập ADMIN
     */
    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này");
            return false;
        }
        
        return true;
    }
}
