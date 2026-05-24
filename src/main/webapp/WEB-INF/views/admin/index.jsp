<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Thống Kê — Admin JVCare</title>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .stat-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); transition: transform 0.2s; border-left: 4px solid #3b82f6; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-icon { font-size: 2rem; color: #cbd5e1; float: right; }
        .chart-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); margin-bottom: 24px; }
    </style>
</head>
<body class="flex min-h-screen bg-muted/30 font-sans text-ink">
    <!-- Sidebar -->
    <aside class="hidden w-64 shrink-0 flex-col border-r border-border/60 bg-card md:flex">
        <div class="p-6">
            <span class="font-display font-bold text-xl text-brand">JVCare Admin</span>
        </div>
        <nav class="flex-1 space-y-1 px-4 py-4">
            <a href="${pageContext.request.contextPath}/admin/index" class="flex items-center gap-3 rounded-lg bg-brand-soft px-3 py-2 text-sm font-semibold text-brand">
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
            <a href="${pageContext.request.contextPath}/admin/reports" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                Báo cáo & Export
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

    <!-- Main Content -->
    <main class="flex-1 p-8 overflow-y-auto">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Dashboard Thống Kê</h1>
            <div class="text-sm text-gray-500">Ngày hôm nay: <span id="currentDate" class="font-semibold text-gray-700"></span></div>
        </div>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <!-- KPI Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="stat-card border-blue-500">
                <i class="fas fa-users stat-icon text-blue-200"></i>
                <div class="text-sm text-gray-500 font-medium mb-1">Tổng Người Dùng</div>
                <div class="text-3xl font-bold text-gray-800">${stats.totalUsers}</div>
                <div class="text-xs text-blue-500 mt-2"><i class="fas fa-arrow-up mr-1"></i>Hoạt động</div>
            </div>
            <div class="stat-card border-green-500">
                <i class="fas fa-user-md stat-icon text-green-200"></i>
                <div class="text-sm text-gray-500 font-medium mb-1">Tổng Bác Sĩ</div>
                <div class="text-3xl font-bold text-gray-800">${stats.totalDoctors}</div>
                <div class="text-xs text-green-500 mt-2">Đang công tác</div>
            </div>
            <div class="stat-card border-purple-500">
                <i class="fas fa-procedures stat-icon text-purple-200"></i>
                <div class="text-sm text-gray-500 font-medium mb-1">Tổng Bệnh Nhân</div>
                <div class="text-3xl font-bold text-gray-800">${stats.totalPatients}</div>
                <div class="text-xs text-purple-500 mt-2">Đã đăng ký</div>
            </div>
            <div class="stat-card border-orange-500">
                <i class="fas fa-calendar-check stat-icon text-orange-200"></i>
                <div class="text-sm text-gray-500 font-medium mb-1">Tổng Lịch Hẹn</div>
                <div class="text-3xl font-bold text-gray-800">${stats.totalAppointments}</div>
                <div class="text-xs text-orange-500 mt-2">Hệ thống</div>
            </div>
        </div>

        <!-- Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div class="lg:col-span-2 chart-container">
                <h3 class="text-lg font-semibold text-gray-700 mb-4">Lịch hẹn theo tháng (Năm ${currentYear})</h3>
                <canvas id="monthlyChart" height="100"></canvas>
            </div>
            <div class="chart-container">
                <h3 class="text-lg font-semibold text-gray-700 mb-4">Trạng thái lịch hẹn</h3>
                <canvas id="statusChart" height="200"></canvas>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('currentDate').innerText = new Date().toLocaleDateString('vi-VN');

        // Parse JSON data from server
        const monthlyData = ${monthlyJson};
        const statusData = ${statusJson};

        // Monthly Chart (Bar)
        const ctxMonthly = document.getElementById('monthlyChart').getContext('2d');
        const labels = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
        const dataValues = [];
        for (let i = 1; i <= 12; i++) {
            dataValues.push(monthlyData[i] || 0);
        }

        new Chart(ctxMonthly, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số lượng lịch hẹn',
                    data: dataValues,
                    backgroundColor: 'rgba(59, 130, 246, 0.6)',
                    borderColor: 'rgb(59, 130, 246)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });

        // Status Chart (Doughnut)
        const ctxStatus = document.getElementById('statusChart').getContext('2d');
        const statusLabels = ['Chờ xử lý', 'Đã xác nhận', 'Hoàn thành', 'Đã hủy'];
        const statusValues = [
            statusData['PENDING'] || 0,
            statusData['CONFIRMED'] || 0,
            statusData['COMPLETED'] || 0,
            statusData['CANCELLED'] || 0
        ];
        const statusColors = ['#f59e0b', '#3b82f6', '#10b981', '#ef4444'];

        new Chart(ctxStatus, {
            type: 'doughnut',
            data: {
                labels: statusLabels,
                datasets: [{
                    data: statusValues,
                    backgroundColor: statusColors,
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                cutout: '65%',
                plugins: {
                    legend: { position: 'bottom' }
                }
            }
        });
    </script>
</body>
</html>
