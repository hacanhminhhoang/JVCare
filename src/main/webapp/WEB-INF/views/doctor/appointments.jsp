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
                        background: "oklch(0.99 0.005 180)",
                        ink: "oklch(0.14 0.03 210)",
                        brand: "oklch(0.55 0.13 195)",
                        "brand-foreground": "oklch(0.99 0.005 180)",
                        "brand-soft": "oklch(0.95 0.04 190)",
                        muted: "oklch(0.96 0.012 200)",
                        "muted-foreground": "oklch(0.5 0.025 215)",
                        border: "oklch(0.92 0.015 200)",
                        card: "oklch(1 0 0)"
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
<body class="min-h-screen bg-background font-sans text-ink flex">
    
    <!-- Sidebar Navigation for Doctor -->
    <aside class="w-64 border-r border-border/60 bg-card shadow-sm flex flex-col hidden md:flex shrink-0">
        <div class="flex h-16 shrink-0 items-center px-6">
            <span class="font-display font-bold text-xl text-brand">JVCare Doctor</span>
        </div>
        <nav class="flex-1 space-y-1 px-4 py-4">
            <c:set var="uri" value="${pageContext.request.requestURI}" />
            <c:set var="isPatients" value="${uri.endsWith('/doctor/index')}" />
            <c:set var="isAppt" value="${uri.endsWith('/doctor/appointments')}" />
            <c:set var="isRecords" value="false" />
            
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

        <div class="mx-auto max-w-6xl p-6 md:p-10">
            <h1 class="font-display text-3xl font-bold text-ink">Lịch hẹn khám</h1>
            <p class="mt-1 text-sm text-muted-foreground">Quản lý và tiếp nhận lịch hẹn của bệnh nhân</p>

            <c:if test="${not empty sessionScope.message}">
                <div class="mt-4 rounded-xl bg-green-50 p-3 text-sm text-green-700 border border-green-200">
                    <c:out value="${sessionScope.message}" />
                    <c:remove var="message" scope="session" />
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="mt-4 rounded-xl bg-red-50 p-3 text-sm text-red-600 border border-red-200">
                    <c:out value="${sessionScope.error}" />
                    <c:remove var="error" scope="session" />
                </div>
            </c:if>

            <!-- Tabs -->
            <div class="mt-8 flex gap-2 border-b border-border pb-px overflow-x-auto">
                <a href="?tab=all" class="px-4 py-2 text-sm font-semibold whitespace-nowrap transition-colors ${currentTab == 'all' ? 'border-b-2 border-brand text-brand' : 'text-muted-foreground hover:text-ink'}">Tất cả</a>
                <a href="?tab=pending" class="px-4 py-2 text-sm font-semibold whitespace-nowrap transition-colors flex items-center gap-2 ${currentTab == 'pending' ? 'border-b-2 border-yellow-500 text-yellow-600' : 'text-muted-foreground hover:text-yellow-600'}">
                    Chưa xác nhận <span class="rounded-full bg-yellow-100 px-1.5 py-0.5 text-[10px] text-yellow-700">Mới</span>
                </a>
                <a href="?tab=confirmed" class="px-4 py-2 text-sm font-semibold whitespace-nowrap transition-colors ${currentTab == 'confirmed' ? 'border-b-2 border-blue-500 text-blue-600' : 'text-muted-foreground hover:text-blue-600'}">Đã xác nhận</a>
                <a href="?tab=completed" class="px-4 py-2 text-sm font-semibold whitespace-nowrap transition-colors ${currentTab == 'completed' ? 'border-b-2 border-green-500 text-green-600' : 'text-muted-foreground hover:text-green-600'}">Đã hoàn thành</a>
            </div>

            <!-- Cards -->
            <div class="mt-6 grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                <c:set var="hasItem" value="false" />
                <c:forEach var="a" items="${appointments}">
                    <!-- Filter logic for tabs -->
                    <c:set var="show" value="false" />
                    <c:if test="${currentTab == 'all'}"><c:set var="show" value="true" /></c:if>
                    <c:if test="${currentTab == 'pending' && a.status == 'PENDING'}"><c:set var="show" value="true" /></c:if>
                    <c:if test="${currentTab == 'confirmed' && a.status == 'CONFIRMED'}"><c:set var="show" value="true" /></c:if>
                    <c:if test="${currentTab == 'completed' && a.status == 'COMPLETED'}"><c:set var="show" value="true" /></c:if>

                    <c:if test="${show}">
                        <c:set var="hasItem" value="true" />
                        <div class="group relative flex flex-col overflow-hidden rounded-3xl border border-border/60 bg-card p-5 shadow-sm transition hover:shadow-lg">
                            
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
                                                    Không có quyền (Bs khác)
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
                    </c:if>
                </c:forEach>
            </div>
            
            <c:if test="${!hasItem}">
                <div class="mt-6 rounded-3xl border border-dashed border-border/60 p-12 text-center">
                    <p class="text-sm text-muted-foreground">Không có lịch hẹn nào trong mục này.</p>
                </div>
            </c:if>
            
            <!-- Pagination Mock -->
            <div class="mt-8 flex items-center justify-center gap-2">
                <button class="rounded-lg border border-border/60 px-3 py-1.5 text-sm font-medium text-muted-foreground hover:bg-muted" disabled>&larr; Trước</button>
                <span class="text-sm font-medium">Trang 1 / 1</span>
                <button class="rounded-lg border border-border/60 px-3 py-1.5 text-sm font-medium text-ink hover:bg-muted transition">Sau &rarr;</button>
            </div>
        </div>
    </main>
</body>
</html>
