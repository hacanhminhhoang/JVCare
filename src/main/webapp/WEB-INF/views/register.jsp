<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <title>Đăng ký tài khoản khách hàng — JVCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              background: "oklch(0.99 0.005 180)",
              ink: "oklch(0.14 0.03 210)",
              brand: "oklch(0.55 0.13 195)",
              "brand-foreground": "oklch(0.99 0.005 180)",
              "brand-soft": "oklch(0.95 0.04 190)",
              muted: "oklch(0.96 0.012 200)",
              "muted-foreground": "oklch(0.5 0.025 215)",
              border: "oklch(0.92 0.015 200)",
              card: "oklch(1 0 0)",
              input: "oklch(0.85 0.01 200)",
            },
            fontFamily: {
              sans: ["Manrope", "system-ui", "sans-serif"],
              display: ["Sora", "system-ui", "sans-serif"],
            },
          },
        },
      };
    </script>
  </head>
  <body class="min-h-screen bg-background font-sans text-ink">
    <div class="flex min-h-screen">
      <!-- Left side image panel (Consistent with login) -->
      <div class="relative hidden w-1/2 flex-col bg-ink p-10 text-white lg:flex">
        <div
          class="absolute inset-0 bg-cover bg-center"
          style="background-image: url('${pageContext.request.contextPath}/images/hero-doctor.jpg');"
        ></div>
        <div class="absolute inset-0 bg-gradient-to-t from-ink/90 via-ink/40 to-transparent"></div>

        <div class="relative z-20 flex items-center font-display text-2xl font-bold text-white">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="mr-2 h-6 w-6"
          >
            <path d="M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3"></path>
          </svg>
          JVCare
        </div>

        <div class="relative z-20 mt-auto">
          <blockquote class="space-y-2">
            <p class="text-lg font-medium leading-relaxed">
              "Bắt đầu ngay hôm nay để quản lý hồ sơ sức khỏe thông minh, nhận chỉ dẫn y tế chuẩn xác và kết nối nhanh chóng với đội ngũ bác sĩ hàng đầu."
            </p>
            <footer class="text-sm text-gray-300">
              Hệ thống chăm sóc sức khỏe chủ động JVCare
            </footer>
          </blockquote>
        </div>
      </div>

      <!-- Right side Sign-up Form -->
      <div class="flex w-full flex-col justify-center px-8 lg:w-1/2 sm:px-12 md:px-16 xl:px-24 py-12">
        <div class="mx-auto w-full max-w-sm">
          <!-- Logo for mobile -->
          <div class="mb-8 flex items-center font-display text-2xl font-bold text-ink lg:hidden">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="mr-2 h-6 w-6"
            >
              <path d="M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3"></path>
            </svg>
            JVCare
          </div>

          <div class="flex flex-col space-y-2 text-left mb-6">
            <h1 class="font-display text-2xl font-semibold tracking-tight text-ink">
              Đăng ký tài khoản
            </h1>
            <p class="text-sm text-muted-foreground">
              Tạo hồ sơ bệnh án điện tử cá nhân hoàn toàn miễn phí.
            </p>
          </div>

          <!-- Error Message Container -->
          <c:if test="${not empty errorMessage}">
            <div class="mb-4 rounded-md bg-red-50 p-3 text-sm text-red-600 border border-red-100 flex items-center gap-2">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <circle cx="12" cy="12" r="10" />
                <line x1="12" x2="12" y1="8" y2="12" />
                <line x1="12" x2="12.01" y1="16" y2="16" />
              </svg>
              <c:out value="${errorMessage}" />
            </div>
          </c:if>

          <form action="${pageContext.request.contextPath}/register" method="POST" class="space-y-4">
            <!-- Full Name -->
            <div class="space-y-1.5">
              <label class="text-sm font-medium leading-none">Họ và tên</label>
              <input
                required
                type="text"
                name="fullName"
                value="<c:out value='${param.fullName}'/>"
                class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent transition"
                placeholder="Nguyễn Văn A"
              />
            </div>

            <!-- Email -->
            <div class="space-y-1.5">
              <label class="text-sm font-medium leading-none">Email</label>
              <input
                required
                type="email"
                name="email"
                value="<c:out value='${param.email}'/>"
                class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent transition"
                placeholder="nguyenvana@gmail.com"
              />
            </div>

            <!-- Phone Number -->
            <div class="space-y-1.5">
              <label class="text-sm font-medium leading-none">Số điện thoại</label>
              <input
                required
                type="tel"
                name="phone"
                pattern="[0-9]{10,11}"
                value="<c:out value='${param.phone}'/>"
                class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent transition"
                placeholder="0987654321"
              />
            </div>

            <!-- Password -->
            <div class="space-y-1.5">
              <label class="text-sm font-medium leading-none">Mật khẩu</label>
              <div class="relative">
                <input
                  required
                  type="password"
                  name="password"
                  id="password"
                  class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent transition pr-10"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  id="togglePassword"
                  class="absolute inset-y-0 right-0 flex items-center pr-3 text-muted-foreground hover:text-ink"
                >
                  <svg
                    id="eyeOpen"
                    xmlns="http://www.w3.org/2000/svg"
                    width="16"
                    height="16"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z" />
                    <circle cx="12" cy="12" r="3" />
                  </svg>
                  <svg
                    id="eyeClosed"
                    class="hidden"
                    xmlns="http://www.w3.org/2000/svg"
                    width="16"
                    height="16"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24" />
                    <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68" />
                    <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61" />
                    <line x1="2" x2="22" y1="2" y2="22" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Submit button -->
            <button
              type="submit"
              class="inline-flex h-10 mt-4 w-full items-center justify-center rounded-md bg-ink px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-ink/90 focus:outline-none focus:ring-2 focus:ring-brand focus:ring-offset-2"
            >
              Đăng ký tài khoản
            </button>
          </form>

          <div class="mt-6 text-center text-sm">
            <span class="text-muted-foreground">Đã có tài khoản?</span>
            <a href="${pageContext.request.contextPath}/login" class="font-semibold text-brand hover:underline ml-1">Đăng nhập ngay</a>
          </div>

          <p class="px-8 text-center text-xs text-muted-foreground mt-8 leading-relaxed">
            Bằng việc đăng ký, bạn đồng ý với
            <a href="#" class="underline underline-offset-4 hover:text-ink">Điều khoản dịch vụ</a>
            và
            <a href="${pageContext.request.contextPath}/policy" class="underline underline-offset-4 hover:text-ink">Chính sách bảo mật</a>
            của chúng tôi.
          </p>
        </div>
      </div>
    </div>

    <!-- Password visibility toggle script -->
    <script>
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
