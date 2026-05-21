package com.jvcare.controller;

import com.jvcare.dao.PatientDAO;
import com.jvcare.model.Patient;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
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
        
        List<Patient> patients = patientDAO.getAllPatients();
        
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
        request.setAttribute("totalPatients", patients.size());
        
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
        
        List<Patient> patients = patientDAO.searchPatients(keyword);
        
        request.setAttribute("patients", patients);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalPatients", patients.size());
        
        request.getRequestDispatcher("/WEB-INF/views/admin/patients.jsp").forward(request, response);
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
