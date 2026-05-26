<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jvcare.model.Appointment" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
                        background: "oklch(0.99 0.005 180)",
                        ink: "oklch(0.14 0.03 210)",
                        brand: "oklch(0.55 0.13 195)",
                        "brand-foreground": "oklch(0.99 0.005 180)",
                        "brand-soft": "oklch(0.95 0.04 190)",
                        muted: "oklch(0.96 0.012 200)",
                        "muted-foreground": "oklch(0.5 0.025 215)",
                        border: "oklch(0.92 0.015 200)"
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

<body class="bg-muted min-h-screen text-ink font-sans">

<div class="flex min-h-screen">

    <!-- SIDEBAR -->

    <aside class="w-64 border-r border-border/60 bg-white shadow-sm flex flex-col hidden md:flex">

        <div class="flex h-16 shrink-0 items-center px-6">
            <span class="font-display font-bold text-xl text-brand">
                JVCare
            </span>
        </div>

        <nav class="flex-1 space-y-1 px-4 py-4">

            <c:set var="uri" value="${pageContext.request.requestURI}" />
            <c:set var="isIndex" value="${uri.endsWith('/patient/index')}" />
            <c:set var="isProfile" value="${uri.endsWith('/patient/profile')}" />
            <c:set var="isHistory" value="${uri.contains('/patient/medical-history')}" />
            <c:set var="isAppt" value="${uri.endsWith('/patient/appointments') || uri.endsWith('/patient/book-appointment')}" />
            <c:set var="isRx" value="${uri.endsWith('/patient/prescriptions')}" />
            <c:set var="isAi" value="${uri.endsWith('/patient/ai')}" />

            <a href="${pageContext.request.contextPath}/patient/index"
               class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isIndex ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">

                <svg xmlns="http://www.w3.org/2000/svg"
                     width="20"
                     height="20"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">
                    <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" x2="8" y1="13" y2="13"></line>
                    <line x1="16" x2="8" y1="17" y2="17"></line>
                    <line x1="10" x2="8" y1="9" y2="9"></line>
                </svg>

                Bệnh án tóm tắt
            </a>

            <a href="${pageContext.request.contextPath}/patient/profile"
               class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isProfile ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">

                <svg xmlns="http://www.w3.org/2000/svg"
                     width="20"
                     height="20"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">
                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>

                Hồ sơ cá nhân
            </a>

            <a href="${pageContext.request.contextPath}/patient/medical-history"
               class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isHistory ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">

                <svg xmlns="http://www.w3.org/2000/svg"
                     width="20"
                     height="20"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">
                    <path d="M12 20h9"></path>
                    <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"></path>
                </svg>

                Lịch sử khám bệnh
            </a>

            <a href="${pageContext.request.contextPath}/patient/appointments"
               class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isAppt ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">

                <svg xmlns="http://www.w3.org/2000/svg"
                     width="20"
                     height="20"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">
                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2"/>
                    <line x1="16" x2="16" y1="2" y2="6"/>
                    <line x1="8" x2="8" y1="2" y2="6"/>
                    <line x1="3" x2="21" y1="10" y2="10"/>
                </svg>

                Lịch tái khám & đặt lịch
            </a>
<!-- Đơn thuốc -->
<a href="${pageContext.request.contextPath}/patient/prescriptions"
   class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-muted-foreground hover:bg-soft hover:text-brand">

    <svg xmlns="http://www.w3.org/2000/svg"
         width="20"
         height="20"
         viewBox="0 0 24 24"
         fill="none"
         stroke="currentColor"
         stroke-width="2"
         stroke-linecap="round"
         stroke-linejoin="round">

        <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/>
        <path d="m8.5 8.5 7 7"/>

    </svg>

    Đơn thuốc
</a>

<!-- Trợ lý AI -->
<a href="${pageContext.request.contextPath}/patient/ai"
   class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-muted-foreground hover:bg-soft hover:text-brand">

    <svg xmlns="http://www.w3.org/2000/svg"
         width="20"
         height="20"
         viewBox="0 0 24 24"
         fill="none"
         stroke="currentColor"
         stroke-width="2"
         stroke-linecap="round"
         stroke-linejoin="round">

        <path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275Z"></path>

    </svg>

    Trợ lý AI
</a>
        </nav>
    </aside>

    <!-- CONTENT -->

    <main class="flex-1 p-8">

        <!-- HEADER -->

        <div class="mb-8">

            <h1 class="text-3xl font-bold text-brand">
                Đặt lịch khám
            </h1>

            <p class="text-muted-foreground mt-2">
                Hệ thống đặt lịch khám trực tuyến JVCare
            </p>

        </div>

        <!-- MESSAGE -->

        <%
            String message = (String) session.getAttribute("message");
            String error = (String) session.getAttribute("error");

            if(message != null){
        %>

        <div class="mb-6 rounded-xl bg-green-50 p-4 text-green-700 border border-green-200">
            <%= message %>
        </div>

        <%
                session.removeAttribute("message");
            }

            if(error != null){
        %>

        <div class="mb-6 rounded-xl bg-red-50 p-4 text-red-700 border border-red-200">
            <%= error %>
        </div>

        <%
                session.removeAttribute("error");
            }
        %>

        <!-- FORM -->

        <div class="bg-white rounded-3xl shadow-sm border border-border p-8 mb-10">

            <h2 class="text-2xl font-bold mb-6">
                Thông tin đặt lịch
            </h2>

            <form method="post"
                  action="${pageContext.request.contextPath}/patient/appointments">

                <input type="hidden" name="action" value="create">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                    <!-- HỌ TÊN -->
<div>
    <label class="block mb-2 font-semibold">
        Họ tên
    </label>

    <input type="text"
           value="${patient.fullName}"
           readonly
           class="w-full rounded-xl border border-border bg-gray-100 px-4 py-3">
</div>

<!-- CCCD -->
<div>
    <label class="block mb-2 font-semibold">
        CCCD
    </label>

    <input type="text"
           value="${patient.idCard}"
           readonly
           class="w-full rounded-xl border border-border bg-gray-100 px-4 py-3">
</div>

<!-- NGÀY SINH -->
<div>
    <label class="block mb-2 font-semibold">
        Ngày sinh
    </label>

    <input type="text"
           value="${patient.dateOfBirth}"
           readonly
           class="w-full rounded-xl border border-border bg-gray-100 px-4 py-3">
</div>

<!-- ĐỊA CHỈ -->
<div>
    <label class="block mb-2 font-semibold">
        Địa chỉ
    </label>

    <input type="text"
           value="${patient.address}"
           readonly
           class="w-full rounded-xl border border-border bg-gray-100 px-4 py-3">
</div>

                    <div class="md:col-span-2">

                        <label class="block mb-2 font-semibold">
                            Ngày giờ khám
                        </label>

                        <input type="datetime-local"
                               name="datetime"
                               required
                               class="w-full rounded-xl border border-border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand">
                    </div>

                    <div class="md:col-span-2">

                        <label class="block mb-2 font-semibold">
                            Lý do khám
                        </label>

                        <textarea name="reason"
                                  rows="4"
                                  class="w-full rounded-xl border border-border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-brand"></textarea>
                    </div>

                </div>

                <div class="mt-8">

                    <button type="submit"
                            class="rounded-xl bg-brand px-8 py-3 text-sm font-bold text-white hover:opacity-90 transition">
                        Đặt lịch khám
                    </button>

                </div>

            </form>

        </div>

        <!-- TABLE -->

        <div class="bg-white rounded-3xl shadow-sm border border-border p-8">

            <h2 class="text-2xl font-bold mb-6">
                Lịch khám của tôi
            </h2>

            <div class="overflow-x-auto">

                <table class="w-full border-collapse">

                    <thead>

                    <tr class="bg-brand-soft text-ink">

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

    </main>

</div>

</body>
</html>