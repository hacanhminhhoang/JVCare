<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%
    LocalDate now = LocalDate.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("'Ngày' dd 'tháng' MM 'năm' yyyy");
    String formattedDate = now.format(formatter);
    request.setAttribute("formattedDate", formattedDate);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Lịch Hẹn — Admin JVCare</title>
    <style>
        @media print {
            @page { size: A4; margin: 20mm; }
            body { margin: 0; background: white; }
            .no-print { display: none !important; }
            .document { box-shadow: none; padding: 0; }
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Times New Roman', Times, serif; 
            background: #f5f5f5; 
            padding: 20px;
            color: #000;
            line-height: 1.6;
        }
        .document {
            max-width: 210mm;
            margin: 0 auto;
            background: white;
            padding: 25mm 20mm;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            min-height: 297mm;
        }
        .header-section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            font-size: 13px;
        }
        .header-left, .header-right {
            width: 45%;
            text-align: center;
        }
        .header-left {
            font-weight: bold;
            text-transform: uppercase;
        }
        .header-right {
            font-weight: bold;
            text-transform: uppercase;
        }
        .header-underline {
            display: inline-block;
            border-bottom: 1px solid #000;
            width: 80px;
            margin: 3px 0;
        }
        .title-section {
            text-align: center;
            margin: 40px 0 30px 0;
        }
        .title-main {
            font-size: 18px;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .title-sub {
            font-size: 14px;
            font-style: italic;
            margin-bottom: 5px;
        }
        .content-section {
            margin: 25px 0;
        }
        .section-title {
            font-size: 15px;
            font-weight: bold;
            margin: 20px 0 10px 0;
            text-transform: uppercase;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
            font-size: 13px;
        }
        th, td {
            border: 1px solid #000;
            padding: 8px 10px;
            text-align: left;
        }
        th {
            background: #f0f0f0;
            font-weight: bold;
            text-align: center;
        }
        td.number {
            text-align: center;
        }
        td.right {
            text-align: right;
        }
        .total-row {
            font-weight: bold;
            background: #e8e8e8;
        }
        .summary-box {
            margin: 20px 0;
            padding: 15px;
            border: 1px solid #000;
            background: #fafafa;
        }
        .summary-item {
            margin: 8px 0;
            font-size: 14px;
        }
        .summary-item strong {
            display: inline-block;
            width: 200px;
        }
        .signatures {
            display: flex;
            justify-content: space-between;
            margin-top: 50px;
            page-break-inside: avoid;
        }
        .signature-box {
            width: 45%;
            text-align: center;
            font-size: 13px;
        }
        .sign-title {
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .sign-subtitle {
            font-style: italic;
            font-size: 12px;
            margin-bottom: 60px;
        }
        .sign-name {
            font-weight: bold;
        }
        .stamp {
            color: #c00;
            border: 2px solid #c00;
            border-radius: 50%;
            padding: 15px;
            display: inline-block;
            font-size: 11px;
            font-weight: bold;
            transform: rotate(-15deg);
            margin: -50px 0 10px 0;
            line-height: 1.3;
        }
        .btn-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .btn {
            background: #2563eb;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-family: Arial, sans-serif;
            margin: 0 5px;
        }
        .btn:hover {
            background: #1d4ed8;
        }
        .btn-secondary {
            background: #6b7280;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
    </style>
</head>
<body>
    <div class="no-print btn-container">
        <button class="btn" onclick="window.print()">
            <i class="fas fa-print"></i> In / Lưu PDF
        </button>
        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-secondary" style="text-decoration: none; display: inline-block;">
            <i class="fas fa-arrow-left"></i> Trở về
        </a>
    </div>

    <div class="document">
        <!-- Header chính thức -->
        <div class="header-section">
            <div class="header-left">
                PHÒNG KHÁM ĐA KHOA JVCARE<br>
                <span class="header-underline"></span>
            </div>
            <div class="header-right">
                CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM<br>
                Độc lập - Tự do - Hạnh phúc<br>
                <span class="header-underline"></span>
            </div>
        </div>

        <!-- Tiêu đề -->
        <div class="title-section">
            <div class="title-main">BÁO CÁO THỐNG KÊ LỊCH HẸN</div>
            <div class="title-sub">${formattedDate}</div>
        </div>

        <!-- Tóm tắt -->
        <div class="summary-box">
            <div class="section-title">I. TỔNG QUAN</div>
            <c:set var="total" value="0"/>
            <c:forEach var="entry" items="${appointmentStats}">
                <c:set var="total" value="${total + entry.value}"/>
            </c:forEach>
            <div class="summary-item">
                <strong>Tổng số lịch hẹn:</strong> ${total} lịch hẹn
            </div>
            <div class="summary-item">
                <strong>Chờ xử lý:</strong> ${appointmentStats['PENDING'] != null ? appointmentStats['PENDING'] : 0} lịch hẹn
            </div>
            <div class="summary-item">
                <strong>Đã xác nhận:</strong> ${appointmentStats['CONFIRMED'] != null ? appointmentStats['CONFIRMED'] : 0} lịch hẹn
            </div>
            <div class="summary-item">
                <strong>Hoàn thành:</strong> ${appointmentStats['COMPLETED'] != null ? appointmentStats['COMPLETED'] : 0} lịch hẹn
            </div>
            <div class="summary-item">
                <strong>Đã hủy:</strong> ${appointmentStats['CANCELLED'] != null ? appointmentStats['CANCELLED'] : 0} lịch hẹn
            </div>
            <c:if test="${total > 0}">
                <div class="summary-item">
                    <strong>Tỷ lệ hoàn thành:</strong> 
                    <c:set var="completed" value="${appointmentStats['COMPLETED'] != null ? appointmentStats['COMPLETED'] : 0}"/>
                    <c:set var="completionRate" value="${completed * 100.0 / total}"/>
                    <fmt:formatNumber value="${completionRate}" pattern="0.0" minFractionDigits="1" maxFractionDigits="1"/>%
                </div>
            </c:if>
        </div>

        <!-- Bảng chi tiết theo trạng thái -->
        <div class="content-section">
            <div class="section-title">II. THỐNG KÊ THEO TRẠNG THÁI</div>
            <table>
                <thead>
                    <tr>
                        <th style="width: 10%;">STT</th>
                        <th style="width: 50%;">Trạng Thái</th>
                        <th style="width: 20%;">Số Lượng</th>
                        <th style="width: 20%;">Tỷ Lệ (%)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="stt" value="1"/>
                    <c:forEach var="entry" items="${appointmentStats}">
                        <tr>
                            <td class="number">${stt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${entry.key == 'PENDING'}">Chờ xử lý</c:when>
                                    <c:when test="${entry.key == 'CONFIRMED'}">Đã xác nhận</c:when>
                                    <c:when test="${entry.key == 'COMPLETED'}">Hoàn thành</c:when>
                                    <c:when test="${entry.key == 'CANCELLED'}">Đã hủy</c:when>
                                    <c:otherwise>${entry.key}</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="number">${entry.value}</td>
                            <td class="number">
                                <c:choose>
                                    <c:when test="${total > 0}">
                                        <c:set var="rate" value="${entry.value * 100.0 / total}"/>
                                        <fmt:formatNumber value="${rate}" pattern="0.0" minFractionDigits="1" maxFractionDigits="1"/>%
                                    </c:when>
                                    <c:otherwise>0.0%</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <c:set var="stt" value="${stt + 1}"/>
                    </c:forEach>
                    <tr class="total-row">
                        <td colspan="2" style="text-align: center;">TỔNG CỘNG</td>
                        <td class="number">${total}</td>
                        <td class="number">100.0%</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Bảng theo tháng -->
        <div class="content-section">
            <div class="section-title">III. THỐNG KÊ THEO THÁNG (NĂM ${currentYear})</div>
            <table>
                <thead>
                    <tr>
                        <th style="width: 15%;">Tháng</th>
                        <th style="width: 20%;">Số Lượng</th>
                        <th style="width: 65%;">Ghi Chú</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="i" begin="1" end="12">
                        <tr>
                            <td class="number">Tháng ${i}</td>
                            <td class="number">${empty monthlyStats[i] ? 0 : monthlyStats[i]}</td>
                            <td></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Chữ ký -->
        <div class="signatures">
            <div class="signature-box">
                <div class="sign-title">NGƯỜI LẬP BIỂU</div>
                <div class="sign-subtitle">(Ký, ghi rõ họ tên)</div>
                <div class="sign-name">Admin JVCare</div>
            </div>
            <div class="signature-box">
                <div class="sign-title">GIÁM ĐỐC</div>
                <div class="sign-subtitle">(Ký, đóng dấu, ghi rõ họ tên)</div>
                <div class="stamp">
                    PHÒNG KHÁM<br>
                    ĐA KHOA<br>
                    JVCARE
                </div>
                <div class="sign-name">BS. Nguyễn Văn A</div>
            </div>
        </div>
        </div>
    </div>
</body>
</html>
