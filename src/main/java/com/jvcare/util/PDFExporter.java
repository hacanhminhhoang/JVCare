package com.jvcare.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.jvcare.dao.StatisticsDAO;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * Tiện ích xuất báo cáo ra file PDF chuyên nghiệp với iText
 * Format như slide báo cáo presentation
 */
public class PDFExporter {
    
    // Colors
    private static final BaseColor HEADER_BG = new BaseColor(30, 58, 138); // Dark blue
    private static final BaseColor HEADER_TEXT = BaseColor.WHITE;
    private static final BaseColor TABLE_HEADER_BG = new BaseColor(96, 165, 250); // Light blue
    private static final BaseColor TABLE_ALT_ROW = new BaseColor(239, 246, 255); // Very light blue
    private static final BaseColor ACCENT_COLOR = new BaseColor(37, 99, 235); // Blue
    
    /**
     * Export báo cáo ra file PDF
     */
    public static void export(HttpServletResponse response, String reportType, StatisticsDAO statisticsDAO) 
            throws IOException {
        
        try {
            // Set response headers
            response.setContentType("application/pdf");
            response.setCharacterEncoding("UTF-8");
            
            String fileName = "BaoCao_" + reportType + "_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".pdf";
            response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
            
            OutputStream out = response.getOutputStream();
            
            // Create document
            Document document = new Document(PageSize.A4, 40, 40, 50, 50);
            PdfWriter writer = PdfWriter.getInstance(document, out);
            
            // Add header and footer
            HeaderFooter event = new HeaderFooter();
            writer.setPageEvent(event);
            
            document.open();
            
            if ("appointments".equals(reportType)) {
                exportAppointmentsReport(document, statisticsDAO);
            } else if ("doctors".equals(reportType)) {
                exportDoctorsReport(document, statisticsDAO);
            } else if ("patients".equals(reportType)) {
                exportPatientsReport(document, statisticsDAO);
            }
            
            document.close();
            out.flush();
            out.close();
            
        } catch (DocumentException e) {
            throw new IOException("Error creating PDF", e);
        }
    }
    
    /**
     * Tạo font tiếng Việt (fallback to default if not available)
     */
    private static Font createFont(int size, int style) {
        try {
            // Try to use a Unicode font that supports Vietnamese
            BaseFont bf = BaseFont.createFont("c:/windows/fonts/times.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            return new Font(bf, size, style);
        } catch (Exception e) {
            // Fallback to default font
            return FontFactory.getFont(FontFactory.TIMES_ROMAN, size, style);
        }
    }
    
    /**
     * Tạo tiêu đề chính
     */
    private static void addTitle(Document document, String title) throws DocumentException {
        Font titleFont = createFont(24, Font.BOLD);
        titleFont.setColor(HEADER_BG);
        
        Paragraph titlePara = new Paragraph(title, titleFont);
        titlePara.setAlignment(Element.ALIGN_CENTER);
        titlePara.setSpacingAfter(10);
        document.add(titlePara);
        
        // Add date
        Font dateFont = createFont(11, Font.ITALIC);
        dateFont.setColor(BaseColor.GRAY);
        String dateStr = "Ngày xuất: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        Paragraph datePara = new Paragraph(dateStr, dateFont);
        datePara.setAlignment(Element.ALIGN_CENTER);
        datePara.setSpacingAfter(20);
        document.add(datePara);
    }
    
    /**
     * Tạo section header
     */
    private static void addSectionHeader(Document document, String text) throws DocumentException {
        Font headerFont = createFont(16, Font.BOLD);
        headerFont.setColor(ACCENT_COLOR);
        
        Paragraph header = new Paragraph(text, headerFont);
        header.setSpacingBefore(15);
        header.setSpacingAfter(10);
        document.add(header);
        
        // Add underline using drawLine
        PdfPTable line = new PdfPTable(1);
        line.setWidthPercentage(100);
        PdfPCell lineCell = new PdfPCell();
        lineCell.setBorder(Rectangle.NO_BORDER);
        lineCell.setBorderWidthBottom(2);
        lineCell.setBorderColorBottom(ACCENT_COLOR);
        lineCell.setFixedHeight(5);
        line.addCell(lineCell);
        document.add(line);
    }
    
    /**
     * Tạo summary box
     */
    private static void addSummaryBox(Document document, String[] labels, String[] values) throws DocumentException {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{3, 1});
        table.setSpacingAfter(15);
        
        Font labelFont = createFont(11, Font.NORMAL);
        Font valueFont = createFont(12, Font.BOLD);
        valueFont.setColor(ACCENT_COLOR);
        
        for (int i = 0; i < labels.length; i++) {
            PdfPCell labelCell = new PdfPCell(new Phrase(labels[i], labelFont));
            labelCell.setBorder(Rectangle.NO_BORDER);
            labelCell.setPadding(8);
            labelCell.setBackgroundColor(i % 2 == 0 ? BaseColor.WHITE : TABLE_ALT_ROW);
            table.addCell(labelCell);
            
            PdfPCell valueCell = new PdfPCell(new Phrase(values[i], valueFont));
            valueCell.setBorder(Rectangle.NO_BORDER);
            valueCell.setPadding(8);
            valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            valueCell.setBackgroundColor(i % 2 == 0 ? BaseColor.WHITE : TABLE_ALT_ROW);
            table.addCell(valueCell);
        }
        
        document.add(table);
    }
    
    /**
     * Export báo cáo lịch hẹn
     */
    private static void exportAppointmentsReport(Document document, StatisticsDAO statisticsDAO) throws DocumentException {
        addTitle(document, "BÁO CÁO THỐNG KÊ LỊCH HẸN");
        
        // Get data
        Map<String, Integer> stats = statisticsDAO.getAppointmentsByStatus();
        int total = stats.values().stream().mapToInt(Integer::intValue).sum();
        
        // Summary section
        addSectionHeader(document, "I. TỔNG QUAN");
        
        String[] labels = {
            "Tổng số lịch hẹn:",
            "Chờ xử lý:",
            "Đã xác nhận:",
            "Hoàn thành:",
            "Đã hủy:",
            "Tỷ lệ hoàn thành:"
        };
        
        String[] values = {
            String.valueOf(total),
            String.valueOf(stats.getOrDefault("PENDING", 0)),
            String.valueOf(stats.getOrDefault("CONFIRMED", 0)),
            String.valueOf(stats.getOrDefault("COMPLETED", 0)),
            String.valueOf(stats.getOrDefault("CANCELLED", 0)),
            total > 0 ? String.format("%.1f%%", stats.getOrDefault("COMPLETED", 0) * 100.0 / total) : "0%"
        };
        
        addSummaryBox(document, labels, values);
        
        // Detail table
        addSectionHeader(document, "II. THỐNG KÊ THEO TRẠNG THÁI");
        
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1, 3, 2, 2});
        table.setSpacingAfter(15);
        
        // Header
        Font headerFont = createFont(11, Font.BOLD);
        headerFont.setColor(HEADER_TEXT);
        String[] headers = {"STT", "Trạng Thái", "Số Lượng", "Tỷ Lệ (%)"};
        
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(TABLE_HEADER_BG);
            cell.setPadding(10);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);
        }
        
        // Data
        Font dataFont = createFont(10, Font.NORMAL);
        String[] statusKeys = {"PENDING", "CONFIRMED", "COMPLETED", "CANCELLED"};
        String[] statusLabels = {"Chờ xử lý", "Đã xác nhận", "Hoàn thành", "Đã hủy"};
        
        for (int i = 0; i < statusKeys.length; i++) {
            if (stats.containsKey(statusKeys[i])) {
                BaseColor bgColor = i % 2 == 0 ? BaseColor.WHITE : TABLE_ALT_ROW;
                
                PdfPCell sttCell = new PdfPCell(new Phrase(String.valueOf(i + 1), dataFont));
                sttCell.setPadding(8);
                sttCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                sttCell.setBackgroundColor(bgColor);
                sttCell.setBorder(Rectangle.BOTTOM);
                table.addCell(sttCell);
                
                PdfPCell statusCell = new PdfPCell(new Phrase(statusLabels[i], dataFont));
                statusCell.setPadding(8);
                statusCell.setBackgroundColor(bgColor);
                statusCell.setBorder(Rectangle.BOTTOM);
                table.addCell(statusCell);
                
                PdfPCell countCell = new PdfPCell(new Phrase(String.valueOf(stats.get(statusKeys[i])), dataFont));
                countCell.setPadding(8);
                countCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                countCell.setBackgroundColor(bgColor);
                countCell.setBorder(Rectangle.BOTTOM);
                table.addCell(countCell);
                
                double rate = total > 0 ? stats.get(statusKeys[i]) * 100.0 / total : 0;
                PdfPCell rateCell = new PdfPCell(new Phrase(String.format("%.1f%%", rate), dataFont));
                rateCell.setPadding(8);
                rateCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                rateCell.setBackgroundColor(bgColor);
                rateCell.setBorder(Rectangle.BOTTOM);
                table.addCell(rateCell);
            }
        }
        
        // Total row
        Font totalFont = createFont(11, Font.BOLD);
        PdfPCell totalLabelCell = new PdfPCell(new Phrase("TỔNG CỘNG", totalFont));
        totalLabelCell.setColspan(2);
        totalLabelCell.setPadding(10);
        totalLabelCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        totalLabelCell.setBackgroundColor(new BaseColor(220, 220, 220));
        table.addCell(totalLabelCell);
        
        PdfPCell totalCountCell = new PdfPCell(new Phrase(String.valueOf(total), totalFont));
        totalCountCell.setPadding(10);
        totalCountCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        totalCountCell.setBackgroundColor(new BaseColor(220, 220, 220));
        table.addCell(totalCountCell);
        
        PdfPCell totalRateCell = new PdfPCell(new Phrase("100.0%", totalFont));
        totalRateCell.setPadding(10);
        totalRateCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        totalRateCell.setBackgroundColor(new BaseColor(220, 220, 220));
        table.addCell(totalRateCell);
        
        document.add(table);
        
        // Monthly statistics
        document.newPage();
        addSectionHeader(document, "III. THỐNG KÊ THEO THÁNG (NĂM " + LocalDate.now().getYear() + ")");
        
        PdfPTable monthlyTable = new PdfPTable(2);
        monthlyTable.setWidthPercentage(70);
        monthlyTable.setWidths(new float[]{2, 1});
        monthlyTable.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        // Header
        PdfPCell monthHeaderCell = new PdfPCell(new Phrase("Tháng", headerFont));
        monthHeaderCell.setBackgroundColor(TABLE_HEADER_BG);
        monthHeaderCell.setPadding(10);
        monthHeaderCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        monthlyTable.addCell(monthHeaderCell);
        
        PdfPCell countHeaderCell = new PdfPCell(new Phrase("Số Lượng", headerFont));
        countHeaderCell.setBackgroundColor(TABLE_HEADER_BG);
        countHeaderCell.setPadding(10);
        countHeaderCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        monthlyTable.addCell(countHeaderCell);
        
        // Data
        Map<Integer, Integer> monthlyStats = statisticsDAO.getAppointmentsByMonth(LocalDate.now().getYear());
        for (int i = 1; i <= 12; i++) {
            BaseColor bgColor = i % 2 == 0 ? BaseColor.WHITE : TABLE_ALT_ROW;
            
            PdfPCell monthCell = new PdfPCell(new Phrase("Tháng " + i, dataFont));
            monthCell.setPadding(8);
            monthCell.setBackgroundColor(bgColor);
            monthCell.setBorder(Rectangle.BOTTOM);
            monthlyTable.addCell(monthCell);
            
            PdfPCell countCell = new PdfPCell(new Phrase(String.valueOf(monthlyStats.getOrDefault(i, 0)), dataFont));
            countCell.setPadding(8);
            countCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            countCell.setBackgroundColor(bgColor);
            countCell.setBorder(Rectangle.BOTTOM);
            monthlyTable.addCell(countCell);
        }
        
        document.add(monthlyTable);
    }
    
    /**
     * Export báo cáo bác sĩ
     */
    private static void exportDoctorsReport(Document document, StatisticsDAO statisticsDAO) throws DocumentException {
        addTitle(document, "BÁO CÁO HIỆU SUẤT BÁC SĨ");
        
        // Get data
        List<Map<String, Object>> doctors = statisticsDAO.getDoctorPerformance();
        int totalAppts = doctors.stream().mapToInt(d -> (int) d.getOrDefault("totalAppointments", 0)).sum();
        int totalRecs = doctors.stream().mapToInt(d -> (int) d.getOrDefault("totalRecords", 0)).sum();
        
        // Summary
        addSectionHeader(document, "I. TỔNG QUAN");
        
        String[] labels = {
            "Tổng số bác sĩ:",
            "Tổng số lịch hẹn:",
            "Tổng số bệnh án:",
            "Trung bình lịch hẹn/bác sĩ:",
            "Trung bình bệnh án/bác sĩ:"
        };
        
        String[] values = {
            String.valueOf(doctors.size()),
            String.valueOf(totalAppts),
            String.valueOf(totalRecs),
            doctors.size() > 0 ? String.format("%.1f", totalAppts * 1.0 / doctors.size()) : "0",
            doctors.size() > 0 ? String.format("%.1f", totalRecs * 1.0 / doctors.size()) : "0"
        };
        
        addSummaryBox(document, labels, values);
        
        // Detail table
        addSectionHeader(document, "II. CHI TIẾT HIỆU SUẤT TỪNG BÁC SĨ");
        
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1, 3, 3, 2, 2});
        table.setSpacingAfter(15);
        
        // Header
        Font headerFont = createFont(11, Font.BOLD);
        headerFont.setColor(HEADER_TEXT);
        String[] headers = {"STT", "Họ và Tên", "Chuyên Khoa", "Lịch Hẹn", "Bệnh Án"};
        
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(TABLE_HEADER_BG);
            cell.setPadding(10);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);
        }
        
        // Data
        Font dataFont = createFont(10, Font.NORMAL);
        int stt = 1;
        
        for (Map<String, Object> doctor : doctors) {
            BaseColor bgColor = stt % 2 == 0 ? TABLE_ALT_ROW : BaseColor.WHITE;
            
            PdfPCell sttCell = new PdfPCell(new Phrase(String.valueOf(stt++), dataFont));
            sttCell.setPadding(8);
            sttCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            sttCell.setBackgroundColor(bgColor);
            sttCell.setBorder(Rectangle.BOTTOM);
            table.addCell(sttCell);
            
            PdfPCell nameCell = new PdfPCell(new Phrase((String) doctor.get("fullName"), dataFont));
            nameCell.setPadding(8);
            nameCell.setBackgroundColor(bgColor);
            nameCell.setBorder(Rectangle.BOTTOM);
            table.addCell(nameCell);
            
            PdfPCell specCell = new PdfPCell(new Phrase((String) doctor.get("specialization"), dataFont));
            specCell.setPadding(8);
            specCell.setBackgroundColor(bgColor);
            specCell.setBorder(Rectangle.BOTTOM);
            table.addCell(specCell);
            
            PdfPCell apptsCell = new PdfPCell(new Phrase(String.valueOf(doctor.get("totalAppointments")), dataFont));
            apptsCell.setPadding(8);
            apptsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            apptsCell.setBackgroundColor(bgColor);
            apptsCell.setBorder(Rectangle.BOTTOM);
            table.addCell(apptsCell);
            
            PdfPCell recsCell = new PdfPCell(new Phrase(String.valueOf(doctor.get("totalRecords")), dataFont));
            recsCell.setPadding(8);
            recsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            recsCell.setBackgroundColor(bgColor);
            recsCell.setBorder(Rectangle.BOTTOM);
            table.addCell(recsCell);
        }
        
        // Total row
        if (!doctors.isEmpty()) {
            Font totalFont = createFont(11, Font.BOLD);
            PdfPCell totalLabelCell = new PdfPCell(new Phrase("TỔNG CỘNG", totalFont));
            totalLabelCell.setColspan(3);
            totalLabelCell.setPadding(10);
            totalLabelCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            totalLabelCell.setBackgroundColor(new BaseColor(220, 220, 220));
            table.addCell(totalLabelCell);
            
            PdfPCell totalApptsCell = new PdfPCell(new Phrase(String.valueOf(totalAppts), totalFont));
            totalApptsCell.setPadding(10);
            totalApptsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            totalApptsCell.setBackgroundColor(new BaseColor(220, 220, 220));
            table.addCell(totalApptsCell);
            
            PdfPCell totalRecsCell = new PdfPCell(new Phrase(String.valueOf(totalRecs), totalFont));
            totalRecsCell.setPadding(10);
            totalRecsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            totalRecsCell.setBackgroundColor(new BaseColor(220, 220, 220));
            table.addCell(totalRecsCell);
        }
        
        document.add(table);
    }
    
    /**
     * Export báo cáo bệnh nhân
     */
    private static void exportPatientsReport(Document document, StatisticsDAO statisticsDAO) throws DocumentException {
        addTitle(document, "BÁO CÁO THỐNG KÊ BỆNH NHÂN");
        
        // Get data
        Map<String, Integer> stats = statisticsDAO.getPatientStatistics();
        int total = stats.getOrDefault("totalPatients", 0);
        int male = stats.getOrDefault("malePatients", 0);
        int female = stats.getOrDefault("femalePatients", 0);
        
        // Summary
        addSectionHeader(document, "I. TỔNG QUAN");
        
        String[] labels = {
            "Tổng số bệnh nhân:",
            "Bệnh nhân nam:",
            "Bệnh nhân nữ:",
            "Tỷ lệ nam/nữ:"
        };
        
        String[] values = {
            String.valueOf(total),
            String.valueOf(male),
            String.valueOf(female),
            total > 0 ? String.format("%.1f%% / %.1f%%", male * 100.0 / total, female * 100.0 / total) : "0% / 0%"
        };
        
        addSummaryBox(document, labels, values);
        
        // Detail table
        addSectionHeader(document, "II. CHI TIẾT NHÂN KHẨU HỌC");
        
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1, 4, 2, 2});
        table.setSpacingAfter(15);
        
        // Header
        Font headerFont = createFont(11, Font.BOLD);
        headerFont.setColor(HEADER_TEXT);
        String[] headers = {"STT", "Chỉ Số", "Giá Trị", "Tỷ Lệ (%)"};
        
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(TABLE_HEADER_BG);
            cell.setPadding(10);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);
        }
        
        // Data
        Font dataFont = createFont(10, Font.NORMAL);
        String[] dataLabels = {
            "Tổng số lượng bệnh nhân đã đăng ký",
            "Bệnh nhân nam giới",
            "Bệnh nhân nữ giới"
        };
        int[] dataValues = {total, male, female};
        
        for (int i = 0; i < dataLabels.length; i++) {
            BaseColor bgColor = i % 2 == 0 ? BaseColor.WHITE : TABLE_ALT_ROW;
            
            PdfPCell sttCell = new PdfPCell(new Phrase(String.valueOf(i + 1), dataFont));
            sttCell.setPadding(8);
            sttCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            sttCell.setBackgroundColor(bgColor);
            sttCell.setBorder(Rectangle.BOTTOM);
            table.addCell(sttCell);
            
            PdfPCell labelCell = new PdfPCell(new Phrase(dataLabels[i], dataFont));
            labelCell.setPadding(8);
            labelCell.setBackgroundColor(bgColor);
            labelCell.setBorder(Rectangle.BOTTOM);
            table.addCell(labelCell);
            
            PdfPCell valueCell = new PdfPCell(new Phrase(String.valueOf(dataValues[i]), dataFont));
            valueCell.setPadding(8);
            valueCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            valueCell.setBackgroundColor(bgColor);
            valueCell.setBorder(Rectangle.BOTTOM);
            table.addCell(valueCell);
            
            double rate = total > 0 ? dataValues[i] * 100.0 / total : 0;
            PdfPCell rateCell = new PdfPCell(new Phrase(String.format("%.1f%%", rate), dataFont));
            rateCell.setPadding(8);
            rateCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            rateCell.setBackgroundColor(bgColor);
            rateCell.setBorder(Rectangle.BOTTOM);
            table.addCell(rateCell);
        }
        
        document.add(table);
    }
    
    /**
     * Header and Footer event handler
     */
    static class HeaderFooter extends PdfPageEventHelper {
        Font footerFont = FontFactory.getFont(FontFactory.TIMES_ROMAN, 9, Font.ITALIC, BaseColor.GRAY);
        
        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            PdfContentByte cb = writer.getDirectContent();
            
            // Footer
            Phrase footer = new Phrase("Phòng Khám Đa Khoa JVCare - Trang " + writer.getPageNumber(), footerFont);
            ColumnText.showTextAligned(cb, Element.ALIGN_CENTER,
                    footer,
                    (document.right() - document.left()) / 2 + document.leftMargin(),
                    document.bottom() - 10, 0);
        }
    }
}
