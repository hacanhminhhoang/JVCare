<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jvcare.model.Appointment" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Lịch khám của tôi - JVCare</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: "#0f766e",
                        soft: "#f0fdfa",
                        border: "#d1d5db"
                    }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<div class="max-w-7xl mx-auto p-6">

    <!-- HEADER -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-brand">
            Đặt lịch khám
        </h1>

        <p class="text-gray-500 mt-2">
            Hệ thống đặt lịch khám trực tuyến JVCare
        </p>
    </div>

    <!-- MESSAGE -->
    <%
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");

        if(message != null){
    %>

    <div class="mb-6 bg-green-100 border border-green-300 text-green-700 px-4 py-3 rounded-xl">
        <%= message %>
    </div>

    <%
            session.removeAttribute("message");
        }

        if(error != null){
    %>

    <div class="mb-6 bg-red-100 border border-red-300 text-red-700 px-4 py-3 rounded-xl">
        <%= error %>
    </div>

    <%
            session.removeAttribute("error");
        }
    %>

    <!-- FORM -->
    <div class="bg-white rounded-3xl shadow-sm border border-gray-200 p-8 mb-10">

        <h2 class="text-2xl font-bold text-gray-800 mb-6">
            Thông tin đặt lịch
        </h2>

        <form method="post"
              action="${pageContext.request.contextPath}/patient/appointments">

            <input type="hidden" name="action" value="create">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                <!-- Họ tên -->
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">
                        Họ tên
                    </label>

                    <input type="text"
                           name="fullName"
                           required
                           class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand">
                </div>

                <!-- CCCD -->
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">
                        CCCD
                    </label>

                    <input type="text"
                           name="idCard"
                           class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand">
                </div>

                <!-- Ngày sinh -->
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">
                        Ngày sinh
                    </label>

                    <input type="date"
                           name="dateOfBirth"
                           class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand">
                </div>

                <!-- Địa chỉ -->
                <div>
                    <label class="block mb-2 font-semibold text-gray-700">
                        Địa chỉ
                    </label>

                    <input type="text"
                           name="address"
                           class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand">
                </div>

                <!-- Ngày giờ -->
                <div class="md:col-span-2">
                    <label class="block mb-2 font-semibold text-gray-700">
                        Ngày giờ khám
                    </label>

                    <input type="datetime-local"
                           name="datetime"
                           required
                           class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand">
                </div>

                <!-- Lý do -->
                <div class="md:col-span-2">
                    <label class="block mb-2 font-semibold text-gray-700">
                        Lý do khám
                    </label>

                    <textarea name="reason"
                              rows="4"
                              class="w-full rounded-xl border border-gray-300 px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand"></textarea>
                </div>

            </div>

            <!-- BUTTON -->
            <div class="mt-8">
                <button type="submit"
                        class="bg-brand hover:bg-teal-800 text-white font-bold px-8 py-3 rounded-xl transition">
                    Đặt lịch khám
                </button>
            </div>

        </form>

    </div>

    <!-- TABLE -->
    <div class="bg-white rounded-3xl shadow-sm border border-gray-200 p-8">

        <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-gray-800">
                Lịch khám của tôi
            </h2>
        </div>

        <div class="overflow-x-auto">

            <table class="w-full border-collapse">

                <thead>
                <tr class="bg-soft text-gray-700">

                    <th class="p-4 text-center">ID</th>
                    <th class="p-4 text-center">Ngày khám</th>
                    <th class="p-4 text-center">Giờ khám</th>
                    <th class="p-4 text-center">Trạng thái</th>
                    <th class="p-4 text-center">Lý do</th>

                </tr>
                </thead>

                <tbody>

                <%
                    List<Appointment> list =
                            (List<Appointment>) request.getAttribute("appointments");

                    if(list != null){

                        for(Appointment a : list){
                %>

                <tr class="border-b hover:bg-gray-50 transition">

                    <td class="p-4 text-center font-semibold">
                        #<%= a.getAppointmentId() %>
                    </td>

                    <td class="p-4 text-center">
                        <%= a.getAppointmentDate() %>
                    </td>

                    <td class="p-4 text-center">
                        <%= a.getAppointmentTime() %>
                    </td>

                    <td class="p-4 text-center">

                        <%
                            String status = a.getStatus();

                            String color = "bg-gray-100 text-gray-700";

                            if("PENDING".equals(status)){
                                color = "bg-yellow-100 text-yellow-700";
                            }
                            else if("CONFIRMED".equals(status)){
                                color = "bg-blue-100 text-blue-700";
                            }
                            else if("COMPLETED".equals(status)){
                                color = "bg-green-100 text-green-700";
                            }
                        %>

                        <span class="px-3 py-1 rounded-full text-sm font-semibold <%= color %>">
                            <%= status %>
                        </span>

                    </td>

                    <td class="p-4">
                        <%= a.getReason() %>
                    </td>

                </tr>

                <%
                        }
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>
</html>