<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Thống Kê Bệnh Nhân — Admin JVCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 min-h-screen p-8">
    <div class="max-w-4xl mx-auto bg-white rounded-xl shadow-sm border p-8">
        <div class="flex justify-between items-center mb-8 border-b pb-4">
            <div>
                <h1 class="text-3xl font-bold text-purple-700">Báo Cáo Thống Kê Bệnh Nhân (HTML)</h1>
                <p class="text-gray-500 mt-1">Dữ liệu tính đến thời điểm hiện tại</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/reports" class="text-gray-500 hover:text-purple-600 transition">
                <i class="fas fa-arrow-left mr-1"></i> Trở về
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-purple-50 p-6 rounded-lg border border-purple-100 text-center">
                <div class="text-4xl font-bold text-purple-700 mb-2">${patientStats['totalPatients']}</div>
                <div class="text-sm font-medium text-purple-600 uppercase tracking-wider">Tổng bệnh nhân</div>
            </div>
            <div class="bg-blue-50 p-6 rounded-lg border border-blue-100 text-center">
                <div class="text-4xl font-bold text-blue-700 mb-2">${patientStats['malePatients']}</div>
                <div class="text-sm font-medium text-blue-600 uppercase tracking-wider">Nam giới</div>
            </div>
            <div class="bg-pink-50 p-6 rounded-lg border border-pink-100 text-center">
                <div class="text-4xl font-bold text-pink-700 mb-2">${patientStats['femalePatients']}</div>
                <div class="text-sm font-medium text-pink-600 uppercase tracking-wider">Nữ giới</div>
            </div>
        </div>

        <h2 class="text-xl font-bold text-gray-800 mb-4 border-l-4 border-purple-500 pl-3">Chi Tiết Nhân Khẩu Học</h2>
        <div class="overflow-x-auto rounded-lg border mb-8">
            <table class="w-full text-left">
                <thead class="bg-purple-50 text-purple-700">
                    <tr>
                        <th class="px-6 py-3 font-semibold">Chỉ Số</th>
                        <th class="px-6 py-3 font-semibold text-right">Giá Trị</th>
                    </tr>
                </thead>
                <tbody class="divide-y text-gray-700">
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-3 font-medium">Tổng số lượng bệnh nhân đã đăng ký</td>
                        <td class="px-6 py-3 text-right font-bold text-purple-700">${patientStats['totalPatients']}</td>
                    </tr>
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-3 font-medium">Tỷ lệ bệnh nhân nam</td>
                        <td class="px-6 py-3 text-right">
                            <c:if test="${patientStats['totalPatients'] > 0}">
                                ${Math.round(patientStats['malePatients'] * 100.0 / patientStats['totalPatients'])}%
                            </c:if>
                            <c:if test="${patientStats['totalPatients'] == 0}">0%</c:if>
                        </td>
                    </tr>
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-3 font-medium">Tỷ lệ bệnh nhân nữ</td>
                        <td class="px-6 py-3 text-right">
                            <c:if test="${patientStats['totalPatients'] > 0}">
                                ${Math.round(patientStats['femalePatients'] * 100.0 / patientStats['totalPatients'])}%
                            </c:if>
                            <c:if test="${patientStats['totalPatients'] == 0}">0%</c:if>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div class="mt-8 flex justify-center space-x-4">
            <button onclick="window.print()" class="px-6 py-2 bg-gray-800 text-white font-medium rounded hover:bg-gray-700 transition">
                <i class="fas fa-print mr-2"></i> In báo cáo này
            </button>
        </div>
    </div>
</body>
</html>
