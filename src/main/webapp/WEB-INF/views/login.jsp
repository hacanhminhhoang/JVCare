<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Đăng nhập — JVCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              background: "#f8faff",
              ink: "#1a2035",
              brand: "#1a56db",
              "brand-foreground": "#ffffff",
              "brand-soft": "#e8f0fe",
              muted: "#eef2fb",
              "muted-foreground": "#6b7a99",
              border: "rgba(26, 86, 219, 0.12)",
              card: "#ffffff",
              input: "#e2e8f0",
            },
            fontFamily: {
              sans: ["'Be Vietnam Pro'", "system-ui", "sans-serif"],
              display: ["'Be Vietnam Pro'", "system-ui", "sans-serif"],
            },
          },
        },
      };
    </script>
  </head>
  <body class="min-h-screen bg-background font-sans text-ink">
    <div class="flex min-h-screen">
      <!-- Left side image and centered overlay -->
      <div class="relative hidden flex-col lg:flex lg:w-[64%] items-center justify-center p-10 text-white select-none">
        <div
          class="absolute inset-0 bg-cover bg-center"
          style="background-image: url('${pageContext.request.contextPath}/images/login_bg_doctor.png');"
        ></div>
        <!-- Semi-transparent overlay to match the screenshot -->
        <div class="absolute inset-0 bg-slate-900/40 backdrop-blur-[1px]"></div>

        <div class="relative z-20 m-auto text-center max-w-lg">
          <h1 class="font-serif text-7xl font-bold tracking-tight text-white mb-6 drop-shadow-md">
            JVCare
          </h1>
          <p class="text-base leading-relaxed text-white/95 max-w-md mx-auto drop-shadow-sm font-medium">
            Hệ thống quản lý hồ sơ bệnh án điện tử toàn diện, bảo mật và tối ưu quy trình chăm sóc sức khỏe của bạn.
          </p>
        </div>
      </div>

      <!-- Right side form -->
      <div class="flex w-full flex-col justify-center px-8 lg:w-[36%] sm:px-12 md:px-16 xl:px-24 bg-white">
        <div class="mx-auto w-full max-w-sm">
          <!-- Logo & Title -->
          <div class="mb-8">
            <h1 class="font-display text-4xl font-bold tracking-tight text-[#1a56db]">
              JVCare
            </h1>
            <p class="text-xl font-bold text-slate-800 mt-1.5">
              Chào mừng trở lại
            </p>
          </div>

          <!-- Error/Success notifications -->
          <c:if test="${not empty errorMessage}">
            <div class="mb-4 rounded-lg bg-red-50 p-3 text-sm text-red-600 border border-red-100 flex items-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10" /><line x1="12" x2="12" y1="8" y2="12" /><line x1="12" x2="12.01" y1="16" y2="16" />
              </svg>
              <c:out value="${errorMessage}" />
            </div>
          </c:if>

          <c:if test="${not empty successMessage}">
            <div class="mb-4 rounded-lg bg-emerald-50 p-3 text-sm text-emerald-600 border border-emerald-100 flex items-center gap-2">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>
              </svg>
              <c:out value="${successMessage}" />
            </div>
          </c:if>

          <!-- Form -->
          <form action="${pageContext.request.contextPath}/login" method="POST" class="space-y-4">
            <!-- Email Input -->
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-gray-500">Email</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                  </svg>
                </div>
                <input
                  required
                  type="email"
                  name="email"
                  class="block w-full pl-10 pr-3 py-2.5 text-sm rounded-lg border border-gray-200 bg-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#1a56db] focus:border-transparent transition"
                  placeholder="name@company.com"
                />
              </div>
            </div>

            <!-- Password Input -->
            <div class="space-y-1.5">
              <label class="text-sm font-medium text-gray-500">Mật khẩu</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                  </svg>
                </div>
                <input
                  required
                  type="password"
                  name="password"
                  id="password"
                  class="block w-full pl-10 pr-10 py-2.5 text-sm rounded-lg border border-gray-200 bg-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#1a56db] focus:border-transparent transition"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  id="togglePassword"
                  class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400 hover:text-gray-600"
                >
                  <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z" /><circle cx="12" cy="12" r="3" />
                  </svg>
                  <svg id="eyeClosed" class="hidden" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24" />
                    <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68" />
                    <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61" /><line x1="2" x2="22" y1="2" y2="22" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Login Button -->
            <button
              type="submit"
              class="w-full inline-flex h-11 items-center justify-center rounded-lg bg-[#1a56db] hover:bg-[#1e40af] text-white font-semibold text-sm transition shadow-sm focus:outline-none focus:ring-2 focus:ring-[#1a56db] focus:ring-offset-2 mt-6"
            >
              Đăng nhập
            </button>
          </form>

          <div class="mt-4 text-center text-sm font-medium">
            <span class="text-gray-400">Chưa có tài khoản?</span>
            <a href="${pageContext.request.contextPath}/register" class="font-semibold text-[#1a56db] hover:underline ml-1">Đăng ký ngay</a>
          </div>

          <!-- Footer text -->
          <p class="text-center text-xs text-gray-400 mt-8 leading-relaxed font-medium select-none">
            Bạn chưa có tài khoản? Vui lòng liên hệ lễ tân để được hỗ trợ.
          </p>
        </div>
      </div>
    </div>

    <script>
      // Toggle password visibility
      document.getElementById("togglePassword").addEventListener("click", function (e) {
        const passwordInput = document.getElementById("password");
        const eyeOpen = document.getElementById("eyeOpen");
        const eyeClosed = document.getElementById("eyeClosed");

        if (passwordInput.type === "password") {
          passwordInput.type = "text";
          eyeOpen.classList.add("hidden");
          eyeClosed.classList.remove("hidden");
        } else {
          passwordInput.type = "password";
          eyeOpen.classList.remove("hidden");
          eyeClosed.classList.add("hidden");
        }
      });
    </script>
  </body>
</html>
