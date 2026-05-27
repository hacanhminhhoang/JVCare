<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div>
    <div class="flex items-center justify-between">
        <div>
            <h1 class="font-display text-3xl font-bold text-ink">Hồ sơ bệnh án</h1>
            <p class="mt-1 text-sm text-muted-foreground">Xin chào, <c:out value="${sessionScope.user.fullName}"/></p>
        </div>
        <button onclick="printSummary()" class="inline-flex items-center gap-2 rounded-xl bg-brand px-4 py-2.5 text-sm font-semibold text-brand-foreground hover:opacity-90">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" x2="12" y1="15" y2="3"></line></svg>
            Xuất PDF
        </button>
    </div>
    
    <!-- Print-only Hospital Header -->
    <div class="print-header" style="display:none;">
        <div style="text-align:center; border-bottom: 2px solid #1a56db; padding-bottom: 16px; margin-bottom: 24px;">
            <h1 style="font-size: 22px; font-weight: bold; color: #1a56db; text-transform: uppercase; letter-spacing: 2px;">Hệ Thống Y Tế JVCare</h1>
            <p style="font-size: 13px; color: #6b7a99; margin-top: 4px;">Tóm tắt hồ sơ bệnh án — Bệnh nhân: <c:out value="${sessionScope.user.fullName}"/></p>
            <p style="font-size: 11px; color: #6b7a99;">Ngày in: <%=(new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm")).format(new java.util.Date())%></p>
        </div>
    </div>
    
    <div class="mt-8 space-y-4" id="recordsListContainer">
        <c:choose>
            <c:when test="${empty records}">
                <div class="rounded-2xl border border-dashed border-border bg-card p-10 text-center text-sm text-muted-foreground">
                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mx-auto mb-3 opacity-40"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" x2="8" y1="13" y2="13"></line><line x1="16" x2="8" y1="17" y2="17"></line><line x1="10" x2="8" y1="9" y2="9"></line></svg>
                    Chưa có hồ sơ. Bác sĩ sẽ cập nhật sau khi bạn đi khám.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="record" items="${records}">
                    <div class="record-card rounded-2xl border border-border/60 bg-card p-6 shadow-sm hover:shadow-md transition">
                        <div class="flex items-center justify-between">
                            <span class="rounded-full bg-brand-soft px-3 py-1 text-xs font-semibold text-brand">
                                Ngày khám: <c:out value="${record.visitDate}"/>
                            </span>
                        </div>
                        <div class="mt-4 grid gap-3 text-sm">
                            <div><span class="font-semibold text-ink">Lý do khám (Triệu chứng): </span><span class="text-muted-foreground"><c:out value="${record.chiefComplaint}" default="—"/></span></div>
                            <div><span class="font-semibold text-ink">Chẩn đoán: </span><span class="text-muted-foreground"><c:out value="${record.diagnosis}" default="—"/></span></div>
                            <div><span class="font-semibold text-ink">Hướng điều trị: </span><span class="text-muted-foreground"><c:out value="${record.treatmentPlan}" default="—"/></span></div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Pagination - server-side, always shown -->
    <c:if test="${totalPages >= 1}">
        <div class="mt-8 flex justify-center gap-2 no-print">
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

<script>
function printSummary() {
    var printHeaders = document.querySelectorAll('.print-header');
    printHeaders.forEach(function(el) { el.style.display = 'block'; });
    
    // Unhide all records for printing (just in case they were hidden by something else)
    const cards = document.querySelectorAll('.record-card');
    cards.forEach(c => c.style.display = '');
    
    window.print();
    
    setTimeout(function() {
        printHeaders.forEach(function(el) { el.style.display = 'none'; });
    }, 500);
}
</script>
