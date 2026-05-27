<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div>
    <div class="flex items-center justify-between">
        <div>
            <h1 class="font-display text-3xl font-bold text-ink">Lịch tái khám</h1>
            <p class="mt-1 text-sm text-muted-foreground">Quản lý các lịch hẹn với bác sĩ</p>
        </div>
    </div>
    
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

    <form action="${pageContext.request.contextPath}/patient/appointments" method="POST" class="mt-6 rounded-2xl border border-border/60 bg-card p-6 space-y-6 shadow-sm">
        <input type="hidden" name="action" value="create" />
        <div class="flex items-center justify-between border-b border-border/60 pb-4">
            <h2 class="font-display text-xl font-bold text-ink">Đặt lịch mới</h2>
        </div>
        
        <div class="grid gap-6 md:grid-cols-2">
            <!-- Cột thông tin cá nhân -->
            <div class="space-y-4 rounded-xl bg-muted/20 p-5 border border-border/40">
                <h3 class="font-semibold text-ink border-b border-border/60 pb-2 mb-4 text-sm uppercase tracking-wider text-muted-foreground">Thông tin bệnh nhân</h3>
                <div>
                    <label class="mb-1.5 block text-sm font-medium">Họ và tên <span class="text-red-500">*</span></label>
                    <input required type="text" name="fullName" value="${patient.fullName}" class="w-full rounded-xl border border-border bg-background px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand transition" />
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="mb-1.5 block text-sm font-medium">CCCD / CMND</label>
                        <input type="text" name="idCard" value="${patient.idCard}" class="w-full rounded-xl border border-border bg-background px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand transition" />
                    </div>
                    <div>
                        <label class="mb-1.5 block text-sm font-medium">Ngày sinh</label>
                        <input type="date" name="dateOfBirth" value="${patient.dateOfBirth}" class="w-full rounded-xl border border-border bg-background px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand transition" />
                    </div>
                </div>
                <div>
                    <label class="mb-1.5 block text-sm font-medium">Địa chỉ</label>
                    <input type="text" name="address" value="${patient.address}" class="w-full rounded-xl border border-border bg-background px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand transition" />
                </div>
                <p class="text-xs text-muted-foreground mt-2 italic">* Thông tin của bạn sẽ được tự động cập nhật vào hồ sơ.</p>
            </div>
            
            <!-- Cột thông tin khám -->
            <div class="space-y-4">
                <h3 class="font-semibold text-ink border-b border-border/60 pb-2 mb-4 text-sm uppercase tracking-wider text-muted-foreground">Chi tiết đặt hẹn</h3>
                <div>
                    <label class="mb-1.5 block text-sm font-medium">Ngày & giờ khám <span class="text-red-500">*</span></label>
                    <input required type="datetime-local" name="datetime" class="w-full rounded-xl border border-border bg-background px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand transition" />
                </div>
                <div>
                    <label class="mb-1.5 block text-sm font-medium">Lý do khám <span class="text-red-500">*</span></label>
                    <textarea required name="reason" rows="3" class="w-full rounded-xl border border-border bg-background px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand transition" placeholder="Triệu chứng, lý do tái khám, tư vấn…"></textarea>
                </div>
                <div class="pt-2">
                    <button type="submit" class="w-full rounded-xl bg-brand px-4 py-3 text-sm font-bold text-brand-foreground hover:opacity-90 transition shadow-md hover:shadow-lg flex justify-center items-center gap-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                        Gửi yêu cầu đặt hẹn
                    </button>
                </div>
            </div>
        </div>
    </form>
    
    <div class="mt-10">
        <h2 class="font-display text-xl font-bold text-ink mb-6">Lịch sử đặt hẹn</h2>
        <c:choose>
            <c:when test="${empty appointments}">
                <div class="rounded-2xl border border-dashed border-border/60 p-10 text-center">
                    <p class="text-sm text-muted-foreground">Bạn chưa có lịch hẹn nào.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
                    <c:forEach var="a" items="${appointments}">
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
                                            <span class="inline-block rounded-full bg-yellow-100 px-2.5 py-1 text-xs font-bold text-yellow-700 whitespace-nowrap">Chờ duyệt</span>
                                        </c:when>
                                        <c:when test="${a.status == 'CONFIRMED'}">
                                            <span class="inline-block rounded-full bg-blue-100 px-2.5 py-1 text-xs font-bold text-blue-700 whitespace-nowrap">Đã nhận</span>
                                        </c:when>
                                        <c:when test="${a.status == 'COMPLETED'}">
                                            <span class="inline-block rounded-full bg-green-100 px-2.5 py-1 text-xs font-bold text-green-700 whitespace-nowrap">Hoàn tất</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-block rounded-full bg-gray-100 px-2.5 py-1 text-xs font-bold text-gray-700 whitespace-nowrap"><c:out value="${a.status}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="flex-1">
                                <h3 class="font-semibold text-ink line-clamp-1 mb-1" title="${a.reason}">
                                    <c:out value="${a.reason}" default="Không rõ lý do"/>
                                </h3>
                                
                                <c:if test="${a.status == 'CONFIRMED' || a.status == 'COMPLETED'}">
                                    <div class="mt-3 flex items-center gap-2 text-sm text-muted-foreground bg-muted/30 p-2.5 rounded-xl border border-border/40">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-brand shrink-0"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                                        <span class="truncate">Bs. <c:out value="${a.doctorName}"/></span>
                                    </div>
                                </c:if>

                                <c:if test="${a.status == 'COMPLETED'}">
                                    <div class="mt-3 text-sm text-muted-foreground border-l-2 border-brand/50 pl-3">
                                        <p class="font-medium text-ink">CĐ: <span class="font-normal text-muted-foreground line-clamp-1"><c:out value="${a.diagnosis}"/></span></p>
                                    </div>
                                </c:if>
                            </div>

                            <div class="mt-5 border-t border-border/60 pt-4">
                                <c:if test="${a.status == 'COMPLETED'}">
                                    <button type="button" onclick="window.print()" class="w-full flex items-center justify-center gap-2 rounded-xl bg-brand-soft/50 py-2.5 text-sm font-bold text-brand hover:bg-brand hover:text-brand-foreground transition">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/></svg>
                                        Lưu Hồ Sơ (PDF)
                                    </button>
                                </c:if>

                                <c:if test="${a.status == 'PENDING'}">
                                    <div class="flex items-center gap-2">
                                </form>
                            </div>
                            
                            <!-- Inline Edit Form -->
                            <form id="edit-form-${a.appointmentId}" action="${pageContext.request.contextPath}/patient/appointments" method="POST" class="absolute inset-0 z-10 hidden flex-col bg-card/95 p-5 backdrop-blur-sm transition-all">
                                <div class="flex-1 space-y-4">
                                    <div class="flex items-center justify-between border-b border-border pb-2">
                                        <h4 class="font-bold text-ink">Đổi lịch hẹn</h4>
                                        <button type="button" onclick="document.getElementById('edit-form-${a.appointmentId}').classList.add('hidden')" class="text-muted-foreground hover:text-ink">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
                                        </button>
                                                <button type="button" onclick="document.getElementById('edit-form-${a.appointmentId}').classList.add('hidden')" class="text-muted-foreground hover:text-ink">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
                                                </button>
                                            </div>
                                            <input type="hidden" name="action" value="update" />
                                            <input type="hidden" name="appointmentId" value="${a.appointmentId}" />
                                            <div>
                                                <label class="mb-1 block text-xs font-medium text-muted-foreground">Ngày & giờ</label>
                                                <input required type="datetime-local" name="datetime" value="${a.appointmentDate}T${a.appointmentTime}" class="w-full rounded-lg border border-border px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand" />
                                            </div>
                                            <div>
                                                <label class="mb-1 block text-xs font-medium text-muted-foreground">Lý do</label>
                                                <textarea required name="reason" rows="2" class="w-full rounded-lg border border-border px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand"><c:out value="${a.reason}"/></textarea>
                                            </div>
                                        </div>
                                        <button type="submit" class="mt-4 w-full rounded-xl bg-brand py-2.5 text-sm font-bold text-brand-foreground hover:opacity-90 transition shadow-sm">Lưu thay đổi</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Pagination - server-side -->
    <c:if test="${totalPages >= 1}">
        <div class="mt-8 flex justify-center gap-2">
            <c:if test="${currentPage > 1}">
                <a href="?page=${currentPage - 1}" class="rounded-lg border border-border bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition">Trước</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="?page=${i}" class="rounded-lg border ${currentPage == i ? 'border-brand bg-brand text-brand-foreground' : 'border-border bg-card text-ink hover:bg-muted'} px-4 py-2 text-sm font-medium transition">${i}</a>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a href="?page=${currentPage + 1}" class="rounded-lg border border-border bg-card px-4 py-2 text-sm font-medium text-ink hover:bg-muted transition">Sau</a>
            </c:if>
        </div>
    </c:if>
</div>
