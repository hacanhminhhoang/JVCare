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
    <title>Báo Cáo Hiệu Suất Bác Sĩ — Admin JVCare</title>
    <style>
        @media print {
            @page { size: A4 landscape; margin: 15mm; }
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
            max-width: 297mm;
            margin: 0 auto;
            background: white;
            padding: 20mm 15mm;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            min-height: 210mm;
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
            margin: 30px 0 25px 0;
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
            width: 250px;
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
            <div class="title-main">BÁO CÁO HIỆU SUẤT BÁC SĨ</div>
            <div class="title-sub">${formattedDate}</div>
        </div>

        <!-- Tóm tắt -->
        <c:set var="totalDoctors" value="${doctorPerformance.size()}"/>
        <c:set var="totalAppts" value="0"/>
        <c:set var="totalRecs" value="0"/>
        <c:forEach var="doc" items="${doctorPerformance}">
            <c:set var="totalAppts" value="${totalAppts + doc.totalAppointments}"/>
            <c:set var="totalRecs" value="${totalRecs + doc.totalRecords}"/>
        </c:forEach>
        
        <div class="summary-box">
            <div class="section-title">I. TỔNG QUAN</div>
            <div class="summary-item">
                <strong>Tổng số bác sĩ:</strong> ${totalDoctors} người
            </div>
            <div class="summary-item">
                <strong>Tổng số lịch hẹn:</strong> ${totalAppts} lịch hẹn
            </div>
            <div class="summary-item">
                <strong>Tổng số bệnh án:</strong> ${totalRecs} bệnh án
            </div>
            <c:if test="${totalDoctors > 0}">
                <div class="summary-item">
                    <strong>Trung bình lịch hẹn/bác sĩ:</strong> 
                    <c:set var="avgAppts" value="${totalAppts * 1.0 / totalDoctors}"/>
                    <fmt:formatNumber value="${avgAppts}" pattern="0.0" minFractionDigits="1" maxFractionDigits="1"/> lịch hẹn
                </div>
                <div class="summary-item">
                    <strong>Trung bình bệnh án/bác sĩ:</strong> 
                    <c:set var="avgRecs" value="${totalRecs * 1.0 / totalDoctors}"/>
                    <fmt:formatNumber value="${avgRecs}" pattern="0.0" minFractionDigits="1" maxFractionDigits="1"/> bệnh án
                </div>
            </c:if>
        </div>

        <!-- Bảng chi tiết -->
        <div class="content-section">
            <div class="section-title">II. CHI TIẾT HIỆU SUẤT TỪNG BÁC SĨ</div>
            <table>
                <thead>
                    <tr>
                        <th style="width: 8%;">STT</th>
                        <th style="width: 30%;">Họ và Tên</th>
                        <th style="width: 25%;">Chuyên Khoa</th>
                        <th style="width: 15%;">Tổng Lịch Hẹn</th>
                        <th style="width: 15%;">Tổng Bệnh Án</th>
                        <th style="width: 7%;">Xếp Hạng</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="doc" items="${doctorPerformance}" varStatus="status">
                        <tr>
                            <td class="number">${status.count}</td>
                            <td>${doc.fullName}</td>
                            <td>${doc.specialization}</td>
                            <td class="number">${doc.totalAppointments}</td>
                            <td class="number">${doc.totalRecords}</td>
                            <td class="number">
                                <c:choose>
                                    <c:when test="${status.count == 1}">⭐⭐⭐</c:when>
                                    <c:when test="${status.count == 2}">⭐⭐</c:when>
                                    <c:when test="${status.count == 3}">⭐</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty doctorPerformance}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 20px;">Chưa có dữ liệu thống kê.</td>
                        </tr>
                    </c:if>
                    <c:if test="${not empty doctorPerformance}">
                        <tr class="total-row">
                            <td colspan="3" style="text-align: center;">TỔNG CỘNG</td>
                            <td class="number">${totalAppts}</td>
                            <td class="number">${totalRecs}</td>
                            <td class="number">-</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Nhận xét -->
        <div class="content-section">
            <div class="section-title">III. NHẬN XÉT VÀ ĐÁNH GIÁ</div>
            <table>
                <thead>
                    <tr>
                        <th>Nội Dung</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="height: 80px; vertical-align: top; padding: 10px;">
                            <c:if test="${not empty doctorPerformance}">
                                - Đội ngũ bác sĩ hoạt động hiệu quả với tổng ${totalAppts} lịch hẹn và ${totalRecs} bệnh án<br>
                                <c:set var="avgAppts" value="${totalAppts * 1.0 / totalDoctors}"/>
                                - Trung bình mỗi bác sĩ phụ trách <fmt:formatNumber value="${avgAppts}" pattern="0.0" minFractionDigits="1" maxFractionDigits="1"/> lịch hẹn<br>
                                - Cần tiếp tục duy trì và nâng cao chất lượng dịch vụ khám chữa bệnh
                            </c:if>
                            <c:if test="${empty doctorPerformance}">
                                - Chưa có dữ liệu thống kê hiệu suất bác sĩ
                            </c:if>
                        </td>
                    </tr>
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
</body>
</html>
