<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div>
    <div class="mb-6">
        <h1 class="font-display text-3xl font-bold text-ink">Hồ sơ cá nhân</h1>
        <p class="mt-1 text-sm text-muted-foreground">Xem và cập nhật thông tin hồ sơ y tế của bạn.</p>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty sessionScope.message}">
        <div class="mb-4 rounded-xl bg-emerald-50 border border-emerald-200 p-4 text-sm text-emerald-800 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            <span><c:out value="${sessionScope.message}"/></span>
            <% session.removeAttribute("message"); %>
        </div>
    </c:if>
    <c:if test="${not empty requestScope.error}">
        <div class="mb-4 rounded-xl bg-rose-50 border border-rose-200 p-4 text-sm text-rose-800 flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
            <span><c:out value="${requestScope.error}"/></span>
        </div>
    </c:if>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Avatar card -->
        <div class="lg:col-span-1 bg-white rounded-2xl border border-border/60 p-6 shadow-sm flex flex-col items-center">
            <div class="relative group">
                <c:choose>
                    <c:when test="${not empty patient.avatarUrl}">
                        <img id="avatar-preview" src="${pageContext.request.contextPath}/${patient.avatarUrl}" class="w-32 h-32 rounded-full object-cover border-4 border-brand-soft shadow-md" alt="Avatar">
                    </c:when>
                    <c:otherwise>
                        <div id="avatar-preview-placeholder" class="w-32 h-32 rounded-full bg-brand-soft text-brand text-4xl font-bold flex items-center justify-center border-4 border-brand-soft shadow-md">
                            ${patient.fullName != null && patient.fullName.length() > 0 ? patient.fullName.substring(0, 1).toUpperCase() : "BN"}
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <h3 class="mt-4 font-semibold text-ink text-lg"><c:out value="${patient.fullName}"/></h3>
            <p class="text-xs text-muted-foreground mt-1">Mã bệnh nhân: <span class="font-mono text-brand font-semibold"><c:out value="${patient.patientCode}"/></span></p>

            <form method="post" action="${pageContext.request.contextPath}/patient/profile" enctype="multipart/form-data" class="w-full mt-6">
                <input type="hidden" name="patientId" value="${patient.patientId}">
                
                <div class="mt-2 text-center">
                    <label class="block text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-2">Thay đổi ảnh đại diện</label>
                    <input type="file" name="avatar" accept="image/png, image/jpeg, image/jpg" class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-semibold file:bg-brand-soft file:text-brand hover:file:bg-brand/10 cursor-pointer">
                    <span class="text-[10px] text-muted-foreground mt-1 block">Tối đa 2MB, định dạng: JPG, PNG</span>
                </div>
        </div>

        <!-- Form card -->
        <div class="lg:col-span-2 bg-white rounded-2xl border border-border/60 p-8 shadow-sm">
            <h2 class="font-display text-xl font-bold text-ink mb-6 pb-2 border-b border-border/60">Thông tin cá nhân & Y tế</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-semibold text-ink mb-1.5">Họ và tên <span class="text-rose-500">*</span></label>
                    <input type="text" name="fullName" value="<c:out value='${patient.fullName}'/>" required class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition">
                </div>
                
                <div>
                    <label class="block text-sm font-semibold text-ink mb-1.5">Mã số CCCD / Hộ chiếu</label>
                    <input type="text" name="idCard" value="<c:out value='${patient.idCard}'/>" class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-ink mb-1.5">Ngày sinh</label>
                    <input type="date" name="dateOfBirth" value="<c:out value='${patient.dateOfBirth}'/>" class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-ink mb-1.5">Giới tính</label>
                    <select name="gender" class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition">
                        <option value="MALE" ${patient.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                        <option value="FEMALE" ${patient.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                        <option value="OTHER" ${patient.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-ink mb-1.5">Số điện thoại <span class="text-rose-500">*</span></label>
                    <input type="text" name="phone" value="<c:out value='${patient.phone}'/>" required class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-ink mb-1.5">Địa chỉ Email</label>
                    <input type="email" name="email" value="<c:out value='${patient.email}'/>" class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition">
                </div>

                <div class="md:col-span-2">
                    <label class="block text-sm font-semibold text-ink mb-1.5">Địa chỉ thường trú</label>
                    <input type="text" name="address" value="<c:out value='${patient.address}'/>" class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition">
                </div>

                <div class="md:col-span-2">
                    <label class="block text-sm font-semibold text-ink mb-1.5">Tiền sử dị ứng</label>
                    <textarea name="allergies" rows="2" placeholder="Ví dụ: Dị ứng Penicillin, hải sản..." class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition"><c:out value='${patient.allergies}'/></textarea>
                </div>

                <div class="md:col-span-2">
                    <label class="block text-sm font-semibold text-ink mb-1.5">Bệnh lý mãn tính</label>
                    <textarea name="chronicDiseases" rows="2" placeholder="Ví dụ: Cao huyết áp, tiểu đường..." class="w-full rounded-xl border border-border/60 bg-transparent px-4 py-2.5 text-sm outline-none focus:border-brand transition"><c:out value='${patient.chronicDiseases}'/></textarea>
                </div>
            </div>

            <div class="mt-8 flex justify-end">
                <button type="submit" class="inline-flex items-center gap-2 rounded-xl bg-brand px-6 py-3 text-sm font-semibold text-brand-foreground hover:opacity-90 shadow-sm transition">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                    Lưu thông tin hồ sơ
                </button>
            </div>
            </form>
        </div>
    </div>
</div>
