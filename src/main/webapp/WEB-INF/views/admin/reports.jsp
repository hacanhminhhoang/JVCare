<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo & Export — Admin JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        background: "#f8faff",
                        ink: "#1a2035",
                        brand: "#1a56db",
                        "brand-foreground": "#f8faff",
                        "brand-soft": "#e8f0fe",
                        muted: "#eef2fb",
                        "muted-foreground": "#6b7a99",
                        border: "rgba(26, 86, 219, 0.12)",
                        card: "#ffffff"
                    },
                    fontFamily: {
                        sans: ['Be Vietnam Pro', 'system-ui', 'sans-serif'],
                        display: ['Be Vietnam Pro', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .report-card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border-top: 4px solid transparent; transition: all 0.2s; }
        .report-card:hover { transform: translateY(-5px); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); }
        .report-card.blue { border-top-color: #3b82f6; }
        .report-card.green { border-top-color: #10b981; }
        .report-card.purple { border-top-color: #8b5cf6; }
    </style>
</head>
<body class="flex min-h-screen bg-muted/30 font-sans text-ink">
    <!-- Sidebar -->
    <aside class="hidden w-64 shrink-0 flex-col border-r border-border/60 bg-card md:flex">
        <div class="p-6">
            <span class="font-display font-bold text-xl text-brand">JVCare Admin</span>
        </div>
        <nav class="flex-1 space-y-1 px-4 py-4">
            <a href="${pageContext.request.contextPath}/admin/index" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
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
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                Báo cáo & Export
            </a>
        </nav>
        <div class="border-t border-border/60 p-4 space-y-2">
            <div class="flex items-center gap-3 rounded-xl bg-muted/50 p-3 mb-2">
                <div class="h-10 w-10 shrink-0 rounded-full bg-brand-soft text-brand flex items-center justify-center font-bold">
                    <c:out value="${not empty sessionScope.user.fullName ? (sessionScope.user.fullName.length() >= 2 ? sessionScope.user.fullName.substring(0,2).toUpperCase() : sessionScope.user.fullName.toUpperCase()) : 'U'}"/>
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

    <!-- Main Content -->
    <main class="flex-1 p-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-8">Xuất Báo Cáo Hệ Thống</h1>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Report 1 -->
            <div class="report-card blue">
                <div class="w-12 h-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center text-xl mb-4">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-800 mb-2">Báo Cáo Lịch Hẹn</h3>
                <p class="text-gray-500 text-sm mb-6 h-10">Thống kê chi tiết lịch hẹn theo trạng thái, theo tháng và tỷ lệ hoàn thành.</p>
                <div class="flex flex-col space-y-2">
                    <a href="${pageContext.request.contextPath}/admin/reports?action=appointments" class="w-full text-center py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 font-medium rounded-lg transition">Xem trước (HTML)</a>
                    <div class="flex space-x-2">
                        <a href="${pageContext.request.contextPath}/admin/reports?action=export&format=excel&type=appointments" class="flex-1 text-center py-2 bg-green-600 hover:bg-green-700 text-white font-medium rounded-lg transition"><i class="fas fa-file-csv mr-2"></i>CSV</a>
                        <a href="${pageContext.request.contextPath}/admin/reports?action=export&format=pdf&type=appointments" target="_blank" class="flex-1 text-center py-2 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg transition"><i class="fas fa-file-pdf mr-2"></i>PDF</a>
                    </div>
                </div>
            </div>

            <!-- Report 2 -->
            <div class="report-card green">
                <div class="w-12 h-12 bg-green-100 text-green-600 rounded-full flex items-center justify-center text-xl mb-4">
                    <i class="fas fa-user-md"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-800 mb-2">Hiệu Suất Bác Sĩ</h3>
                <p class="text-gray-500 text-sm mb-6 h-10">Thống kê số lượng bệnh nhân, lịch hẹn và bệnh án của từng bác sĩ.</p>
                <div class="flex flex-col space-y-2">
                    <a href="${pageContext.request.contextPath}/admin/reports?action=doctors" class="w-full text-center py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 font-medium rounded-lg transition">Xem trước (HTML)</a>
                    <div class="flex space-x-2">
                        <a href="${pageContext.request.contextPath}/admin/reports?action=export&format=excel&type=doctors" class="flex-1 text-center py-2 bg-green-600 hover:bg-green-700 text-white font-medium rounded-lg transition"><i class="fas fa-file-csv mr-2"></i>CSV</a>
                        <a href="${pageContext.request.contextPath}/admin/reports?action=export&format=pdf&type=doctors" target="_blank" class="flex-1 text-center py-2 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg transition"><i class="fas fa-file-pdf mr-2"></i>PDF</a>
                    </div>
                </div>
            </div>

            <!-- Report 3 -->
            <div class="report-card purple">
                <div class="w-12 h-12 bg-purple-100 text-purple-600 rounded-full flex items-center justify-center text-xl mb-4">
                    <i class="fas fa-procedures"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-800 mb-2">Thống Kê Bệnh Nhân</h3>
                <p class="text-gray-500 text-sm mb-6 h-10">Thống kê tổng quan số lượng và nhân khẩu học của bệnh nhân.</p>
                <div class="flex flex-col space-y-2">
                    <a href="${pageContext.request.contextPath}/admin/reports?action=patients" class="w-full text-center py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 font-medium rounded-lg transition">Xem trước (HTML)</a>
                    <div class="flex space-x-2">
                        <a href="${pageContext.request.contextPath}/admin/reports?action=export&format=excel&type=patients" class="flex-1 text-center py-2 bg-green-600 hover:bg-green-700 text-white font-medium rounded-lg transition"><i class="fas fa-file-csv mr-2"></i>CSV</a>
                        <a href="${pageContext.request.contextPath}/admin/reports?action=export&format=pdf&type=patients" target="_blank" class="flex-1 text-center py-2 bg-red-500 hover:bg-red-600 text-white font-medium rounded-lg transition"><i class="fas fa-file-pdf mr-2"></i>PDF</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
