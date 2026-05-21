package com.jvcare.controller;

import com.jvcare.dao.DoctorDAO;
import com.jvcare.model.Doctor;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/doctors")
public class AdminDoctorServlet extends HttpServlet {
    
    private DoctorDAO doctorDAO = new DoctorDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra authentication và authorization
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            viewDoctor(request, response);
        } else if ("search".equals(action)) {
            searchDoctors(request, response);
        } else {
            listDoctors(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách doctors
     */
    private void listDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        int totalDoctors = doctorDAO.getTotalDoctors();
        
        // Lấy thông báo success nếu có
        String success = request.getParameter("success");
        if (success != null) {
            switch (success) {
                case "created":
                    request.setAttribute("successMessage", "Tạo bác sĩ thành công!");
                    break;
                case "updated":
                    request.setAttribute("successMessage", "Cập nhật bác sĩ thành công!");
                    break;
                case "deleted":
                    request.setAttribute("successMessage", "Xóa bác sĩ thành công!");
                    break;
            }
        }
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("totalDoctors", totalDoctors);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/doctors.jsp").forward(request, response);
    }
    
    /**
     * Xem chi tiết doctor
     */
    private void viewDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorDAO.getDoctorById(doctorId);
        
        if (doctor == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bác sĩ không tồn tại");
            return;
        }
        
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/WEB-INF/views/admin/doctor_detail.jsp").forward(request, response);
    }
    
    /**
     * Tìm kiếm doctors
     */
    private void searchDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            listDoctors(request, response);
            return;
        }
        
        List<Doctor> doctors = doctorDAO.searchDoctors(keyword);
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalDoctors", doctors.size());
        
        request.getRequestDispatcher("/WEB-INF/views/admin/doctors.jsp").forward(request, response);
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
