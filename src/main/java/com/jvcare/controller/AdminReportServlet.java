package com.jvcare.controller;

import com.jvcare.dao.UserDAO;
import com.jvcare.dao.DoctorDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra authentication và authorization
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("generate".equals(action)) {
            generateReport(request, response);
        } else {
            showReportPage(request, response);
        }
    }
    
    /**
     * Hiển thị trang báo cáo
     */
    private void showReportPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy thống kê tổng quan
        int totalUsers = userDAO.getTotalUsers();
        int totalDoctors = doctorDAO.getTotalDoctors();
        int totalPatients = patientDAO.getTotalPatients();
        int totalAppointments = appointmentDAO.getTotalAppointments();
        
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalDoctors", totalDoctors);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("totalAppointments", totalAppointments);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
    }
    
    /**
     * Tạo báo cáo PDF
     */
    private void generateReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String reportType = request.getParameter("type");
        
        // TODO: Implement PDF generation
        // Hiện tại chỉ redirect về trang báo cáo với thông báo
        response.sendRedirect(request.getContextPath() + "/admin/reports?success=generated");
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
