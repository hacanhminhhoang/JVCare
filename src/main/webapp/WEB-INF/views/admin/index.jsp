<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Thống Kê — Admin JVCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', system-ui, sans-serif; background-color: #f8fafc; color: #0f172a; }
        .stat-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); transition: transform 0.2s; border-left: 4px solid #3b82f6; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-icon { font-size: 2rem; color: #cbd5e1; float: right; }
        .chart-container { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); margin-bottom: 24px; }
    </style>
</head>
<body class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="w-64 bg-white border-r shadow-sm flex flex-col">
        <div class="p-6 border-b text-center">
            <h2 class="text-2xl font-bold text-blue-600"><i class="fas fa-hospital-user mr-2"></i>JVCare</h2>
            <p class="text-sm text-gray-500">Quản trị viên</p>
        </div>
        <nav class="flex-1 p-4 space-y-2">
            <a href="${pageContext.request.contextPath}/admin/index" class="flex items-center space-x-3 text-blue-600 bg-blue-50 px-4 py-3 rounded-lg font-medium"><i class="fas fa-chart-line w-5"></i><span>Tổng quan</span></a>
            <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-users w-5"></i><span>Nhân viên</span></a>
            <a href="${pageContext.request.contextPath}/admin/doctors" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-user-md w-5"></i><span>Bác sĩ</span></a>
            <a href="${pageContext.request.contextPath}/admin/patients" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-procedures w-5"></i><span>Bệnh nhân</span></a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-file-export w-5"></i><span>Báo cáo & Export</span></a>
        </nav>
        <div class="p-4 border-t">
            <a href="${pageContext.request.contextPath}/login" class="flex items-center space-x-3 text-red-500 hover:bg-red-50 px-4 py-2 rounded-lg transition"><i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span></a>
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
