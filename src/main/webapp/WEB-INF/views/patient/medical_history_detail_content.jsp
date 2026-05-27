<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <%--=====PRINT STYLES: Only show when printing=====--%>
                <style>
                    @media print {

                        /* 1. PHÁ VỠ MỌI GIỚI HẠN CHIỀU CAO & THANH CUỘN CỦA TẤT CẢ THẺ CHA BÊN NGOÀI */
                        html,
                        body,
                        main,
                        #app,
                        .wrapper,
                        div:not(#print-document):not(#print-document *) {
                            height: auto !important;
                            min-height: 0 !important;
                            max-height: none !important;
                            overflow: visible !important;
                            position: static !important;
                        }

                        /* 2. ẨN GIAO DIỆN WEB */
                        .no-print-wrapper,
                        aside,
                        header,
                        nav,
                        footer {
                            display: none !important;
                        }

                        /* 3. TÁCH BẢN IN RA KHỎI LAYOUT VÀ CHO PHÉP TRÀN TRANG */
                        #print-document {
                            display: block !important;
                            position: absolute !important;
                            /* Giúp bản in thoát khỏi mọi flexbox/grid của thẻ cha */
                            top: 0 !important;
                            left: 0 !important;
                            width: 100% !important;
                            height: auto !important;
                            margin: 0 !important;
                            padding: 0 !important;
                            overflow: visible !important;
                        }

                        @page {
                            size: A4;
                            margin: 15mm 18mm 15mm 25mm;
                        }
                    }

                    @media screen {
                        #print-document {
                            display: none;
                        }
                    }
                </style>

                <%--=====PRINT DOCUMENT (hidden on screen, shown when printing)=====--%>
                    <div id="print-document">
                        <style>
                            #print-document * {
                                box-sizing: border-box;
                            }

                            #print-document .doc-page {
                                font-family: 'Times New Roman', Times, serif;
                                font-size: 13pt;
                                color: #000;
                                background: #fff;
                                padding: 0;
                            }

                            /* Hospital header */
                            #print-document .hosp-header {
                                display: flex;
                                justify-content: space-between;
                                align-items: flex-start;
                                border-bottom: 2px solid #000;
                                padding-bottom: 8px;
                                margin-bottom: 6px;
                            }

                            #print-document .hosp-left {
                                text-align: center;
                                width: 50%;
                            }

                            #print-document .hosp-right {
                                text-align: center;
                                width: 50%;
                            }

                            #print-document .hosp-name {
                                font-size: 13pt;
                                font-weight: bold;
                                text-transform: uppercase;
                            }

                            #print-document .hosp-sub {
                                font-size: 10pt;
                            }

                            #print-document .doc-title {
                                text-align: center;
                                margin: 14px 0 4px;
                            }

                            #print-document .doc-title h2 {
                                font-size: 17pt;
                                font-weight: bold;
                                text-transform: uppercase;
                                letter-spacing: 1px;
                            }

                            #print-document .doc-title p {
                                font-size: 11pt;
                                margin: 2px 0;
                            }

                            #print-document .doc-meta {
                                display: flex;
                                justify-content: space-between;
                                font-size: 11pt;
                                border-top: 1px solid #888;
                                border-bottom: 1px solid #888;
                                padding: 4px 0;
                                margin: 10px 0;
                            }

                            /* Section label */
                            #print-document .section-title {
                                font-size: 12pt;
                                font-weight: bold;
                                text-transform: uppercase;
                                border-bottom: 1px solid #000;
                                padding-bottom: 3px;
                                margin: 14px 0 8px;
                                letter-spacing: 0.5px;
                            }

                            /* Field row */
                            #print-document .field-row {
                                display: flex;
                                margin-bottom: 7px;
                                font-size: 12pt;
                                line-height: 1.5;
                            }

                            #print-document .field-label {
                                font-weight: bold;
                                min-width: 180px;
                                flex-shrink: 0;
                            }

                            #print-document .field-value {
                                border-bottom: 1px dotted #555;
                                flex: 1;
                                padding-bottom: 1px;
                            }

                            #print-document .field-value.no-border {
                                border-bottom: none;
                            }

                            /* Two-col layout */
                            #print-document .two-col {
                                display: flex;
                                gap: 20px;
                            }

                            #print-document .two-col>div {
                                flex: 1;
                            }

                            /* Vitals grid */
                            #print-document .vitals-grid {
                                display: grid;
                                grid-template-columns: 1fr 1fr 1fr;
                                gap: 8px 16px;
                                margin-bottom: 8px;
                            }

                            #print-document .vital-item {
                                font-size: 11.5pt;
                            }

                            #print-document .vital-item .v-label {
                                font-weight: bold;
                                font-size: 10.5pt;
                                color: #333;
                            }

                            #print-document .vital-item .v-value {
                                border-bottom: 1px dotted #555;
                                padding-bottom: 1px;
                                display: block;
                            }

                            /* Prescription table */
                            #print-document .rx-table {
                                width: 100%;
                                border-collapse: collapse;
                                font-size: 11.5pt;
                                margin-top: 6px;
                            }

                            #print-document .rx-table th {
                                background: #f0f0f0;
                                border: 1px solid #888;
                                padding: 5px 8px;
                                font-weight: bold;
                                text-align: left;
                                font-size: 11pt;
                            }

                            #print-document .rx-table td {
                                border: 1px solid #bbb;
                                padding: 5px 8px;
                                vertical-align: top;
                            }

                            #print-document .rx-table tr:nth-child(even) td {
                                background: #fafafa;
                            }

                            /* Signature block */
                            #print-document .signature-block {
                                display: flex;
                                justify-content: space-between;
                                margin-top: 36px;
                            }

                            #print-document .sig-box {
                                text-align: center;
                                width: 42%;
                                font-size: 11pt;
                            }

                            #print-document .sig-box .sig-title {
                                font-weight: bold;
                            }

                            #print-document .sig-box .sig-note {
                                font-size: 10pt;
                                font-style: italic;
                                color: #555;
                                margin-top: 2px;
                            }

                            #print-document .sig-line {
                                border-top: 1px solid #000;
                                margin-top: 50px;
                                padding-top: 4px;
                            }

                            /* Footer */
                            #print-document .doc-footer {
                                margin-top: 20px;
                                border-top: 1px solid #bbb;
                                padding-top: 6px;
                                font-size: 9.5pt;
                                color: #555;
                                text-align: center;
                            }

                            /* Content box (multiline) */
                            #print-document .content-box {
                                border: 1px solid #bbb;
                                padding: 7px 10px;
                                min-height: 48px;
                                font-size: 12pt;
                                line-height: 1.6;
                                margin-bottom: 8px;
                                white-space: pre-line;
                            }

                            #print-document .bmi-badge {
                                display: inline-block;
                                border: 1px solid #000;
                                padding: 2px 10px;
                                font-weight: bold;
                                font-size: 12pt;
                            }
                        </style>

                        <div class="doc-page">
                            <!-- Hospital Header -->
                            <div class="hosp-header">
                                <div class="hosp-left">
                                    <div class="hosp-name">Hệ Thống Y Tế JVCare</div>
                                    <div class="hosp-sub">Địa chỉ: 123 Đường Y Tế, TP. Hồ Chí Minh</div>
                                    <div class="hosp-sub">ĐT: (028) 1234-5678 &nbsp;|&nbsp; Email: info@jvcare.vn</div>
                                </div>
                                <div class="hosp-right">
                                    <div style="font-size:10pt;">Mã bệnh án:</div>
                                    <div
                                        style="font-size:14pt; font-weight:bold; font-family:monospace; border:1px solid #000; padding:2px 10px; display:inline-block;">
                                        <c:out value="${record.recordCode}" default="REC-N/A" />
                                    </div>
                                    <div style="font-size:10pt; margin-top:4px;">Ngày khám:
                                        <strong>
                                            <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy" />
                                        </strong>
                                    </div>
                                    <div style="font-size:9.5pt; color:#555;">Ngày in: <%=(new
                                            java.text.SimpleDateFormat("dd/MM/yyyy HH:mm")).format(new
                                            java.util.Date())%>
                                    </div>
                                </div>
                            </div>

                            <!-- Document Title -->
                            <div class="doc-title">
                                <h2>Phiếu Khám Bệnh</h2>
                                <p><em>Hệ thống quản lý bệnh án điện tử JVCare</em></p>
                            </div>

                            <!-- Patient Info -->
                            <div class="section-title">I. Thông Tin Bệnh Nhân</div>
                            <div class="two-col">
                                <div>
                                    <div class="field-row">
                                        <span class="field-label">Họ và tên:</span>
                                        <span class="field-value">
                                            <c:out value="${record.patientName}" default="—" />
                                        </span>
                                    </div>
                                    <div class="field-row">
                                        <span class="field-label">Mã bệnh nhân:</span>
                                        <span class="field-value">
                                            <c:out value="${record.patientCode}" default="—" />
                                        </span>
                                    </div>
                                </div>
                                <div>
                                    <div class="field-row">
                                        <span class="field-label">Bác sĩ phụ trách:</span>
                                        <span class="field-value">
                                            <c:out value="${record.doctorName}" default="—" />
                                        </span>
                                    </div>
                                    <div class="field-row">
                                        <span class="field-label">Giờ khám:</span>
                                        <span class="field-value">
                                            <fmt:formatDate value="${record.visitDate}" pattern="HH:mm" /> ngày
                                            <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy" />
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Vital Signs -->
                            <div class="section-title">II. Chỉ Số Sinh Tồn</div>
                            <div class="vitals-grid">
                                <div class="vital-item">
                                    <div class="v-label">Huyết áp (mmHg)</div>
                                    <span class="v-value">
                                        <c:out value="${record.bloodPressure}" default="—" />
                                    </span>
                                </div>
                                <div class="vital-item">
                                    <div class="v-label">Nhịp tim (bpm)</div>
                                    <span class="v-value">
                                        <c:choose>
                                            <c:when test="${record.heartRate > 0}">${record.heartRate}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="vital-item">
                                    <div class="v-label">Nhiệt độ (°C)</div>
                                    <span class="v-value">
                                        <c:choose>
                                            <c:when test="${record.temperature > 0}">${record.temperature}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="vital-item">
                                    <div class="v-label">Chiều cao (cm)</div>
                                    <span class="v-value">
                                        <c:choose>
                                            <c:when test="${record.height > 0}">${record.height}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="vital-item">
                                    <div class="v-label">Cân nặng (kg)</div>
                                    <span class="v-value">
                                        <c:choose>
                                            <c:when test="${record.weight > 0}">${record.weight}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="vital-item">
                                    <div class="v-label">Chỉ số BMI</div>
                                    <span class="v-value">
                                        <c:choose>
                                            <c:when test="${record.bmi > 0}">
                                                ${record.bmi}
                                                (<c:choose>
                                                    <c:when test="${record.bmi < 18.5}">Gầy</c:when>
                                                    <c:when test="${record.bmi >= 18.5 && record.bmi < 24.9}">Bình
                                                        thường</c:when>
                                                    <c:when test="${record.bmi >= 25 && record.bmi < 29.9}">Thừa cân
                                                    </c:when>
                                                    <c:otherwise>Béo phì</c:otherwise>
                                                </c:choose>)
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- Clinical Information -->
                            <div class="section-title">III. Thông Tin Lâm Sàng</div>

                            <div class="field-row">
                                <span class="field-label">Lý do khám / Triệu chứng chính:</span>
                            </div>
                            <div class="content-box">
                                <c:out value="${record.chiefComplaint}" default="—" />
                            </div>

                            <div class="field-row" style="margin-top:10px;">
                                <span class="field-label">Chẩn đoán y tế:</span>
                            </div>
                            <div class="content-box" style="font-weight:bold; border:2px solid #000;">
                                <c:out value="${record.diagnosis}" default="—" />
                            </div>

                            <div class="field-row" style="margin-top:10px;">
                                <span class="field-label">Hướng điều trị / Dặn dò của bác sĩ:</span>
                            </div>
                            <div class="content-box">
                                <c:out value="${record.treatmentPlan}" default="—" />
                            </div>

                            <c:if test="${not empty record.notes}">
                                <div class="field-row" style="margin-top:10px;">
                                    <span class="field-label">Ghi chú bổ sung:</span>
                                </div>
                                <div class="content-box" style="font-style:italic; color:#333;">
                                    <c:out value="${record.notes}" />
                                </div>
                            </c:if>

                            <!-- Prescriptions -->
                            <div class="section-title">IV. Đơn Thuốc</div>
                            <c:choose>
                                <c:when test="${empty record.prescriptions}">
                                    <p style="font-style:italic; font-size:11.5pt; padding: 8px 0;">Không có đơn thuốc
                                        nào được kê trong lần khám này.</p>
                                </c:when>
                                <c:otherwise>
                                    <table class="rx-table">
                                        <thead>
                                            <tr>
                                                <th style="width:5%;">STT</th>
                                                <th style="width:28%;">Tên thuốc</th>
                                                <th style="width:14%;">Liều lượng</th>
                                                <th style="width:16%;">Tần suất dùng</th>
                                                <th style="width:10%;">Số ngày</th>
                                                <th>Hướng dẫn sử dụng</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="pres" items="${record.prescriptions}" varStatus="st">
                                                <tr>
                                                    <td style="text-align:center;">${st.count}</td>
                                                    <td><strong>
                                                            <c:out value="${pres.medicationName}" />
                                                        </strong></td>
                                                    <td>
                                                        <c:out value="${pres.dosage}" default="—" />
                                                    </td>
                                                    <td>
                                                        <c:out value="${pres.frequency}" default="—" />
                                                    </td>
                                                    <td style="text-align:center;">
                                                        <c:out value="${pres.durationDays}" default="—" /> ngày
                                                    </td>
                                                    <td>
                                                        <c:out value="${pres.instructions}" default="—" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>

                            <!-- Signature Block -->
                            <div class="signature-block">
                                <div class="sig-box">
                                    <div class="sig-title">Bệnh nhân</div>
                                    <div class="sig-note">(Ký và ghi rõ họ tên)</div>
                                    <div class="sig-line">
                                        <c:out value="${record.patientName}" default="" />
                                    </div>
                                </div>
                                <div class="sig-box">
                                    <div class="sig-title">Bác sĩ điều trị</div>
                                    <div class="sig-note">(Ký, ghi rõ họ tên và đóng dấu)</div>
                                    <div class="sig-line">
                                        <c:out value="${record.doctorName}" default="" />
                                    </div>
                                </div>
                            </div>

                            <!-- Footer -->
                            <div class="doc-footer">
                                Phiếu này được tạo tự động bởi Hệ thống Quản lý Bệnh án JVCare &mdash; Chỉ có giá trị
                                tham khảo khi có chữ ký và con dấu hợp lệ.
                                &nbsp;|&nbsp; Mã:
                                <c:out value="${record.recordCode}" default="N/A" /> &nbsp;|&nbsp;
                                In ngày: <%=(new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm")).format(new
                                    java.util.Date())%>
                            </div>
                        </div>
                    </div>

                    <%--=====SCREEN VIEW (normal web UI, hidden when printing)=====--%>
                        <div class="no-print-wrapper">
                            <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                                <div>
                                    <div class="flex items-center gap-3">
                                        <a href="${pageContext.request.contextPath}/patient/medical-history"
                                            class="inline-flex items-center justify-center h-9 w-9 rounded-xl border border-border bg-white text-muted-foreground hover:text-ink hover:bg-slate-50 transition">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round">
                                                <path d="m15 18-6-6 6-6" />
                                            </svg>
                                        </a>
                                        <h1 class="font-display text-3xl font-bold text-ink">Chi tiết bệnh án</h1>
                                    </div>
                                    <p class="mt-1 text-sm text-muted-foreground ml-12">Mã bệnh án: <span
                                            class="font-mono text-brand font-semibold">
                                            <c:out value="${record.recordCode}" default="REC-N/A" />
                                        </span></p>
                                </div>
                                <div class="flex gap-3 ml-12 md:ml-0">
                                    <button onclick="printMedicalRecord()"
                                        class="inline-flex items-center gap-2 rounded-xl bg-brand px-5 py-2.5 text-sm font-semibold text-white hover:opacity-90 shadow-sm transition">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M6 9V2h12v7" />
                                            <path
                                                d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2" />
                                            <rect width="12" height="8" x="6" y="14" rx="1" ry="1" />
                                        </svg>
                                        Xuất PDF Hồ sơ
                                    </button>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                                <!-- Main details -->
                                <div class="lg:col-span-2 space-y-6">
                                    <!-- Medical details card -->
                                    <div class="bg-white rounded-2xl border border-border/60 p-6 md:p-8 shadow-sm">
                                        <h2
                                            class="font-display text-xl font-bold text-ink mb-6 pb-2 border-b border-border/60">
                                            Thông tin chuyên môn</h2>

                                        <div class="space-y-6">
                                            <div>
                                                <h4
                                                    class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">
                                                    Lý do khám (Triệu chứng chính)</h4>
                                                <p
                                                    class="text-sm text-ink bg-slate-50 rounded-xl p-4 border border-border/40">
                                                    <c:out value="${record.chiefComplaint}" default="—" />
                                                </p>
                                            </div>

                                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                                <div>
                                                    <h4
                                                        class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">
                                                        Bác sĩ khám</h4>
                                                    <div
                                                        class="flex items-center gap-3 bg-slate-50 rounded-xl p-4 border border-border/40">
                                                        <div
                                                            class="h-10 w-10 rounded-full bg-brand-soft text-brand flex items-center justify-center font-bold text-sm">
                                                            BS</div>
                                                        <div>
                                                            <p class="text-sm font-semibold text-ink">
                                                                <c:out value="${record.doctorName}"
                                                                    default="Bác sĩ hệ thống" />
                                                            </p>
                                                            <p class="text-[11px] text-muted-foreground">Đa khoa</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div>
                                                    <h4
                                                        class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">
                                                        Ngày khám bệnh</h4>
                                                    <div
                                                        class="flex items-center gap-3 bg-slate-50 rounded-xl p-4 border border-border/40">
                                                        <div
                                                            class="h-10 w-10 rounded-full bg-cyan-50 text-cyan-600 flex items-center justify-center font-bold text-sm">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="18"
                                                                height="18" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <rect width="18" height="18" x="3" y="4" rx="2"
                                                                    ry="2" />
                                                                <line x1="16" x2="16" y1="2" y2="6" />
                                                                <line x1="8" x2="8" y1="2" y2="6" />
                                                                <line x1="3" x2="21" y1="10" y2="10" />
                                                            </svg>
                                                        </div>
                                                        <div>
                                                            <p class="text-sm font-semibold text-ink">
                                                                <fmt:formatDate value="${record.visitDate}"
                                                                    pattern="dd/MM/yyyy" />
                                                            </p>
                                                            <p class="text-[11px] text-muted-foreground">Vào lúc
                                                                <fmt:formatDate value="${record.visitDate}"
                                                                    pattern="HH:mm" />
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div>
                                                <h4
                                                    class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">
                                                    Chẩn đoán y tế</h4>
                                                <p
                                                    class="text-sm font-bold text-brand bg-brand-soft/30 rounded-xl p-4 border border-brand-soft/50">
                                                    <c:out value="${record.diagnosis}" default="—" />
                                                </p>
                                            </div>

                                            <div>
                                                <h4
                                                    class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">
                                                    Hướng điều trị / Dặn dò của bác sĩ</h4>
                                                <div
                                                    class="text-sm text-ink bg-slate-50 rounded-xl p-4 border border-border/40 whitespace-pre-line">
                                                    <c:out value="${record.treatmentPlan}" default="—" />
                                                </div>
                                            </div>

                                            <c:if test="${not empty record.notes}">
                                                <div>
                                                    <h4
                                                        class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">
                                                        Ghi chú bổ sung</h4>
                                                    <p
                                                        class="text-sm text-muted-foreground bg-slate-50 rounded-xl p-4 border border-border/40">
                                                        <c:out value="${record.notes}" />
                                                    </p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Prescriptions card -->
                                    <div class="bg-white rounded-2xl border border-border/60 p-6 md:p-8 shadow-sm">
                                        <h2
                                            class="font-display text-xl font-bold text-ink mb-6 pb-2 border-b border-border/60 flex items-center gap-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round" class="text-brand">
                                                <path
                                                    d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z">
                                                </path>
                                                <path d="m8.5 8.5 7 7"></path>
                                            </svg>
                                            Đơn thuốc đi kèm
                                        </h2>

                                        <c:choose>
                                            <c:when test="${empty record.prescriptions}">
                                                <p
                                                    class="text-sm text-muted-foreground italic text-center py-4 bg-slate-50 rounded-xl border border-border/40">
                                                    Không có đơn thuốc nào được kê cho lần khám này.</p>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="overflow-x-auto">
                                                    <table class="w-full text-left border-collapse">
                                                        <thead>
                                                            <tr class="border-b border-border/60">
                                                                <th
                                                                    class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                                                                    Tên Thuốc</th>
                                                                <th
                                                                    class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                                                                    Liều lượng</th>
                                                                <th
                                                                    class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                                                                    Tần suất</th>
                                                                <th
                                                                    class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                                                                    Số ngày uống</th>
                                                                <th
                                                                    class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                                                                    Hướng dẫn</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody class="divide-y divide-border/40">
                                                            <c:forEach var="pres" items="${record.prescriptions}">
                                                                <tr class="hover:bg-slate-50/50 transition">
                                                                    <td class="py-3 text-sm font-semibold text-ink">
                                                                        <c:out value="${pres.medicationName}" />
                                                                    </td>
                                                                    <td class="py-3 text-sm text-ink">
                                                                        <c:out value="${pres.dosage}" />
                                                                    </td>
                                                                    <td class="py-3 text-sm text-ink">
                                                                        <c:out value="${pres.frequency}" />
                                                                    </td>
                                                                    <td
                                                                        class="py-3 text-sm text-ink font-semibold text-brand">
                                                                        <c:out value="${pres.durationDays}" /> ngày
                                                                    </td>
                                                                    <td class="py-3 text-sm text-muted-foreground">
                                                                        <c:out value="${pres.instructions}"
                                                                            default="—" />
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Vital signs sidebar -->
                                <div class="lg:col-span-1 space-y-6">
                                    <div class="bg-white rounded-2xl border border-border/60 p-6 shadow-sm">
                                        <h2
                                            class="font-display text-lg font-bold text-ink mb-6 pb-2 border-b border-border/60">
                                            Chỉ số sinh tồn</h2>

                                        <div class="space-y-4">
                                            <div
                                                class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                                                <div class="flex items-center gap-2.5">
                                                    <span
                                                        class="h-8 w-8 rounded-lg bg-rose-50 text-rose-500 flex items-center justify-center">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2" stroke-linecap="round"
                                                            stroke-linejoin="round">
                                                            <path
                                                                d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2z">
                                                            </path>
                                                            <path d="M12 6v6l4 2"></path>
                                                        </svg>
                                                    </span>
                                                    <span class="text-sm font-medium text-ink">Huyết áp</span>
                                                </div>
                                                <span class="text-sm font-bold text-ink">
                                                    <c:out value="${record.bloodPressure}" default="—" /> mmHg
                                                </span>
                                            </div>

                                            <div
                                                class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                                                <div class="flex items-center gap-2.5">
                                                    <span
                                                        class="h-8 w-8 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2" stroke-linecap="round"
                                                            stroke-linejoin="round">
                                                            <path
                                                                d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z" />
                                                        </svg>
                                                    </span>
                                                    <span class="text-sm font-medium text-ink">Nhịp tim</span>
                                                </div>
                                                <span class="text-sm font-bold text-ink">
                                                    <c:choose>
                                                        <c:when test="${record.heartRate > 0}">${record.heartRate} bpm
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <div
                                                class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                                                <div class="flex items-center gap-2.5">
                                                    <span
                                                        class="h-8 w-8 rounded-lg bg-amber-50 text-amber-500 flex items-center justify-center">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2" stroke-linecap="round"
                                                            stroke-linejoin="round">
                                                            <path d="M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z" />
                                                        </svg>
                                                    </span>
                                                    <span class="text-sm font-medium text-ink">Nhiệt độ</span>
                                                </div>
                                                <span class="text-sm font-bold text-ink">
                                                    <c:choose>
                                                        <c:when test="${record.temperature > 0}">${record.temperature}
                                                            °C</c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <div
                                                class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                                                <div class="flex items-center gap-2.5">
                                                    <span
                                                        class="h-8 w-8 rounded-lg bg-blue-50 text-blue-500 flex items-center justify-center">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2" stroke-linecap="round"
                                                            stroke-linejoin="round">
                                                            <path
                                                                d="M21 16V8a2 2 0 0 0-2-2h-5V3a1 1 0 0 0-2 0v3H7a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2Z" />
                                                        </svg>
                                                    </span>
                                                    <span class="text-sm font-medium text-ink">Chiều cao</span>
                                                </div>
                                                <span class="text-sm font-bold text-ink">
                                                    <c:choose>
                                                        <c:when test="${record.height > 0}">${record.height} cm</c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <div
                                                class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                                                <div class="flex items-center gap-2.5">
                                                    <span
                                                        class="h-8 w-8 rounded-lg bg-teal-50 text-teal-600 flex items-center justify-center">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                            stroke-width="2" stroke-linecap="round"
                                                            stroke-linejoin="round">
                                                            <path
                                                                d="M12 3h.01M19 8.5v9a2.5 2.5 0 0 1-2.5 2.5h-9A2.5 2.5 0 0 1 5 17.5v-9A2.5 2.5 0 0 1 7.5 6h9A2.5 2.5 0 0 1 19 8.5Z" />
                                                        </svg>
                                                    </span>
                                                    <span class="text-sm font-medium text-ink">Cân nặng</span>
                                                </div>
                                                <span class="text-sm font-bold text-ink">
                                                    <c:choose>
                                                        <c:when test="${record.weight > 0}">${record.weight} kg</c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <c:if test="${record.bmi > 0}">
                                                <div
                                                    class="flex items-center justify-between p-3.5 bg-brand-soft/20 rounded-xl border border-brand-soft/30 mt-6">
                                                    <div class="flex items-center gap-2.5">
                                                        <span
                                                            class="h-8 w-8 rounded-lg bg-brand text-brand-foreground flex items-center justify-center font-bold text-xs">BMI</span>
                                                        <span class="text-sm font-semibold text-brand">Chỉ số BMI</span>
                                                    </div>
                                                    <div class="text-right">
                                                        <span
                                                            class="text-sm font-extrabold text-brand">${record.bmi}</span>
                                                        <span class="text-[10px] text-muted-foreground block">
                                                            <c:choose>
                                                                <c:when test="${record.bmi < 18.5}">Gầy</c:when>
                                                                <c:when
                                                                    test="${record.bmi >= 18.5 && record.bmi < 24.9}">
                                                                    Bình thường</c:when>
                                                                <c:when test="${record.bmi >= 25 && record.bmi < 29.9}">
                                                                    Thừa cân</c:when>
                                                                <c:otherwise>Béo phì</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            function printMedicalRecord() {
                                window.print();
                            }
                        </script>