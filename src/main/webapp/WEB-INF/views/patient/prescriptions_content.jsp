<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div>
    <h1 class="font-display text-3xl font-bold text-ink">Đơn thuốc</h1>
    <p class="mt-1 text-sm text-muted-foreground">Lịch sử đơn thuốc của bạn</p>
    
    <div class="mt-6 space-y-3">
        <c:choose>
            <c:when test="${not empty prescriptions}">
                <c:forEach var="p" items="${prescriptions}">
                    <div class="rounded-2xl border border-border/60 bg-card p-5">
                        <div class="flex items-center gap-3">
                            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-brand-soft text-brand">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/><path d="m8.5 8.5 7 7"/></svg>
                            </div>
                            <div>
                                <div class="font-semibold text-ink">${p.medicationName}</div>
                                <div class="text-xs text-muted-foreground">
                                    <fmt:formatDate value="${p.prescriptionDate}" pattern="dd/MM/yyyy" />
                                </div>
                            </div>
                        </div>
                        <div class="mt-3 grid gap-2 text-sm">
                            <div><span class="font-medium text-ink">Liều dùng: </span><span class="text-muted-foreground">${p.dosage != null ? p.dosage : "—"}</span></div>
                            <div><span class="font-medium text-ink">Hướng dẫn: </span><span class="text-muted-foreground">${p.instructions != null ? p.instructions : "—"}</span></div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="text-sm text-muted-foreground">Chưa có đơn thuốc nào.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>
