<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${empty patient ? 'Tạo mới Bệnh nhân' : 'Chi tiết Bệnh nhân'} — JVCare Doctor</title>
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
<body class="min-h-screen bg-muted/30 font-sans text-ink">
    <header class="sticky top-0 z-10 flex h-16 items-center border-b border-border/60 bg-card px-6 shadow-sm">
        <a href="${pageContext.request.contextPath}/doctor/index" class="mr-4 text-muted-foreground hover:text-ink">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
        </a>
        <span class="font-display text-xl font-bold text-brand">${empty patient ? 'Tạo hồ sơ bệnh nhân mới' : 'Chi tiết bệnh nhân'}</span>
    </header>

    <main class="mx-auto max-w-6xl p-6 md:p-10">
        <form action="${pageContext.request.contextPath}/doctor/patient-detail" method="POST" enctype="multipart/form-data" class="space-y-8 rounded-3xl border border-border/60 bg-card p-6 md:p-10 shadow-sm">
            <input type="hidden" name="patientId" value="${patient.patientId}" />
            <input type="hidden" name="currentAvatar" value="${patient.avatarUrl}" />
            
            <div class="grid gap-8 lg:grid-cols-3">
                <!-- Cột trái: Form thông tin -->
                <div class="lg:col-span-2 space-y-8">
                    <div>
                        <h2 class="mb-4 font-display text-lg font-bold text-ink">Thông tin hành chính</h2>
                        <div class="grid gap-6 md:grid-cols-2">
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Họ và tên *</label>
                        <input type="text" name="fullName" value="${patient.fullName}" required class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand" />
                    </div>
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Số điện thoại *</label>
                        <input type="text" name="phone" value="${patient.phone}" required class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand" />
                    </div>
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Ngày sinh</label>
                        <input type="date" name="dateOfBirth" value="${patient.dateOfBirth}" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand" />
                    </div>
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Giới tính</label>
                        <select name="gender" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand">
                            <option value="MALE" ${patient.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                            <option value="FEMALE" ${patient.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                            <option value="OTHER" ${patient.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                    <div class="md:col-span-2">
                        <label class="mb-1 block text-sm font-semibold text-ink">Quê quán / Địa chỉ</label>
                        <input type="text" name="address" value="${patient.address}" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand" />
                    </div>
                </div>
            </div>

            <div class="border-t border-border/60 pt-8">
                <h2 class="mb-4 font-display text-lg font-bold text-ink">Tiền sử bệnh lý</h2>
                <div class="grid gap-6 md:grid-cols-2">
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Dị ứng</label>
                        <textarea name="allergies" rows="2" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand">${patient.allergies}</textarea>
                    </div>
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Bệnh nền</label>
                        <textarea name="chronicDiseases" rows="2" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand">${patient.chronicDiseases}</textarea>
                    </div>
                </div>
            </div>

            <div class="border-t border-border/60 pt-8">
                <h2 class="mb-4 font-display text-lg font-bold text-ink">Chỉ số sinh tồn (Vital Signs)</h2>
                <p class="mb-6 text-sm text-muted-foreground">Các chỉ số này sẽ được lưu vào Hồ sơ khám bệnh mới nhất. Giữ trống nếu không cập nhật.</p>
                <div class="grid gap-6 md:grid-cols-3">
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Cân nặng (kg)</label>
                        <input type="number" step="0.1" name="weight" value="${weight}" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand" />
                    </div>
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Chiều cao (cm)</label>
                        <input type="number" step="0.1" name="height" value="${height}" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand" />
                    </div>
                    <div>
                        <label class="mb-1 block text-sm font-semibold text-ink">Nhịp tim (bpm)</label>
                        <input type="number" name="heartRate" value="${heartRate}" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand" />
                    </div>
                </div>
            </div> <!-- Closes Vital Signs -->
        </div> <!-- Closes lg:col-span-2 -->
            
        <!-- Cột phải: Ảnh đại diện -->
            <div class="flex flex-col items-center border-border/60 pt-8 lg:border-l lg:pt-0 lg:pl-8">
                    <h2 class="mb-4 w-full font-display text-lg font-bold text-ink text-left">Ảnh bệnh nhân (3x4)</h2>
                    <div class="relative flex aspect-[3/4] w-48 flex-col items-center justify-center overflow-hidden rounded-2xl border-2 border-dashed border-border bg-muted/30">
                        <c:choose>
                            <c:when test="${not empty patient.avatarUrl}">
                                <img id="avatarPreview" src="${patient.avatarUrl}" alt="Avatar" class="h-full w-full object-cover" />
                            </c:when>
                            <c:otherwise>
                                <img id="avatarPreview" src="" alt="" class="h-full w-full object-cover hidden" />
                                <div id="avatarPlaceholder" class="flex flex-col items-center text-muted-foreground">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mb-2"><rect width="18" height="18" x="3" y="3" rx="2" ry="2"></rect><circle cx="9" cy="9" r="2"></circle><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"></path></svg>
                                    <span class="text-xs font-semibold">Tải ảnh lên</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <label class="mt-4 cursor-pointer rounded-xl bg-brand-soft px-4 py-2 text-sm font-semibold text-brand hover:bg-brand hover:text-brand-foreground transition">
                        Chọn ảnh mới
                        <input type="file" name="avatar" accept="image/*" class="hidden" onchange="previewImage(this)" />
                    </label>
                    <p class="mt-2 text-center text-xs text-muted-foreground">Khuyến nghị ảnh tỷ lệ 3x4,<br>kích thước < 5MB.</p>
                </div>
            </div>

            <div class="flex justify-end gap-3 border-t border-border/60 pt-6">
                <a href="${pageContext.request.contextPath}/doctor/index" class="rounded-xl px-6 py-2.5 text-sm font-semibold text-muted-foreground hover:bg-muted hover:text-ink">Hủy</a>
                <button type="submit" class="rounded-xl bg-brand px-6 py-2.5 text-sm font-semibold text-brand-foreground hover:opacity-90">Lưu thay đổi</button>
            </div>
        </form>
    </main>

    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var preview = document.getElementById('avatarPreview');
                    preview.src = e.target.result;
                    preview.classList.remove('hidden');
                    
                    var placeholder = document.getElementById('avatarPlaceholder');
                    if(placeholder) placeholder.classList.add('hidden');
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>
