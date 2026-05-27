<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div>
    <div class="mb-6">
        <h1 class="font-display text-3xl font-bold text-ink">Lịch sử khám bệnh</h1>
        <p class="mt-1 text-sm text-muted-foreground">Danh sách tất cả các lần khám bệnh và chẩn đoán y tế của bạn.</p>
    </div>

    <!-- Table Container -->
    <div class="bg-white rounded-2xl border border-border/60 p-6 shadow-sm overflow-hidden">
        <c:choose>
            <c:when test="${empty history}">
                <div class="rounded-2xl border border-dashed border-border bg-card p-12 text-center text-sm text-muted-foreground">
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mx-auto mb-4 opacity-40"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" x2="8" y1="13" y2="13"></line><line x1="16" x2="8" y1="17" y2="17"></line><line x1="10" x2="8" y1="9" y2="9"></line></svg>
                    Bạn chưa có lịch sử khám bệnh nào được ghi nhận trên hệ thống.
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="border-b border-border/60">
                                <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Mã Bệnh Án</th>
                                <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Ngày Khám</th>
                                <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Triệu Chứng / Lý Do</th>
                                <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Chẩn Đoán</th>
                                <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider text-right">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-border/40">
                            <c:forEach var="record" items="${history}">
                                <tr class="hover:bg-slate-50/50 transition">
                                    <td class="py-4 text-sm font-semibold text-ink font-mono"><c:out value="${record.recordCode}" default="REC-N/A"/></td>
                                    <td class="py-4 text-sm text-muted-foreground">
                                        <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="py-4 text-sm text-ink max-w-xs truncate"><c:out value="${record.chiefComplaint}" default="—"/></td>
                                    <td class="py-4 text-sm text-ink font-medium"><c:out value="${record.diagnosis}"/></td>
                                    <td class="py-4 text-sm text-right">
                                        <a href="${pageContext.request.contextPath}/patient/medical-history?id=${record.recordId}" class="inline-flex items-center gap-1 rounded-xl bg-brand-soft px-3 py-1.5 text-xs font-semibold text-brand hover:bg-brand/10 transition">
                                            Xem chi tiết
                                            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"></path><path d="m12 5 7 7-7 7"></path></svg>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Pagination - server-side, always shown -->
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
