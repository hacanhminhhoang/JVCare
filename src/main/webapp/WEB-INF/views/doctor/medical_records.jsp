<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Bệnh án — JVCare</title>
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

        <div class="mx-auto max-w-6xl p-6 md:p-10">
            <!-- Header Section -->
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
                <div>
                    <h1 class="font-display text-3xl font-bold text-ink">Danh sách Bệnh án</h1>
                    <p class="mt-1 text-sm text-muted-foreground">Quản lý, chẩn đoán và theo dõi hồ sơ bệnh án của bệnh nhân</p>
                </div>
                <div class="flex items-center gap-3">
                    <a href="${pageContext.request.contextPath}/doctor/index" class="inline-flex items-center gap-2 rounded-xl border border-border/60 bg-card px-4 py-2.5 text-sm font-semibold text-muted-foreground hover:text-ink hover:bg-muted/30 transition shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                        Quay lại
                    </a>
                </div>
            </div>

            <!-- Messages/Alerts -->
            <c:if test="${not empty sessionScope.message}">
                <div class="mb-6 rounded-2xl bg-green-50 p-4 text-sm text-green-700 border border-green-200 shadow-sm animate-pulse">
                    <c:out value="${sessionScope.message}" />
                    <c:remove var="message" scope="session" />
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="mb-6 rounded-2xl bg-red-50 p-4 text-sm text-red-600 border border-red-200 shadow-sm">
                    <c:out value="${sessionScope.error}" />
                    <c:remove var="error" scope="session" />
                </div>
            </c:if>

            <!-- Search and Filter Panel -->
            <div class="mb-6 bg-card border border-border/60 rounded-3xl p-5 shadow-sm">
                <div class="relative max-w-md">
                    <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-muted-foreground">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    </div>
                    <input type="text" id="searchInput" 
                           class="w-full pl-10 pr-4 py-2.5 rounded-2xl border border-border bg-background text-sm text-ink placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-brand/20 focus:border-brand transition"
                           placeholder="Tìm kiếm bệnh nhân, mã bệnh án, chẩn đoán...">
                </div>
            </div>

            <!-- Medical Records List (Table) -->
            <div class="bg-card border border-border/60 rounded-3xl overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="border-b border-border/60 bg-muted/20">
                                <th class="p-4 text-xs font-bold uppercase tracking-wider text-muted-foreground w-24">Mã BA</th>
                                <th class="p-4 text-xs font-bold uppercase tracking-wider text-muted-foreground w-28">Mã BN</th>
                                <th class="p-4 text-xs font-bold uppercase tracking-wider text-muted-foreground">Bệnh nhân</th>
                                <th class="p-4 text-xs font-bold uppercase tracking-wider text-muted-foreground w-44">Ngày khám</th>
                                <th class="p-4 text-xs font-bold uppercase tracking-wider text-muted-foreground">Chẩn đoán</th>
                                <th class="p-4 text-xs font-bold uppercase tracking-wider text-muted-foreground text-right w-44">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="recordsTableBody" class="divide-y divide-border/40">
                            <c:forEach var="record" items="${records}">
                                <tr class="hover:bg-muted/10 transition-colors">
                                    <td class="p-4 align-middle">
                                        <span class="inline-flex items-center rounded-lg bg-brand-soft px-2.5 py-1 text-xs font-bold text-brand">
                                            #${record.recordId}
                                        </span>
                                    </td>
                                    <td class="p-4 align-middle text-sm font-semibold text-ink">
                                        <c:out value="${record.patientCode}"/>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="font-bold text-ink"><c:out value="${record.patientName}"/></div>
                                    </td>
                                    <td class="p-4 align-middle text-sm text-muted-foreground">
                                        <div class="flex items-center gap-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground/75"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                                            <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle text-sm text-ink max-w-xs">
                                        <div class="truncate" title="<c:out value="${record.diagnosis}"/>">
                                            <c:choose>
                                                <c:when test="${record.diagnosis.length() > 50}">
                                                    <c:out value="${record.diagnosis.substring(0, 50)}"/>...
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${record.diagnosis}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle text-right">
                                        <div class="inline-flex items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/doctor/medical-records?action=detail&id=${record.recordId}" 
                                               class="inline-flex items-center gap-1.5 rounded-xl bg-brand-soft px-3 py-1.5 text-xs font-bold text-brand hover:bg-brand hover:text-brand-foreground transition-all shadow-sm"
                                               title="Xem chi tiết bệnh án">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                                                Xem
                                            </a>
                                            <a href="${pageContext.request.contextPath}/doctor/medical-records?action=edit&id=${record.recordId}" 
                                               class="inline-flex items-center gap-1.5 rounded-xl bg-yellow-50 border border-yellow-100 px-3 py-1.5 text-xs font-bold text-yellow-600 hover:bg-yellow-500 hover:text-white transition-all shadow-sm"
                                               title="Chỉnh sửa bệnh án">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg>
                                                Sửa
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty records}">
                                <tr>
                                    <td colspan="6" class="p-12 text-center text-muted-foreground bg-card">
                                        <div class="flex flex-col items-center justify-center gap-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground/50"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" x2="8" y1="13" y2="13"/><line x1="16" x2="8" y1="17" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                            <span class="text-sm font-medium">Chưa có bệnh án nào được khởi tạo</span>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Pagination / Counter Mock -->
            <div class="mt-6 flex flex-col sm:flex-row items-center justify-between gap-4">
                <span class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                    Tổng số bệnh án: <b id="recordsCount" class="text-ink"><c:out value="${records.size()}" default="0"/></b>
                </span>
                <div class="flex items-center gap-2">
                    <button class="rounded-lg border border-border/60 px-3 py-1.5 text-xs font-semibold text-muted-foreground hover:bg-muted/30 transition shadow-sm" disabled>&larr; Trước</button>
                    <span class="text-xs font-semibold text-muted-foreground">Trang 1 / 1</span>
                    <button class="rounded-lg border border-border/60 px-3 py-1.5 text-xs font-semibold text-ink hover:bg-muted/30 transition shadow-sm" disabled>Sau &rarr;</button>
                </div>
            </div>
        </div>
    </main>

    <!-- Client-side filtering script -->
    <script>
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.trim().toLowerCase();
            const rows = document.querySelectorAll('#recordsTableBody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                // Skip empty state row if it's there
                if (row.querySelector('td[colspan]')) return;

                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            // Update visible counter if count label exists
            const countEl = document.getElementById('recordsCount');
            if (countEl) {
                countEl.textContent = visibleCount;
            }
        });
    </script>
</body>
</html>
