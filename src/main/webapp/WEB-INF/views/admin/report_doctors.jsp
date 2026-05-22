<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Hiệu Suất Bác Sĩ — Admin JVCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 min-h-screen p-8">
    <div class="max-w-5xl mx-auto bg-white rounded-xl shadow-sm border p-8">
        <div class="flex justify-between items-center mb-8 border-b pb-4">
            <div>
                <h1 class="text-3xl font-bold text-green-700">Báo Cáo Hiệu Suất Bác Sĩ (HTML)</h1>
                <p class="text-gray-500 mt-1">Sắp xếp theo số lượng lịch hẹn giảm dần</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/reports" class="text-gray-500 hover:text-green-600 transition">
                <i class="fas fa-arrow-left mr-1"></i> Trở về
            </a>
        </div>

        <div class="overflow-x-auto rounded-lg border">
            <table class="w-full text-left">
                <thead class="bg-green-50 text-green-700">
                    <tr>
                        <th class="px-6 py-4 font-semibold w-16">STT</th>
                        <th class="px-6 py-4 font-semibold">Họ tên Bác sĩ</th>
                        <th class="px-6 py-4 font-semibold">Chuyên Khoa</th>
                        <th class="px-6 py-4 font-semibold text-center">Tổng Lịch Hẹn</th>
                        <th class="px-6 py-4 font-semibold text-center">Tổng Bệnh Án</th>
                    </tr>
                </thead>
                <tbody class="divide-y text-gray-700">
                    <c:forEach var="doc" items="${doctorPerformance}" varStatus="status">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 text-gray-500">${status.count}</td>
                            <td class="px-6 py-4 font-bold text-gray-800">${doc.fullName}</td>
                            <td class="px-6 py-4"><span class="bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">${doc.specialization}</span></td>
                            <td class="px-6 py-4 text-center font-medium text-blue-600">${doc.totalAppointments}</td>
                            <td class="px-6 py-4 text-center font-medium text-purple-600">${doc.totalRecords}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty doctorPerformance}">
                        <tr>
                            <td colspan="5" class="px-6 py-8 text-center text-gray-500">Chưa có dữ liệu thống kê.</td>
                        </tr>
                    </c:if>
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
