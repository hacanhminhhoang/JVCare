<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập — JVCare</title>
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
                        card: "oklch(1 0 0)"
                    },
                    fontFamily: {
                        sans: ['Manrope', 'system-ui', 'sans-serif'],
                        display: ['Sora', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>
</head>
<body class="flex min-h-screen items-center justify-center bg-gradient-to-br from-brand-soft via-background to-background px-4 py-12 font-sans text-ink">
    <div class="w-full max-w-md rounded-3xl border border-border/60 bg-card p-8 shadow-xl">
        <div class="mb-6 flex justify-center">
            <span class="font-display font-bold text-3xl text-brand">JVCare</span>
        </div>
        <h1 class="text-center font-display text-2xl font-bold text-ink">
            Chào mừng trở lại
        </h1>
        <p class="mt-2 text-center text-sm text-muted-foreground">
            Đăng nhập để truy cập hồ sơ bệnh án của bạn
        </p>

        <c:if test="${not empty errorMessage}">
            <div class="mt-4 rounded-xl bg-red-50 p-3 text-sm text-red-600 text-center border border-red-100">
                <c:out value="${errorMessage}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST" class="mt-6 space-y-4">
            <div>
                <label class="mb-1.5 block text-sm font-medium text-ink">Email</label>
                <input required type="email" name="email" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand" placeholder="admin@jvcare.vn" />
            </div>
            <div>
                <label class="mb-1.5 block text-sm font-medium text-ink">Mật khẩu</label>
                <input required type="password" name="password" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-brand" placeholder="admin123" />
            </div>
            <button type="submit" class="flex w-full items-center justify-center gap-2 rounded-xl bg-brand py-3 text-sm font-semibold text-brand-foreground transition hover:opacity-90">
                Đăng nhập
            </button>
        </form>

        <p class="mt-6 text-center text-xs text-muted-foreground">
            Bạn chưa có tài khoản? Vui lòng liên hệ lễ tân để đăng ký hồ sơ bệnh nhân.
        </p>
    </div>
</body>
</html>
