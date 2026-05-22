package com.jvcare.util;

import com.jvcare.dao.StatisticsDAO;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

/**
 * Tiện ích xuất báo cáo ra file Excel (CSV format đơn giản)
 * Sử dụng CSV thay cho Apache POI để giảm dependency
 */
public class ExcelExporter {
    
    /**
     * Export báo cáo ra file Excel/CSV
     */
    public static void export(HttpServletResponse response, String reportType, StatisticsDAO statisticsDAO) 
            throws IOException {
        
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String fileName = "report_" + reportType + "_" + java.time.LocalDate.now() + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        OutputStream out = response.getOutputStream();
        // BOM cho Excel đọc UTF-8
        out.write(new byte[]{(byte) 0xEF, (byte) 0xBB, (byte) 0xBF});
        
        StringBuilder sb = new StringBuilder();
        
        if ("appointments".equals(reportType)) {
            exportAppointmentsReport(sb, statisticsDAO);
        } else if ("doctors".equals(reportType)) {
            exportDoctorsReport(sb, statisticsDAO);
        } else if ("patients".equals(reportType)) {
            exportPatientsReport(sb, statisticsDAO);
        }
        
        out.write(sb.toString().getBytes("UTF-8"));
        out.flush();
        out.close();
    }
    
    private static void exportAppointmentsReport(StringBuilder sb, StatisticsDAO statisticsDAO) {
        sb.append("BÁO CÁO LỊCH HẸN - JVCARE\n");
        sb.append("Ngày xuất:,").append(java.time.LocalDate.now()).append("\n\n");
        
        // Header
        sb.append("Trạng thái,Số lượng\n");
        
        // Data
        Map<String, Integer> stats = statisticsDAO.getAppointmentsByStatus();
        sb.append("Chờ xử lý,").append(stats.getOrDefault("PENDING", 0)).append("\n");
        sb.append("Đã xác nhận,").append(stats.getOrDefault("CONFIRMED", 0)).append("\n");
        sb.append("Hoàn thành,").append(stats.getOrDefault("COMPLETED", 0)).append("\n");
        sb.append("Đã hủy,").append(stats.getOrDefault("CANCELLED", 0)).append("\n");
        
        int total = stats.values().stream().mapToInt(Integer::intValue).sum();
        sb.append("TỔNG CỘNG,").append(total).append("\n");
        
        // Monthly data
        sb.append("\nTHỐNG KÊ THEO THÁNG\n");
        sb.append("Tháng,Số lượng\n");
        int currentYear = java.time.Year.now().getValue();
        Map<Integer, Integer> monthlyStats = statisticsDAO.getAppointmentsByMonth(currentYear);
        String[] monthNames = {"", "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6",
                "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"};
        for (int i = 1; i <= 12; i++) {
            sb.append(monthNames[i]).append(",").append(monthlyStats.getOrDefault(i, 0)).append("\n");
        }
    }
    
    private static void exportDoctorsReport(StringBuilder sb, StatisticsDAO statisticsDAO) {
        sb.append("\"BÁO CÁO HIỆU SUẤT BÁC SĨ - JVCARE\"\n");
        sb.append("\"Ngày xuất:\",\"").append(java.time.LocalDate.now()).append("\"\n\n");
        
        // Header
        sb.append("\"STT\",\"Họ tên\",\"Chuyên khoa\",\"Tổng lịch hẹn\",\"Tổng bệnh án\"\n");
        
        // Data
        List<Map<String, Object>> doctors = statisticsDAO.getDoctorPerformance();
        int stt = 1;
        for (Map<String, Object> doctor : doctors) {
            sb.append(stt++).append(",");
            sb.append("\"").append(doctor.get("fullName")).append("\",");
            sb.append("\"").append(doctor.get("specialization")).append("\",");
            sb.append(doctor.get("totalAppointments")).append(",");
            sb.append(doctor.get("totalRecords")).append("\n");
        }
    }
    
    private static void exportPatientsReport(StringBuilder sb, StatisticsDAO statisticsDAO) {
        sb.append("BÁO CÁO THỐNG KÊ BỆNH NHÂN - JVCARE\n");
        sb.append("Ngày xuất:,").append(java.time.LocalDate.now()).append("\n\n");
        
        Map<String, Integer> stats = statisticsDAO.getPatientStatistics();
        sb.append("Chỉ số,Giá trị\n");
        sb.append("Tổng bệnh nhân,").append(stats.getOrDefault("totalPatients", 0)).append("\n");
        sb.append("Bệnh nhân nam,").append(stats.getOrDefault("malePatients", 0)).append("\n");
        sb.append("Bệnh nhân nữ,").append(stats.getOrDefault("femalePatients", 0)).append("\n");
    }
}
