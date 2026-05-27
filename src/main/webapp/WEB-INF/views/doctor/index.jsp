<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cổng Bác Sĩ — Danh sách bệnh nhân</title>
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
            <c:if test="${not empty stats}">
                <div class="grid grid-cols-2 md:grid-cols-4 gap-6 mb-8">
                    <div class="bg-blue-50 border border-blue-200 rounded-xl p-6 text-center shadow-sm hover:shadow transition">
                        <div class="text-3xl font-bold text-blue-600 mb-1">${stats.totalAppointments}</div>
                        <div class="text-sm font-medium text-blue-800">Lịch khám hôm nay</div>
                    </div>
                    <div class="bg-green-50 border border-green-200 rounded-xl p-6 text-center shadow-sm hover:shadow transition">
                        <div class="text-3xl font-bold text-green-600 mb-1">${stats.totalPatients}</div>
                        <div class="text-sm font-medium text-green-800">Bệnh nhân đã khám</div>
                    </div>
                    <div class="bg-purple-50 border border-purple-200 rounded-xl p-6 text-center shadow-sm hover:shadow transition">
                        <div class="text-3xl font-bold text-purple-600 mb-1">${stats.totalRecords}</div>
                        <div class="text-sm font-medium text-purple-800">Tổng bệnh án</div>
                    </div>
                    <div class="bg-yellow-50 border border-yellow-200 rounded-xl p-6 text-center shadow-sm hover:shadow transition">
                        <div class="text-3xl font-bold text-yellow-600 mb-1">${stats.pendingAppointments}</div>
                        <div class="text-sm font-medium text-yellow-800">Lịch chờ xác nhận</div>
                    </div>
                </div>
            </c:if>

            <div class="flex items-center justify-between mb-8">
                <h1 class="font-display text-3xl font-bold text-ink">Danh sách bệnh nhân</h1>
                <a href="${pageContext.request.contextPath}/doctor/patient-detail" class="inline-flex items-center gap-2 rounded-xl bg-brand px-4 py-2 text-sm font-semibold text-brand-foreground hover:opacity-90">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    Tạo hồ sơ bệnh nhân
                </a>
            </div>

            <c:if test="${not empty sessionScope.message}">
                <div class="mb-6 rounded-xl bg-green-50 p-4 text-sm text-green-700 border border-green-200">
                    <c:out value="${sessionScope.message}" />
                    <c:remove var="message" scope="session" />
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="mb-6 rounded-xl bg-red-50 p-4 text-sm text-red-600 border border-red-200">
                    <c:out value="${sessionScope.error}" />
                    <c:remove var="error" scope="session" />
                </div>
            </c:if>

            <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                <c:forEach var="p" items="${patients}">
                    <div class="group relative flex flex-col overflow-hidden rounded-3xl border border-border/60 bg-card p-5 shadow-sm transition hover:shadow-lg">
                        <div class="flex items-start justify-between">
                            <div class="h-16 w-16 overflow-hidden rounded-2xl bg-muted/50 border border-border/50">
                                <c:choose>
                                    <c:when test="${not empty p.avatarUrl}">
                                        <img src="${p.avatarUrl}" alt="Avatar" class="h-full w-full object-cover"/>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="flex h-full w-full items-center justify-center font-display text-xl font-bold text-muted-foreground uppercase">
                                            ${p.fullName.substring(0,1)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <span class="rounded-full bg-brand-soft px-2.5 py-1 text-xs font-bold tracking-wide text-brand">
                                <c:out value="${p.patientCode}"/>
                            </span>
                        </div>

                        <div class="mt-4 flex-1">
                            <h3 class="font-display text-lg font-bold text-ink line-clamp-1"><c:out value="${p.fullName}"/></h3>
                            <div class="mt-2 space-y-1.5 text-sm text-muted-foreground">
                                <p><span class="font-medium text-ink">Tuổi:</span> <c:out value="${p.age}"/></p>
                                <p class="line-clamp-1"><span class="font-medium text-ink">Quê:</span> <c:out value="${p.address}" default="—"/></p>
                                <p class="line-clamp-2"><span class="font-medium text-ink">Bệnh nền:</span> <c:out value="${p.chronicDiseases}" default="Không có"/></p>
                            </div>
                        </div>

                        <div class="mt-6 flex items-center gap-2 border-t border-border/60 pt-4">
                            <a href="${pageContext.request.contextPath}/doctor/patient-detail?id=${p.patientId}" class="flex-1 rounded-xl bg-brand-soft/50 py-2 text-center text-sm font-semibold text-brand hover:bg-brand hover:text-brand-foreground transition">
                                Chi tiết
                            </a>
                            <form action="${pageContext.request.contextPath}/doctor/index" method="POST" onsubmit="return confirm('Bạn có chắc chắn muốn xóa Bệnh nhân này? Việc này có thể xóa cả các bệnh án liên quan.');">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="patientId" value="${p.patientId}" />
                                <button type="submit" class="flex h-9 w-9 items-center justify-center rounded-xl border border-red-100 bg-red-50 text-red-600 hover:bg-red-500 hover:text-white transition" title="Xóa">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"></path><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${totalPages >= 1}">
                <div class="mt-8 flex justify-center gap-2">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}" class="rounded-lg border border-border/60 bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition shadow-sm">
                            Trước
                        </a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?page=${i}" class="rounded-lg border ${currentPage == i ? 'border-brand bg-brand text-white shadow-sm' : 'border-border/60 bg-card text-ink hover:bg-muted shadow-sm'} px-4 py-2 text-sm font-medium transition">
                            ${i}
                        </a>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}" class="rounded-lg border border-border/60 bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition shadow-sm">
                            Sau
                        </a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>
</body>
</html>