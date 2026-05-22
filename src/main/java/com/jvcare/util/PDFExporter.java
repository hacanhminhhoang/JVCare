package com.jvcare.util;

import com.jvcare.dao.StatisticsDAO;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Tiện ích xuất báo cáo ra file PDF (HTML format đơn giản)
 * Sử dụng HTML thay cho iText để giảm dependency
 * Trình duyệt có thể in thành PDF qua Print dialog
 */
public class PDFExporter {
    
    /**
     * Export báo cáo ra dạng HTML có thể in thành PDF
     */
    public static void export(HttpServletResponse response, String reportType, StatisticsDAO statisticsDAO) 
            throws IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Báo cáo - JVCare</title>");
        out.println("<style>");
        out.println("@media print { body { margin: 0; } .no-print { display: none; } }");
        out.println("body { font-family: 'Segoe UI', Arial, sans-serif; padding: 30px; color: #333; }");
        out.println("h1 { color: #2563eb; border-bottom: 3px solid #2563eb; padding-bottom: 10px; }");
        out.println("h2 { color: #1e40af; margin-top: 25px; }");
        out.println("table { width: 100%; border-collapse: collapse; margin: 15px 0; }");
        out.println("th { background-color: #2563eb; color: white; padding: 12px 15px; text-align: left; }");
        out.println("td { padding: 10px 15px; border-bottom: 1px solid #e5e7eb; }");
        out.println("tr:nth-child(even) { background-color: #f9fafb; }");
        out.println(".summary-box { background: #eff6ff; border-left: 4px solid #2563eb; padding: 15px; margin: 15px 0; border-radius: 4px; }");
        out.println(".footer { text-align: center; margin-top: 30px; font-size: 12px; color: #999; border-top: 1px solid #eee; padding-top: 10px; }");
        out.println(".btn-print { background: #2563eb; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        // Nút in
        out.println("<div class='no-print' style='text-align: right; margin-bottom: 20px;'>");
        out.println("<button class='btn-print' onclick='window.print()'>🖨️ In / Lưu PDF</button>");
        out.println("</div>");
        
        if ("appointments".equals(reportType)) {
            exportAppointmentsReport(out, statisticsDAO);
        } else if ("doctors".equals(reportType)) {
            exportDoctorsReport(out, statisticsDAO);
        } else if ("patients".equals(reportType)) {
            exportPatientsReport(out, statisticsDAO);
        }
        
        out.println("<div class='footer'>");
        out.println("<p>🏥 JVCare - Hệ thống Quản lý Bệnh án Bệnh nhân</p>");
        out.println("<p>Xuất ngày: " + java.time.LocalDate.now() + " | © 2026 JVCare Team</p>");
        out.println("</div>");
        
        out.println("</body></html>");
        out.flush();
        out.close();
    }
    
    private static void exportAppointmentsReport(PrintWriter out, StatisticsDAO statisticsDAO) {
        out.println("<h1>📊 BÁO CÁO LỊCH HẸN</h1>");
        out.println("<p><strong>Ngày xuất:</strong> " + java.time.LocalDate.now() + "</p>");
        
        Map<String, Integer> stats = statisticsDAO.getAppointmentsByStatus();
        int total = stats.values().stream().mapToInt(Integer::intValue).sum();
        
        // Summary
        out.println("<div class='summary-box'>");
        out.println("<h2>📋 Tổng quan</h2>");
        out.println("<p><strong>Tổng số lịch hẹn:</strong> " + total + "</p>");
        out.println("<p><strong>Chờ xử lý:</strong> " + stats.getOrDefault("PENDING", 0) + "</p>");
        out.println("<p><strong>Đã xác nhận:</strong> " + stats.getOrDefault("CONFIRMED", 0) + "</p>");
        out.println("<p><strong>Hoàn thành:</strong> " + stats.getOrDefault("COMPLETED", 0) + "</p>");
        out.println("<p><strong>Đã hủy:</strong> " + stats.getOrDefault("CANCELLED", 0) + "</p>");
        out.println("</div>");
        
        // Table
        out.println("<h2>📊 Chi tiết theo trạng thái</h2>");
        out.println("<table>");
        out.println("<tr><th>Trạng thái</th><th>Số lượng</th><th>Tỷ lệ</th></tr>");
        
        for (Map.Entry<String, Integer> entry : stats.entrySet()) {
            String statusVi = translateStatus(entry.getKey());
            double rate = total > 0 ? (double) entry.getValue() / total * 100 : 0;
            out.printf("<tr><td>%s</td><td>%d</td><td>%.1f%%</td></tr>%n", 
                statusVi, entry.getValue(), rate);
        }
        out.println("<tr style='font-weight:bold; background:#dbeafe;'><td>TỔNG CỘNG</td><td>" + total + "</td><td>100%</td></tr>");
        out.println("</table>");
        
        // Monthly
        out.println("<h2>📅 Thống kê theo tháng (Năm " + java.time.Year.now().getValue() + ")</h2>");
        out.println("<table>");
        out.println("<tr><th>Tháng</th><th>Số lượng</th></tr>");
        Map<Integer, Integer> monthly = statisticsDAO.getAppointmentsByMonth(java.time.Year.now().getValue());
        for (int i = 1; i <= 12; i++) {
            out.printf("<tr><td>Tháng %d</td><td>%d</td></tr>%n", i, monthly.getOrDefault(i, 0));
        }
        out.println("</table>");
    }
    
    private static void exportDoctorsReport(PrintWriter out, StatisticsDAO statisticsDAO) {
        out.println("<h1>👨‍⚕️ BÁO CÁO HIỆU SUẤT BÁC SĨ</h1>");
        out.println("<p><strong>Ngày xuất:</strong> " + java.time.LocalDate.now() + "</p>");
        
        List<Map<String, Object>> doctors = statisticsDAO.getDoctorPerformance();
        
        // Summary
        out.println("<div class='summary-box'>");
        out.println("<h2>📋 Tổng quan</h2>");
        out.println("<p><strong>Tổng số bác sĩ:</strong> " + doctors.size() + "</p>");
        int totalAppt = doctors.stream().mapToInt(d -> (int) d.getOrDefault("totalAppointments", 0)).sum();
        int totalRec = doctors.stream().mapToInt(d -> (int) d.getOrDefault("totalRecords", 0)).sum();
        out.println("<p><strong>Tổng lịch hẹn:</strong> " + totalAppt + "</p>");
        out.println("<p><strong>Tổng bệnh án:</strong> " + totalRec + "</p>");
        out.println("</div>");
        
        // Table
        out.println("<h2>📊 Chi tiết hiệu suất</h2>");
        out.println("<table>");
        out.println("<tr><th>STT</th><th>Họ tên</th><th>Chuyên khoa</th><th>Lịch hẹn</th><th>Bệnh án</th></tr>");
        int stt = 1;
        for (Map<String, Object> doctor : doctors) {
            out.printf("<tr><td>%d</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>%n",
                stt++, doctor.get("fullName"), doctor.get("specialization"),
                doctor.get("totalAppointments"), doctor.get("totalRecords"));
        }
        out.println("</table>");
    }
    
    private static void exportPatientsReport(PrintWriter out, StatisticsDAO statisticsDAO) {
        out.println("<h1>🏥 BÁO CÁO THỐNG KÊ BỆNH NHÂN</h1>");
        out.println("<p><strong>Ngày xuất:</strong> " + java.time.LocalDate.now() + "</p>");
        
        Map<String, Integer> stats = statisticsDAO.getPatientStatistics();
        
        out.println("<div class='summary-box'>");
        out.println("<h2>📋 Tổng quan</h2>");
        out.println("<p><strong>Tổng bệnh nhân:</strong> " + stats.getOrDefault("totalPatients", 0) + "</p>");
        out.println("<p><strong>Nam:</strong> " + stats.getOrDefault("malePatients", 0) + "</p>");
        out.println("<p><strong>Nữ:</strong> " + stats.getOrDefault("femalePatients", 0) + "</p>");
        out.println("</div>");
        
        out.println("<table>");
        out.println("<tr><th>Chỉ số</th><th>Giá trị</th></tr>");
        out.println("<tr><td>Tổng bệnh nhân</td><td>" + stats.getOrDefault("totalPatients", 0) + "</td></tr>");
        out.println("<tr><td>Bệnh nhân nam</td><td>" + stats.getOrDefault("malePatients", 0) + "</td></tr>");
        out.println("<tr><td>Bệnh nhân nữ</td><td>" + stats.getOrDefault("femalePatients", 0) + "</td></tr>");
        out.println("</table>");
    }
    
    private static String translateStatus(String status) {
        switch (status) {
            case "PENDING": return "Chờ xử lý";
            case "CONFIRMED": return "Đã xác nhận";
            case "COMPLETED": return "Hoàn thành";
            case "CANCELLED": return "Đã hủy";
            default: return status;
        }
    }
}
