<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cổng Bác Sĩ — Lịch hẹn khám</title>
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
</head>
<body class="min-h-screen bg-background font-sans text-ink flex">
    
    <aside class="w-64 border-r border-border/60 bg-card shadow-sm flex flex-col hidden md:flex shrink-0 h-screen sticky top-0">
        <div class="flex h-16 shrink-0 items-center px-6">
            <span class="font-display font-bold text-xl text-brand">JVCare Doctor</span>
        </div>
        <nav class="flex-1 space-y-1 px-4 py-4">
            <c:set var="uri" value="${pageContext.request.requestURI}" />
            <c:set var="isPatients" value="${uri.endsWith('/doctor/index') || uri.endsWith('/doctor')}" />
            <c:set var="isAppt" value="${uri.endsWith('/doctor/appointments')}" />
            <c:set var="isRecords" value="${uri.endsWith('/doctor/medical-records')}" />
            
            <a href="${pageContext.request.contextPath}/doctor/index" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isPatients ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                Danh sách bệnh nhân
            </a>
            
            <a href="${pageContext.request.contextPath}/doctor/appointments" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isAppt ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                Lịch hẹn khám
            </a>

            <a href="${pageContext.request.contextPath}/doctor/medical-records" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm ${isRecords ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" x2="8" y1="13" y2="13"/><line x1="16" x2="8" y1="17" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                Danh sách Bệnh án
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

    <main class="flex-1 overflow-auto bg-muted/30">
        <header class="sticky top-0 z-10 flex h-16 items-center justify-between border-b border-border/60 bg-card px-6 shadow-sm md:hidden">
            <span class="font-display text-xl font-bold text-brand">JVCare Doctor</span>
            <span class="text-sm font-medium"><c:out value="${sessionScope.user.fullName}"/></span>
        </header>

        <div class="mx-auto max-w-7xl p-6 md:p-10">
            
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-8">
                <div>
                    <h1 class="font-display font-bold text-3xl text-ink tracking-tight">Quản lý lịch hẹn khám</h1>
                    <p class="text-sm font-medium text-muted-foreground mt-1">Xem, xác nhận và cập nhật trạng thái các ca khám bệnh của bạn.</p>
                </div>
            </div>

            <c:if test="${not empty sessionScope.message}">
                <div class="mb-6 p-4 rounded-2xl bg-green-50 border border-green-200 text-sm font-semibold text-green-700 flex items-center gap-3">
                    <svg class="h-5 w-5 shrink-0 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="mb-6 p-4 rounded-2xl bg-red-50 border border-red-200 text-sm font-semibold text-red-700 flex items-center gap-3">
                    <svg class="h-5 w-5 shrink-0 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <div class="flex border-b border-border/60 gap-2 overflow-x-auto pb-px">
                <a href="?tab=all" class="px-5 py-3 text-sm font-bold border-b-2 transition whitespace-nowrap ${currentTab == 'all' ? 'border-brand text-brand bg-brand-soft/30 rounded-t-xl' : 'border-transparent text-muted-foreground hover:text-ink'}">
                    Tất cả
                </a>
                <a href="?tab=pending" class="px-5 py-3 text-sm font-bold border-b-2 transition whitespace-nowrap ${currentTab == 'pending' ? 'border-brand text-brand bg-brand-soft/30 rounded-t-xl' : 'border-transparent text-muted-foreground hover:text-ink'}">
                    Chưa xác nhận
                </a>
                <a href="?tab=confirmed" class="px-5 py-3 text-sm font-bold border-b-2 transition whitespace-nowrap ${currentTab == 'confirmed' ? 'border-brand text-brand bg-brand-soft/30 rounded-t-xl' : 'border-transparent text-muted-foreground hover:text-ink'}">
                    Đã nhận lịch
                </a>
                <a href="?tab=completed" class="px-5 py-3 text-sm font-bold border-b-2 transition whitespace-nowrap ${currentTab == 'completed' ? 'border-brand text-brand bg-brand-soft/30 rounded-t-xl' : 'border-transparent text-muted-foreground hover:text-ink'}">
                    Hoàn thành
                </a>
            </div>

            <div class="mt-6 grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                <c:forEach var="a" items="${appointments}">
                    <div class="appointment-card group relative flex flex-col overflow-hidden rounded-3xl border border-border/60 bg-card p-5 shadow-sm transition hover:shadow-lg">
                        
                        <div class="flex items-start justify-between border-b border-border/40 pb-4 mb-4">
                            <div class="flex items-center gap-3">
                                <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-brand-soft font-display text-xl font-bold text-brand">
                                    <fmt:formatDate value="${a.appointmentDate}" pattern="dd" />
                                </div>
                                <div>
                                    <div class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">
                                        Tháng <fmt:formatDate value="${a.appointmentDate}" pattern="MM, yyyy" />
                                    </div>
                                    <div class="font-display font-bold text-ink text-lg">
                                        <fmt:formatDate value="${a.appointmentTime}" pattern="HH:mm" />
                                    </div>
                                </div>
                            </div>
                            <div class="shrink-0 text-right ml-2">
                                <c:choose>
                                    <c:when test="${a.status == 'PENDING'}">
                                        <span class="inline-block rounded-full bg-yellow-100 px-2.5 py-1 text-xs font-bold text-yellow-700 whitespace-nowrap">Mới</span>
                                    </c:when>
                                    <c:when test="${a.status == 'CONFIRMED'}">
                                        <span class="inline-block rounded-full bg-blue-100 px-2.5 py-1 text-xs font-bold text-blue-700 whitespace-nowrap">Đã nhận</span>
                                    </c:when>
                                    <c:when test="${a.status == 'COMPLETED'}">
                                        <span class="inline-block rounded-full bg-green-100 px-2.5 py-1 text-xs font-bold text-green-700 whitespace-nowrap">Hoàn tất</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="flex-1">
                            <h3 class="font-bold text-ink text-lg mb-1"><c:out value="${a.patientName}"/></h3>
                            <p class="text-sm font-semibold text-ink line-clamp-1 mb-2">Lý do: <span class="font-normal text-muted-foreground"><c:out value="${a.reason}" default="Không rõ"/></span></p>
                            
                            <c:if test="${a.status == 'CONFIRMED' || a.status == 'COMPLETED'}">
                                <p class="text-xs text-muted-foreground mt-2">Bs phụ trách: <b><c:out value="${a.doctorName}"/></b></p>
                            </c:if>
                        </div>

                        <div class="mt-5 border-t border-border/60 pt-4">
                            <c:choose>
                                <c:when test="${a.status == 'PENDING'}">
                                    <form action="${pageContext.request.contextPath}/doctor/appointments" method="POST">
                                        <input type="hidden" name="action" value="assign" />
                                        <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                        <button type="submit" class="w-full flex items-center justify-center gap-2 rounded-xl bg-brand py-2.5 text-sm font-bold text-brand-foreground hover:opacity-90 transition">
                                            Xác nhận nhận khám
                                        </button>
                                    </form>
                                </c:when>
                                <c:when test="${a.status == 'CONFIRMED'}">
                                    <c:choose>
                                        <c:when test="${a.doctorId == currentDoctorId}">
                                            <a href="${pageContext.request.contextPath}/doctor/appointment-detail?id=${a.appointmentId}" class="w-full flex items-center justify-center gap-2 rounded-xl border border-brand bg-brand-soft py-2.5 text-sm font-bold text-brand hover:bg-brand hover:text-brand-foreground transition">
                                                Xem & Cập nhật
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full rounded-xl bg-muted py-2.5 text-sm font-semibold text-muted-foreground text-center">
                                                Hồ sơ đã được tiếp nhận
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${a.status == 'COMPLETED'}">
                                    <a href="${pageContext.request.contextPath}/doctor/appointment-detail?id=${a.appointmentId}" class="w-full flex items-center justify-center gap-2 rounded-xl bg-brand-soft/50 py-2.5 text-sm font-bold text-brand hover:bg-brand-soft transition">
                                        Xem chi tiết
                                    </a>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <c:if test="${empty appointments}">
                <div class="mt-6 rounded-3xl border border-dashed border-border/60 p-12 text-center">
                    <p class="text-sm text-muted-foreground">Không có lịch hẹn nào trong mục này.</p>
                </div>
            </c:if>

            <c:if test="${totalPages >= 1}">
                <div class="mt-8 flex justify-center gap-2 border-t border-border/40 pt-6">
                    <c:if test="${currentPage > 1}">
                        <a href="?tab=${currentTab}&page=${currentPage - 1}" class="rounded-lg border border-border/60 bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition shadow-sm">
                            Trước
                        </a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?tab=${currentTab}&page=${i}" class="rounded-lg border ${currentPage == i ? 'border-brand bg-brand text-white shadow-sm' : 'border-border/60 bg-card text-ink hover:bg-muted shadow-sm'} px-4 py-2 text-sm font-medium transition">
                            ${i}
                        </a>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="?tab=${currentTab}&page=${currentPage + 1}" class="rounded-lg border border-border/60 bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition shadow-sm">
                            Sau
                        </a>
                    </c:if>
                </div>
            </c:if>

        </div>
    </main>
</body>
</html>