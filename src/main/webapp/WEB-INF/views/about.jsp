<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Về chúng tôi — JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        background: "#f8faff",
                        ink: "#1a2035",
                        brand: "#1a56db",
                        "brand-foreground": "#f8faff",
                        "brand-soft": "#e8f0fe",
                        muted: "#eef2fb",
                        "muted-foreground": "#6b7a99",
                        border: "rgba(26, 86, 219, 0.12)",
                        card: "#ffffff"
                    },
                    fontFamily: {
                        sans: ['Be Vietnam Pro', 'system-ui', 'sans-serif'],
                        display: ['Be Vietnam Pro', 'system-ui', 'sans-serif'],
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
          <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-brand to-[#1e40af] text-brand-foreground shadow-lg shadow-brand/20">
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

    <main class="mx-auto max-w-5xl px-6 py-16">
        <span class="inline-flex items-center rounded-full bg-brand-soft px-3 py-1 text-xs font-semibold text-brand">
          Về JVCare
        </span>
        <h1 class="mt-4 font-display text-4xl font-bold tracking-tight text-ink md:text-5xl">
          Số hóa bệnh án, nâng tầm chăm sóc sức khỏe Việt Nam
        </h1>
        <p class="mt-6 max-w-3xl text-lg leading-relaxed text-muted-foreground">
          JVCare ra đời với sứ mệnh giúp các bệnh viện, phòng khám và bệnh nhân
          Việt Nam quản lý hồ sơ y tế một cách thông minh, an toàn và hiệu quả.
          Chúng tôi tin rằng công nghệ có thể giải phóng đội ngũ y bác sĩ khỏi
          giấy tờ, để họ dành nhiều thời gian hơn cho điều quan trọng nhất —
          bệnh nhân.
        </p>
        <div class="mt-12 grid gap-6 sm:grid-cols-2">
            <div class="rounded-2xl border border-border/60 bg-card p-6">
              <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-brand-soft text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
              </div>
              <h3 class="mt-4 font-display text-lg font-semibold text-ink">Tận tâm</h3>
              <p class="mt-1.5 text-sm text-muted-foreground">Lấy bệnh nhân làm trung tâm trong mọi tính năng chúng tôi xây dựng.</p>
            </div>
            
            <div class="rounded-2xl border border-border/60 bg-card p-6">
              <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-brand-soft text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/></svg>
              </div>
              <h3 class="mt-4 font-display text-lg font-semibold text-ink">An toàn</h3>
              <p class="mt-1.5 text-sm text-muted-foreground">Mã hóa đầu cuối, tuân thủ tiêu chuẩn bảo mật y tế quốc tế.</p>
            </div>

            <div class="rounded-2xl border border-border/60 bg-card p-6">
              <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-brand-soft text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/></svg>
              </div>
              <h3 class="mt-4 font-display text-lg font-semibold text-ink">Chính xác</h3>
              <p class="mt-1.5 text-sm text-muted-foreground">Hỗ trợ AI giúp giảm sai sót trong chẩn đoán và kê đơn.</p>
            </div>

            <div class="rounded-2xl border border-border/60 bg-card p-6">
              <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-brand-soft text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              </div>
              <h3 class="mt-4 font-display text-lg font-semibold text-ink">Kết nối</h3>
              <p class="mt-1.5 text-sm text-muted-foreground">Cầu nối hiệu quả giữa bác sĩ, bệnh nhân và cơ sở y tế.</p>
            </div>
        </div>
        <section class="mt-16 rounded-3xl bg-gradient-to-br from-brand to-[#1e40af] p-10 text-brand-foreground">
          <h2 class="font-display text-2xl font-bold">Câu chuyện của chúng tôi</h2>
          <p class="mt-4 leading-relaxed opacity-90">
            Được thành lập bởi đội ngũ kỹ sư phần mềm và bác sĩ giàu kinh nghiệm,
            JVCare đã đồng hành cùng hơn 200 cơ sở y tế trên cả nước. Chúng tôi
            không ngừng cải tiến sản phẩm dựa trên phản hồi thực tế từ người dùng,
            mang đến một nền tảng vừa hiện đại vừa phù hợp với đặc thù y tế Việt Nam.
          </p>
        </section>
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
