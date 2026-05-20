<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>JVCare — Nền tảng quản lý bệnh án thông minh</title>
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
                        card: "oklch(1 0 0)",
                        accent: "oklch(0.65 0.15 45)",
                        "accent-foreground": "oklch(0.99 0.01 45)"
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
<body class="min-h-screen bg-background font-sans text-ink antialiased">
    <!-- Header -->
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
        <nav class="hidden items-center gap-8 md:flex">
            <a href="#features" class="text-sm font-medium text-muted-foreground transition hover:text-ink">Tính năng</a>
            <a href="#workflow" class="text-sm font-medium text-muted-foreground transition hover:text-ink">Quy trình</a>
            <a href="#pricing" class="text-sm font-medium text-muted-foreground transition hover:text-ink">Bảng giá</a>
            <a href="#testimonials" class="text-sm font-medium text-muted-foreground transition hover:text-ink">Đánh giá</a>
        </nav>
        <div class="flex items-center gap-3">
          <a href="${pageContext.request.contextPath}/login" class="hidden text-sm font-medium text-muted-foreground hover:text-ink sm:block">Đăng nhập</a>
          <a href="#cta" class="inline-flex items-center gap-1.5 rounded-full bg-ink px-4 py-2 text-sm font-semibold text-background transition hover:opacity-90">
            Dùng thử miễn phí
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
          </a>
        </div>
      </div>
    </header>

    <main>
        <!-- Hero -->
        <section class="relative overflow-hidden">
          <div class="absolute inset-0 -z-10 bg-[radial-gradient(60%_50%_at_50%_0%,oklch(0.95_0.04_190)_0%,transparent_70%)]"></div>
          <div class="mx-auto grid max-w-7xl gap-16 px-6 py-20 lg:grid-cols-[1.05fr_1fr] lg:items-center lg:py-28">
            <div>
              <div class="inline-flex items-center gap-2 rounded-full border border-brand/20 bg-brand-soft px-3 py-1 text-xs font-semibold text-brand">
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275Z"/></svg>
                Nền tảng EMR thế hệ mới cho cơ sở y tế Việt Nam
              </div>
              <h1 class="mt-6 font-display text-5xl font-bold leading-[1.05] tracking-tight text-ink lg:text-6xl">
                Quản lý bệnh án <span class="bg-gradient-to-r from-brand to-[oklch(0.45_0.15_210)] bg-clip-text text-transparent">thông minh, an toàn</span> cho mọi cơ sở y tế.
              </h1>
              <p class="mt-6 max-w-xl text-lg leading-relaxed text-muted-foreground">
                JVCare số hoá toàn bộ hồ sơ bệnh án — từ tiếp đón, khám chữa, kê đơn đến lưu trữ —
                giúp bác sĩ tiết kiệm 70% thời gian giấy tờ và đảm bảo bảo mật chuẩn HIPAA.
              </p>
              <div class="mt-8 flex flex-wrap items-center gap-3">
                <a href="#cta" class="inline-flex items-center gap-2 rounded-full bg-brand px-6 py-3 text-sm font-semibold text-brand-foreground shadow-lg shadow-brand/25 transition hover:shadow-xl hover:shadow-brand/30">
                  Trải nghiệm miễn phí 30 ngày
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                </a>
                <a href="#workflow" class="inline-flex items-center gap-2 rounded-full border border-border bg-background px-6 py-3 text-sm font-semibold text-ink transition hover:bg-muted">
                  Xem demo
                </a>
              </div>
              <div class="mt-10 flex items-center gap-6 text-sm text-muted-foreground">
                <div class="flex items-center gap-2"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" class="text-brand" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Không cần thẻ tín dụng</div>
                <div class="flex items-center gap-2"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" class="text-brand" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Triển khai trong 24h</div>
              </div>
            </div>
            <div class="relative">
              <div class="absolute -inset-6 -z-10 rounded-[2rem] bg-gradient-to-tr from-brand/20 via-transparent to-accent/30 blur-2xl"></div>
              <img src="${pageContext.request.contextPath}/images/hero-doctor.jpg" alt="Bác sĩ sử dụng JVCare để xem bệnh án điện tử trên máy tính bảng" class="rounded-3xl border border-border/60 shadow-2xl shadow-brand/10 w-full" />
              <div class="absolute -bottom-6 -left-6 hidden rounded-2xl border border-border bg-card p-4 shadow-xl sm:block">
                <div class="flex items-center gap-3">
                  <div class="flex h-10 w-10 items-center justify-center rounded-full bg-brand-soft text-brand">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                  </div>
                  <div>
                    <p class="text-xs text-muted-foreground">Bệnh nhân hôm nay</p>
                    <p class="font-display text-lg font-bold text-ink">+248 hồ sơ</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- LogoStrip -->
        <section class="border-y border-border/60 bg-muted/30">
          <div class="mx-auto flex max-w-7xl flex-wrap items-center justify-center gap-x-12 gap-y-4 px-6 py-8">
            <p class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Được tin dùng bởi 200+ cơ sở y tế</p>
            <span class="font-display text-lg font-semibold text-muted-foreground/70">Vinmec</span>
            <span class="font-display text-lg font-semibold text-muted-foreground/70">Hồng Ngọc</span>
            <span class="font-display text-lg font-semibold text-muted-foreground/70">Tâm Anh</span>
            <span class="font-display text-lg font-semibold text-muted-foreground/70">Medlatec</span>
            <span class="font-display text-lg font-semibold text-muted-foreground/70">Hoàn Mỹ</span>
            <span class="font-display text-lg font-semibold text-muted-foreground/70">FV Hospital</span>
          </div>
        </section>

        <!-- Features -->
        <section id="features" class="mx-auto max-w-7xl px-6 py-24">
          <div class="max-w-2xl">
            <p class="text-sm font-semibold uppercase tracking-widest text-brand">Tính năng</p>
            <h2 class="mt-3 font-display text-4xl font-bold tracking-tight text-ink lg:text-5xl">Tất cả những gì cơ sở y tế cần — trong một nền tảng.</h2>
          </div>
          <div class="mt-16 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            <div class="group relative rounded-2xl border border-border bg-card p-7 transition hover:-translate-y-1 hover:border-brand/40 hover:shadow-xl hover:shadow-brand/5">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-soft text-brand transition group-hover:bg-brand group-hover:text-brand-foreground">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><path d="M10 10.5c3.8 0 6.8 2.5 6.8 5.6 0 3.1-3 5.6-6.8 5.6S3.2 19.2 3.2 16.1c0-3.1 3-5.6 6.8-5.6Z"/><path d="m10 13-1.4 1.6c-.6.7-1.7 1.9-1.7 3.2 0 1.6 1.4 2.9 3.1 2.9 1.7 0 3.1-1.3 3.1-2.9 0-1.3-1.1-2.5-1.7-3.2L10 13Z"/></svg>
              </div>
              <h3 class="mt-5 font-display text-xl font-semibold text-ink">Bệnh án điện tử (EMR)</h3>
              <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Tạo, lưu trữ và truy xuất hồ sơ bệnh nhân chỉ trong vài giây với giao diện tinh gọn.</p>
            </div>
            <div class="group relative rounded-2xl border border-border bg-card p-7 transition hover:-translate-y-1 hover:border-brand/40 hover:shadow-xl hover:shadow-brand/5">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-soft text-brand transition group-hover:bg-brand group-hover:text-brand-foreground">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
              </div>
              <h3 class="mt-5 font-display text-xl font-semibold text-ink">Bảo mật chuẩn quốc tế</h3>
              <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Mã hoá AES-256, tuân thủ HIPAA & Nghị định 13/2023 về bảo vệ dữ liệu cá nhân.</p>
            </div>
            <div class="group relative rounded-2xl border border-border bg-card p-7 transition hover:-translate-y-1 hover:border-brand/40 hover:shadow-xl hover:shadow-brand/5">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-soft text-brand transition group-hover:bg-brand group-hover:text-brand-foreground">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4.8 2.3A.3.3 0 1 0 5 2H4a2 2 0 0 0-2 2v5a6 6 0 0 0 6 6v0a6 6 0 0 0 6-6V4a2 2 0 0 0-2-2h-1a.2.2 0 1 0 .3.3"/><path d="M8 15v1a6 6 0 0 0 6 6v0a6 6 0 0 0 6-6v-4"/><circle cx="20" cy="10" r="2"/></svg>
              </div>
              <h3 class="mt-5 font-display text-xl font-semibold text-ink">Hỗ trợ chẩn đoán AI</h3>
              <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Gợi ý chẩn đoán dựa trên triệu chứng và lịch sử khám, tăng độ chính xác lên 35%.</p>
            </div>
            <div class="group relative rounded-2xl border border-border bg-card p-7 transition hover:-translate-y-1 hover:border-brand/40 hover:shadow-xl hover:shadow-brand/5">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-soft text-brand transition group-hover:bg-brand group-hover:text-brand-foreground">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              </div>
              <h3 class="mt-5 font-display text-xl font-semibold text-ink">Tiết kiệm 70% thời gian</h3>
              <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Tự động hoá nhập liệu, kê đơn và in phiếu — bác sĩ tập trung vào bệnh nhân.</p>
            </div>
            <div class="group relative rounded-2xl border border-border bg-card p-7 transition hover:-translate-y-1 hover:border-brand/40 hover:shadow-xl hover:shadow-brand/5">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-soft text-brand transition group-hover:bg-brand group-hover:text-brand-foreground">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              </div>
              <h3 class="mt-5 font-display text-xl font-semibold text-ink">Cổng bệnh nhân</h3>
              <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Bệnh nhân tra cứu hồ sơ, đặt lịch tái khám và nhận đơn thuốc qua ứng dụng di động.</p>
            </div>
            <div class="group relative rounded-2xl border border-border bg-card p-7 transition hover:-translate-y-1 hover:border-brand/40 hover:shadow-xl hover:shadow-brand/5">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-brand-soft text-brand transition group-hover:bg-brand group-hover:text-brand-foreground">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
              </div>
              <h3 class="mt-5 font-display text-xl font-semibold text-ink">Phân quyền linh hoạt</h3>
              <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Kiểm soát truy cập theo vai trò: bác sĩ, điều dưỡng, lễ tân, quản lý.</p>
            </div>
          </div>
        </section>

        <!-- Workflow -->
        <section id="workflow" class="relative bg-gradient-to-b from-muted/40 to-background py-24">
          <div class="mx-auto max-w-7xl px-6">
            <div class="max-w-2xl">
              <p class="text-sm font-semibold uppercase tracking-widest text-brand">Quy trình</p>
              <h2 class="mt-3 font-display text-4xl font-bold tracking-tight text-ink lg:text-5xl">Một dòng chảy liền mạch — từ tiếp đón đến tái khám.</h2>
            </div>
            <div class="mt-16 grid gap-6 md:grid-cols-2 lg:grid-cols-4">
                <div class="rounded-2xl border border-border bg-card p-7">
                  <p class="font-display text-4xl font-bold text-brand/30">01</p>
                  <h3 class="mt-4 font-display text-lg font-semibold text-ink">Tiếp đón nhanh chóng</h3>
                  <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Quét CCCD/BHYT, tự động tạo hồ sơ bệnh nhân trong 10 giây.</p>
                </div>
                <div class="rounded-2xl border border-border bg-card p-7">
                  <p class="font-display text-4xl font-bold text-brand/30">02</p>
                  <h3 class="mt-4 font-display text-lg font-semibold text-ink">Khám & chẩn đoán</h3>
                  <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Bác sĩ nhập triệu chứng, AI gợi ý chẩn đoán và xét nghiệm cần thiết.</p>
                </div>
                <div class="rounded-2xl border border-border bg-card p-7">
                  <p class="font-display text-4xl font-bold text-brand/30">03</p>
                  <h3 class="mt-4 font-display text-lg font-semibold text-ink">Kê đơn & thanh toán</h3>
                  <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Đơn thuốc điện tử kết nối nhà thuốc, tích hợp thanh toán không tiền mặt.</p>
                </div>
                <div class="rounded-2xl border border-border bg-card p-7">
                  <p class="font-display text-4xl font-bold text-brand/30">04</p>
                  <h3 class="mt-4 font-display text-lg font-semibold text-ink">Theo dõi & tái khám</h3>
                  <p class="mt-2 text-sm leading-relaxed text-muted-foreground">Tự động nhắc lịch, gửi kết quả qua app cho bệnh nhân.</p>
                </div>
            </div>
          </div>
        </section>

        <!-- Stats -->
        <section class="mx-auto max-w-7xl px-6 py-20">
          <div class="rounded-3xl bg-ink p-10 lg:p-14">
            <div class="grid gap-10 sm:grid-cols-2 lg:grid-cols-4">
                <div>
                  <p class="font-display text-5xl font-bold text-background">200+</p>
                  <p class="mt-2 text-sm text-background/60">Cơ sở y tế tin dùng</p>
                </div>
                <div>
                  <p class="font-display text-5xl font-bold text-background">1.2M+</p>
                  <p class="mt-2 text-sm text-background/60">Hồ sơ bệnh án được quản lý</p>
                </div>
                <div>
                  <p class="font-display text-5xl font-bold text-background">99.99%</p>
                  <p class="mt-2 text-sm text-background/60">Uptime hệ thống</p>
                </div>
                <div>
                  <p class="font-display text-5xl font-bold text-background">70%</p>
                  <p class="mt-2 text-sm text-background/60">Thời gian giấy tờ tiết kiệm</p>
                </div>
            </div>
          </div>
        </section>

        <!-- Pricing -->
        <section id="pricing" class="bg-muted/30 py-24">
          <div class="mx-auto max-w-7xl px-6">
            <div class="mx-auto max-w-2xl text-center">
              <p class="text-sm font-semibold uppercase tracking-widest text-brand">Bảng giá</p>
              <h2 class="mt-3 font-display text-4xl font-bold tracking-tight text-ink lg:text-5xl">Linh hoạt theo quy mô của bạn.</h2>
            </div>
            <div class="mt-16 grid gap-6 lg:grid-cols-3">
                <div class="relative rounded-2xl border border-border bg-card text-ink p-8">
                  <h3 class="font-display text-2xl font-bold">Phòng khám</h3>
                  <p class="mt-1 text-sm text-muted-foreground">Phù hợp phòng khám tư nhân, dưới 5 bác sĩ.</p>
                  <div class="mt-6 flex items-baseline gap-1">
                    <span class="font-display text-4xl font-bold">1.490.000</span>
                    <span class="text-sm text-muted-foreground">đ/tháng</span>
                  </div>
                  <ul class="mt-6 space-y-3">
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Bệnh án điện tử</li>
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> 5 tài khoản bác sĩ</li>
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Cổng bệnh nhân</li>
                  </ul>
                  <a href="#cta" class="mt-8 inline-flex w-full items-center justify-center rounded-full px-5 py-3 text-sm font-semibold transition border border-border bg-background text-ink hover:bg-muted">Bắt đầu ngay</a>
                </div>

                <div class="relative rounded-2xl border border-brand bg-ink text-background shadow-2xl shadow-brand/20 p-8">
                  <span class="absolute -top-3 left-8 rounded-full bg-brand px-3 py-1 text-xs font-semibold text-brand-foreground">Phổ biến nhất</span>
                  <h3 class="font-display text-2xl font-bold">Bệnh viện</h3>
                  <p class="mt-1 text-sm text-background/70">Cho cơ sở đa khoa, đa chuyên khoa.</p>
                  <div class="mt-6 flex items-baseline gap-1">
                    <span class="font-display text-4xl font-bold">4.990.000</span>
                    <span class="text-sm text-background/60">đ/tháng</span>
                  </div>
                  <ul class="mt-6 space-y-3">
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Mọi tính năng Phòng khám</li>
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Tài khoản không giới hạn</li>
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> AI chẩn đoán</li>
                  </ul>
                  <a href="#cta" class="mt-8 inline-flex w-full items-center justify-center rounded-full px-5 py-3 text-sm font-semibold transition bg-brand text-brand-foreground hover:opacity-90">Bắt đầu ngay</a>
                </div>

                <div class="relative rounded-2xl border border-border bg-card text-ink p-8">
                  <h3 class="font-display text-2xl font-bold">Enterprise</h3>
                  <p class="mt-1 text-sm text-muted-foreground">Hệ thống chuỗi bệnh viện, tuỳ chỉnh cao.</p>
                  <div class="mt-6 flex items-baseline gap-1">
                    <span class="font-display text-4xl font-bold">Liên hệ</span>
                  </div>
                  <ul class="mt-6 space-y-3">
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Triển khai on-premise</li>
                    <li class="flex items-start gap-2 text-sm"><svg class="mt-0.5 h-4 w-4 shrink-0 text-brand" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> Tích hợp HIS riêng</li>
                  </ul>
                  <a href="#cta" class="mt-8 inline-flex w-full items-center justify-center rounded-full px-5 py-3 text-sm font-semibold transition border border-border bg-background text-ink hover:bg-muted">Liên hệ tư vấn</a>
                </div>
            </div>
          </div>
        </section>

        <!-- CTA -->
        <section id="cta" class="mx-auto max-w-7xl px-6 py-24">
          <div class="relative overflow-hidden rounded-3xl bg-gradient-to-br from-brand to-[oklch(0.42_0.14_215)] p-12 lg:p-16">
            <div class="absolute -right-20 -top-20 h-72 w-72 rounded-full bg-accent/30 blur-3xl"></div>
            <div class="relative max-w-2xl">
              <h2 class="font-display text-4xl font-bold tracking-tight text-brand-foreground lg:text-5xl">Sẵn sàng số hoá bệnh án cùng JVCare?</h2>
              <p class="mt-4 text-lg text-brand-foreground/80">Đăng ký tư vấn miễn phí — đội ngũ JVCare sẽ liên hệ trong vòng 4 giờ làm việc.</p>
              <form class="mt-8 flex flex-col gap-3 sm:flex-row">
                <input type="email" required placeholder="email@coso-y-te.vn" class="flex-1 rounded-full border border-white/20 bg-white/10 px-5 py-3 text-sm text-brand-foreground placeholder:text-brand-foreground/60 backdrop-blur focus:border-white/40 focus:outline-none" />
                <button type="button" class="inline-flex items-center justify-center gap-2 rounded-full bg-background px-6 py-3 text-sm font-semibold text-ink transition hover:bg-background/90">
                  Đăng ký tư vấn
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                </button>
              </form>
            </div>
          </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="border-t border-border bg-background">
      <div class="mx-auto flex max-w-7xl flex-col items-start justify-between gap-6 px-6 py-10 sm:flex-row sm:items-center">
        <div>
          <a href="${pageContext.request.contextPath}/" class="flex items-center gap-2">
            <span class="font-display text-xl font-bold tracking-tight text-ink">JV<span class="text-brand">Care</span></span>
          </a>
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
