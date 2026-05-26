<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div>
    <div class="mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/patient/medical-history" class="inline-flex items-center justify-center h-9 w-9 rounded-xl border border-border bg-white text-muted-foreground hover:text-ink hover:bg-slate-50 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                </a>
                <h1 class="font-display text-3xl font-bold text-ink">Chi tiết bệnh án</h1>
            </div>
            <p class="mt-1 text-sm text-muted-foreground ml-12">Mã bệnh án: <span class="font-mono text-brand font-semibold"><c:out value="${record.recordCode}" default="REC-N/A"/></span></p>
        </div>
        <div class="flex gap-3 ml-12 md:ml-0">
            <button onclick="window.print()" class="inline-flex items-center gap-2 rounded-xl border border-border bg-white px-4 py-2.5 text-sm font-semibold text-ink hover:bg-slate-50 shadow-sm transition">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9V2h12v7"></path><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect width="12" height="8" x="6" y="14" rx="1" ry="1"></rect></svg>
                In bệnh án
            </button>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Main details -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Medical details card -->
            <div class="bg-white rounded-2xl border border-border/60 p-6 md:p-8 shadow-sm">
                <h2 class="font-display text-xl font-bold text-ink mb-6 pb-2 border-b border-border/60">Thông tin chuyên môn</h2>
                
                <div class="space-y-6">
                    <div>
                        <h4 class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">Lý do khám (Triệu chứng chính)</h4>
                        <p class="text-sm text-ink bg-slate-50 rounded-xl p-4 border border-border/40"><c:out value="${record.chiefComplaint}" default="—"/></p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <h4 class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">Bác sĩ khám</h4>
                            <div class="flex items-center gap-3 bg-slate-50 rounded-xl p-4 border border-border/40">
                                <div class="h-10 w-10 rounded-full bg-brand-soft text-brand flex items-center justify-center font-bold text-sm">BS</div>
                                <div>
                                    <p class="text-sm font-semibold text-ink"><c:out value="${record.doctorName}" default="Bác sĩ hệ thống"/></p>
                                    <p class="text-[11px] text-muted-foreground"><c:out value="${record.doctorSpecialization}" default="Đa khoa"/></p>
                                </div>
                            </div>
                        </div>
                        <div>
                            <h4 class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">Ngày khám bệnh</h4>
                            <div class="flex items-center gap-3 bg-slate-50 rounded-xl p-4 border border-border/40">
                                <div class="h-10 w-10 rounded-full bg-cyan-50 text-cyan-600 flex items-center justify-center font-bold text-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                                </div>
                                <div>
                                    <p class="text-sm font-semibold text-ink">
                                        <fmt:formatDate value="${record.visitDate}" pattern="dd/MM/yyyy"/>
                                    </p>
                                    <p class="text-[11px] text-muted-foreground">Vào lúc <fmt:formatDate value="${record.visitDate}" pattern="HH:mm"/></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h4 class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">Chẩn đoán y tế</h4>
                        <p class="text-sm font-bold text-brand bg-brand-soft/30 rounded-xl p-4 border border-brand-soft/50"><c:out value="${record.diagnosis}" default="—"/></p>
                    </div>

                    <div>
                        <h4 class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">Hướng điều trị / Dặn dò của bác sĩ</h4>
                        <div class="text-sm text-ink bg-slate-50 rounded-xl p-4 border border-border/40 whitespace-pre-line"><c:out value="${record.treatmentPlan}" default="—"/></div>
                    </div>

                    <c:if test="${not empty record.notes}">
                        <div>
                            <h4 class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-1.5">Ghi chú bổ sung</h4>
                            <p class="text-sm text-muted-foreground bg-slate-50 rounded-xl p-4 border border-border/40"><c:out value="${record.notes}"/></p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Prescriptions card -->
            <div class="bg-white rounded-2xl border border-border/60 p-6 md:p-8 shadow-sm">
                <h2 class="font-display text-xl font-bold text-ink mb-6 pb-2 border-b border-border/60 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-brand"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"></path><path d="m8.5 8.5 7 7"></path></svg>
                    Đơn thuốc đi kèm
                </h2>
                
                <c:choose>
                    <c:when test="${empty record.prescriptions}">
                        <p class="text-sm text-muted-foreground italic text-center py-4 bg-slate-50 rounded-xl border border-border/40">Không có đơn thuốc nào được kê cho lần khám này.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="border-b border-border/60">
                                        <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Tên Thuốc</th>
                                        <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Liều lượng</th>
                                        <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Tần suất</th>
                                        <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Số ngày uống</th>
                                        <th class="pb-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider">Hướng dẫn</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-border/40">
                                    <c:forEach var="pres" items="${record.prescriptions}">
                                        <tr class="hover:bg-slate-50/50 transition">
                                            <td class="py-3 text-sm font-semibold text-ink"><c:out value="${pres.medicationName}"/></td>
                                            <td class="py-3 text-sm text-ink"><c:out value="${pres.dosage}"/></td>
                                            <td class="py-3 text-sm text-ink"><c:out value="${pres.frequency}"/></td>
                                            <td class="py-3 text-sm text-ink font-semibold text-brand"><c:out value="${pres.durationDays}"/> ngày</td>
                                            <td class="py-3 text-sm text-muted-foreground"><c:out value="${pres.instructions}" default="—"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Vital signs sidebar -->
        <div class="lg:col-span-1 space-y-6">
            <div class="bg-white rounded-2xl border border-border/60 p-6 shadow-sm">
                <h2 class="font-display text-lg font-bold text-ink mb-6 pb-2 border-b border-border/60">Chỉ số sinh tồn</h2>
                
                <div class="space-y-4">
                    <!-- Huyết áp -->
                    <div class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                        <div class="flex items-center gap-2.5">
                            <span class="h-8 w-8 rounded-lg bg-rose-50 text-rose-500 flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2z"></path><path d="M12 6v6l4 2"></path></svg>
                            </span>
                            <span class="text-sm font-medium text-ink">Huyết áp</span>
                        </div>
                        <span class="text-sm font-bold text-ink"><c:out value="${record.bloodPressure}" default="—"/> mmHg</span>
                    </div>

                    <!-- Nhịp tim -->
                    <div class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                        <div class="flex items-center gap-2.5">
                            <span class="h-8 w-8 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                            </span>
                            <span class="text-sm font-medium text-ink">Nhịp tim</span>
                        </div>
                        <span class="text-sm font-bold text-ink"><c:choose><c:when test="${record.heartRate > 0}">${record.heartRate} bpm</c:when><c:otherwise>—</c:otherwise></c:choose></span>
                    </div>

                    <!-- Nhiệt độ -->
                    <div class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                        <div class="flex items-center gap-2.5">
                            <span class="h-8 w-8 rounded-lg bg-amber-50 text-amber-500 flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z"/></svg>
                            </span>
                            <span class="text-sm font-medium text-ink">Nhiệt độ</span>
                        </div>
                        <span class="text-sm font-bold text-ink"><c:choose><c:when test="${record.temperature > 0}">${record.temperature} °C</c:when><c:otherwise>—</c:otherwise></c:choose></span>
                    </div>

                    <!-- Chiều cao -->
                    <div class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                        <div class="flex items-center gap-2.5">
                            <span class="h-8 w-8 rounded-lg bg-blue-50 text-blue-500 flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-2-2h-5V3a1 1 0 0 0-2 0v3H7a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2Z"/></svg>
                            </span>
                            <span class="text-sm font-medium text-ink">Chiều cao</span>
                        </div>
                        <span class="text-sm font-bold text-ink"><c:choose><c:when test="${record.height > 0}">${record.height} cm</c:when><c:otherwise>—</c:otherwise></c:choose></span>
                    </div>

                    <!-- Cân nặng -->
                    <div class="flex items-center justify-between p-3.5 bg-slate-50 rounded-xl border border-border/40">
                        <div class="flex items-center gap-2.5">
                            <span class="h-8 w-8 rounded-lg bg-teal-50 text-teal-600 flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3h.01M19 8.5v9a2.5 2.5 0 0 1-2.5 2.5h-9A2.5 2.5 0 0 1 5 17.5v-9A2.5 2.5 0 0 1 7.5 6h9A2.5 2.5 0 0 1 19 8.5Z"/></svg>
                            </span>
                            <span class="text-sm font-medium text-ink">Cân nặng</span>
                        </div>
                        <span class="text-sm font-bold text-ink"><c:choose><c:when test="${record.weight > 0}">${record.weight} kg</c:when><c:otherwise>—</c:otherwise></c:choose></span>
                    </div>

                    <!-- Chỉ số BMI -->
                    <c:if test="${record.bmi > 0}">
                        <div class="flex items-center justify-between p-3.5 bg-brand-soft/20 rounded-xl border border-brand-soft/30 mt-6">
                            <div class="flex items-center gap-2.5">
                                <span class="h-8 w-8 rounded-lg bg-brand text-brand-foreground flex items-center justify-center font-bold text-xs">BMI</span>
                                <span class="text-sm font-semibold text-brand">Chỉ số BMI</span>
                            </div>
                            <div class="text-right">
                                <span class="text-sm font-extrabold text-brand">${record.bmi}</span>
                                <span class="text-[10px] text-muted-foreground block">
                                    <c:choose>
                                        <c:when test="${record.bmi < 18.5}">Gầy</c:when>
                                        <c:when test="${record.bmi >= 18.5 && record.bmi < 24.9}">Bình thường</c:when>
                                        <c:when test="${record.bmi >= 25 && record.bmi < 29.9}">Thừa cân</c:when>
                                        <c:otherwise>Béo phì</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
