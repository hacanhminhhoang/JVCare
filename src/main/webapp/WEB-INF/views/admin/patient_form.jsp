<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty patient ? 'Thêm' : 'Sửa'} Bệnh nhân - JVCare</title>
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
                <h1 class="font-display text-3xl font-bold text-ink">${empty patient ? 'Thêm' : 'Sửa'} Bệnh nhân</h1>
                <p class="mt-2 text-sm text-muted-foreground">
                    ${empty patient ? 'Thêm bệnh nhân mới vào hệ thống' : 'Cập nhật hồ sơ bệnh nhân'}
                </p>
            </div>

            <c:if test="${not empty error}">
                <div class="mb-6 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-800">
                    <svg class="inline mr-2" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>
                    ${error}
                </div>
            </c:if>

            <div class="rounded-xl border border-border bg-card p-6">
                <form method="post" action="${pageContext.request.contextPath}/admin/patients" id="patientForm">
                    <input type="hidden" name="action" value="${empty patient ? 'create' : 'update'}">
                    <c:if test="${not empty patient}">
                        <input type="hidden" name="patientId" value="${patient.patientId}">
                    </c:if>

                    <div class="space-y-6">
                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Họ tên <span class="text-red-600">*</span></label>
                                <input type="text" name="fullName" value="${patient.fullName}" required class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>

                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Email</label>
                                <input type="email" name="email" value="${patient.email}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>
                        </div>

                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Số điện thoại</label>
                                <input type="text" name="phone" value="${patient.phone}" pattern="[0-9]{10,11}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>

                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">CCCD</label>
                                <input type="text" name="idCard" value="${patient.idCard}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>
                        </div>

                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Ngày sinh</label>
                                <input type="date" name="dateOfBirth" value="${patient.dateOfBirth}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>

                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Giới tính</label>
                                <select name="gender" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                                    <option value="MALE" ${patient.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                    <option value="FEMALE" ${patient.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                    <option value="OTHER" ${patient.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label class="mb-2 block text-sm font-medium text-ink">Địa chỉ</label>
                            <input type="text" name="address" value="${patient.address}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                        </div>

                        <div class="grid gap-6 md:grid-cols-2">
                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Dị ứng</label>
                                <input type="text" name="allergies" value="${patient.allergies}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>

                            <div>
                                <label class="mb-2 block text-sm font-medium text-ink">Bệnh mãn tính</label>
                                <input type="text" name="chronicDiseases" value="${patient.chronicDiseases}" class="w-full rounded-lg border border-border bg-card px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand">
                            </div>
                        </div>
                    </div>

                    <div class="mt-8 flex gap-3">
                        <a href="${pageContext.request.contextPath}/admin/patients" class="rounded-lg border border-border bg-card px-6 py-2 text-sm font-medium text-ink hover:bg-muted transition">Hủy</a>
                        <button type="submit" class="rounded-lg bg-brand px-6 py-2 text-sm font-medium text-brand-foreground hover:bg-brand/90 transition">${empty patient ? 'Thêm bệnh nhân' : 'Cập nhật'}</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    <script>
            document.addEventListener("DOMContentLoaded", function() {
                // Kích hoạt hàm kiểm tra form từ file validation.js
                if (typeof addFormValidation === 'function') {
                    addFormValidation('patientForm');
                }
            });
        </script>
    </main>
</body>
</html>
</body>
</html>
