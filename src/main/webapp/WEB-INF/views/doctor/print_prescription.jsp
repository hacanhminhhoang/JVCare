<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn thuốc #${record.recordId} - JVCare</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Serif:wght@400;700&family=Manrope:wght@400;500;600&display=swap');

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Manrope', sans-serif;
            font-size: 13px;
            color: #1a1a2e;
            background: #f5f5f5;
            padding: 20px;
        }

        .print-container {
            max-width: 780px;
            margin: 0 auto;
            background: white;
            padding: 40px 50px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        /* ===== HEADER ===== */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 3px solid #1a237e;
            padding-bottom: 16px;
            margin-bottom: 20px;
        }
        .hospital-info h1 {
            font-family: 'Noto Serif', serif;
            font-size: 18px;
            color: #1a237e;
            font-weight: 700;
        }
        .hospital-info p { font-size: 11px; color: #555; margin-top: 2px; }
        .logo-area {
            text-align: right;
            font-size: 11px;
            color: #555;
        }
        .logo-area .doc-no {
            font-weight: 600;
            color: #1a237e;
            font-size: 13px;
        }

        /* ===== TITLE ===== */
        .prescription-title {
            text-align: center;
            margin: 18px 0 20px;
        }
        .prescription-title h2 {
            font-family: 'Noto Serif', serif;
            font-size: 22px;
            font-weight: 700;
            color: #1a237e;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .prescription-title p { font-size: 12px; color: #555; margin-top: 4px; }

        /* ===== PATIENT / DOCTOR INFO ===== */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px 30px;
            background: #f0f4ff;
            border-radius: 8px;
            padding: 14px 18px;
            margin-bottom: 20px;
            border: 1px solid #c5cae9;
        }
        .info-row { display: flex; gap: 6px; }
        .info-label { font-weight: 600; color: #1a237e; min-width: 100px; font-size: 12px; }
        .info-value { color: #333; font-size: 12px; }

        /* ===== VITAL SIGNS ===== */
        .vital-signs {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 8px;
            margin-bottom: 20px;
        }
        .vital-box {
            text-align: center;
            padding: 10px 8px;
            background: #fff;
            border: 1.5px solid #c5cae9;
            border-radius: 8px;
        }
        .vital-value {
            font-size: 16px;
            font-weight: 700;
            color: #1a237e;
        }
        .vital-label { font-size: 10px; color: #666; margin-top: 3px; }

        /* ===== DIAGNOSIS ===== */
        .section { margin-bottom: 18px; }
        .section-title {
            font-weight: 700;
            font-size: 12px;
            color: #1a237e;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            border-bottom: 1px solid #c5cae9;
            padding-bottom: 4px;
            margin-bottom: 8px;
        }
        .section-content {
            font-size: 13px;
            color: #333;
            line-height: 1.6;
        }

        /* ===== PRESCRIPTION TABLE ===== */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 16px;
        }
        thead th {
            background: #1a237e;
            color: white;
            padding: 8px 10px;
            text-align: left;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        tbody tr:nth-child(even) { background: #f0f4ff; }
        tbody td {
            padding: 8px 10px;
            border-bottom: 1px solid #e8eaf6;
            font-size: 12px;
            color: #333;
            vertical-align: top;
        }
        tbody tr:last-child td { border-bottom: none; }
        .no-prescription {
            text-align: center;
            color: #888;
            padding: 20px;
            font-style: italic;
        }

        /* ===== SIGNATURES ===== */
        .signatures {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px dashed #c5cae9;
        }
        .sig-box { text-align: center; }
        .sig-title { font-weight: 600; font-size: 12px; color: #333; margin-bottom: 40px; }
        .sig-name { font-weight: 700; font-size: 13px; border-top: 1px solid #333; padding-top: 4px; display: inline-block; min-width: 150px; }

        /* ===== FOOTER ===== */
        .print-footer {
            margin-top: 20px;
            padding-top: 10px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            font-size: 10px;
            color: #999;
        }

        /* ===== PRINT BUTTON ===== */
        .no-print {
            text-align: center;
            margin-bottom: 20px;
        }
        .btn-print {
            background: #1a237e;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn-back {
            background: #f5f5f5;
            color: #333;
            border: 1px solid #ddd;
            padding: 12px 30px;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        @media print {
            body { background: white; padding: 0; }
            .print-container { box-shadow: none; padding: 20px; }
            .no-print { display: none; }
        }
    </style>
</head>
<body>

    <div class="no-print">
        <button class="btn-print" onclick="window.print()">🖨️ In đơn thuốc</button>
        <a href="${pageContext.request.contextPath}/doctor/medical-records?action=detail&id=${record.recordId}"
           class="btn-back">← Quay lại bệnh án</a>
    </div>

    <div class="print-container">

        <!-- HEADER -->
        <div class="header">
            <div class="hospital-info">
                <h1>🏥 JVCare Medical Center</h1>
                <p>Hệ thống Quản lý Bệnh án Điện tử</p>
                <p>Hotline: 1900-1234 | Email: contact@jvcare.com</p>
            </div>
            <div class="logo-area">
                <p>Ngày in: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/></p>
                <p class="doc-no">Mã bệnh án: #${record.recordId}</p>
            </div>
        </div>

        <!-- TITLE -->
        <div class="prescription-title">
            <h2>Đơn Thuốc</h2>
            <p>Ngày khám: <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy"/></p>
        </div>

        <!-- PATIENT / DOCTOR INFO -->
        <div class="info-grid">
            <div class="info-row">
                <span class="info-label">Mã bệnh nhân:</span>
                <span class="info-value">${record.patientCode}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Họ và tên:</span>
                <span class="info-value">${record.patientName}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Bác sĩ điều trị:</span>
                <span class="info-value">${record.doctorName}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Ngày khám:</span>
                <span class="info-value"><fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy HH:mm"/></span>
            </div>
        </div>

        <!-- VITAL SIGNS -->
        <c:if test="${record.bloodPressure != null or record.heartRate > 0 or record.temperature > 0 or record.weight > 0 or record.height > 0}">
        <div class="vital-signs">
            <div class="vital-box">
                <div class="vital-value">${not empty record.bloodPressure ? record.bloodPressure : '—'}</div>
                <div class="vital-label">Huyết áp (mmHg)</div>
            </div>
            <div class="vital-box">
                <div class="vital-value">${record.heartRate > 0 ? record.heartRate : '—'}</div>
                <div class="vital-label">Nhịp tim (bpm)</div>
            </div>
            <div class="vital-box">
                <div class="vital-value">${record.temperature > 0 ? record.temperature : '—'}${record.temperature > 0 ? '°C' : ''}</div>
                <div class="vital-label">Nhiệt độ</div>
            </div>
            <div class="vital-box">
                <div class="vital-value">${record.weight > 0 ? record.weight : '—'}${record.weight > 0 ? 'kg' : ''}</div>
                <div class="vital-label">Cân nặng</div>
            </div>
            <div class="vital-box">
                <div class="vital-value">${record.height > 0 ? record.height : '—'}${record.height > 0 ? 'cm' : ''}</div>
                <div class="vital-label">Chiều cao</div>
            </div>
        </div>
        </c:if>

        <!-- DIAGNOSIS -->
        <div class="section">
            <div class="section-title">Chẩn đoán</div>
            <div class="section-content">${record.diagnosis}</div>
        </div>

        <c:if test="${not empty record.treatmentPlan}">
        <div class="section">
            <div class="section-title">Phương án điều trị</div>
            <div class="section-content">${record.treatmentPlan}</div>
        </div>
        </c:if>

        <!-- PRESCRIPTIONS TABLE -->
        <div class="section">
            <div class="section-title">Danh sách thuốc được kê</div>
            <c:choose>
                <c:when test="${not empty prescriptions}">
                    <table>
                        <thead>
                            <tr>
                                <th style="width:30px">STT</th>
                                <th>Tên thuốc</th>
                                <th>Liều lượng</th>
                                <th>Tần suất</th>
                                <th>Số ngày</th>
                                <th>Hướng dẫn sử dụng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${prescriptions}" varStatus="st">
                                <tr>
                                    <td style="text-align:center">${st.index + 1}</td>
                                    <td><strong>${p.medicationName}</strong></td>
                                    <td>${p.dosage}</td>
                                    <td>${p.frequency}</td>
                                    <td style="text-align:center">${p.durationDays} ngày</td>
                                    <td>${not empty p.instructions ? p.instructions : '—'}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="no-prescription">Chưa có thuốc nào được kê trong đơn này.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- NOTES -->
        <c:if test="${not empty record.notes}">
        <div class="section">
            <div class="section-title">Lưu ý đặc biệt</div>
            <div class="section-content">${record.notes}</div>
        </div>
        </c:if>

        <!-- SIGNATURES -->
        <div class="signatures">
            <div class="sig-box">
                <div class="sig-title">Bệnh nhân / Người nhà ký</div>
                <div class="sig-name">${record.patientName}</div>
            </div>
            <div class="sig-box">
                <div class="sig-title">Bác sĩ kê đơn</div>
                <div class="sig-name">${record.doctorName}</div>
            </div>
        </div>

        <!-- FOOTER -->
        <div class="print-footer">
            Đơn thuốc này có giá trị trong vòng 30 ngày kể từ ngày kê. JVCare Medical Center © 2026
        </div>

    </div>

</body>
</html>
