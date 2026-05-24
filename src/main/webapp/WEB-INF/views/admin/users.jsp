<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Nhân viên - JVCare</title>
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
<body class="flex min-h-screen bg-muted/30 font-sans text-ink">
    <!-- Sidebar -->
    <aside class="hidden w-64 shrink-0 flex-col border-r border-border/60 bg-card md:flex">
        <div class="p-6">
            <span class="font-display font-bold text-xl text-brand">JVCare Admin</span>
        </div>
        <nav class="flex-1 space-y-1 px-4 py-4">
            <a href="${pageContext.request.contextPath}/admin/index" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-3 rounded-lg bg-brand-soft px-3 py-2 text-sm font-semibold text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                Quản lý Nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/admin/doctors" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                Quản lý Bác sĩ
            </a>
            <a href="${pageContext.request.contextPath}/admin/patients" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                Quản lý Bệnh nhân
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                Báo cáo & Export
            </a>
        </nav>
        <div class="border-t border-border/60 p-4 space-y-2">
            <div class="flex items-center gap-3 rounded-xl bg-muted/50 p-3 mb-2">
                <div class="h-10 w-10 shrink-0 rounded-full bg-brand-soft text-brand flex items-center justify-center font-bold">
                    <c:out value="${sessionScope.user.fullName.substring(0,2).toUpperCase()}"/>
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

    <!-- Main content -->
    <main class="flex-1 overflow-auto p-6 md:p-10">
        <div class="mb-6">
            <h1 class="font-display text-3xl font-bold text-ink">Quản lý Nhân viên</h1>
            <p class="mt-2 text-sm text-muted-foreground">Quản lý tài khoản nhân viên và lễ tân trong hệ thống</p>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty successMessage}">
            <div class="mb-4 rounded-lg border border-green-200 bg-green-50 p-4 text-sm text-green-800">
                <svg class="inline mr-2" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="mb-4 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-800">
                <svg class="inline mr-2" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
                <c:choose>
                    <c:when test="${param.error == 'cannot_delete_self'}">Không thể xóa chính mình!</c:when>
                    <c:when test="${param.error == 'last_admin'}">Không thể xóa admin cuối cùng!</c:when>
                    <c:when test="${param.error == 'delete_failed'}">Xóa nhân viên thất bại!</c:when>
                    <c:otherwise>Có lỗi xảy ra!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Actions Bar -->
        <div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="flex gap-2">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" value="${keyword}" 
                       placeholder="Tìm kiếm theo tên, email, username..." 
                       class="rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand w-80">
                <button type="submit" class="rounded-lg bg-brand px-4 py-2 text-sm font-medium text-brand-foreground hover:bg-brand/90 transition">
                    Tìm kiếm
                </button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/users?action=create" 
               class="inline-flex items-center gap-2 rounded-lg bg-brand px-4 py-2 text-sm font-medium text-brand-foreground hover:bg-brand/90 transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" x2="12" y1="5" y2="19"/><line x1="5" x2="19" y1="12" y2="12"/></svg>
                Thêm nhân viên
            </a>
        </div>

        <!-- Stats -->
        <div class="mb-6 text-sm text-muted-foreground">
            Tổng số: <span class="font-semibold text-ink">${totalUsers}</span> nhân viên
        </div>

        <!-- Users Grid -->
        <c:choose>
            <c:when test="${empty users}">
                <div class="rounded-xl border border-dashed border-border bg-card p-12 text-center">
                    <svg class="mx-auto mb-4 text-muted-foreground" xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    <p class="mb-4 text-sm text-muted-foreground">Chưa có nhân viên nào trong hệ thống</p>
                    <a href="${pageContext.request.contextPath}/admin/users?action=create" 
                       class="inline-flex items-center gap-2 rounded-lg bg-brand px-4 py-2 text-sm font-medium text-brand-foreground hover:bg-brand/90 transition">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" x2="12" y1="5" y2="19"/><line x1="5" x2="19" y1="12" y2="12"/></svg>
                        Thêm nhân viên đầu tiên
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                    <c:forEach var="user" items="${users}">
                        <div class="group rounded-xl border border-border bg-card p-6 transition hover:shadow-lg">
                            <div class="mb-4 flex items-start justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-brand-soft text-brand">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                                    </div>
                                    <div>
                                        <h3 class="font-semibold text-ink">${user.fullName}</h3>
                                        <p class="text-xs text-muted-foreground">@${user.username}</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-4 space-y-2">
                                <div class="flex items-center gap-2 text-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
                                    <span class="text-muted-foreground">${user.email}</span>
                                </div>
                                <div class="flex items-center gap-2 text-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                    <span class="text-muted-foreground">${user.phone}</span>
                                </div>
                                <div class="mt-3">
                                    <c:choose>
                                        <c:when test="${user.role == 'ADMIN'}">
                                            <span class="inline-flex items-center gap-1 rounded-full bg-red-100 px-3 py-1 text-xs font-medium text-red-800">
                                                Admin
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center gap-1 rounded-full bg-gray-100 px-3 py-1 text-xs font-medium text-gray-800">
                                                Receptionist
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="flex gap-2 border-t border-border pt-4">
                                <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userId}" 
                                   class="flex-1 rounded-lg bg-yellow-100 px-3 py-2 text-center text-xs font-medium text-yellow-800 hover:bg-yellow-200 transition">
                                    Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=${user.userId}" 
                                   onclick="return confirm('Bạn có chắc muốn xóa nhân viên ${user.username}?')"
                                   class="rounded-lg bg-red-100 px-3 py-2 text-center text-xs font-medium text-red-800 hover:bg-red-200 transition">
                                    Xóa
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="mt-6 flex justify-center gap-2">
                <c:if test="${currentPage > 1}">
                    <a href="?page=${currentPage - 1}" class="rounded-lg border border-border bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition">
                        Trước
                    </a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="?page=${i}" class="rounded-lg border ${currentPage == i ? 'border-brand bg-brand text-brand-foreground' : 'border-border bg-card text-ink hover:bg-muted'} px-4 py-2 text-sm font-medium transition">
                        ${i}
                    </a>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="?page=${currentPage + 1}" class="rounded-lg border border-border bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition">
                        Sau
                    </a>
                </c:if>
            </div>
        </c:if>
    </main>
</body>
</html>
