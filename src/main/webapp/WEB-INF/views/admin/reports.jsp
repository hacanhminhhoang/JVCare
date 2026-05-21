<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo hệ thống - JVCare</title>
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
<body class="flex min-h-screen bg-muted/30 font-sans text-ink">
    <!-- Sidebar -->
    <aside class="hidden w-64 shrink-0 flex-col border-r border-border/60 bg-card md:flex">
        <div class="p-6">
            <span class="font-display font-bold text-xl text-brand">JVCare Admin</span>
        </div>
        <nav class="flex-1 space-y-1 px-4 py-4">
            <a href="${pageContext.request.contextPath}/admin/home" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                Quản lý Nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/admin/doctors" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                Quản lý Bác sĩ
            </a>
            <a href="${pageContext.request.contextPath}/admin/patients" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                Quản lý Bệnh nhân
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="flex items-center gap-3 rounded-lg bg-brand-soft px-3 py-2 text-sm font-semibold text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/><line x1="16" x2="8" y1="13" y2="13"/><line x1="16" x2="8" y1="17" y2="17"/><line x1="10" x2="8" y1="9" y2="9"/></svg>
                Báo cáo hệ thống
            </a>
        </nav>
        <div class="border-t border-border/60 p-4 space-y-2">
            <div class="flex items-center gap-3 rounded-xl bg-muted/50 p-3 mb-2">
                <div class="h-10 w-10 shrink-0 rounded-full bg-brand-soft text-brand flex items-center justify-center font-bold">
                    <c:out value="${sessionScope.user.fullName.substring(0,2).toUpperCase()}"/>
                </div>
                <div class="overflow-hidden">
                    <p class="truncate text-sm font-semibold text-ink"><c:out value="${sessionScope.user.fullName}"/></p>
                    <p class="truncate text-xs text-muted-foreground"><c:out value="${sessionScope.user.email}"/></p>
                </div>
            </div>
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

    <!-- Main content -->
    <main class="flex-1 overflow-auto p-6 md:p-10">
        <div class="mb-6">
            <h1 class="font-display text-3xl font-bold text-ink">Báo cáo hệ thống</h1>
            <p class="mt-2 text-sm text-muted-foreground">Xuất báo cáo và thống kê hệ thống JVCare</p>
        </div>

        <!-- Success Message -->
        <c:if test="${param.success == 'generated'}">
            <div class="mb-6 rounded-lg border border-green-200 bg-green-50 p-4 text-sm text-green-800">
                <svg class="inline mr-2" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                Báo cáo đã được tạo thành công!
            </div>
        </c:if>

        <!-- Statistics Overview -->
        <div class="mb-8 grid gap-6 md:grid-cols-2 lg:grid-cols-4">
            <div class="rounded-xl border border-border bg-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-muted-foreground">Tổng nhân viên</p>
                        <p class="mt-2 font-display text-3xl font-bold text-ink">${totalUsers}</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-full bg-blue-100 text-blue-600">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                </div>
            </div>

            <div class="rounded-xl border border-border bg-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-muted-foreground">Tổng bác sĩ</p>
                        <p class="mt-2 font-display text-3xl font-bold text-ink">${totalDoctors}</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-full bg-green-100 text-green-600">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                    </div>
                </div>
            </div>

            <div class="rounded-xl border border-border bg-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-muted-foreground">Tổng bệnh nhân</p>
                        <p class="mt-2 font-display text-3xl font-bold text-ink">${totalPatients}</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-full bg-purple-100 text-purple-600">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </div>
                </div>
            </div>

            <div class="rounded-xl border border-border bg-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-muted-foreground">Tổng lịch hẹn</p>
                        <p class="mt-2 font-display text-3xl font-bold text-ink">${totalAppointments}</p>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-full bg-orange-100 text-orange-600">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Types -->
        <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <!-- System Overview Report -->
            <div class="rounded-xl border border-border bg-card p-6">
                <div class="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-brand-soft text-brand">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/></svg>
                </div>
                <h3 class="mb-2 font-semibold text-ink">Báo cáo tổng quan hệ thống</h3>
                <p class="mb-4 text-sm text-muted-foreground">Thống kê tổng quan về users, doctors, patients và appointments</p>
                <button onclick="generateReport('system')" class="w-full rounded-lg bg-brand px-4 py-2 text-sm font-medium text-brand-foreground hover:bg-brand/90 transition">
                    Xuất báo cáo PDF
                </button>
            </div>

            <!-- Users Report -->
            <div class="rounded-xl border border-border bg-card p-6">
                <div class="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-blue-100 text-blue-600">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                </div>
                <h3 class="mb-2 font-semibold text-ink">Báo cáo nhân viên</h3>
                <p class="mb-4 text-sm text-muted-foreground">Danh sách chi tiết nhân viên theo role và trạng thái</p>
                <button onclick="generateReport('users')" class="w-full rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition">
                    Xuất báo cáo PDF
                </button>
            </div>

            <!-- Doctors Report -->
            <div class="rounded-xl border border-border bg-card p-6">
                <div class="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-green-100 text-green-600">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                </div>
                <h3 class="mb-2 font-semibold text-ink">Báo cáo bác sĩ</h3>
                <p class="mb-4 text-sm text-muted-foreground">Danh sách bác sĩ theo chuyên khoa và thống kê hoạt động</p>
                <button onclick="generateReport('doctors')" class="w-full rounded-lg bg-green-600 px-4 py-2 text-sm font-medium text-white hover:bg-green-700 transition">
                    Xuất báo cáo PDF
                </button>
            </div>

            <!-- Patients Report -->
            <div class="rounded-xl border border-border bg-card p-6">
                <div class="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-purple-100 text-purple-600">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </div>
                <h3 class="mb-2 font-semibold text-ink">Báo cáo bệnh nhân</h3>
                <p class="mb-4 text-sm text-muted-foreground">Danh sách bệnh nhân và lịch sử khám bệnh</p>
                <button onclick="generateReport('patients')" class="w-full rounded-lg bg-purple-600 px-4 py-2 text-sm font-medium text-white hover:bg-purple-700 transition">
                    Xuất báo cáo PDF
                </button>
            </div>

            <!-- Appointments Report -->
            <div class="rounded-xl border border-border bg-card p-6">
                <div class="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-orange-100 text-orange-600">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                </div>
                <h3 class="mb-2 font-semibold text-ink">Báo cáo lịch hẹn</h3>
                <p class="mb-4 text-sm text-muted-foreground">Thống kê lịch hẹn theo trạng thái và thời gian</p>
                <button onclick="generateReport('appointments')" class="w-full rounded-lg bg-orange-600 px-4 py-2 text-sm font-medium text-white hover:bg-orange-700 transition">
                    Xuất báo cáo PDF
                </button>
            </div>

            <!-- Monthly Report -->
            <div class="rounded-xl border border-border bg-card p-6">
                <div class="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-red-100 text-red-600">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/><path d="M12 18v-6"/><path d="m9 15 3 3 3-3"/></svg>
                </div>
                <h3 class="mb-2 font-semibold text-ink">Báo cáo tháng</h3>
                <p class="mb-4 text-sm text-muted-foreground">Báo cáo tổng hợp hoạt động trong tháng</p>
                <button onclick="generateReport('monthly')" class="w-full rounded-lg bg-red-600 px-4 py-2 text-sm font-medium text-white hover:bg-red-700 transition">
                    Xuất báo cáo PDF
                </button>
            </div>
        </div>
    </main>

    <script>
        function generateReport(type) {
            if (confirm('Bạn có chắc muốn xuất báo cáo ' + type + '?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/reports?action=generate&type=' + type;
            }
        }
    </script>
</body>
</html>
