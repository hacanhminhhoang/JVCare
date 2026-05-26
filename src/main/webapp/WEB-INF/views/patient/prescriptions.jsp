<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <title>Đơn thuốc - JVCare</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: "#0f766e",
                        soft: "#f0fdfa",
                        border: "#d1d5db",
                        ink: "#0f172a"
                    }
                }
            }
        }
    </script>

    <style>

        body{
            font-family: Arial, sans-serif;
        }

        .glass-card{
            background: rgba(255,255,255,0.75);
            backdrop-filter: blur(12px);
        }

        .medicine-card{
            transition: all 0.25s ease;
        }

        .medicine-card:hover{
            transform: translateY(-4px);
        }

        .gradient-text{
            background: linear-gradient(to right, #0f766e, #14b8a6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .pill-badge{
            box-shadow: 0 4px 12px rgba(16,185,129,0.15);
        }

    </style>

</head>

<body class="bg-gray-100 min-h-screen flex">

<!-- SIDEBAR -->
<aside class="w-64 border-r border-border/60 bg-white shadow-sm flex flex-col hidden md:flex">

    <!-- LOGO -->
    <div class="flex h-16 shrink-0 items-center px-6 border-b">

        <span class="font-bold text-2xl text-brand">
            JVCare
        </span>

    </div>

    <!-- MENU -->
    <nav class="flex-1 space-y-1 px-4 py-4">

        <c:set var="uri" value="${pageContext.request.requestURI}" />

        <c:set var="isIndex" value="${uri.endsWith('/patient/index')}" />
        <c:set var="isProfile" value="${uri.endsWith('/patient/profile')}" />
        <c:set var="isHistory" value="${uri.contains('/patient/medical-history')}" />
        <c:set var="isAppt" value="${uri.endsWith('/patient/appointments')}" />
        <c:set var="isRx" value="${uri.endsWith('/patient/prescriptions')}" />
        <c:set var="isAi" value="${uri.endsWith('/patient/ai')}" />

        <!-- HOME -->
        <a href="${pageContext.request.contextPath}/patient/index"
           class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm
           ${isIndex ? 'bg-soft font-semibold text-brand'
           : 'font-medium text-gray-600 hover:bg-soft hover:text-brand'}">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="20"
                 height="20"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                <polyline points="9 22 9 12 15 12 15 22"></polyline>

            </svg>

            Bệnh án tóm tắt
        </a>

        <!-- PROFILE -->
        <a href="${pageContext.request.contextPath}/patient/profile"
           class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm
           ${isProfile ? 'bg-soft font-semibold text-brand'
           : 'font-medium text-gray-600 hover:bg-soft hover:text-brand'}">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="20"
                 height="20"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>

            </svg>

            Hồ sơ cá nhân
        </a>

        <!-- HISTORY -->
        <a href="${pageContext.request.contextPath}/patient/medical-history"
           class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm
           ${isHistory ? 'bg-soft font-semibold text-brand'
           : 'font-medium text-gray-600 hover:bg-soft hover:text-brand'}">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="20"
                 height="20"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <path d="M12 20h9"></path>
                <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"></path>

            </svg>

            Lịch sử khám bệnh
        </a>

        <!-- APPOINTMENT -->
        <a href="${pageContext.request.contextPath}/patient/appointments"
           class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm
           ${isAppt ? 'bg-soft font-semibold text-brand'
           : 'font-medium text-gray-600 hover:bg-soft hover:text-brand'}">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="20"
                 height="20"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <rect width="18" height="18" x="3" y="4" rx="2"></rect>
                <line x1="16" x2="16" y1="2" y2="6"></line>
                <line x1="8" x2="8" y1="2" y2="6"></line>
                <line x1="3" x2="21" y1="10" y2="10"></line>

            </svg>

            Lịch tái khám & đặt lịch
        </a>

        <!-- PRESCRIPTION -->
        <a href="${pageContext.request.contextPath}/patient/prescriptions"
           class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm
           ${isRx ? 'bg-soft font-semibold text-brand'
           : 'font-medium text-gray-600 hover:bg-soft hover:text-brand'}">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="20"
                 height="20"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"></path>
                <path d="m8.5 8.5 7 7"></path>

            </svg>

            Đơn thuốc
        </a>

        <!-- AI -->
        <a href="${pageContext.request.contextPath}/patient/ai"
           class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm
           ${isAi ? 'bg-soft font-semibold text-brand'
           : 'font-medium text-gray-600 hover:bg-soft hover:text-brand'}">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="20"
                 height="20"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275Z"></path>

            </svg>

            Trợ lý AI
        </a>

    </nav>

    <!-- FOOTER -->
    <div class="border-t border-border/60 p-4 space-y-2">

        <a href="${pageContext.request.contextPath}/"
           class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-gray-600 hover:bg-gray-100 transition">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="18"
                 height="18"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                <polyline points="9 22 9 12 15 12 15 22"></polyline>

            </svg>

            Trang chủ
        </a>

        <a href="${pageContext.request.contextPath}/login"
           class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-red-600 hover:bg-red-50 transition">

            <svg xmlns="http://www.w3.org/2000/svg"
                 width="18"
                 height="18"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="2"
                 viewBox="0 0 24 24">

                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                <polyline points="16 17 21 12 16 7"></polyline>
                <line x1="21" x2="9" y1="12" y2="12"></line>

            </svg>

            Đăng xuất
        </a>

    </div>

</aside>

<!-- MAIN -->
<div class="flex-1 p-8">

    <!-- HEADER -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-5 mb-8">

        <div>

            <h1 class="text-4xl font-black gradient-text">
                Đơn thuốc
            </h1>

            <p class="mt-2 text-gray-500">
                Danh sách thuốc được bác sĩ kê cho bạn
            </p>

        </div>

        <div class="glass-card rounded-2xl px-5 py-3 border border-white/40 shadow-sm">

            <div class="flex items-center gap-3">

                <div class="text-2xl">
                    💊
                </div>

                <div>

                    <div class="text-sm text-gray-500">
                        Tổng đơn thuốc
                    </div>

                    <div class="text-xl font-bold text-brand">
                        ${prescriptions.size()}
                    </div>

                </div>

            </div>

        </div>

    </div>

    <!-- EMPTY -->
    <c:if test="${empty prescriptions}">

        <div class="glass-card rounded-3xl border border-border p-14 text-center shadow-sm">

            <div class="text-7xl mb-5">
                💊
            </div>

            <h2 class="text-3xl font-bold text-ink">
                Chưa có đơn thuốc
            </h2>

            <p class="mt-3 text-gray-500 text-lg">
                Hiện tại bác sĩ chưa kê đơn thuốc nào cho bạn.
            </p>

        </div>

    </c:if>

    <!-- LIST -->
    <div class="grid gap-6">

        <c:forEach var="p" items="${prescriptions}">

            <div class="medicine-card glass-card rounded-3xl border border-white/40 shadow-sm overflow-hidden">

                <!-- TOP -->
                <div class="bg-gradient-to-r from-teal-600 to-emerald-500 px-6 py-5 text-white">

                    <div class="flex items-center justify-between">

                        <div class="flex items-center gap-4">

                            <div class="h-14 w-14 rounded-2xl bg-white/20 flex items-center justify-center text-3xl">
                                💊
                            </div>

                            <div>

                                <h2 class="text-2xl font-bold">
                                    ${p.medicationName}
                                </h2>

                                <div class="mt-1 text-sm text-white/80">

                                    Ngày kê:

                                    <fmt:formatDate
                                            value="${p.prescriptionDate}"
                                            pattern="dd/MM/yyyy" />

                                </div>

                            </div>

                        </div>

                        <div class="pill-badge bg-white text-emerald-600 font-bold px-4 py-2 rounded-full">

                            Active

                        </div>

                    </div>

                </div>

                <!-- CONTENT -->
                <div class="p-6">

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">

                        <!-- DOSAGE -->
                        <div class="rounded-2xl bg-gray-50 border border-gray-100 p-5">

                            <div class="flex items-center gap-2 text-sm text-gray-500">

                                💉 Liều dùng

                            </div>

                            <div class="mt-2 text-lg font-bold text-gray-800">

                                ${p.dosage != null ? p.dosage : "Không có"}

                            </div>

                        </div>

                        <!-- FREQUENCY -->
                        <div class="rounded-2xl bg-gray-50 border border-gray-100 p-5">

                            <div class="flex items-center gap-2 text-sm text-gray-500">

                                ⏰ Tần suất

                            </div>

                            <div class="mt-2 text-lg font-bold text-gray-800">

                                ${p.frequency != null ? p.frequency : "Không có"}

                            </div>

                        </div>

                        <!-- INSTRUCTIONS -->
                        <div class="md:col-span-2 rounded-2xl bg-gray-50 border border-gray-100 p-5">

                            <div class="flex items-center gap-2 text-sm text-gray-500">

                                📋 Hướng dẫn sử dụng

                            </div>

                            <div class="mt-3 text-gray-700 leading-8">

                                ${p.instructions != null ? p.instructions : "Không có hướng dẫn"}

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </c:forEach>

    </div>

</div>

</body>

</html>