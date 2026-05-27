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

    <!-- Form Section & Chat View -->
    <div class="mt-6 rounded-2xl border border-border/60 bg-card p-0 shadow-sm overflow-hidden flex flex-col h-[600px] max-h-[70vh]">
        
        <!-- Chat History Area -->
        <div class="flex-1 overflow-y-auto p-4 md:p-6 space-y-6 bg-slate-50/50">
            <!-- Initial Greeting -->
            <div class="flex gap-3 md:gap-4 items-start">
                <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-brand to-[#1e40af] text-white shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275Z"></path></svg>
                </div>
                <div class="rounded-2xl rounded-tl-sm bg-white p-4 text-sm text-ink shadow-sm border border-border/40">
                    <p>Chào bạn, tôi là Trợ lý AI y tế của JVCare. Tôi có thể giúp gì cho bạn hôm nay? Hãy hỏi tôi về lịch sử khám bệnh, phân tích các chỉ số sức khỏe của mình, hoặc bất kỳ câu hỏi tư vấn y tế nào khác dựa trên hồ sơ của bạn.</p>
                </div>
            </div>

            <c:if test="${not empty question}">
                <!-- User Question -->
                <div class="flex gap-3 md:gap-4 items-start flex-row-reverse">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-slate-200 text-slate-600 font-bold shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    </div>
                    <div class="rounded-2xl rounded-tr-sm bg-brand p-4 text-sm text-white shadow-sm max-w-[85%] md:max-w-[75%]">
                        <p class="whitespace-pre-wrap"><c:out value="${question}"/></p>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty reply}">
                <!-- AI Reply -->
                <div class="flex gap-3 md:gap-4 items-start">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-brand to-[#1e40af] text-white shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275Z"></path></svg>
                    </div>
                    <div class="rounded-2xl rounded-tl-sm bg-white p-4 text-sm text-ink shadow-sm border border-border/40 max-w-[90%] md:max-w-[85%]">
                        <div class="whitespace-pre-wrap leading-relaxed text-ink"><c:out value="${reply}"/></div>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Input Area -->
        <div class="border-t border-border/60 bg-white p-4">
            <form action="${pageContext.request.contextPath}/patient/ai" method="POST" class="relative flex items-center">
                <textarea 
                    name="question" 
                    rows="2" 
                    required 
                    placeholder="Hỏi AI về hồ sơ bệnh án của bạn... (VD: Tóm tắt tình trạng sức khoẻ của tôi, xu hướng triệu chứng…)" 
                    class="w-full resize-none rounded-2xl border border-border bg-background py-3 pl-4 pr-14 text-sm focus:outline-none focus:ring-2 focus:ring-brand shadow-sm transition-shadow"></textarea>
                <button type="submit" class="absolute right-2 top-1/2 -translate-y-1/2 flex h-10 w-10 items-center justify-center rounded-xl bg-brand text-white hover:bg-brand/90 transition shadow-sm" title="Gửi câu hỏi">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="-ml-0.5 mt-0.5"><path d="m22 2-7 20-4-9-9-4Z"></path><path d="M22 2 11 13"></path></svg>
                </button>
            </form>
        </div>
    </div>
</div>
