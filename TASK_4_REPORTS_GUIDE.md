# HƯỚNG DẪN TASK 4: BÁO CÁO & THỐNG KÊ (DASHBOARD)

## 📋 TỔNG QUAN
Phát triển dashboard và báo cáo thống kê cho Admin và Doctor với biểu đồ và export Excel/PDF.

**Thời gian ước tính:** 1-2 ngày

---

## 🗂️ CẤU TRÚC FILE CẦN TẠO/CẬP NHẬT

```
src/main/java/com/jvcare/
├── controller/
│   ├── AdminReportServlet.java                [MỚI]
│   ├── AdminHomeServlet.java                  [CẬP NHẬT]
│   └── DoctorHomeServlet.java                 [CẬP NHẬT]
├── dao/
│   └── StatisticsDAO.java                     [MỚI]
└── util/
    ├── ExcelExporter.java                     [MỚI]
    └── PDFExporter.java                       [MỚI]

src/main/webapp/WEB-INF/views/
├── admin/
│   ├── index.jsp                              [CẬP NHẬT]
│   ├── reports.jsp                            [MỚI]
│   ├── report_appointments.jsp                [MỚI]
│   └── report_doctors.jsp                     [MỚI]
└── doctor/
    └── index.jsp                              [CẬP NHẬT]
```

---

## 📝 BƯỚC 1: TẠO STATISTICS DAO

**File:** `src/main/java/com/jvcare/dao/StatisticsDAO.java`

```java
package com.jvcare.dao;

import com.jvcare.util.DBConnection;
import java.sql.*;
import java.util.*;

public class StatisticsDAO {
    
    /**
     * Tổng số users theo role
     */
    public Map<String, Integer> getUserCountByRole() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT role, COUNT(*) as total FROM users GROUP BY role";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                result.put(rs.getString("role"), rs.getInt("total"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Tổng số appointments
     */
    public int getTotalAppointments() {
        String sql = "SELECT COUNT(*) FROM appointments";
        return executeCountQuery(sql);
    }
    
    /**
     * Appointments theo status
     */
    public Map<String, Integer> getAppointmentsByStatus() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as total FROM appointments GROUP BY status";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                result.put(rs.getString("status"), rs.getInt("total"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Appointments theo tháng trong năm
     */
    public Map<Integer, Integer> getAppointmentsByMonth(int year) {
        Map<Integer, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT MONTH(appointment_date) as month, COUNT(*) as total " +
                     "FROM appointments " +
                     "WHERE YEAR(appointment_date) = ? " +
                     "GROUP BY MONTH(appointment_date) " +
                     "ORDER BY month";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                result.put(rs.getInt("month"), rs.getInt("total"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Hiệu suất bác sĩ (số lịch hẹn, bệnh án)
     */
    public List<Map<String, Object>> getDoctorPerformance() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT d.doctor_id, u.full_name, d.specialization, " +
                     "COUNT(DISTINCT a.appointment_id) as total_appointments, " +
                     "COUNT(DISTINCT mr.record_id) as total_records " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "LEFT JOIN appointments a ON d.doctor_id = a.doctor_id " +
                     "LEFT JOIN medical_records mr ON d.doctor_id = mr.doctor_id " +
                     "GROUP BY d.doctor_id, u.full_name, d.specialization " +
                     "ORDER BY total_appointments DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> doctor = new HashMap<>();
                doctor.put("doctorId", rs.getInt("doctor_id"));
                doctor.put("fullName", rs.getString("full_name"));
                doctor.put("specialization", rs.getString("specialization"));
                doctor.put("totalAppointments", rs.getInt("total_appointments"));
                doctor.put("totalRecords", rs.getInt("total_records"));
                result.add(doctor);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * Thống kê cho doctor dashboard
     */
    public Map<String, Integer> getDoctorStatistics(int doctorId) {
        Map<String, Integer> stats = new HashMap<>();
        
        // Appointments hôm nay
        String sql1 = "SELECT COUNT(*) FROM appointments " +
                      "WHERE doctor_id = ? AND appointment_date = CAST(GETDATE() AS DATE)";
        stats.put("todayAppointments", executeCountQuery(sql1, doctorId));
        
        // Tổng bệnh nhân đã khám
        String sql2 = "SELECT COUNT(DISTINCT patient_id) FROM appointments " +
                      "WHERE doctor_id = ? AND status = 'COMPLETED'";
        stats.put("totalPatients", executeCountQuery(sql2, doctorId));
        
        // Tổng bệnh án
        String sql3 = "SELECT COUNT(*) FROM medical_records WHERE doctor_id = ?";
        stats.put("totalRecords", executeCountQuery(sql3, doctorId));
        
        // Pending appointments
        String sql4 = "SELECT COUNT(*) FROM appointments " +
                      "WHERE doctor_id = ? AND status = 'PENDING'";
        stats.put("pendingAppointments", executeCountQuery(sql4, doctorId));
        
        return stats;
    }
    
    /**
     * Thống kê bệnh nhân
     */
    public Map<String, Integer> getPatientStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        
        stats.put("totalPatients", executeCountQuery("SELECT COUNT(*) FROM patients"));
        stats.put("malePatients", executeCountQuery(
            "SELECT COUNT(*) FROM patients WHERE gender = 'MALE'"));
        stats.put("femalePatients", executeCountQuery(
            "SELECT COUNT(*) FROM patients WHERE gender = 'FEMALE'"));
        
        return stats;
    }
    
    /**
     * Helper method để execute count query
     */
    private int executeCountQuery(String sql, Object... params) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
```

---

## 📝 BƯỚC 2: CẬP NHẬT ADMIN HOME SERVLET

**File:** `src/main/java/com/jvcare/controller/AdminHomeServlet.java`

```java
package com.jvcare.controller;

import com.jvcare.dao.StatisticsDAO;
import com.jvcare.model.User;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/index")
public class AdminHomeServlet extends HttpServlet {
    
    private StatisticsDAO statisticsDAO = new StatisticsDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        // Get statistics
        Map<String, Integer> userStats = statisticsDAO.getUserCountByRole();
        Map<String, Integer> appointmentStats = statisticsDAO.getAppointmentsByStatus();
        Map<String, Integer> patientStats = statisticsDAO.getPatientStatistics();
        
        // Get appointments by month for chart
        int currentYear = java.time.Year.now().getValue();
        Map<Integer, Integer> monthlyAppointments = 
            statisticsDAO.getAppointmentsByMonth(currentYear);
        
        // Convert to JSON for Chart.js
        Gson gson = new Gson();
        String monthlyAppointmentsJson = gson.toJson(monthlyAppointments);
        String appointmentStatsJson = gson.toJson(appointmentStats);
        
        request.setAttribute("userStats", userStats);
        request.setAttribute("appointmentStats", appointmentStats);
        request.setAttribute("patientStats", patientStats);
        request.setAttribute("monthlyAppointmentsJson", monthlyAppointmentsJson);
        request.setAttribute("appointmentStatsJson", appointmentStatsJson);
        request.setAttribute("currentYear", currentYear);

        request.getRequestDispatcher("/WEB-INF/views/admin/index.jsp")
               .forward(request, response);
    }
}
```

---

## 📝 BƯỚC 3: TẠO ADMIN REPORT SERVLET

**File:** `src/main/java/com/jvcare/controller/AdminReportServlet.java`

```java
package com.jvcare.controller;

import com.jvcare.dao.StatisticsDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.User;
import com.jvcare.util.ExcelExporter;
import com.jvcare.util.PDFExporter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    
    private StatisticsDAO statisticsDAO = new StatisticsDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("appointments".equals(action)) {
            showAppointmentsReport(request, response);
        } else if ("doctors".equals(action)) {
            showDoctorsReport(request, response);
        } else if ("export".equals(action)) {
            exportReport(request, response);
        } else {
            showReportsMenu(request, response);
        }
    }
    
    private void showAppointmentsReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Map<String, Integer> appointmentStats = statisticsDAO.getAppointmentsByStatus();
        int currentYear = java.time.Year.now().getValue();
        Map<Integer, Integer> monthlyStats = statisticsDAO.getAppointmentsByMonth(currentYear);
        
        request.setAttribute("appointmentStats", appointmentStats);
        request.setAttribute("monthlyStats", monthlyStats);
        request.setAttribute("currentYear", currentYear);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/report_appointments.jsp")
               .forward(request, response);
    }
    
    private void showDoctorsReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, Object>> doctorPerformance = statisticsDAO.getDoctorPerformance();
        
        request.setAttribute("doctorPerformance", doctorPerformance);
        request.getRequestDispatcher("/WEB-INF/views/admin/report_doctors.jsp")
               .forward(request, response);
    }
    
    private void exportReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String format = request.getParameter("format"); // excel or pdf
        String reportType = request.getParameter("type"); // appointments or doctors
        
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        return true;
    }
}
```

