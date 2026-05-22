<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Chi tiết Bệnh án #${record.recordId} — JVCare</title>
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

            <body class="min-h-screen bg-background font-sans text-ink flex">

                <!-- Sidebar Navigation for Doctor -->
                <aside class="w-64 border-r border-border/60 bg-card shadow-sm flex flex-col hidden md:flex shrink-0">
                    <div class="flex h-16 shrink-0 items-center px-6">
                        <span class="font-display font-bold text-xl text-brand">JVCare Doctor</span>
                    </div>
                    <nav class="flex-1 space-y-1 px-4 py-4">
                        <c:set var="uri" value="${pageContext.request.requestURI}" />
                        <c:set var="isPatients" value="${uri.endsWith('/doctor/index') || uri.endsWith('/doctor')}" />
                        <c:set var="isAppt" value="${uri.contains('/doctor/appointments')}" />
                        <c:set var="isRecords" value="true" />

                        <a href="${pageContext.request.contextPath}/doctor/index"
                            class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isPatients ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                                <circle cx="9" cy="7" r="4" />
                                <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
                                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                            </svg>
                            Danh sách bệnh nhân
                        </a>

                        <a href="${pageContext.request.contextPath}/doctor/appointments"
                            class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isAppt ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <rect width="18" height="18" x="3" y="4" rx="2" ry="2" />
                                <line x1="16" x2="16" y1="2" y2="6" />
                                <line x1="8" x2="8" y1="2" y2="6" />
                                <line x1="3" x2="21" y1="10" y2="10" />
                            </svg>
                            Lịch hẹn khám
                        </a>

                        <a href="${pageContext.request.contextPath}/doctor/medical-records"
                            class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isRecords ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                <polyline points="14 2 14 8 20 8" />
                                <line x1="16" x2="8" y1="13" y2="13" />
                                <line x1="16" x2="8" y1="17" y2="17" />
                                <polyline points="10 9 9 9 8 9" />
                            </svg>
                            Danh sách Bệnh án
                        </a>
                    </nav>
                    <div class="border-t border-border/60 p-4 space-y-2">
                        <a href="${pageContext.request.contextPath}/"
                            class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                                <polyline points="9 22 9 12 15 12 15 22" />
                            </svg>
                            Trang chủ
                        </a>
                        <a href="${pageContext.request.contextPath}/login"
                            class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-red-600 hover:bg-red-50 transition">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                                <polyline points="16 17 21 12 16 7" />
                                <line x1="21" x2="9" y1="12" y2="12" />
                            </svg>
                            Đăng xuất
                        </a>
                    </div>
                </aside>

                <!-- Main Content Area -->
                <main class="flex-1 overflow-auto bg-muted/30">
                    <header
                        class="sticky top-0 z-10 flex h-16 items-center justify-between border-b border-border/60 bg-card px-6 shadow-sm md:hidden">
                        <span class="font-display text-xl font-bold text-brand">JVCare Doctor</span>
                        <span class="text-sm font-medium">
                            <c:out value="${sessionScope.user.fullName}" />
                        </span>
                    </header>

                    <div class="mx-auto max-w-4xl p-6 md:p-10">
                        <!-- Header Section -->
                        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
                            <div>
                                <h1 class="font-display text-3xl font-bold text-ink">Chi tiết Bệnh án</h1>
                                <p class="mt-1 text-sm text-muted-foreground">Mã bệnh án điện tử: <span
                                        class="font-semibold text-brand">#${record.recordId}</span></p>
                            </div>
                            <div class="flex items-center gap-3">
                                <a href="${pageContext.request.contextPath}/doctor/medical-records?action=edit&id=${record.recordId}"
                                    class="inline-flex items-center gap-2 rounded-xl bg-yellow-50 border border-yellow-100 px-4 py-2.5 text-sm font-semibold text-yellow-600 hover:bg-yellow-500 hover:text-white transition-all shadow-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round">
                                        <path d="M12 20h9" />
                                        <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z" />
                                    </svg>
                                    Chỉnh sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/medical-records"
                                    class="inline-flex items-center gap-2 rounded-xl border border-border/60 bg-card px-4 py-2.5 text-sm font-semibold text-muted-foreground hover:text-ink hover:bg-muted/30 transition shadow-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round">
                                        <line x1="19" y1="12" x2="5" y2="12" />
                                        <polyline points="12 19 5 12 12 5" />
                                    </svg>
                                    Quay lại
                                </a>
                            </div>
                        </div>

                        <!-- Messages/Alerts -->
                        <c:if test="${not empty sessionScope.message}">
                            <div
                                class="mb-6 rounded-2xl bg-green-50 p-4 text-sm text-green-700 border border-green-200 shadow-sm animate-pulse">
                                <c:out value="${sessionScope.message}" />
                                <c:remove var="message" scope="session" />
                            </div>
                        </c:if>
                        <c:if test="${not empty sessionScope.error}">
                            <div
                                class="mb-6 rounded-2xl bg-red-50 p-4 text-sm text-red-600 border border-red-200 shadow-sm">
                                <c:out value="${sessionScope.error}" />
                                <c:remove var="error" scope="session" />
                            </div>
                        </c:if>

                        <div class="space-y-6">
                            <!-- Patient Administrative Info Card -->
                            <div class="bg-card border border-border/60 rounded-3xl p-6 shadow-sm">
                                <div class="flex items-center gap-3 border-b border-border/40 pb-4 mb-4">
                                    <span class="p-2 bg-brand/10 text-brand rounded-xl">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
                                            <circle cx="12" cy="7" r="4" />
                                        </svg>
                                    </span>
                                    <h2 class="font-display font-bold text-lg text-ink">Thông tin hành chính</h2>
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 text-sm">
                                    <div>
                                        <span
                                            class="text-xs font-bold uppercase tracking-wider text-muted-foreground block">Mã
                                            bệnh nhân</span>
                                        <span class="text-base font-bold text-ink mt-1 block">
                                            <c:out value="${record.patientCode}" />
                                        </span>
                                    </div>
                                    <div>
                                        <span
                                            class="text-xs font-bold uppercase tracking-wider text-muted-foreground block">Họ
                                            và tên bệnh nhân</span>
                                        <span class="text-base font-bold text-brand uppercase mt-1 block">
                                            <c:out value="${record.patientName}" />
                                        </span>
                                    </div>
                                    <div>
                                        <span
                                            class="text-xs font-bold uppercase tracking-wider text-muted-foreground block">Ngày
                                            khám</span>
                                        <div class="flex items-center gap-1.5 text-ink mt-1 font-semibold text-base">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round"
                                                class="text-muted-foreground">
                                                <rect width="18" height="18" x="3" y="4" rx="2" ry="2" />
                                                <line x1="16" x2="16" y1="2" y2="6" />
                                                <line x1="8" x2="8" y1="2" y2="6" />
                                                <line x1="3" x2="21" y1="10" y2="10" />
                                            </svg>
                                            <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Vital Signs Panel -->
                            <div class="bg-card border border-border/60 rounded-3xl p-6 shadow-sm">
                                <div class="flex items-center gap-3 border-b border-border/40 pb-4 mb-4">
                                    <span class="p-2 bg-brand/10 text-brand rounded-xl">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
                                        </svg>
                                    </span>
                                    <h2 class="font-display font-bold text-lg text-ink">Chỉ số sức khỏe</h2>
                                </div>

                                <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
                                    <div class="bg-muted/10 rounded-2xl p-4 border border-border/20 text-center">
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Huyết
                                            áp</span>
                                        <span class="block text-lg font-bold text-ink mt-1">
                                            <c:out value="${record.bloodPressure}" default="—" />
                                        </span>
                                    </div>
                                    <div class="bg-muted/10 rounded-2xl p-4 border border-border/20 text-center">
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Nhịp
                                            tim</span>
                                        <span class="block text-lg font-bold text-ink mt-1">
                                            <c:choose>
                                                <c:when test="${record.heartRate > 0}">${record.heartRate} <span
                                                        class="text-xs font-semibold text-muted-foreground">bpm</span>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="bg-muted/10 rounded-2xl p-4 border border-border/20 text-center">
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Nhiệt
                                            độ</span>
                                        <span class="block text-lg font-bold text-ink mt-1">
                                            <c:choose>
                                                <c:when test="${record.temperature > 0}">${record.temperature} <span
                                                        class="text-xs font-semibold text-muted-foreground">°C</span>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="bg-muted/10 rounded-2xl p-4 border border-border/20 text-center">
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Cân
                                            nặng</span>
                                        <span class="block text-lg font-bold text-ink mt-1">
                                            <c:choose>
                                                <c:when test="${record.weight > 0}">${record.weight} <span
                                                        class="text-xs font-semibold text-muted-foreground">kg</span>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div
                                        class="bg-muted/10 rounded-2xl p-4 border border-border/20 text-center col-span-2 md:col-span-1">
                                        <span
                                            class="text-[10px] font-bold uppercase tracking-widest text-muted-foreground">Chiều
                                            cao</span>
                                        <span class="block text-lg font-bold text-ink mt-1">
                                            <c:choose>
                                                <c:when test="${record.height > 0}">${record.height} <span
                                                        class="text-xs font-semibold text-muted-foreground">cm</span>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Diagnosis & Treatment Details Card -->
                            <div class="bg-card border border-border/60 rounded-3xl p-6 shadow-sm">
                                <div class="flex items-center gap-3 border-b border-border/40 pb-4 mb-4">
                                    <span class="p-2 bg-brand/10 text-brand rounded-xl">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <path
                                                d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z" />
                                            <polyline points="14 2 14 8 20 8" />
                                        </svg>
                                    </span>
                                    <h2 class="font-display font-bold text-lg text-ink">Chẩn đoán & Điều trị</h2>
                                </div>

                                <div class="space-y-6">
                                    <div>
                                        <span
                                            class="text-xs font-bold uppercase tracking-wider text-muted-foreground">Chẩn
                                            đoán lâm sàng</span>
                                        <div
                                            class="mt-2 text-base font-bold text-ink bg-muted/5 border border-border/40 rounded-2xl p-4 leading-relaxed">
                                            <c:out value="${record.diagnosis}" />
                                        </div>
                                    </div>

                                    <div>
                                        <span
                                            class="text-xs font-bold uppercase tracking-wider text-muted-foreground">Phương
                                            án điều trị</span>
                                        <div
                                            class="mt-2 text-sm text-ink bg-muted/5 border border-border/40 rounded-2xl p-4 leading-relaxed whitespace-pre-wrap">
                                            <c:out value="${record.treatmentPlan}" />
                                        </div>
                                    </div>

                                    <c:if test="${not empty record.notes}">
                                        <div>
                                            <span
                                                class="text-xs font-bold uppercase tracking-wider text-muted-foreground">Ghi
                                                chú phụ</span>
                                            <div
                                                class="mt-2 text-sm italic text-muted-foreground bg-muted/5 border border-border/40 rounded-2xl p-4 whitespace-pre-wrap">
                                                <c:out value="${record.notes}" />
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Prescription Details Card -->
                            <div class="bg-card border border-border/60 rounded-3xl p-6 shadow-sm">
                                <div class="flex items-center justify-between border-b border-border/40 pb-4 mb-4">
                                    <div class="flex items-center gap-3">
                                        <span class="p-2 bg-brand/10 text-brand rounded-xl">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round">
                                                <path
                                                    d="M12 22c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10z" />
                                                <path d="M7 12h10" />
                                                <path d="M12 7v10" />
                                            </svg>
                                        </span>
                                        <h2 class="font-display font-bold text-lg text-ink">Đơn thuốc của bệnh án</h2>
                                    </div>
                                    <button type="button" onclick="openModal()"
                                        class="inline-flex items-center gap-1.5 rounded-xl bg-brand px-3.5 py-2 text-xs font-bold text-brand-foreground hover:opacity-90 shadow-sm transition">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14"
                                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"
                                            stroke-linecap="round" stroke-linejoin="round">
                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                        </svg>
                                        Thêm thuốc
                                    </button>
                                </div>

                                <c:choose>
                                    <c:when test="${empty prescriptions}">
                                        <div
                                            class="p-8 text-center text-muted-foreground border border-dashed border-border/60 rounded-2xl flex flex-col items-center gap-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"
                                                stroke-linecap="round" stroke-linejoin="round"
                                                class="text-muted-foreground/60">
                                                <path
                                                    d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z" />
                                                <path d="m8.5 8.5 7 7" />
                                            </svg>
                                            <span class="text-sm font-semibold">Chưa kê thuốc nào trong đơn này</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="overflow-x-auto rounded-2xl border border-border/60">
                                            <table class="w-full text-left border-collapse">
                                                <thead>
                                                    <tr class="border-b border-border/60 bg-muted/20">
                                                        <th
                                                            class="p-3 text-xs font-bold uppercase tracking-wider text-muted-foreground text-center w-12">
                                                            STT</th>
                                                        <th
                                                            class="p-3 text-xs font-bold uppercase tracking-wider text-muted-foreground">
                                                            Tên thuốc</th>
                                                        <th
                                                            class="p-3 text-xs font-bold uppercase tracking-wider text-muted-foreground w-28">
                                                            Liều lượng</th>
                                                        <th
                                                            class="p-3 text-xs font-bold uppercase tracking-wider text-muted-foreground w-32">
                                                            Tần suất</th>
                                                        <th
                                                            class="p-3 text-xs font-bold uppercase tracking-wider text-muted-foreground text-center w-24">
                                                            Số ngày</th>
                                                        <th
                                                            class="p-3 text-xs font-bold uppercase tracking-wider text-muted-foreground">
                                                            Hướng dẫn sử dụng</th>
                                                        <th
                                                            class="p-3 text-xs font-bold uppercase tracking-wider text-muted-foreground text-center w-20">
                                                            Xóa</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="divide-y divide-border/40 text-sm">
                                                    <c:forEach var="p" items="${prescriptions}" varStatus="status">
                                                        <tr class="hover:bg-muted/5 transition-colors">
                                                            <td
                                                                class="p-3 align-middle text-center font-bold text-muted-foreground">
                                                                ${status.index + 1}
                                                            </td>
                                                            <td class="p-3 align-middle font-bold text-ink">
                                                                <c:out value="${p.medicationName}" />
                                                            </td>
                                                            <td class="p-3 align-middle text-ink font-semibold">
                                                                <span
                                                                    class="inline-flex items-center rounded-lg bg-muted px-2.5 py-0.5 text-xs text-ink/80">
                                                                    <c:out value="${p.dosage}" />
                                                                </span>
                                                            </td>
                                                            <td class="p-3 align-middle text-muted-foreground">
                                                                <c:out value="${p.frequency}" />
                                                            </td>
                                                            <td
                                                                class="p-3 align-middle text-center font-semibold text-ink">
                                                                ${p.durationDays} ngày
                                                            </td>
                                                            <td
                                                                class="p-3 align-middle text-xs text-muted-foreground italic leading-normal">
                                                                <c:out value="${p.instructions}" default="—" />
                                                            </td>
                                                            <td class="p-3 align-middle text-center">
                                                                <a href="${pageContext.request.contextPath}/doctor/prescriptions?action=delete&id=${p.prescriptionId}&recordId=${record.recordId}"
                                                                    class="inline-flex h-8 w-8 items-center justify-center rounded-xl border border-red-100 bg-red-50 text-red-600 hover:bg-red-500 hover:text-white transition"
                                                                    onclick="return confirm('Bạn có thực sự muốn xóa thuốc này khỏi đơn thuốc?')"
                                                                    title="Xóa thuốc">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" width="14"
                                                                        height="14" viewBox="0 0 24 24" fill="none"
                                                                        stroke="currentColor" stroke-width="2"
                                                                        stroke-linecap="round" stroke-linejoin="round">
                                                                        <path d="M3 6h18" />
                                                                        <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6">
                                                                        </path>
                                                                        <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2" />
                                                                    </svg>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="mt-6 flex justify-end">
                                            <a href="${pageContext.request.contextPath}/doctor/medical-records/print?id=${record.recordId}"
                                                class="inline-flex items-center gap-2 rounded-xl bg-brand-soft border border-brand/20 px-5 py-3 text-sm font-bold text-brand hover:bg-brand hover:text-brand-foreground hover:border-transparent shadow-sm transition"
                                                target="_blank">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M6 9V2h12v7" />
                                                    <path
                                                        d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2" />
                                                    <rect width="12" height="8" x="6" y="14" />
                                                </svg>
                                                In đơn thuốc
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </main>

                <!-- Add Medication Modal Overlay -->
                <div id="addMedicationModal"
                    class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-ink/50 backdrop-blur-sm hidden opacity-0 transition-opacity duration-300">
                    <!-- Modal Card -->
                    <div
                        class="bg-card w-full max-w-lg rounded-3xl border border-border/60 shadow-lg transform scale-95 transition-all duration-300 flex flex-col overflow-hidden">
                        <!-- Modal Header -->
                        <div class="px-6 py-4 border-b border-border/60 flex items-center justify-between">
                            <h3 class="font-display font-bold text-lg text-ink">Kê đơn thuốc</h3>
                            <button type="button" onclick="closeModal()"
                                class="p-1.5 rounded-lg text-muted-foreground hover:bg-muted/40 transition">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                                    fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <line x1="18" y1="6" x2="6" y2="18" />
                                    <line x1="6" y1="6" x2="18" y2="18" />
                                </svg>
                            </button>
                        </div>
                        <!-- Modal Form Body -->
                        <form method="post" action="${pageContext.request.contextPath}/doctor/prescriptions">
                            <div class="p-6 space-y-4">
                                <input type="hidden" name="action" value="create">
                                <input type="hidden" name="recordId" value="${record.recordId}">

                                <div>
                                    <label
                                        class="block text-sm font-semibold text-ink mb-1.5 flex items-center gap-0.5">
                                        Tên thuốc <span class="text-red-500 font-bold">*</span>
                                    </label>
                                    <input type="text" name="medicationName" required list="medication-list"
                                        autocomplete="off" placeholder="Ví dụ: Paracetamol, Amoxicillin..."
                                        class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition">
                                    <datalist id="medication-list">
                                        <option value="Paracetamol">Giảm đau, hạ sốt</option>
                                        <option value="Amoxicillin">Kháng sinh</option>
                                        <option value="Ibuprofen">Kháng viêm, giảm đau</option>
                                        <option value="Vitamin C">Bổ sung vitamin</option>
                                        <option value="Loratadine">Dị ứng</option>
                                        <option value="Cetirizine">Dị ứng</option>
                                        <option value="Omeprazole">Dạ dày</option>
                                        <option value="Pantoprazole">Dạ dày</option>
                                        <option value="Amlodipine">Huyết áp</option>
                                        <option value="Aspirin">Huyết áp, tim mạch</option>
                                        <option value="Hydrocortisone cream 1%">Bôi da</option>
                                        <option value="Erythromycin">Kháng sinh</option>
                                        <option value="Alpha Choay">Kháng viêm dạng men</option>
                                        <option value="Oresol">Bù nước</option>
                                    </datalist>
                                </div>

                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label
                                            class="block text-sm font-semibold text-ink mb-1.5 flex items-center gap-0.5">
                                            Liều lượng <span class="text-red-500 font-bold">*</span>
                                        </label>
                                        <input type="text" name="dosage" required placeholder="Ví dụ: 500mg, 1 viên..."
                                            class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition">
                                    </div>
                                    <div>
                                        <label
                                            class="block text-sm font-semibold text-ink mb-1.5 flex items-center gap-0.5">
                                            Tần suất <span class="text-red-500 font-bold">*</span>
                                        </label>
                                        <input type="text" name="frequency" required
                                            placeholder="Ví dụ: 3 lần/ngày, sau ăn..."
                                            class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition">
                                    </div>
                                </div>

                                <div>
                                    <label
                                        class="block text-sm font-semibold text-ink mb-1.5 flex items-center gap-0.5">
                                        Số ngày uống <span class="text-red-500 font-bold">*</span>
                                    </label>
                                    <input type="number" name="durationDays" required placeholder="Ví dụ: 5, 7, 10..."
                                        class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition">
                                </div>

                                <div>
                                    <label class="block text-sm font-semibold text-ink mb-1.5">Hướng dẫn sử dụng chi
                                        tiết</label>
                                    <textarea name="instructions" rows="3"
                                        class="w-full px-4 py-3 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition"
                                        placeholder="Ví dụ: Uống sau bữa ăn sáng và tối. Tránh uống với sữa..."></textarea>
                                </div>
                            </div>
                            <!-- Modal Form Footer -->
                            <div
                                class="px-6 py-4 bg-muted/10 border-t border-border/60 flex items-center justify-end gap-3">
                                <button type="button" onclick="closeModal()"
                                    class="rounded-xl border border-border/60 bg-card px-5 py-2.5 text-sm font-semibold text-muted-foreground hover:text-ink hover:bg-muted/30 transition">
                                    Hủy
                                </button>
                                <button type="submit"
                                    class="rounded-xl bg-brand px-6 py-2.5 text-sm font-bold text-brand-foreground hover:opacity-90 shadow-md transition">
                                    Thêm vào đơn
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal script functions for beautiful animations -->
                <script>
                    function openModal() {
                        const modal = document.getElementById('addMedicationModal');
                        modal.classList.remove('hidden');
                        setTimeout(() => {
                            modal.classList.remove('opacity-0');
                            modal.firstElementChild.classList.remove('scale-95');
                        }, 10);
                    }

                    function closeModal() {
                        const modal = document.getElementById('addMedicationModal');
                        modal.classList.add('opacity-0');
                        modal.firstElementChild.classList.add('scale-95');
                        setTimeout(() => {
                            modal.classList.add('hidden');
                        }, 300);
                    }

                    // Close on overlay click
                    document.getElementById('addMedicationModal').addEventListener('click', function (e) {
                        if (e.target === this) {
                            closeModal();
                        }
                    });
                </script>
            </body>

            </html>