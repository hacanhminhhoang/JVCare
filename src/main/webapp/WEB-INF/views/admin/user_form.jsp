<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty editUser ? 'Thêm' : 'Sửa'} Nhân viên - JVCare</title>
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
    <main class="flex-1 overflow-auto p-6 md:p-10">
        <div class="mx-auto max-w-3xl">
            <div class="mb-6">
                <c:choose>
                    <c:when test="${fromDoctors}">
                        <h1 class="font-display text-3xl font-bold text-ink">${empty editUser ? 'Thêm' : 'Sửa'} Bác sĩ</h1>
                        <p class="mt-2 text-sm text-muted-foreground">
                            ${empty editUser ? 'Thêm bác sĩ mới vào hệ thống' : 'Cập nhật thông tin bác sĩ'}
                        </p>
                    </c:when>
                    <c:otherwise>
                        <h1 class="font-display text-3xl font-bold text-ink">${empty editUser ? 'Thêm' : 'Sửa'} Nhân viên</h1>
                        <p class="mt-2 text-sm text-muted-foreground">
                            ${empty editUser ? 'Thêm tài khoản nhân viên mới' : 'Cập nhật thông tin nhân viên'}
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="mb-6 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-800">
                    <svg class="inline mr-2" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
                    ${error}
                </div>
            </c:if>

            <div class="rounded-xl border border-border bg-card p-6">
                <form action="${pageContext.request.contextPath}/admin/users" method="post" class="space-y-6">
                    <input type="hidden" name="action" value="${empty editUser ? 'create' : 'update'}">
                    <c:if test="${not empty editUser}">
                        <input type="hidden" name="userId" value="${editUser.userId}">
                    </c:if>

                    <div class="space-y-6">
                        <!-- Username & Password Row -->
                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">
                                    Username <span class="text-red-600">*</span>
                                </label>
                                <input type="text" name="username" 
                                       value="${editUser.username}" 
                                       required 
                                       ${not empty editUser ? 'readonly' : ''}
                                       pattern="[a-zA-Z0-9_]{3,50}"
                                       title="Username phải từ 3-50 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới"
                                       class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand ${not empty editUser ? 'bg-muted/50 cursor-not-allowed' : ''}">
                                <c:if test="${not empty editUser}">
                                    <p class="mt-1 text-xs text-muted-foreground">Username không thể thay đổi</p>
                                </c:if>
                            </div>

                            <c:if test="${empty editUser}">
                                <div>
                                    <label class="mb-2 block text-sm font-medium text-ink">
                                        Password <span class="text-red-600">*</span>
                                    </label>
                                    <input type="password" name="password" 
                                           required minlength="6"
                                           title="Password phải có ít nhất 6 ký tự"
                                           class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                    <p class="mt-1 text-xs text-muted-foreground">Tối thiểu 6 ký tự</p>
                                </div>
                            </c:if>
                        </div>

                        <!-- Full Name & Email Row -->
                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">
                                    Họ tên <span class="text-red-600">*</span>
                                </label>
                                <input type="text" name="fullName" 
                                       value="${editUser.fullName}" 
                                       required maxlength="100"
                                       class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>

                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">
                                    Email <span class="text-red-600">*</span>
                                </label>
                                <input type="email" name="email" 
                                       value="${editUser.email}" 
                                       required
                                       class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>
                        </div>

                        <!-- Phone & Role Row -->
                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Số điện thoại</label>
                                <input type="text" name="phone" 
                                       value="${editUser.phone}"
                                       pattern="[0-9]{10,11}"
                                       title="Số điện thoại phải có 10-11 chữ số"
                                       class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>

                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">
                                    Role <span class="text-red-600">*</span>
                                </label>
                                <select name="role" required 
                                        ${not empty editUser ? 'disabled' : ''}
                                        id="roleSelect"
                                        onchange="toggleDoctorFields()"
                                        class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand ${not empty editUser ? 'bg-muted/50 cursor-not-allowed' : ''}">
                                    <c:choose>
                                        <c:when test="${empty editUser}">
                                            <c:choose>
                                                <c:when test="${defaultRole == 'DOCTOR'}">
                                                    <option value="DOCTOR" selected>Bác sĩ (Doctor)</option>
                                                    <option value="RECEPTIONIST">Lễ tân (Receptionist)</option>
                                                    <option value="ADMIN">Quản trị viên (Admin)</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="RECEPTIONIST">Lễ tân (Receptionist)</option>
                                                    <option value="ADMIN">Quản trị viên (Admin)</option>
                                                    <option value="DOCTOR">Bác sĩ (Doctor)</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="RECEPTIONIST" ${editUser.role == 'RECEPTIONIST' ? 'selected' : ''}>Lễ tân (Receptionist)</option>
                                            <option value="ADMIN" ${editUser.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên (Admin)</option>
                                            <option value="DOCTOR" ${editUser.role == 'DOCTOR' ? 'selected' : ''}>Bác sĩ (Doctor)</option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                                <c:if test="${not empty editUser}">
                                    <input type="hidden" name="role" value="${editUser.role}">
                                    <p class="mt-1 text-xs text-muted-foreground">Role không thể thay đổi</p>
                                </c:if>
                            </div>
                        </div>

                        <!-- Status (only for edit) -->
                        <c:if test="${not empty editUser}">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Trạng thái</label>
                                <select name="status" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                    <option value="ACTIVE" ${editUser.status == 'ACTIVE' ? 'selected' : ''}>Active - Hoạt động</option>
                                    <option value="INACTIVE" ${editUser.status == 'INACTIVE' ? 'selected' : ''}>Inactive - Không hoạt động</option>
                                </select>
                            </div>
                        </c:if>

                        <!-- Doctor-specific fields -->
                        <div id="doctorFields" style="display: none;">
                            <div class="border-t border-border pt-6 mt-6">
                                <h3 class="font-semibold text-ink mb-4">Thông tin Bác sĩ</h3>
                                
                                <div class="grid gap-6 md:grid-cols-2">
                                    <div>
                                        <label class="mb-2 block text-sm font-medium text-ink">
                                            Chuyên khoa <span class="text-red-600">*</span>
                                        </label>
                                        <input type="text" name="specialization" 
                                               value="${doctor.specialization}"
                                               placeholder="VD: Nội khoa, Tim mạch..."
                                               class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                    </div>

                                    <div>
                                        <label class="mb-2 block text-sm font-medium text-ink">Khoa</label>
                                        <select name="departmentId" 
                                                class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                            <option value="">-- Chọn khoa --</option>
                                            <c:choose>
                                                <c:when test="${empty departments}">
                                                    <option value="" disabled>Không có khoa nào</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="dept" items="${departments}">
                                                        <option value="${dept.departmentId}" 
                                                                ${doctor.departmentId == dept.departmentId ? 'selected' : ''}>
                                                            ${dept.departmentName}
                                                        </option>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </select>
                                        <c:if test="${empty departments}">
                                            <p class="mt-1 text-xs text-red-600">⚠️ Không load được danh sách khoa</p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="mt-8 flex gap-3">
                        <c:choose>
                            <c:when test="${fromDoctors}">
                                <a href="${pageContext.request.contextPath}/admin/doctors" 
                                   class="rounded-lg border border-border bg-card px-6 py-2 text-sm font-medium text-ink hover:bg-muted transition">
                                    Hủy
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/users" 
                                   class="rounded-lg border border-border bg-card px-6 py-2 text-sm font-medium text-ink hover:bg-muted transition">
                                    Hủy
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <button type="submit" 
                                class="rounded-lg bg-brand px-6 py-2 text-sm font-medium text-brand-foreground hover:bg-brand/90 transition">
                            <c:choose>
                                <c:when test="${fromDoctors}">
                                    ${empty editUser ? 'Tạo bác sĩ' : 'Cập nhật'}
                                </c:when>
                                <c:otherwise>
                                    ${empty editUser ? 'Tạo nhân viên' : 'Cập nhật'}
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        // Toggle doctor fields based on role selection
        function toggleDoctorFields() {
            const roleSelect = document.getElementById('roleSelect');
            const doctorFields = document.getElementById('doctorFields');
            const specializationInput = document.querySelector('input[name="specialization"]');
            
            if (roleSelect && doctorFields) {
                if (roleSelect.value === 'DOCTOR') {
                    doctorFields.style.display = 'block';
                    if (specializationInput) {
                        specializationInput.required = true;
                    }
                } else {
                    doctorFields.style.display = 'none';
                    if (specializationInput) {
                        specializationInput.required = false;
                    }
                }
            }
        }
        
        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            toggleDoctorFields();
            
            // Also check if editing a doctor
            <c:if test="${not empty editUser && editUser.role == 'DOCTOR'}">
                const doctorFields = document.getElementById('doctorFields');
                if (doctorFields) {
                    doctorFields.style.display = 'block';
                }
            </c:if>
        });
    </script>
</body>
</html>
