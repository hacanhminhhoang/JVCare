# TASK 4: BÁO CÁO & THỐNG KÊ (3-LAYER)

## 📋 CẤU TRÚC 3 LỚP

```
PRESENTATION LAYER
  ├── AdminReportServlet.java
  ├── AdminHomeServlet.java (update)
  └── DoctorHomeServlet.java (update)
           ↓
BUSINESS LOGIC LAYER
  ├── StatisticsService.java
  └── ReportService.java
           ↓
DATA ACCESS LAYER
  └── StatisticsDAO.java
```

---

## 📝 BƯỚC 1: TẠO DTO CLASSES

### StatisticsDTO.java

```java
package com.jvcare.dto;

import java.util.Map;

public class StatisticsDTO {
    // User statistics
    private int totalUsers;
    private int totalAdmins;
    private int totalDoctors;
    private int totalPatients;
    
    // Appointment statistics
    private int totalAppointments;
    private int pendingAppointments;
    private int confirmedAppointments;
    private int completedAppointments;
    private int cancelledAppointments;
    
    // Medical record statistics
    private int totalRecords;
    private int totalPrescriptions;
    
    // Chart data
    private Map<Integer, Integer> appointmentsByMonth;
    private Map<String, Integer> appointmentsByStatus;
    private Map<String, Integer> usersByRole;
    
    // Constructors, Getters, Setters
}
```

### ReportDTO.java

```java
package com.jvcare.dto;

import java.util.List;
import java.util.Map;

public class ReportDTO {
    private String reportType; // appointments, doctors, patients
    private String reportDate;
    private Map<String, Object> filters;
    private List<Map<String, Object>> data;
    private Map<String, Object> summary;
    
    // Constructors, Getters, Setters
}
```

---

## 📝 BƯỚC 2: TẠO STATISTICS SERVICE

### StatisticsService.java

```java
package com.jvcare.service;

import com.jvcare.dao.StatisticsDAO;
import com.jvcare.dto.StatisticsDTO;
import com.jvcare.exception.BusinessException;

import java.util.Map;

public class StatisticsService {
    
    private StatisticsDAO statisticsDAO = new StatisticsDAO();
    
    /**
     * Lấy thống kê cho Admin Dashboard
     */
    public StatisticsDTO getAdminStatistics() throws BusinessException {
        try {
            StatisticsDTO stats = new StatisticsDTO();
            
            // User statistics
            Map<String, Integer> usersByRole = statisticsDAO.getUserCountByRole();
            stats.setTotalAdmins(usersByRole.getOrDefault("ADMIN", 0));
            stats.setTotalDoctors(usersByRole.getOrDefault("DOCTOR", 0));
            stats.setTotalPatients(usersByRole.getOrDefault("PATIENT", 0));
            stats.setTotalUsers(stats.getTotalAdmins() + 
                               stats.getTotalDoctors() + 
                               stats.getTotalPatients());
            
            // Appointment statistics
            Map<String, Integer> appointmentsByStatus = 
                statisticsDAO.getAppointmentsByStatus();
            stats.setPendingAppointments(
                appointmentsByStatus.getOrDefault("PENDING", 0));
            stats.setConfirmedAppointments(
                appointmentsByStatus.getOrDefault("CONFIRMED", 0));
            stats.setCompletedAppointments(
                appointmentsByStatus.getOrDefault("COMPLETED", 0));
            stats.setCancelledAppointments(
                appointmentsByStatus.getOrDefault("CANCELLED", 0));
            stats.setTotalAppointments(
                stats.getPendingAppointments() + 
                stats.getConfirmedAppointments() + 
                stats.getCompletedAppointments() + 
                stats.getCancelledAppointments());
            
            // Chart data
            int currentYear = java.time.Year.now().getValue();
            stats.setAppointmentsByMonth(
                statisticsDAO.getAppointmentsByMonth(currentYear));
            stats.setAppointmentsByStatus(appointmentsByStatus);
            stats.setUsersByRole(usersByRole);
            
            return stats;
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê", e);
        }
    }
    
    /**
     * Lấy thống kê cho Doctor Dashboard
     */
    public StatisticsDTO getDoctorStatistics(int doctorId) 
            throws BusinessException {
        try {
            Map<String, Integer> stats = 
                statisticsDAO.getDoctorStatistics(doctorId);
            
            StatisticsDTO dto = new StatisticsDTO();
            dto.setTotalAppointments(stats.getOrDefault("todayAppointments", 0));
            dto.setTotalPatients(stats.getOrDefault("totalPatients", 0));
            dto.setTotalRecords(stats.getOrDefault("totalRecords", 0));
            dto.setPendingAppointments(stats.getOrDefault("pendingAppointments", 0));
            
            return dto;
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thống kê bác sĩ", e);
        }
    }
    
    /**
     * Lấy hiệu suất của các bác sĩ
     */
    public List<Map<String, Object>> getDoctorPerformance() 
            throws BusinessException {
        try {
            return statisticsDAO.getDoctorPerformance();
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy hiệu suất bác sĩ", e);
        }
    }
}
```

---

## 📝 BƯỚC 3: TẠO REPORT SERVICE

### ReportService.java

```java
package com.jvcare.service;

import com.jvcare.dao.StatisticsDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dto.ReportDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.util.ExcelExporter;
import com.jvcare.util.PDFExporter;

import java.util.List;
import java.util.Map;

public class ReportService {
    
    private StatisticsDAO statisticsDAO = new StatisticsDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    /**
     * Tạo báo cáo appointments
     */
    public ReportDTO generateAppointmentReport(Map<String, Object> filters) 
            throws BusinessException {
        try {
            ReportDTO report = new ReportDTO();
            report.setReportType("appointments");
            report.setReportDate(java.time.LocalDate.now().toString());
            report.setFilters(filters);
            
            // Get data based on filters
            // Apply date range, status filter, etc.
            List<Map<String, Object>> data = getAppointmentData(filters);
            report.setData(data);
            
            // Calculate summary
            Map<String, Object> summary = calculateAppointmentSummary(data);
            report.setSummary(summary);
            
            return report;
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tạo báo cáo", e);
        }
    }
    
    /**
     * Export báo cáo ra Excel
     */
    public byte[] exportToExcel(ReportDTO report) throws BusinessException {
        try {
            return ExcelExporter.export(report);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi export Excel", e);
        }
    }
    
    /**
     * Export báo cáo ra PDF
     */
    public byte[] exportToPDF(ReportDTO report) throws BusinessException {
        try {
            return PDFExporter.export(report);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi export PDF", e);
        }
    }
    
    private List<Map<String, Object>> getAppointmentData(Map<String, Object> filters) {
        // Implementation
        return null;
    }
    
    private Map<String, Object> calculateAppointmentSummary(
            List<Map<String, Object>> data) {
        // Calculate totals, averages, etc.
        return null;
    }
}
```

---

## 📝 BƯỚC 4: CẬP NHẬT SERVLET

### AdminHomeServlet.java (Updated)

```java
@WebServlet("/admin/index")
public class AdminHomeServlet extends HttpServlet {
    
    private StatisticsService statisticsService = new StatisticsService();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Call Service
            StatisticsDTO stats = statisticsService.getAdminStatistics();
            
            // Convert to JSON for charts
            Gson gson = new Gson();
            String monthlyJson = gson.toJson(stats.getAppointmentsByMonth());
            String statusJson = gson.toJson(stats.getAppointmentsByStatus());
            
            // Set attributes
            request.setAttribute("stats", stats);
            request.setAttribute("monthlyJson", monthlyJson);
            request.setAttribute("statusJson", statusJson);
            
            // Forward
            request.getRequestDispatcher("/WEB-INF/views/admin/index.jsp")
                   .forward(request, response);
                   
        } catch (BusinessException e) {
            // Handle error
        }
    }
}
```

---

## ✅ CHECKLIST

- [ ] Tạo StatisticsDTO.java
- [ ] Tạo ReportDTO.java
- [ ] Tạo StatisticsService.java
- [ ] Tạo ReportService.java
- [ ] Cập nhật AdminHomeServlet
- [ ] Cập nhật DoctorHomeServlet
- [ ] Tạo AdminReportServlet
- [ ] Tích hợp Chart.js
- [ ] Implement Excel export
- [ ] Implement PDF export

