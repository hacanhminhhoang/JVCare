<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${record != null ? 'Chỉnh sửa' : 'Khởi tạo'} Bệnh án — JVCare</title>
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
            
            <a href="${pageContext.request.contextPath}/doctor/index" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isPatients ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                Danh sách bệnh nhân
            </a>
            
            <a href="${pageContext.request.contextPath}/doctor/appointments" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isAppt ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                Lịch hẹn khám
            </a>

            <a href="${pageContext.request.contextPath}/doctor/medical-records" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isRecords ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" x2="8" y1="13" y2="13"/><line x1="16" x2="8" y1="17" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                Danh sách Bệnh án
            </a>
        </nav>
        <div class="border-t border-border/60 p-4 space-y-2">
            <a href="${pageContext.request.contextPath}/" class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                Trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/login" class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-red-600 hover:bg-red-50 transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/></svg>
                Đăng xuất
            </a>
        </div>
    </aside>

    <!-- Main Content Area -->
    <main class="flex-1 overflow-auto bg-muted/30">
        <header class="sticky top-0 z-10 flex h-16 items-center justify-between border-b border-border/60 bg-card px-6 shadow-sm md:hidden">
            <span class="font-display text-xl font-bold text-brand">JVCare Doctor</span>
            <span class="text-sm font-medium"><c:out value="${sessionScope.user.fullName}"/></span>
        </header>

        <div class="mx-auto max-w-4xl p-6 md:p-10">
            <!-- Breadcrumbs -->
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/doctor/medical-records" class="inline-flex items-center gap-1.5 text-sm font-semibold text-muted-foreground hover:text-brand transition">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                    Quay lại danh sách bệnh án
                </a>
            </div>

            <!-- Page Header -->
            <div class="mb-8">
                <h1 class="font-display text-3xl font-bold text-ink">
                    ${record != null ? 'Chỉnh sửa' : 'Khởi tạo'} Bệnh án
                </h1>
                <p class="mt-1 text-sm text-muted-foreground">
                    ${record != null ? 'Thay đổi thông tin chẩn đoán, điều trị của bệnh án hiện có' : 'Nhập thông tin thăm khám lâm sàng và đưa ra phương án điều trị mới'}
                </p>
            </div>

            <!-- Main Form Card -->
            <div class="bg-card border border-border/60 rounded-3xl p-6 md:p-10 shadow-sm">
                
                <form method="post" action="${pageContext.request.contextPath}/doctor/medical-records" class="space-y-8">
                    <!-- Hidden Parameters -->
                    <input type="hidden" name="action" value="${record != null ? 'update' : 'create'}">
                    <c:if test="${record != null}">
                        <input type="hidden" name="recordId" value="${record.recordId}">
                        <input type="hidden" name="patientId" value="${record.patientId}">
                    </c:if>
                    <c:if test="${appointment != null}">
                        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                        <input type="hidden" name="patientId" value="${appointment.patientId}">
                    </c:if>

                    <!-- Patient administrative information banner -->
                    <c:choose>
                        <c:when test="${appointment != null}">
                            <div class="rounded-2xl border border-brand/20 bg-brand-soft/20 p-5 flex items-start gap-4 shadow-inner">
                                <div class="p-3 bg-brand rounded-xl text-white shadow-sm flex-shrink-0">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                </div>
                                <div class="text-sm">
                                    <span class="text-xs font-bold uppercase tracking-wider text-brand">Hồ sơ bệnh nhân từ lịch hẹn</span>
                                    <h4 class="text-base font-bold text-ink mt-0.5"><c:out value="${appointment.patientName}"/></h4>
                                    <p class="text-muted-foreground mt-1"><span class="font-semibold text-ink">Lý do khám:</span> <c:out value="${appointment.reason}"/></p>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${record != null}">
                            <div class="rounded-2xl border border-brand/10 bg-brand-soft/10 p-5 flex items-start gap-4">
                                <div class="p-3 bg-brand-soft rounded-xl text-brand flex-shrink-0">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                </div>
                                <div class="text-sm">
                                    <span class="text-xs font-bold uppercase tracking-wider text-brand-soft-foreground">Hồ sơ bệnh án #${record.recordId}</span>
                                    <h4 class="text-base font-bold text-ink mt-0.5"><c:out value="${record.patientName}"/></h4>
                                    <p class="text-muted-foreground mt-0.5"><span class="font-semibold text-ink">Mã bệnh nhân:</span> <c:out value="${record.patientCode}"/></p>
                                </div>
                            </div>
                        </c:when>
                    </c:choose>

                    <!-- SECTION 1: Vital Signs -->
                    <div class="border border-border/60 bg-muted/10 rounded-2xl p-5 md:p-6 space-y-4">
                        <div class="flex items-center gap-2 border-b border-border/40 pb-3">
                            <span class="text-brand flex-shrink-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                            </span>
                            <h3 class="font-display font-bold text-base text-ink">Chỉ số sinh tồn</h3>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-5 gap-4">
                            <div>
                                <label class="block text-xs font-bold uppercase tracking-wide text-muted-foreground mb-1.5">Huyết áp</label>
                                <input type="text" name="bloodPressure" class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition" 
                                       value="${record.bloodPressure}" placeholder="Ví dụ: 120/80">
                            </div>
                            <div>
                                <label class="block text-xs font-bold uppercase tracking-wide text-muted-foreground mb-1.5">Nhịp tim (bpm)</label>
                                <input type="number" name="heartRate" class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition" 
                                       value="${record.heartRate}" placeholder="Ví dụ: 75">
                            </div>
                            <div>
                                <label class="block text-xs font-bold uppercase tracking-wide text-muted-foreground mb-1.5">Nhiệt độ (°C)</label>
                                <input type="number" step="0.1" name="temperature" class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition" 
                                       value="${record.temperature}" placeholder="Ví dụ: 36.5">
                            </div>
                            <div>
                                <label class="block text-xs font-bold uppercase tracking-wide text-muted-foreground mb-1.5">Cân nặng (kg)</label>
                                <input type="number" step="0.1" name="weight" class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition" 
                                       value="${record.weight}" placeholder="Ví dụ: 65.5">
                            </div>
                            <div>
                                <label class="block text-xs font-bold uppercase tracking-wide text-muted-foreground mb-1.5">Chiều cao (cm)</label>
                                <input type="number" step="0.1" name="height" class="w-full px-4 py-2.5 rounded-xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition" 
                                       value="${record.height}" placeholder="Ví dụ: 170">
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 2: Diagnosis & Treatment -->
                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-semibold text-ink mb-1.5 flex items-center gap-1">
                                Chẩn đoán bệnh <span class="text-red-500 font-bold">*</span>
                            </label>
                            <textarea name="diagnosis" required rows="3" 
                                      class="w-full px-4 py-3 rounded-2xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition"
                                      placeholder="Mô tả chẩn đoán lâm sàng chi tiết của bệnh nhân...">${record.diagnosis}</textarea>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-ink mb-1.5 flex items-center gap-1">
                                Phương án điều trị <span class="text-red-500 font-bold">*</span>
                            </label>
                            <textarea name="treatmentPlan" required rows="4" 
                                      class="w-full px-4 py-3 rounded-2xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition"
                                      placeholder="Nêu rõ phương pháp điều trị, chỉ định lâm sàng, chế độ kiêng cữ...">${record.treatmentPlan}</textarea>
                        </div>

                        <div>
                            <label class="block text-sm font-semibold text-ink mb-1.5">Ghi chú thêm</label>
                            <textarea name="notes" rows="3" 
                                      class="w-full px-4 py-3 rounded-2xl border border-border bg-card text-sm text-ink placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition"
                                      placeholder="Nhập ghi chú phụ khoa, tiền sử dị ứng đặc biệt hoặc các ghi nhớ khác...">${record.notes}</textarea>
                        </div>
                    </div>

                    <!-- Actions Buttons -->
                    <div class="flex items-center justify-end gap-3 pt-6 border-t border-border/60">
                        <a href="${pageContext.request.contextPath}/doctor/medical-records" 
                           class="rounded-xl border border-border/60 bg-card px-5 py-2.5 text-sm font-semibold text-muted-foreground hover:text-ink hover:bg-muted/30 transition shadow-sm">
                            Hủy
                        </a>
                        <button type="submit" 
                                class="rounded-xl bg-gradient-to-r from-brand to-brand/90 px-6 py-2.5 text-sm font-bold text-brand-foreground shadow-md hover:shadow-lg hover:brightness-105 active:scale-95 transition flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                            Lưu bệnh án
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </main>

</body>
</html>
