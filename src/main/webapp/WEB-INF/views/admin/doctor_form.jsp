<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty editUser ? 'Thêm' : 'Sửa'} Bác sĩ - JVCare</title>
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
    <main class="flex-1 overflow-auto p-6 md:p-10">
        <div class="mx-auto max-w-3xl">
            <div class="mb-6">
                <h1 class="font-display text-3xl font-bold text-ink">${empty editUser ? 'Thêm' : 'Sửa'} Bác sĩ</h1>
                <p class="mt-2 text-sm text-muted-foreground">
                    ${empty editUser ? 'Thêm tài khoản bác sĩ mới' : 'Cập nhật thông tin bác sĩ'}
                </p>
            </div>

            <c:if test="${not empty error}">
                <div class="mb-6 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-800">
                    <svg class="inline mr-2" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
                    ${error}
                </div>
            </c:if>

            <div class="rounded-xl border border-border bg-card p-6">
                <form action="${pageContext.request.contextPath}/admin/doctors" method="post" class="space-y-6">
                    <input type="hidden" name="action" value="${empty editUser ? 'create' : 'update'}">
                    <c:if test="${not empty editUser}">
                        <input type="hidden" name="userId" value="${editUser.userId}">
                    </c:if>

                    <div class="space-y-6">
                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Username <span class="text-red-600">*</span></label>
                                <input type="text" id="username" name="username" value="${editUser.username}" required ${not empty editUser ? 'readonly' : ''} pattern="[a-zA-Z0-9_]{3,50}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand ${not empty editUser ? 'bg-muted/50 cursor-not-allowed' : ''}">
                            </div>

                            <c:if test="${empty editUser}">
                                <div>
                                    <label for="password" class="mb-2 block text-sm font-medium text-ink">Password <span class="text-red-600">*</span></label>
                                    <input type="password" id="password" name="password" required minlength="6" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                </div>
                            </c:if>
                        </div>

                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Họ tên <span class="text-red-600">*</span></label>
                                <input type="text" id="fullName" name="fullName" value="${editUser.fullName}" required class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>

                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Email <span class="text-red-600">*</span></label>
                                <input type="email" id="email" name="email" value="${editUser.email}" required class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>
                        </div>

                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Số điện thoại</label>
                                <input type="text" id="phone" name="phone" value="${editUser.phone}" pattern="[0-9]{10,11}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>
                            
                            <c:if test="${not empty editUser}">
                                <div>
                                    <label for="status" class="mb-2 block text-sm font-medium text-ink">Trạng thái</label>
                                    <select id="status" name="status" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                        <option value="ACTIVE" ${editUser.status == 'ACTIVE' ? 'selected' : ''}>Active - Hoạt động</option>
                                        <option value="INACTIVE" ${editUser.status == 'INACTIVE' ? 'selected' : ''}>Inactive - Khóa</option>
                                    </select>
                                </div>
                            </c:if>
                        </div>

                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Chuyên khoa <span class="text-red-600">*</span></label>
                                <input type="text" name="specialization" value="${doctor.specialization}" required placeholder="VD: Nội khoa..." class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>
                            
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Khoa</label>
                                <select name="departmentId" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                    <option value="">-- Chọn khoa --</option>
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept.departmentId}" ${doctor.departmentId == dept.departmentId ? 'selected' : ''}>${dept.departmentName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="mt-8 flex gap-3">
                        <a href="${pageContext.request.contextPath}/admin/doctors" class="rounded-lg border border-border bg-card px-6 py-2 text-sm font-medium text-ink hover:bg-muted transition">Hủy</a>
                        <button type="submit" class="rounded-lg bg-brand px-6 py-2 text-sm font-medium text-brand-foreground hover:bg-brand/90 transition">${empty editUser ? 'Tạo bác sĩ' : 'Cập nhật'}</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
