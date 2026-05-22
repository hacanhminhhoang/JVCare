package com.jvcare.controller;

import com.jvcare.service.ReportService;
import com.jvcare.service.StatisticsService;
import com.jvcare.dao.StatisticsDAO;
import com.jvcare.model.User;
import com.jvcare.util.ExcelExporter;
import com.jvcare.util.PDFExporter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    
    private ReportService reportService;
    private StatisticsService statisticsService;
    private StatisticsDAO statisticsDAO; // for legacy exporter support
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.reportService = new ReportService();
        this.statisticsService = new StatisticsService();
        this.statisticsDAO = new StatisticsDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        try {
            if ("appointments".equals(action)) {
                showAppointmentsReport(request, response);
            } else if ("doctors".equals(action)) {
                showDoctorsReport(request, response);
            } else if ("patients".equals(action)) {
                showPatientsReport(request, response);
            } else if ("export".equals(action)) {
                exportReport(request, response);
            } else {
                showReportsMenu(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xử lý báo cáo: " + e.getMessage());
        }
    }
    
    private void showAppointmentsReport(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        Map<String, Integer> appointmentStats = statisticsService.getAppointmentsByStatus();
        int currentYear = java.time.Year.now().getValue();
        Map<Integer, Integer> monthlyStats = statisticsService.getAppointmentsByMonth(currentYear);
        
        request.setAttribute("appointmentStats", appointmentStats);
        request.setAttribute("monthlyStats", monthlyStats);
        request.setAttribute("currentYear", currentYear);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/report_appointments.jsp")
               .forward(request, response);
    }
    
    private void showDoctorsReport(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        request.setAttribute("doctorPerformance", statisticsService.getDoctorPerformance());
        request.getRequestDispatcher("/WEB-INF/views/admin/report_doctors.jsp")
               .forward(request, response);
    }
    
    private void showPatientsReport(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        request.setAttribute("patientStats", statisticsService.getPatientStatistics());
        request.getRequestDispatcher("/WEB-INF/views/admin/report_patients.jsp")
               .forward(request, response);
    }
    
    private void exportReport(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String format = request.getParameter("format"); // excel or pdf
        String reportType = request.getParameter("type"); // appointments, doctors, patients
        
        if ("excel".equals(format)) {
            ExcelExporter.export(response, reportType, statisticsDAO);
        } else if ("pdf".equals(format)) {
            PDFExporter.export(response, reportType, statisticsDAO);
        }
    }
    
    private void showReportsMenu(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp")
               .forward(request, response);
    }
    
    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập");
            return false;
        }
        return true;
    }
}
