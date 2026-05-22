package com.jvcare.util;

import com.jvcare.dao.StatisticsDAO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * Tiện ích xuất báo cáo ra file Excel chuyên nghiệp với Apache POI
 * Có border, màu sắc, format đầy đủ
 */
public class ExcelExporter {
    
    /**
     * Export báo cáo ra file Excel chuyên nghiệp
     */
    public static void export(HttpServletResponse response, String reportType, StatisticsDAO statisticsDAO) 
            throws IOException {
        
        Workbook workbook = new XSSFWorkbook();
        
        if ("appointments".equals(reportType)) {
            exportAppointmentsReport(workbook, statisticsDAO);
        } else if ("doctors".equals(reportType)) {
            exportDoctorsReport(workbook, statisticsDAO);
        } else if ("patients".equals(reportType)) {
            exportPatientsReport(workbook, statisticsDAO);
        }
        
        // Set response headers
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        
        String fileName = "BaoCao_" + reportType + "_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".xlsx";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // Write to output stream
        OutputStream out = response.getOutputStream();
        workbook.write(out);
        workbook.close();
        out.flush();
        out.close();
    }
    
    /**
     * Tạo style cho header chính
     */
    private static CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 16);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }
    
    /**
     * Tạo style cho tiêu đề cột
     */
    private static CellStyle createColumnHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 12);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.BLUE_GREY.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setBorderTop(BorderStyle.MEDIUM);
        style.setBorderBottom(BorderStyle.MEDIUM);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }
    
    /**
     * Tạo style cho dữ liệu
     */
    private static CellStyle createDataStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short) 11);
        style.setFont(font);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        return style;
    }
    
    /**
     * Tạo style cho dữ liệu số
     */
    private static CellStyle createNumberStyle(Workbook workbook) {
        CellStyle style = createDataStyle(workbook);
        style.setAlignment(HorizontalAlignment.CENTER);
        return style;
    }
    
    /**
     * Tạo style cho tổng cộng
     */
    private static CellStyle createTotalStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 11);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderTop(BorderStyle.MEDIUM);
        style.setBorderBottom(BorderStyle.MEDIUM);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        return style;
    }
    
    /**
     * Tạo style cho thông tin
     */
    private static CellStyle createInfoStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short) 10);
        font.setItalic(true);
        style.setFont(font);
        return style;
    }
    
    /**
     * Export báo cáo lịch hẹn
     */
    private static void exportAppointmentsReport(Workbook workbook, StatisticsDAO statisticsDAO) {
        Sheet sheet = workbook.createSheet("Báo Cáo Lịch Hẹn");
        
        // Styles
        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle columnHeaderStyle = createColumnHeaderStyle(workbook);
        CellStyle dataStyle = createDataStyle(workbook);
        CellStyle numberStyle = createNumberStyle(workbook);
        CellStyle totalStyle = createTotalStyle(workbook);
        CellStyle infoStyle = createInfoStyle(workbook);
        
        int rowNum = 0;
        
        // Title
        Row titleRow = sheet.createRow(rowNum++);
        titleRow.setHeightInPoints(30);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO THỐNG KÊ LỊCH HẸN");
        titleCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 3));
        
        // Date
        Row dateRow = sheet.createRow(rowNum++);
        Cell dateCell = dateRow.createCell(0);
        dateCell.setCellValue("Ngày xuất: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        dateCell.setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 3));
        
        rowNum++; // Empty row
        
        // Get data
        Map<String, Integer> stats = statisticsDAO.getAppointmentsByStatus();
        int total = stats.values().stream().mapToInt(Integer::intValue).sum();
        
        // Summary section
        Row summaryHeaderRow = sheet.createRow(rowNum++);
        Cell summaryCell = summaryHeaderRow.createCell(0);
        summaryCell.setCellValue("I. TỔNG QUAN");
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        boldFont.setFontHeightInPoints((short) 12);
        CellStyle summaryHeaderStyle = workbook.createCellStyle();
        summaryHeaderStyle.setFont(boldFont);
        summaryCell.setCellStyle(summaryHeaderStyle);
        
        String[] summaryLabels = {"Tổng số lịch hẹn:", "Chờ xử lý:", "Đã xác nhận:", "Hoàn thành:", "Đã hủy:"};
        int[] summaryValues = {
            total,
            stats.getOrDefault("PENDING", 0),
            stats.getOrDefault("CONFIRMED", 0),
            stats.getOrDefault("COMPLETED", 0),
            stats.getOrDefault("CANCELLED", 0)
        };
        
        for (int i = 0; i < summaryLabels.length; i++) {
            Row row = sheet.createRow(rowNum++);
            Cell labelCell = row.createCell(0);
            labelCell.setCellValue(summaryLabels[i]);
            Cell valueCell = row.createCell(1);
            valueCell.setCellValue(summaryValues[i]);
            valueCell.setCellStyle(numberStyle);
        }
        
        if (total > 0) {
            Row rateRow = sheet.createRow(rowNum++);
            Cell labelCell = rateRow.createCell(0);
            labelCell.setCellValue("Tỷ lệ hoàn thành:");
            Cell valueCell = rateRow.createCell(1);
            valueCell.setCellValue(String.format("%.1f%%", stats.getOrDefault("COMPLETED", 0) * 100.0 / total));
            valueCell.setCellStyle(numberStyle);
        }
        
        rowNum++; // Empty row
        
        // Detail table header
        Row detailHeaderRow = sheet.createRow(rowNum++);
        Cell detailTitleCell = detailHeaderRow.createCell(0);
        detailTitleCell.setCellValue("II. THỐNG KÊ THEO TRẠNG THÁI");
        detailTitleCell.setCellStyle(summaryHeaderStyle);
        
        rowNum++; // Empty row
        
        // Column headers
        Row headerRow = sheet.createRow(rowNum++);
        String[] headers = {"STT", "Trạng Thái", "Số Lượng", "Tỷ Lệ (%)"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(columnHeaderStyle);
        }
        
        // Data rows
        int stt = 1;
        String[] statusKeys = {"PENDING", "CONFIRMED", "COMPLETED", "CANCELLED"};
        String[] statusLabels = {"Chờ xử lý", "Đã xác nhận", "Hoàn thành", "Đã hủy"};
        
        for (int i = 0; i < statusKeys.length; i++) {
            if (stats.containsKey(statusKeys[i])) {
                Row row = sheet.createRow(rowNum++);
                
                Cell sttCell = row.createCell(0);
                sttCell.setCellValue(stt++);
                sttCell.setCellStyle(numberStyle);
                
                Cell statusCell = row.createCell(1);
                statusCell.setCellValue(statusLabels[i]);
                statusCell.setCellStyle(dataStyle);
                
                Cell countCell = row.createCell(2);
                countCell.setCellValue(stats.get(statusKeys[i]));
                countCell.setCellStyle(numberStyle);
                
                Cell rateCell = row.createCell(3);
                double rate = total > 0 ? stats.get(statusKeys[i]) * 100.0 / total : 0;
                rateCell.setCellValue(String.format("%.1f%%", rate));
                rateCell.setCellStyle(numberStyle);
            }
        }
        
        // Total row
        Row totalRow = sheet.createRow(rowNum++);
        Cell totalLabelCell = totalRow.createCell(0);
        totalLabelCell.setCellValue("TỔNG CỘNG");
        totalLabelCell.setCellStyle(totalStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 1));
        
        Cell totalCountCell = totalRow.createCell(2);
        totalCountCell.setCellValue(total);
        totalCountCell.setCellStyle(totalStyle);
        
        Cell totalRateCell = totalRow.createCell(3);
        totalRateCell.setCellValue("100.0%");
        totalRateCell.setCellStyle(totalStyle);
        
        rowNum += 2; // Empty rows
        
        // Monthly statistics
        Row monthlyHeaderRow = sheet.createRow(rowNum++);
        Cell monthlyTitleCell = monthlyHeaderRow.createCell(0);
        monthlyTitleCell.setCellValue("III. THỐNG KÊ THEO THÁNG (NĂM " + LocalDate.now().getYear() + ")");
        monthlyTitleCell.setCellStyle(summaryHeaderStyle);
        
        rowNum++; // Empty row
        
        // Monthly table headers
        Row monthlyColHeaderRow = sheet.createRow(rowNum++);
        Cell monthHeaderCell = monthlyColHeaderRow.createCell(0);
        monthHeaderCell.setCellValue("Tháng");
        monthHeaderCell.setCellStyle(columnHeaderStyle);
        Cell countHeaderCell = monthlyColHeaderRow.createCell(1);
        countHeaderCell.setCellValue("Số Lượng");
        countHeaderCell.setCellStyle(columnHeaderStyle);
        
        // Monthly data
        Map<Integer, Integer> monthlyStats = statisticsDAO.getAppointmentsByMonth(LocalDate.now().getYear());
        for (int i = 1; i <= 12; i++) {
            Row row = sheet.createRow(rowNum++);
            Cell monthCell = row.createCell(0);
            monthCell.setCellValue("Tháng " + i);
            monthCell.setCellStyle(dataStyle);
            
            Cell countCell = row.createCell(1);
            countCell.setCellValue(monthlyStats.getOrDefault(i, 0));
            countCell.setCellStyle(numberStyle);
        }
        
        // Auto-size columns
        for (int i = 0; i < 4; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
        }
    }
    
    /**
     * Export báo cáo bác sĩ
     */
    private static void exportDoctorsReport(Workbook workbook, StatisticsDAO statisticsDAO) {
        Sheet sheet = workbook.createSheet("Báo Cáo Bác Sĩ");
        
        // Styles
        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle columnHeaderStyle = createColumnHeaderStyle(workbook);
        CellStyle dataStyle = createDataStyle(workbook);
        CellStyle numberStyle = createNumberStyle(workbook);
        CellStyle totalStyle = createTotalStyle(workbook);
        CellStyle infoStyle = createInfoStyle(workbook);
        
        int rowNum = 0;
        
        // Title
        Row titleRow = sheet.createRow(rowNum++);
        titleRow.setHeightInPoints(30);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO HIỆU SUẤT BÁC SĨ");
        titleCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 4));
        
        // Date
        Row dateRow = sheet.createRow(rowNum++);
        Cell dateCell = dateRow.createCell(0);
        dateCell.setCellValue("Ngày xuất: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        dateCell.setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 4));
        
        rowNum++; // Empty row
        
        // Get data
        List<Map<String, Object>> doctors = statisticsDAO.getDoctorPerformance();
        int totalAppts = doctors.stream().mapToInt(d -> (int) d.getOrDefault("totalAppointments", 0)).sum();
        int totalRecs = doctors.stream().mapToInt(d -> (int) d.getOrDefault("totalRecords", 0)).sum();
        
        // Summary
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        boldFont.setFontHeightInPoints((short) 12);
        CellStyle summaryHeaderStyle = workbook.createCellStyle();
        summaryHeaderStyle.setFont(boldFont);
        
        Row summaryHeaderRow = sheet.createRow(rowNum++);
        Cell summaryCell = summaryHeaderRow.createCell(0);
        summaryCell.setCellValue("I. TỔNG QUAN");
        summaryCell.setCellStyle(summaryHeaderStyle);
        
        String[] summaryLabels = {"Tổng số bác sĩ:", "Tổng số lịch hẹn:", "Tổng số bệnh án:"};
        int[] summaryValues = {doctors.size(), totalAppts, totalRecs};
        
        for (int i = 0; i < summaryLabels.length; i++) {
            Row row = sheet.createRow(rowNum++);
            Cell labelCell = row.createCell(0);
            labelCell.setCellValue(summaryLabels[i]);
            Cell valueCell = row.createCell(1);
            valueCell.setCellValue(summaryValues[i]);
            valueCell.setCellStyle(numberStyle);
        }
        
        if (doctors.size() > 0) {
            Row avgRow1 = sheet.createRow(rowNum++);
            Cell label1 = avgRow1.createCell(0);
            label1.setCellValue("Trung bình lịch hẹn/bác sĩ:");
            Cell value1 = avgRow1.createCell(1);
            value1.setCellValue(String.format("%.1f", totalAppts * 1.0 / doctors.size()));
            value1.setCellStyle(numberStyle);
            
            Row avgRow2 = sheet.createRow(rowNum++);
            Cell label2 = avgRow2.createCell(0);
            label2.setCellValue("Trung bình bệnh án/bác sĩ:");
            Cell value2 = avgRow2.createCell(1);
            value2.setCellValue(String.format("%.1f", totalRecs * 1.0 / doctors.size()));
            value2.setCellStyle(numberStyle);
        }
        
        rowNum++; // Empty row
        
        // Detail table
        Row detailHeaderRow = sheet.createRow(rowNum++);
        Cell detailTitleCell = detailHeaderRow.createCell(0);
        detailTitleCell.setCellValue("II. CHI TIẾT HIỆU SUẤT TỪNG BÁC SĨ");
        detailTitleCell.setCellStyle(summaryHeaderStyle);
        
        rowNum++; // Empty row
        
        // Column headers
        Row headerRow = sheet.createRow(rowNum++);
        String[] headers = {"STT", "Họ và Tên", "Chuyên Khoa", "Tổng Lịch Hẹn", "Tổng Bệnh Án"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(columnHeaderStyle);
        }
        
        // Data rows
        int stt = 1;
        for (Map<String, Object> doctor : doctors) {
            Row row = sheet.createRow(rowNum++);
            
            Cell sttCell = row.createCell(0);
            sttCell.setCellValue(stt++);
            sttCell.setCellStyle(numberStyle);
            
            Cell nameCell = row.createCell(1);
            nameCell.setCellValue((String) doctor.get("fullName"));
            nameCell.setCellStyle(dataStyle);
            
            Cell specCell = row.createCell(2);
            specCell.setCellValue((String) doctor.get("specialization"));
            specCell.setCellStyle(dataStyle);
            
            Cell apptsCell = row.createCell(3);
            apptsCell.setCellValue((Integer) doctor.get("totalAppointments"));
            apptsCell.setCellStyle(numberStyle);
            
            Cell recsCell = row.createCell(4);
            recsCell.setCellValue((Integer) doctor.get("totalRecords"));
            recsCell.setCellStyle(numberStyle);
        }
        
        // Total row
        if (!doctors.isEmpty()) {
            Row totalRow = sheet.createRow(rowNum++);
            Cell totalLabelCell = totalRow.createCell(0);
            totalLabelCell.setCellValue("TỔNG CỘNG");
            totalLabelCell.setCellStyle(totalStyle);
            sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 2));
            
            Cell totalApptsCell = totalRow.createCell(3);
            totalApptsCell.setCellValue(totalAppts);
            totalApptsCell.setCellStyle(totalStyle);
            
            Cell totalRecsCell = totalRow.createCell(4);
            totalRecsCell.setCellValue(totalRecs);
            totalRecsCell.setCellStyle(totalStyle);
        }
        
        // Auto-size columns
        for (int i = 0; i < 5; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
        }
    }
    
    /**
     * Export báo cáo bệnh nhân
     */
    private static void exportPatientsReport(Workbook workbook, StatisticsDAO statisticsDAO) {
        Sheet sheet = workbook.createSheet("Báo Cáo Bệnh Nhân");
        
        // Styles
        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle columnHeaderStyle = createColumnHeaderStyle(workbook);
        CellStyle dataStyle = createDataStyle(workbook);
        CellStyle numberStyle = createNumberStyle(workbook);
        CellStyle infoStyle = createInfoStyle(workbook);
        
        int rowNum = 0;
        
        // Title
        Row titleRow = sheet.createRow(rowNum++);
        titleRow.setHeightInPoints(30);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO THỐNG KÊ BỆNH NHÂN");
        titleCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 3));
        
        // Date
        Row dateRow = sheet.createRow(rowNum++);
        Cell dateCell = dateRow.createCell(0);
        dateCell.setCellValue("Ngày xuất: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        dateCell.setCellStyle(infoStyle);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 3));
        
        rowNum++; // Empty row
        
        // Get data
        Map<String, Integer> stats = statisticsDAO.getPatientStatistics();
        int total = stats.getOrDefault("totalPatients", 0);
        int male = stats.getOrDefault("malePatients", 0);
        int female = stats.getOrDefault("femalePatients", 0);
        
        // Summary
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        boldFont.setFontHeightInPoints((short) 12);
        CellStyle summaryHeaderStyle = workbook.createCellStyle();
        summaryHeaderStyle.setFont(boldFont);
        
        Row summaryHeaderRow = sheet.createRow(rowNum++);
        Cell summaryCell = summaryHeaderRow.createCell(0);
        summaryCell.setCellValue("I. TỔNG QUAN");
        summaryCell.setCellStyle(summaryHeaderStyle);
        
        String[] summaryLabels = {"Tổng số bệnh nhân:", "Bệnh nhân nam:", "Bệnh nhân nữ:"};
        int[] summaryValues = {total, male, female};
        
        for (int i = 0; i < summaryLabels.length; i++) {
            Row row = sheet.createRow(rowNum++);
            Cell labelCell = row.createCell(0);
            labelCell.setCellValue(summaryLabels[i]);
            Cell valueCell = row.createCell(1);
            valueCell.setCellValue(summaryValues[i]);
            valueCell.setCellStyle(numberStyle);
        }
        
        if (total > 0) {
            Row rateRow = sheet.createRow(rowNum++);
            Cell labelCell = rateRow.createCell(0);
            labelCell.setCellValue("Tỷ lệ nam/nữ:");
            Cell valueCell = rateRow.createCell(1);
            valueCell.setCellValue(String.format("%.1f%% / %.1f%%", male * 100.0 / total, female * 100.0 / total));
            valueCell.setCellStyle(numberStyle);
        }
        
        rowNum++; // Empty row
        
        // Detail table
        Row detailHeaderRow = sheet.createRow(rowNum++);
        Cell detailTitleCell = detailHeaderRow.createCell(0);
        detailTitleCell.setCellValue("II. CHI TIẾT NHÂN KHẨU HỌC");
        detailTitleCell.setCellStyle(summaryHeaderStyle);
        
        rowNum++; // Empty row
        
        // Column headers
        Row headerRow = sheet.createRow(rowNum++);
        String[] headers = {"STT", "Chỉ Số", "Giá Trị", "Tỷ Lệ (%)"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(columnHeaderStyle);
        }
        
        // Data rows
        String[] labels = {"Tổng số lượng bệnh nhân đã đăng ký", "Bệnh nhân nam giới", "Bệnh nhân nữ giới"};
        int[] values = {total, male, female};
        
        for (int i = 0; i < labels.length; i++) {
            Row row = sheet.createRow(rowNum++);
            
            Cell sttCell = row.createCell(0);
            sttCell.setCellValue(i + 1);
            sttCell.setCellStyle(numberStyle);
            
            Cell labelCell = row.createCell(1);
            labelCell.setCellValue(labels[i]);
            labelCell.setCellStyle(dataStyle);
            
            Cell valueCell = row.createCell(2);
            valueCell.setCellValue(values[i]);
            valueCell.setCellStyle(numberStyle);
            
            Cell rateCell = row.createCell(3);
            double rate = total > 0 ? values[i] * 100.0 / total : 0;
            rateCell.setCellValue(String.format("%.1f%%", rate));
            rateCell.setCellStyle(numberStyle);
        }
        
        // Auto-size columns
        for (int i = 0; i < 4; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
        }
    }
}
