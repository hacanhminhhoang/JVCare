<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ khám bệnh - JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        background: "oklch(0.99 0.005 180)",
                        ink: "oklch(0.14 0.03 210)",
                        brand: "oklch(0.55 0.13 195)",
                        "brand-foreground": "oklch(0.99 0.005 180)",
                        "brand-soft": "oklch(0.95 0.04 190)",
                        muted: "oklch(0.96 0.012 200)",
                        "muted-foreground": "oklch(0.5 0.025 215)",
                        border: "oklch(0.92 0.015 200)",
                        card: "oklch(1 0 0)"
                    },
                    fontFamily: {
                        sans: ['Manrope', 'system-ui', 'sans-serif'],
                        display: ['Sora', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>
</head>
<body class="min-h-screen bg-muted/30 font-sans text-ink">

    <main class="mx-auto max-w-4xl p-6 md:p-10">
        <a href="${pageContext.request.contextPath}/doctor/appointments" class="inline-flex items-center gap-2 text-sm font-semibold text-muted-foreground hover:text-ink mb-6 transition">
            &larr; Quay lại danh sách
        </a>
        
        <c:if test="${not empty sessionScope.message}">
            <div class="mb-6 rounded-xl bg-green-50 p-4 text-sm font-medium text-green-700 border border-green-200">
                <c:out value="${sessionScope.message}" />
                <c:remove var="message" scope="session" />
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="mb-6 rounded-xl bg-red-50 p-4 text-sm font-medium text-red-600 border border-red-200">
                <c:out value="${sessionScope.error}" />
                <c:remove var="error" scope="session" />
            </div>
        </c:if>

        <div id="document-content" class="rounded-3xl bg-white p-8 md:p-12 shadow-sm border border-border/60">
            <!-- Header Bệnh viện -->
            <div class="flex items-center justify-between border-b-2 border-brand pb-6 mb-8">
                <div>
                    <h1 class="font-display text-2xl font-bold text-brand uppercase tracking-wider">Hệ Thống JVCare</h1>
                    <p class="text-sm font-medium text-muted-foreground mt-1">Hồ sơ khám bệnh điện tử</p>
                </div>
                <div class="text-right">
                    <p class="text-sm font-bold text-ink">Mã hồ sơ: <span class="text-brand">#<fmt:formatNumber value="${appointment.appointmentId}" pattern="000000"/></span></p>
                    <p class="text-xs text-muted-foreground mt-1">Ngày tạo: <fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy" /></p>
                </div>
            </div>

            <!-- Khối 1: Thông tin Hành chính -->
            <div class="mb-8">
                <h2 class="font-bold text-lg text-ink border-b border-border pb-2 mb-4">I. Thông tin Bệnh nhân</h2>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-y-4 gap-x-6 text-sm">
                    <div><span class="text-muted-foreground">Họ và tên:</span> <br><strong class="text-ink text-base uppercase"><c:out value="${patient.fullName}"/></strong></div>
                    <div><span class="text-muted-foreground">Mã bệnh nhân:</span> <br><strong class="text-ink"><c:out value="${patient.patientCode}"/></strong></div>
                    <div><span class="text-muted-foreground">Ngày sinh:</span> <br><strong class="text-ink"><fmt:formatDate value="${patient.dateOfBirth}" pattern="dd/MM/yyyy" /> (<c:out value="${patient.age}"/> tuổi)</strong></div>
                    <div><span class="text-muted-foreground">Giới tính:</span> <br><strong class="text-ink"><c:out value="${patient.gender}"/></strong></div>
                    <div><span class="text-muted-foreground">CCCD / CMND:</span> <br><strong class="text-ink"><c:out value="${patient.idCard}" default="—"/></strong></div>
                    <div><span class="text-muted-foreground">SĐT:</span> <br><strong class="text-ink"><c:out value="${patient.phone}"/></strong></div>
                    <div class="col-span-2 md:col-span-3"><span class="text-muted-foreground">Địa chỉ:</span> <br><strong class="text-ink"><c:out value="${patient.address}" default="—"/></strong></div>
                </div>
            </div>

            <!-- Khối 2: Thông tin Khám bệnh -->
            <div class="mb-8">
                <h2 class="font-bold text-lg text-ink border-b border-border pb-2 mb-4">II. Thông tin Khám bệnh</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-y-4 gap-x-6 text-sm">
                    <div><span class="text-muted-foreground">Lý do khám:</span> <br><strong class="text-ink"><c:out value="${appointment.reason}" default="Không có"/></strong></div>
                    <div><span class="text-muted-foreground">Trạng thái hồ sơ:</span> <br>
                        <strong class="text-ink">
                            <c:if test="${appointment.status == 'CONFIRMED'}">Đang xử lý (Đã nhận)</c:if>
                            <c:if test="${appointment.status == 'COMPLETED'}">Đã hoàn thành</c:if>
                        </strong>
                    </div>
                    <div><span class="text-muted-foreground">Ngày khám thực tế:</span> <br><strong class="text-ink"><fmt:formatDate value="${appointment.appointmentDate}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${appointment.appointmentTime}" pattern="HH:mm" /></strong></div>
                    <div><span class="text-muted-foreground">Bác sĩ phụ trách:</span> <br><strong class="text-ink"><c:out value="${appointment.doctorName}"/></strong></div>
                </div>
            </div>

            <!-- Khối 3: Kết luận (Nếu COMPLETED) -->
            <c:choose>
                <c:when test="${appointment.status == 'COMPLETED'}">
                    <div class="mb-8 rounded-xl border border-brand/20 bg-brand-soft/20 p-6">
                        <h2 class="font-bold text-lg text-ink border-b border-brand/20 pb-2 mb-4">III. Kết luận Bác sĩ</h2>
                        <div class="space-y-4 text-sm">
                            <div><span class="text-muted-foreground font-semibold">1. Tình trạng lúc khám:</span> <br><p class="mt-1 text-ink leading-relaxed"><c:out value="${appointment.patientCondition}"/></p></div>
                            <div><span class="text-muted-foreground font-semibold">2. Chẩn đoán lâm sàng:</span> <br><p class="mt-1 font-bold text-brand text-base"><c:out value="${appointment.diagnosis}"/></p></div>
                            <div><span class="text-muted-foreground font-semibold">3. Lời khuyên / Dặn dò:</span> <br><p class="mt-1 text-ink leading-relaxed italic"><c:out value="${appointment.advice}"/></p></div>
                        </div>
                    </div>
                </c:when>
                <c:when test="${appointment.status == 'CONFIRMED' && appointment.doctorId == currentDoctorId}">
                    <!-- Khối 3: Form Cập nhật (Nếu CONFIRMED) -->
                    <div class="mb-8 rounded-xl border-2 border-dashed border-border bg-muted/20 p-6">
                        <h2 class="font-bold text-lg text-ink mb-1">Cập nhật Hồ sơ Khám</h2>
                        <p class="text-sm text-muted-foreground mb-4">Vui lòng điền đầy đủ thông tin bệnh án để hoàn tất quá trình khám.</p>
                        
                        <form action="${pageContext.request.contextPath}/doctor/appointment-detail" method="POST" class="space-y-5">
                            <input type="hidden" name="action" value="complete" />
                            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}" />
                            
                            <div>
                                <label class="mb-1.5 block text-sm font-semibold">Tình trạng bệnh nhân (Lúc khám)</label>
                                <textarea name="patientCondition" rows="2" class="w-full rounded-xl border border-border px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-brand" placeholder="Ghi nhận các triệu chứng, huyết áp, nhiệt độ..."></textarea>
                            </div>
                            
                            <div>
                                <label class="mb-1.5 block text-sm font-semibold">Chẩn đoán bệnh <span class="text-red-500">*</span></label>
                                <textarea required name="diagnosis" rows="2" class="w-full rounded-xl border border-brand px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-brand" placeholder="Chẩn đoán lâm sàng cuối cùng"></textarea>
                            </div>
                            
                            <div>
                                <label class="mb-1.5 block text-sm font-semibold">Lời khuyên / Dặn dò</label>
                                <textarea name="advice" rows="3" class="w-full rounded-xl border border-border px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-brand" placeholder="Chế độ ăn uống, sinh hoạt, lịch tái khám (nếu có)..."></textarea>
                            </div>
                            
                            <div class="pt-2 flex justify-end">
                                <button type="submit" class="rounded-xl bg-brand px-6 py-3 text-sm font-bold text-brand-foreground shadow-sm hover:opacity-90 transition flex items-center gap-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                                    Lưu & Hoàn Thành Hồ Sơ
                                </button>
                            </div>
                        </form>
                    </div>
                </c:when>
            </c:choose>

            <!-- Chữ ký -->
            <div class="mt-12 flex justify-end text-center">
                <div>
                    <p class="text-sm font-medium text-ink">Ngày <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd" /> tháng <fmt:formatDate value="<%=new java.util.Date()%>" pattern="MM" /> năm <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy" /></p>
                    <p class="text-sm font-bold text-ink mt-1">Bác sĩ khám bệnh</p>
                    <div class="h-16"></div> <!-- Khoảng trống ký tên -->
                    <p class="font-bold text-brand"><c:out value="${appointment.doctorName}"/></p>
                </div>
            </div>
        </div>
        
        <c:if test="${appointment.status == 'COMPLETED'}">
            <div class="mt-6 flex justify-end">
                <button type="button" onclick="window.print()" class="rounded-xl bg-brand px-6 py-3 text-sm font-bold text-brand-foreground shadow-md hover:shadow-lg transition flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/></svg>
                    Xuất PDF Hồ Sơ
                </button>
            </div>
        </c:if>

    </main>

    <!-- Ẩn các phần tử khác khi in PDF -->
    <style>
        @media print {
            body { background: white; }
            main { padding: 0 !important; max-width: 100% !important; margin: 0 !important; }
            a, button, .mb-6 { display: none !important; }
            #document-content { border: none; box-shadow: none; padding: 0; }
        }
    </style>
</body>
</html>
