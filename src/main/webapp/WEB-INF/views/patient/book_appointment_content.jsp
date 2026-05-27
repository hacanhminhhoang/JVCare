<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div>
    <div class="flex items-center justify-between mb-8">
        <div>
            <h1 class="font-display text-3xl font-bold text-ink">Đặt lịch khám</h1>
            <p class="mt-1 text-sm text-muted-foreground">Chọn bác sĩ và thời gian khám phù hợp</p>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-6 rounded-xl bg-red-50 p-4 text-sm text-red-600 border border-red-200 shadow-sm">
            ${error}
        </div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="mb-6 rounded-xl bg-green-50 p-4 text-sm text-green-700 border border-green-200 shadow-sm">
            ${success}
        </div>
    </c:if>

    <div class="rounded-3xl border border-border/60 bg-card p-6 md:p-8 shadow-sm">
        <form method="post" action="${pageContext.request.contextPath}/patient/book-appointment" class="space-y-6">
            
            <div class="grid gap-6 md:grid-cols-2">
                <div>
                    <label class="mb-2 block text-sm font-semibold text-ink">Ngày khám <span class="text-red-500">*</span></label>
                    <input type="date" name="appointmentDate" required class="w-full rounded-xl border border-border bg-background px-4 py-3 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand transition" />
                </div>
                
                <div>
                    <label class="mb-2 block text-sm font-semibold text-ink">Giờ khám <span class="text-red-500">*</span></label>
                    <input type="time" name="appointmentTime" required class="w-full rounded-xl border border-border bg-background px-4 py-3 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand transition" />
                </div>
            </div>

            <div>
                <label class="mb-2 block text-sm font-semibold text-ink">Bác sĩ</label>
                <select name="doctorId" class="w-full rounded-xl border border-border bg-background px-4 py-3 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand transition">
                    <option value="">-- Chọn bác sĩ (Không bắt buộc) --</option>
                    <c:forEach var="doctor" items="${doctors}">
                        <option value="${doctor.doctorId}">${doctor.fullName} - ${doctor.specialization}</option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="mb-2 block text-sm font-semibold text-ink">Lý do khám <span class="text-red-500">*</span></label>
                <textarea name="reason" rows="4" required class="w-full rounded-xl border border-border bg-background px-4 py-3 text-sm focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand transition" placeholder="Mô tả triệu chứng hoặc lý do bạn muốn khám..."></textarea>
            </div>

            <div class="pt-4 flex justify-end">
                <button type="submit" class="rounded-xl bg-brand px-8 py-3 text-sm font-bold text-brand-foreground hover:opacity-90 transition shadow-md hover:shadow-lg flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                    Xác nhận đặt lịch
                </button>
            </div>
            
        </form>
    </div>
</div>