<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Lịch Hẹn — Admin JVCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50 min-h-screen p-8">
    <div class="max-w-4xl mx-auto bg-white rounded-xl shadow-sm border p-8">
        <div class="flex justify-between items-center mb-8 border-b pb-4">
            <div>
                <h1 class="text-3xl font-bold text-blue-700">Báo Cáo Lịch Hẹn (HTML)</h1>
                <p class="text-gray-500 mt-1">Dữ liệu tính đến thời điểm hiện tại</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/reports" class="text-gray-500 hover:text-blue-600 transition">
                <i class="fas fa-arrow-left mr-1"></i> Trở về
            </a>
        </div>

        <h2 class="text-xl font-bold text-gray-800 mb-4 mt-6 border-l-4 border-blue-500 pl-3">Trạng Thái Lịch Hẹn</h2>
        <div class="overflow-x-auto mb-8 rounded-lg border">
            <table class="w-full text-left">
                <thead class="bg-blue-50 text-blue-700">
                    <tr>
                        <th class="px-6 py-3 font-semibold">Trạng Thái</th>
                        <th class="px-6 py-3 font-semibold text-right">Số Lượng</th>
                    </tr>
                </thead>
                <tbody class="divide-y text-gray-700">
                    <c:set var="total" value="0"/>
                    <c:forEach var="entry" items="${appointmentStats}">
                        <c:set var="total" value="${total + entry.value}"/>
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-3">
                                <c:choose>
                                    <c:when test="${entry.key == 'PENDING'}"><span class="text-yellow-600 font-medium">Chờ xử lý</span></c:when>
                                    <c:when test="${entry.key == 'CONFIRMED'}"><span class="text-blue-600 font-medium">Đã xác nhận</span></c:when>
                                    <c:when test="${entry.key == 'COMPLETED'}"><span class="text-green-600 font-medium">Hoàn thành</span></c:when>
                                    <c:when test="${entry.key == 'CANCELLED'}"><span class="text-red-600 font-medium">Đã hủy</span></c:when>
                                    <c:otherwise>${entry.key}</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-6 py-3 text-right font-medium">${entry.value}</td>
                        </tr>
                    </c:forEach>
                    <tr class="bg-gray-100 font-bold">
                        <td class="px-6 py-3 text-gray-800">TỔNG CỘNG</td>
                        <td class="px-6 py-3 text-right text-blue-700">${total}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h2 class="text-xl font-bold text-gray-800 mb-4 mt-6 border-l-4 border-blue-500 pl-3">Lịch Hẹn Theo Tháng (Năm ${currentYear})</h2>
        <div class="overflow-x-auto rounded-lg border">
            <table class="w-full text-left">
                <thead class="bg-blue-50 text-blue-700">
                    <tr>
                        <th class="px-6 py-3 font-semibold">Tháng</th>
                        <th class="px-6 py-3 font-semibold text-right">Số Lượng</th>
                    </tr>
                </thead>
                <tbody class="divide-y text-gray-700">
                    <c:forEach var="i" begin="1" end="12">
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-3 font-medium">Tháng ${i}</td>
                            <td class="px-6 py-3 text-right">${empty monthlyStats[i] ? 0 : monthlyStats[i]}</td>
                        </tr>
                    </c:forEach>
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
