<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div>
    <!-- Header Section -->
    <div class="flex items-center gap-3">
        <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-gradient-to-br from-brand to-[#1e40af] text-brand-foreground">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275Z"></path></svg>
        </div>
        <div>
            <h1 class="font-display text-3xl font-bold text-ink">Trợ lý AI</h1>
            <p class="text-sm text-muted-foreground">Phân tích hồ sơ bệnh án của bạn</p>
        </div>
    </div>
    
    <!-- Warning Alert -->
    <div class="mt-4 flex items-start gap-2 rounded-xl bg-amber-50 p-3 text-xs text-amber-900">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mt-0.5 shrink-0"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
        <span>Thông tin chỉ mang tính tham khảo, không thay thế chẩn đoán của bác sĩ. Hãy mô tả triệu chứng hoặc hỏi về hồ sơ của bạn.</span>
    </div>

    <!-- Form Section -->
    <form action="${pageContext.request.contextPath}/patient/ai" method="POST" class="mt-6 rounded-2xl border border-border/60 bg-card p-6 shadow-sm">
        <label class="mb-2 block text-sm font-medium text-ink">Câu hỏi của bạn</label>
        <textarea name="question" rows="3" required placeholder="VD: Tóm tắt tình trạng sức khoẻ của tôi, xu hướng triệu chứng…" class="w-full rounded-xl border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand"><c:out value="${question}"/></textarea>
        <button type="submit" class="mt-3 inline-flex items-center gap-2 rounded-xl bg-brand px-4 py-2 text-sm font-semibold text-brand-foreground hover:opacity-90">
            Hỏi AI
        </button>
    </form>

    <!-- AI Reply Section -->
    <c:if test="${not empty reply}">
        <div class="mt-6 rounded-2xl border border-border/60 bg-card p-6 shadow-sm">
            <h3 class="mb-3 font-semibold text-ink flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-brand"><path d="M12 2v20"></path><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                Phản hồi từ AI
            </h3>
            <p class="whitespace-pre-wrap text-sm leading-relaxed text-muted-foreground"><c:out value="${reply}"/></p>
        </div>
    </c:if>
</div>
