<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cổng Quản Trị — JVCare</title>
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
<body class="flex min-h-screen bg-muted/30 font-sans text-ink">
    <aside class="hidden w-64 shrink-0 flex-col border-r border-border/60 bg-card md:flex">
        <div class="p-6">
            <span class="font-display font-bold text-xl text-brand">JVCare Admin</span>
        </div>
        <nav class="flex-1 space-y-1 px-4 py-4">
            <a href="${pageContext.request.contextPath}/admin/index" class="flex items-center gap-3 rounded-lg bg-brand-soft px-3 py-2 text-sm font-semibold text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
                Tổng quan
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
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
        </nav>
        <div class="border-t border-border/60 p-4 space-y-2">
            <div class="flex items-center gap-3 rounded-xl bg-muted/50 p-3 mb-2">
                <div class="h-10 w-10 shrink-0 rounded-full bg-brand-soft text-brand flex items-center justify-center font-bold">
                    AD
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
    <main class="flex-1 overflow-auto p-6 md:p-10">
        <h1 class="font-display text-3xl font-bold text-ink">Tổng quan quản trị</h1>
        <div class="mt-6 rounded-2xl border border-dashed border-border bg-card p-10 text-center text-sm text-muted-foreground">
            Xin chào quản trị viên. Trang tính năng đang được phát triển...
        </div>
    </main>
</body>
</html>
