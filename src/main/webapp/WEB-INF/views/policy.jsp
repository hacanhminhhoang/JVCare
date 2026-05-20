<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chính sách bảo mật — JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
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
<body class="min-h-screen bg-background font-sans text-ink">
    <header class="sticky top-0 z-50 border-b border-border/60 bg-background/80 backdrop-blur-xl">
      <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <a href="${pageContext.request.contextPath}/" class="flex items-center gap-2">
          <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-brand to-[oklch(0.45_0.15_210)] text-brand-foreground shadow-lg shadow-brand/20">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/><path d="M10 10.5c3.8 0 6.8 2.5 6.8 5.6 0 3.1-3 5.6-6.8 5.6S3.2 19.2 3.2 16.1c0-3.1 3-5.6 6.8-5.6Z"/><path d="m10 13-1.4 1.6c-.6.7-1.7 1.9-1.7 3.2 0 1.6 1.4 2.9 3.1 2.9 1.7 0 3.1-1.3 3.1-2.9 0-1.3-1.1-2.5-1.7-3.2L10 13Z"/></svg>
          </div>
          <span class="font-display text-xl font-bold tracking-tight text-ink">
            JV<span class="text-brand">Care</span>
          </span>
        </a>
        <div class="flex items-center gap-3">
          <a href="${pageContext.request.contextPath}/login" class="text-sm font-medium text-muted-foreground hover:text-ink">Đăng nhập</a>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-3xl px-6 py-16">
        <h1 class="font-display text-4xl font-bold tracking-tight text-ink">Chính sách bảo mật & Điều khoản sử dụng</h1>
        <p class="mt-3 text-sm text-muted-foreground">Cập nhật lần cuối: 19/05/2026</p>
        <div class="mt-10 space-y-8">
            <section>
              <h2 class="font-display text-xl font-semibold text-ink">1. Thu thập thông tin</h2>
              <p class="mt-2 leading-relaxed text-muted-foreground">JVCare chỉ thu thập thông tin cần thiết cho mục đích chăm sóc sức khỏe: họ tên, ngày sinh, số điện thoại, email, lịch sử khám chữa bệnh và đơn thuốc. Mọi thông tin do người dùng cung cấp hoặc do bác sĩ điều trị nhập vào.</p>
            </section>
            <section>
              <h2 class="font-display text-xl font-semibold text-ink">2. Sử dụng thông tin</h2>
              <p class="mt-2 leading-relaxed text-muted-foreground">Dữ liệu được sử dụng để: (1) cung cấp dịch vụ quản lý bệnh án, (2) hỗ trợ chẩn đoán bằng AI khi bệnh nhân yêu cầu, (3) gửi thông báo về lịch tái khám và đơn thuốc. Chúng tôi KHÔNG bán hay chia sẻ dữ liệu cho bên thứ ba vì mục đích thương mại.</p>
            </section>
            <section>
              <h2 class="font-display text-xl font-semibold text-ink">3. Bảo mật dữ liệu</h2>
              <p class="mt-2 leading-relaxed text-muted-foreground">Toàn bộ dữ liệu được mã hóa cả khi truyền tải (TLS 1.3) lẫn khi lưu trữ (AES-256). Cơ chế phân quyền theo vai trò đảm bảo bệnh nhân chỉ truy cập được hồ sơ của chính mình; bác sĩ chỉ truy cập hồ sơ trong phạm vi điều trị.</p>
            </section>
            <section>
              <h2 class="font-display text-xl font-semibold text-ink">4. Quyền của bệnh nhân</h2>
              <p class="mt-2 leading-relaxed text-muted-foreground">Bệnh nhân có quyền: xem, tải về (định dạng PDF), yêu cầu chỉnh sửa hoặc xóa toàn bộ hồ sơ cá nhân bất kỳ lúc nào bằng cách liên hệ qua email support@jvcare.vn.</p>
            </section>
            <section>
              <h2 class="font-display text-xl font-semibold text-ink">5. AI chẩn đoán</h2>
              <p class="mt-2 leading-relaxed text-muted-foreground">Các gợi ý từ trợ lý AI chỉ mang tính tham khảo, KHÔNG thay thế chẩn đoán của bác sĩ. Bệnh nhân nên trao đổi với bác sĩ chuyên khoa trước khi đưa ra quyết định điều trị.</p>
            </section>
            <section>
              <h2 class="font-display text-xl font-semibold text-ink">6. Liên hệ</h2>
              <p class="mt-2 leading-relaxed text-muted-foreground">Mọi thắc mắc về chính sách xin gửi về email: privacy@jvcare.vn hoặc hotline 1900-xxxx.</p>
            </section>
        </div>
    </main>
    
    <footer class="border-t border-border bg-background">
      <div class="mx-auto flex max-w-7xl flex-col items-start justify-between gap-6 px-6 py-10 sm:flex-row sm:items-center">
        <div>
          <span class="font-display text-xl font-bold tracking-tight text-ink">JV<span class="text-brand">Care</span></span>
          <p class="mt-2 text-sm text-muted-foreground">© 2026 JVCare. Nền tảng y tế số.</p>
        </div>
        <div class="flex gap-6 text-sm text-muted-foreground">
          <a href="${pageContext.request.contextPath}/policy" class="hover:text-ink">Chính sách bảo mật</a>
          <a href="${pageContext.request.contextPath}/about" class="hover:text-ink">Về chúng tôi</a>
        </div>
      </div>
    </footer>
</body>
</html>
