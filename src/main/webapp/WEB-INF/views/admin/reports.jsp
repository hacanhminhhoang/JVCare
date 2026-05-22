<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo & Export — Admin JVCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', system-ui, sans-serif; background-color: #f8fafc; color: #0f172a; }
        .report-card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); border-top: 4px solid transparent; transition: all 0.2s; }
        .report-card:hover { transform: translateY(-5px); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); }
        .report-card.blue { border-top-color: #3b82f6; }
        .report-card.green { border-top-color: #10b981; }
        .report-card.purple { border-top-color: #8b5cf6; }
    </style>
</head>
<body class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="w-64 bg-white border-r shadow-sm flex flex-col">
        <div class="p-6 border-b text-center">
            <h2 class="text-2xl font-bold text-blue-600"><i class="fas fa-hospital-user mr-2"></i>JVCare</h2>
        </div>
        <nav class="flex-1 p-4 space-y-2">
            <a href="${pageContext.request.contextPath}/admin/index" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-chart-line w-5"></i><span>Tổng quan</span></a>
            <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-users w-5"></i><span>Nhân viên</span></a>
            <a href="${pageContext.request.contextPath}/admin/doctors" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-user-md w-5"></i><span>Bác sĩ</span></a>
            <a href="${pageContext.request.contextPath}/admin/patients" class="flex items-center space-x-3 text-gray-600 hover:bg-gray-50 px-4 py-3 rounded-lg"><i class="fas fa-procedures w-5"></i><span>Bệnh nhân</span></a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="flex items-center space-x-3 text-blue-600 bg-blue-50 px-4 py-3 rounded-lg font-medium"><i class="fas fa-file-export w-5"></i><span>Báo cáo & Export</span></a>
        </nav>
        <div class="p-4 border-t">
            <a href="${pageContext.request.contextPath}/login" class="flex items-center space-x-3 text-red-500 hover:bg-red-50 px-4 py-2 rounded-lg transition"><i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span></a>
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
                    <button disabled class="w-full text-center py-2 bg-gray-100 text-gray-400 font-medium rounded-lg cursor-not-allowed">Chỉ xuất file</button>
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
