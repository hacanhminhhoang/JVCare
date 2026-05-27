<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>JVCare - Hệ thống Quản lý Bệnh án</title>

      <!-- CSS Tùy chỉnh -->
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />

      <!-- Tailwind CSS (CDN) -->
      <script src="https://cdn.tailwindcss.com"></script>
      <script>
        tailwind.config = {
          theme: {
            extend: {
              colors: {
                background: "#f8faff",
                foreground: "#1a2035",
                ink: "#1a2035",
                brand: "#1a56db",
                "brand-foreground": "#f8faff",
                "brand-soft": "#e8f0fe",
                muted: "#eef2fb",
                "muted-foreground": "#6b7a99",
                border: "rgba(26, 86, 219, 0.12)",
                card: "#ffffff",
              },
              fontFamily: {
                sans: ["'Be Vietnam Pro'", "system-ui", "sans-serif"],
                display: ["'Be Vietnam Pro'", "system-ui", "sans-serif"],
              },
            },
          },
        };
      </script>
      <style>
        @media print {

          /* 1. PHÁ VỠ LỒNG KÍNH CỦA TAILWIND (Sửa lỗi thanh cuộn & kẹt 1 trang) */
          .h-screen {
            height: auto !important;
            min-height: 100% !important;
            display: block !important;
          }

          .overflow-hidden,
          .overflow-y-auto {
            overflow: visible !important;
          }

          /* 2. Dành cho trang CÓ #print-document (như Chi tiết bệnh án) */
          body:has(#print-document) aside,
          body:has(#print-document) header,
          body:has(#print-document) .no-print-wrapper,
          body:has(#print-document) nav {
            display: none !important;
          }

          /* 3. Dành cho trang KHÔNG CÓ #print-document (Generic print) */
          body:not(:has(#print-document)) aside,
          body:not(:has(#print-document)) header,
          body:not(:has(#print-document)) #searchInput,
          body:not(:has(#print-document)) .no-print,
          body:not(:has(#print-document)) button,
          body:not(:has(#print-document)) a[href],
          body:not(:has(#print-document)) nav,
          body:not(:has(#print-document)) [class*="search"],
          body:not(:has(#print-document)) .flex.items-center.gap-4 {
            display: none !important;
          }

          body:not(:has(#print-document)) body,
          body:not(:has(#print-document)) html {
            background: white !important;
          }

          body:not(:has(#print-document)) .p-6,
          body:not(:has(#print-document)) .md\:p-8,
          body:not(:has(#print-document)) .lg\:p-12 {
            padding: 0 !important;
          }

          body:not(:has(#print-document)) .max-w-5xl,
          body:not(:has(#print-document)) .mx-auto {
            max-width: 100% !important;
            margin: 0 !important;
          }

          body:not(:has(#print-document)) .print-header {
            display: block !important;
          }

          body:not(:has(#print-document)) .rounded-2xl,
          body:not(:has(#print-document)) .rounded-3xl {
            border-radius: 0 !important;
          }

          body:not(:has(#print-document)) .shadow-sm,
          body:not(:has(#print-document)) .shadow-md {
            box-shadow: none !important;
          }

          body:not(:has(#print-document)) .border {
            border: 1px solid #ddd !important;
          }

          @page {
            margin: 15mm;
            size: A4;
          }
        }

        .print-header {
          display: none;
        }
      </style>
    </head>

    <body
      class="min-h-screen bg-background text-foreground antialiased selection:bg-brand/20 selection:text-brand-foreground">
      <!-- Sidebar / Shell Wrapper -->
      <div class="flex h-screen overflow-hidden">
        <!-- Sidebar Navigation (Mock) -->
        <aside class="w-64 border-r border-border/60 bg-white shadow-sm flex flex-col hidden md:flex">
          <div class="flex h-16 shrink-0 items-center px-6">
            <span class="font-display font-bold text-xl text-brand">JVCare</span>
          </div>
          <nav class="flex-1 space-y-1 px-4 py-4">
            <c:set var="uri" value="${pageContext.request.requestURI}" />
            <c:set var="isIndex" value="${uri.endsWith('/patient/index')}" />
            <c:set var="isHistory" value="${uri.contains('/patient/medical-history')}" />
            <c:set var="isAppt"
              value="${uri.endsWith('/patient/appointments') || uri.endsWith('/patient/book-appointment')}" />
            <c:set var="isRx" value="${uri.endsWith('/patient/prescriptions')}" />
            <c:set var="isAi" value="${uri.endsWith('/patient/ai')}" />
            <c:set var="isProfile" value="${uri.endsWith('/patient/profile')}" />

            <a href="${pageContext.request.contextPath}/patient/index"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isIndex ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
                <line x1="16" x2="8" y1="13" y2="13"></line>
                <line x1="16" x2="8" y1="17" y2="17"></line>
                <line x1="10" x2="8" y1="9" y2="9"></line>
              </svg>
              Bệnh án tóm tắt
            </a>

            <a href="${pageContext.request.contextPath}/patient/medical-history"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isHistory ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 20h9"></path>
                <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"></path>
              </svg>
              Lịch sử khám bệnh
            </a>

            <a href="${pageContext.request.contextPath}/patient/appointments"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isAppt ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect width="18" height="18" x="3" y="4" rx="2" ry="2" />
                <line x1="16" x2="16" y1="2" y2="6" />
                <line x1="8" x2="8" y1="2" y2="6" />
                <line x1="3" x2="21" y1="10" y2="10" />
              </svg>
              Lịch tái khám & đặt lịch
            </a>

            <a href="${pageContext.request.contextPath}/patient/prescriptions"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isRx ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z" />
                <path d="m8.5 8.5 7 7" />
              </svg>
              Đơn thuốc
            </a>

            <a href="${pageContext.request.contextPath}/patient/ai"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isAi ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path
                  d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275Z">
                </path>
              </svg>
              Trợ lý AI
            </a>

            <a href="${pageContext.request.contextPath}/patient/profile"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm ${isProfile ? 'bg-brand-soft font-semibold text-brand' : 'font-medium text-muted-foreground hover:bg-brand-soft hover:text-brand'}">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
              Hồ sơ cá nhân
            </a>

          </nav>
          <div class="border-t border-border/60 p-4 space-y-2">
            <div class="flex items-center gap-3 rounded-xl bg-muted/50 p-3 mb-2">
              <div
                class="h-10 w-10 shrink-0 rounded-full bg-brand-soft text-brand flex items-center justify-center font-bold">
                <c:out
                  value="${not empty sessionScope.user.fullName ? (sessionScope.user.fullName.length() >= 2 ? sessionScope.user.fullName.substring(0,2).toUpperCase() : sessionScope.user.fullName.toUpperCase()) : 'U'}" />
              </div>
              <div class="overflow-hidden">
                <p class="truncate text-sm font-semibold text-ink">
                  <c:out value="${sessionScope.user.fullName}" />
                </p>
                <p class="truncate text-xs text-muted-foreground">
                  <c:out value="${sessionScope.user.email}" />
                </p>
              </div>
            </div>
            <a href="${pageContext.request.contextPath}/"
              class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted transition">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                <polyline points="9 22 9 12 15 12 15 22" />
              </svg>
              Trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/login"
              class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-red-600 hover:bg-red-50 transition">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                <polyline points="16 17 21 12 16 7" />
                <line x1="21" x2="9" y1="12" y2="12" />
              </svg>
              Đăng xuất
            </a>
          </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 overflow-y-auto">
          <c:if test="${sessionScope.user.role != 'PATIENT'}">
            <header
              class="sticky top-0 z-10 flex h-16 shrink-0 items-center justify-between border-b border-border/40 bg-background/80 px-6 backdrop-blur-md">
              <div class="flex items-center"></div>

              <div class="relative mx-4 hidden md:block z-50 flex-1 max-w-md ml-8">
                <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                    class="text-muted-foreground" viewBox="0 0 16 16">
                    <path
                      d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z" />
                  </svg>
                </div>
                <input type="text" id="searchInput" autocomplete="off"
                  class="block w-full rounded-lg border border-border bg-card py-2 pl-10 pr-3 text-sm text-ink placeholder-muted-foreground focus:border-brand focus:outline-none focus:ring-1 focus:ring-brand transition-all duration-200"
                  placeholder="Tìm kiếm bệnh nhân, lịch hẹn..." />
                <div id="searchResults"
                  class="absolute left-0 top-full mt-2 w-full max-h-96 overflow-y-auto rounded-lg border border-border bg-card shadow-xl"
                  style="display: none"></div>
              </div>
              <div class="flex items-center gap-4">
              </div>
            </header>
          </c:if>

          <div class="p-6 md:p-8 lg:p-12 max-w-5xl mx-auto">
            <jsp:include page="${contentPage}" />
          </div>
        </main>
      </div>
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

      <script src="${pageContext.request.contextPath}/js/notifications.js"></script>
      <script src="${pageContext.request.contextPath}/js/validation.js"></script>
      <script src="${pageContext.request.contextPath}/js/search.js"></script>

      <script>
        document.addEventListener("DOMContentLoaded", function () {
          // Lấy thông báo từ session (nếu có) do Servlet gửi sang
          const successMsg = "${sessionScope.message}";
          const errorMsg = "${sessionScope.error}";

          if (successMsg) {
            showSuccess(successMsg);
            // Xóa session sau khi hiển thị bằng JSTL (cần thêm taglib ở đầu trang nếu dùng cách khác)
            <c:remove var="message" scope="session" />;
          }
          if (errorMsg) {
            showError(errorMsg);
            <c:remove var="error" scope="session" />;
          }
        });
      </script>
    </body>

    </html>