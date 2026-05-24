<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chính sách bảo mật & Điều khoản y tế y khoa — JVCare</title>
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
                        card: "#ffffff",
                        accent: "#dbeafe",
                        "accent-soft": "#fffbeb"
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
<body class="min-h-screen bg-background font-sans text-ink antialiased">
    <!-- Header -->
    <header class="sticky top-0 z-50 border-b border-border/60 bg-background/80 backdrop-blur-xl">
      <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <a href="${pageContext.request.contextPath}/" class="flex items-center gap-2">
          <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-brand to-[#1e40af] text-brand-foreground shadow-lg shadow-brand/20">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
              <polyline points="14 2 14 8 20 8"/>
              <path d="M10 10.5c3.8 0 6.8 2.5 6.8 5.6 0 3.1-3 5.6-6.8 5.6S3.2 19.2 3.2 16.1c0-3.1 3-5.6 6.8-5.6Z"/>
              <path d="m10 13-1.4 1.6c-.6.7-1.7 1.9-1.7 3.2 0 1.6 1.4 2.9 3.1 2.9 1.7 0 3.1-1.3 3.1-2.9 0-1.3-1.1-2.5-1.7-3.2L10 13Z"/>
            </svg>
          </div>
          <span class="font-display text-xl font-bold tracking-tight text-ink">
            JV<span class="text-brand">Care</span>
          </span>
        </a>
        <div class="flex items-center gap-3">
          <a href="${pageContext.request.contextPath}/login" class="text-sm font-medium text-muted-foreground hover:text-ink transition">Đăng nhập</a>
          <a href="${pageContext.request.contextPath}/login" class="inline-flex items-center gap-1.5 rounded-full bg-ink px-4 py-2 text-sm font-semibold text-background transition hover:opacity-90">
            Bắt đầu ngay
          </a>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="relative py-16 overflow-hidden">
        <!-- Background decorative gradients -->
        <div class="absolute inset-0 -z-10 bg-[radial-gradient(45%_35%_at_70%_10%,rgba(26,86,219,0.04)_0%,transparent_100%)]"></div>
        <div class="absolute inset-0 -z-10 bg-[radial-gradient(35%_30%_at_15%_80%,rgba(245,158,11,0.03)_0%,transparent_100%)]"></div>

        <div class="mx-auto max-w-7xl px-6">
            <!-- Header section -->
            <div class="mx-auto max-w-3xl text-center mb-16">
                <div class="inline-flex items-center gap-2 rounded-full border border-brand/20 bg-brand-soft px-3.5 py-1 text-xs font-semibold text-brand mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    Bảo mật dữ liệu y tế & Tuân thủ pháp luật Việt Nam
                </div>
                <h1 class="font-display text-4xl font-extrabold tracking-tight text-ink lg:text-5xl leading-tight">
                    Chính sách bảo mật <br>& Bảo vệ dữ liệu cá nhân
                </h1>
                <p class="mt-4 text-base text-muted-foreground">
                    Áp dụng toàn diện hệ thống mã hóa y tế quốc tế, tuân thủ Luật Khám chữa bệnh 2023 và Nghị định 13/2023/NĐ-CP về Bảo vệ dữ liệu cá nhân.
                </p>
                <p class="mt-2 text-xs font-semibold text-brand uppercase tracking-wider">Cập nhật chính thức: Ngày 22 tháng 05 năm 2026</p>
            </div>

            <!-- Key Trust Badges -->
            <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-4 mb-16">
                <div class="rounded-2xl border border-border bg-white p-6 shadow-sm flex items-start gap-4">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-brand-soft text-brand">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    </div>
                    <div>
                        <h3 class="font-display font-bold text-ink text-sm">Nghị định 13/2023/NĐ-CP</h3>
                        <p class="text-xs text-muted-foreground mt-1">Tuân thủ đầy đủ quyền chủ thể dữ liệu cá nhân.</p>
                    </div>
                </div>
                <div class="rounded-2xl border border-border bg-white p-6 shadow-sm flex items-start gap-4">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-accent-soft text-accent">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                    <div>
                        <h3 class="font-display font-bold text-ink text-sm">Mã hóa AES-256</h3>
                        <p class="text-xs text-muted-foreground mt-1">Bảo vệ bệnh án điện tử ở cấp độ mã hóa quân sự tối cao.</p>
                    </div>
                </div>
                <div class="rounded-2xl border border-border bg-white p-6 shadow-sm flex items-start gap-4">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-brand-soft text-brand">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                    </div>
                    <div>
                        <h3 class="font-display font-bold text-ink text-sm">Chuẩn HIPAA Y Khoa</h3>
                        <p class="text-xs text-muted-foreground mt-1">Quy trình truyền tải dữ liệu y tế nghiêm ngặt an toàn.</p>
                    </div>
                </div>
                <div class="rounded-2xl border border-border bg-white p-6 shadow-sm flex items-start gap-4">
                    <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-accent-soft text-accent">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                    </div>
                    <div>
                        <h3 class="font-display font-bold text-ink text-sm">Phân Quyền Tuyệt Đối</h3>
                        <p class="text-xs text-muted-foreground mt-1">Cách ly dữ liệu bệnh viện, bác sĩ và bệnh nhân.</p>
                    </div>
                </div>
            </div>

            <!-- Two Column Layout: Navigation & Articles -->
            <div class="grid gap-8 lg:grid-cols-[280px_1fr]">
                <!-- Side Navigation -->
                <aside class="hidden lg:block">
                    <div class="sticky top-24 rounded-2xl border border-border/80 bg-white/50 p-5 backdrop-blur shadow-sm">
                        <h3 class="font-display font-bold text-xs uppercase tracking-wider text-muted-foreground px-2 mb-4">Mục lục điều khoản</h3>
                        <nav class="space-y-1">
                            <a href="#dieu-1" class="flex items-center justify-between rounded-lg px-3 py-2 text-sm font-medium text-ink transition hover:bg-brand/10 hover:text-brand">
                                <span>1. Cơ sở pháp lý chính thức</span>
                            </a>
                            <a href="#dieu-2" class="flex items-center justify-between rounded-lg px-3 py-2 text-sm font-medium text-ink transition hover:bg-brand/10 hover:text-brand">
                                <span>2. Phân loại dữ liệu thu thập</span>
                            </a>
                            <a href="#dieu-3" class="flex items-center justify-between rounded-lg px-3 py-2 text-sm font-medium text-ink transition hover:bg-brand/10 hover:text-brand">
                                <span>3. Mục đích sử dụng dữ liệu</span>
                            </a>
                            <a href="#dieu-4" class="flex items-center justify-between rounded-lg px-3 py-2 text-sm font-medium text-ink transition hover:bg-brand/10 hover:text-brand">
                                <span>4. Tiêu chuẩn bảo mật y tế</span>
                            </a>
                            <a href="#dieu-5" class="flex items-center justify-between rounded-lg px-3 py-2 text-sm font-medium text-ink transition hover:bg-brand/10 hover:text-brand">
                                <span>5. Quyền của Chủ thể dữ liệu</span>
                            </a>
                            <a href="#dieu-6" class="flex items-center justify-between rounded-lg px-3 py-2 text-sm font-medium text-ink transition hover:bg-brand/10 hover:text-brand">
                                <span>6. Hỗ trợ chẩn đoán từ AI</span>
                            </a>
                            <a href="#dieu-7" class="flex items-center justify-between rounded-lg px-3 py-2 text-sm font-medium text-ink transition hover:bg-brand/10 hover:text-brand">
                                <span>7. Cam kết lưu trữ & Xóa sạch</span>
                            </a>
                        </nav>
                        <div class="mt-8 border-t border-border pt-4 px-2">
                            <h4 class="font-display font-semibold text-xs text-ink">Bạn cần trợ giúp?</h4>
                            <p class="text-xs text-muted-foreground mt-1">Đội ngũ pháp chế và bảo mật JVCare luôn sẵn sàng giải đáp.</p>
                            <a href="mailto:privacy@jvcare.vn" class="mt-2 inline-flex text-xs font-bold text-brand hover:underline">privacy@jvcare.vn</a>
                        </div>
                    </div>
                </aside>

                <!-- Detailed Articles -->
                <div class="space-y-8">
                    <!-- Điều 1 -->
                    <div id="dieu-1" class="scroll-mt-24 rounded-3xl border border-border bg-white p-8 shadow-sm transition hover:shadow-md">
                        <div class="flex items-center gap-3 mb-4">
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-soft font-display font-bold text-brand text-sm">01</span>
                            <h2 class="font-display text-xl font-bold text-ink">Cơ sở pháp lý & Phạm vi áp dụng</h2>
                        </div>
                        <div class="text-sm text-muted-foreground leading-relaxed space-y-3">
                            <p>
                                Chính sách bảo mật này là một thỏa thuận pháp lý ràng buộc giữa <strong>Công ty Cổ phần Công nghệ Y tế JVCare</strong> (gọi tắt là "JVCare") với các <strong>Bệnh nhân (Khách hàng)</strong>, <strong>Bác sĩ</strong> và <strong>Cơ sở y tế</strong> sử dụng nền tảng của chúng tôi.
                            </p>
                            <p>
                                Chúng tôi cam kết tuyệt đối tuân thủ các quy định pháp luật hiện hành của nước Cộng hòa Xã hội Chủ nghĩa Việt Nam bao gồm:
                            </p>
                            <ul class="list-disc pl-5 space-y-1.5 mt-2 text-ink/90">
                                <li><strong>Nghị định số 13/2023/NĐ-CP</strong> ngày 17/04/2023 của Chính phủ về Bảo vệ dữ liệu cá nhân (PDPD).</li>
                                <li><strong>Luật Khám bệnh, chữa bệnh số 15/2023/QH15</strong> của Quốc hội ban hành.</li>
                                <li><strong>Luật An toàn thông tin mạng số 86/2015/QH13</strong> và các quy chuẩn kỹ thuật an toàn thông tin của Bộ Thông tin & Truyền thông.</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Điều 2 -->
                    <div id="dieu-2" class="scroll-mt-24 rounded-3xl border border-border bg-white p-8 shadow-sm transition hover:shadow-md">
                        <div class="flex items-center gap-3 mb-4">
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-soft font-display font-bold text-brand text-sm">02</span>
                            <h2 class="font-display text-xl font-bold text-ink">Các loại dữ liệu y tế được thu thập</h2>
                        </div>
                        <div class="text-sm text-muted-foreground leading-relaxed space-y-4">
                            <p>
                                JVCare thực hiện phân tách dữ liệu thu thập thành hai nhóm phân loại theo Điều 3 và Điều 4 của Nghị định 13/2023/NĐ-CP:
                            </p>
                            <div class="grid gap-4 sm:grid-cols-2 mt-2">
                                <div class="rounded-xl bg-slate-50 p-4 border border-border/60">
                                    <h4 class="font-bold text-ink text-sm flex items-center gap-2 mb-2">
                                        <span class="h-2 w-2 rounded-full bg-brand"></span>
                                        Dữ liệu cá nhân cơ bản
                                    </h4>
                                    <p class="text-xs text-muted-foreground">
                                        Họ và tên khai sinh, ngày tháng năm sinh, giới tính, số điện thoại liên lạc, địa chỉ email, địa chỉ thường trú/tạm trú, số Căn cước công dân (CCCD), và mã số Bảo hiểm y tế (BHYT).
                                    </p>
                                </div>
                                <div class="rounded-xl bg-accent-soft/30 p-4 border border-accent/10">
                                    <h4 class="font-bold text-accent text-sm flex items-center gap-2 mb-2">
                                        <span class="h-2 w-2 rounded-full bg-accent"></span>
                                        Dữ liệu cá nhân nhạy cảm
                                    </h4>
                                    <p class="text-xs text-muted-foreground">
                                        Dữ liệu bệnh án điện tử, tiền sử bệnh lý cá nhân và gia đình, nhóm máu, tình trạng sinh lý vật lý, hồ sơ xét nghiệm hình ảnh y khoa, đơn thuốc, lịch trình khám bệnh, và dữ liệu hỗ trợ chẩn đoán AI.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Điều 3 -->
                    <div id="dieu-3" class="scroll-mt-24 rounded-3xl border border-border bg-white p-8 shadow-sm transition hover:shadow-md">
                        <div class="flex items-center gap-3 mb-4">
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-soft font-display font-bold text-brand text-sm">03</span>
                            <h2 class="font-display text-xl font-bold text-ink">Mục đích sử dụng dữ liệu hợp pháp</h2>
                        </div>
                        <div class="text-sm text-muted-foreground leading-relaxed space-y-3">
                            <p>
                                Dữ liệu thu thập được chúng tôi xử lý hoàn toàn dựa trên sự đồng ý rõ ràng của chủ thể dữ liệu hoặc phục vụ trực tiếp công tác cứu chữa người bệnh trong tình trạng khẩn cấp. Các mục đích cụ thể bao gồm:
                            </p>
                            <ul class="list-decimal pl-5 space-y-2 mt-2">
                                <li><strong class="text-ink">Quản lý bệnh án điện tử (EMR)</strong>: Hỗ trợ các cơ sở khám chữa bệnh thực hiện theo dõi sức khỏe và điều trị chuẩn y khoa.</li>
                                <li><strong class="text-ink">Tích hợp và liên thông thông tin</strong>: Cho phép bệnh nhân tra cứu hồ sơ bệnh án trực tuyến cá nhân, đơn thuốc điện tử, lịch sử khám.</li>
                                <li><strong class="text-ink">Trợ lý hỗ trợ chẩn đoán y tế AI</strong>: Sử dụng thông tin sức khỏe để phân tích các chỉ số hỗ trợ bác sĩ ra quyết định.</li>
                                <li><strong class="text-ink">Thông báo y tế</strong>: Nhắc lịch tái khám, lịch uống thuốc và cảnh báo sức khỏe khẩn cấp qua Email/SMS.</li>
                            </ul>
                            <p class="text-xs text-accent font-semibold mt-4 bg-accent-soft/40 p-3 rounded-lg border border-accent/20">
                                ⚠️ Cam kết nghiêm ngặt: JVCare tuyệt đối KHÔNG bán, cho thuê, trao đổi hay chuyển giao trái phép bất cứ phần thông tin cá nhân/y tế nào của người bệnh cho bên thứ ba vì mục đích thương mại hoặc quảng cáo.
                            </p>
                        </div>
                    </div>

                    <!-- Điều 4 -->
                    <div id="dieu-4" class="scroll-mt-24 rounded-3xl border border-border bg-white p-8 shadow-sm transition hover:shadow-md">
                        <div class="flex items-center gap-3 mb-4">
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-soft font-display font-bold text-brand text-sm">04</span>
                            <h2 class="font-display text-xl font-bold text-ink">Tiêu chuẩn bảo mật cấp độ y tế y khoa</h2>
                        </div>
                        <div class="text-sm text-muted-foreground leading-relaxed space-y-4">
                            <p>
                                Nhằm đảm bảo an toàn tuyệt đối trước mọi nguy cơ rò rỉ hoặc tấn công mạng, JVCare áp dụng các chuẩn kỹ thuật an ninh cao nhất:
                            </p>
                            <div class="space-y-3">
                                <div class="flex gap-3">
                                    <div class="h-5 w-5 shrink-0 rounded bg-emerald-50 text-emerald-600 flex items-center justify-center text-xs font-bold">✓</div>
                                    <p><strong>Mã hóa dữ liệu kép</strong>: Mã hóa đường truyền SSL/TLS 1.3 bảo vệ thông tin khi di chuyển. Mã hóa cơ sở dữ liệu ở trạng thái tĩnh (Encryption at Rest) bằng thuật toán <strong>AES-256 (Advanced Encryption Standard 256-bit)</strong>.</p>
                                </div>
                                <div class="flex gap-3">
                                    <div class="h-5 w-5 shrink-0 rounded bg-emerald-50 text-emerald-600 flex items-center justify-center text-xs font-bold">✓</div>
                                    <p><strong>Kiến trúc Zero-Knowledge</strong>: Hệ thống được thiết kế để kỹ sư vận hành hệ thống của JVCare không thể đọc trực tiếp nội dung hồ sơ bệnh án nhạy cảm nếu không có sự cấp quyền từ khóa giải mã cá nhân của cơ sở khám chữa bệnh hoặc bệnh nhân.</p>
                                </div>
                                <div class="flex gap-3">
                                    <div class="h-5 w-5 shrink-0 rounded bg-emerald-50 text-emerald-600 flex items-center justify-center text-xs font-bold">✓</div>
                                    <p><strong>Giám sát bảo mật (SIEM)</strong>: Hệ thống phát hiện xâm nhập và cảnh báo an ninh hoạt động 24/7. Mọi lượt truy cập hồ sơ bệnh án của bác sĩ hay nhân viên y tế đều được lưu vết chi tiết (Audit Trail) không thể sửa xóa.</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Điều 5 -->
                    <div id="dieu-5" class="scroll-mt-24 rounded-3xl border border-border bg-white p-8 shadow-sm transition hover:shadow-md">
                        <div class="flex items-center gap-3 mb-4">
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-soft font-display font-bold text-brand text-sm">05</span>
                            <h2 class="font-display text-xl font-bold text-ink">Quyền của chủ thể dữ liệu (Bệnh nhân)</h2>
                        </div>
                        <div class="text-sm text-muted-foreground leading-relaxed space-y-3">
                            <p>
                                Chiếu theo Chương II của Nghị định 13/2023/NĐ-CP, JVCare bảo đảm và hỗ trợ tối đa việc thực hiện các quyền của người bệnh đối với dữ liệu cá nhân của mình thông qua trang quản lý cá nhân:
                            </p>
                            <div class="grid gap-3 sm:grid-cols-2 mt-3">
                                <div class="p-3 bg-slate-50 rounded-xl">
                                    <span class="font-bold text-ink text-xs block">Quyền được biết & đồng ý</span>
                                    <span class="text-xs text-muted-foreground block mt-1">Người bệnh được giải thích minh bạch về việc thu thập dữ liệu và có quyền đồng ý hoặc từ chối xử lý dữ liệu.</span>
                                </div>
                                <div class="p-3 bg-slate-50 rounded-xl">
                                    <span class="font-bold text-ink text-xs block">Quyền truy cập & chỉnh sửa</span>
                                    <span class="text-xs text-muted-foreground block mt-1">Được quyền đăng nhập cổng bệnh nhân để tự tra cứu hồ sơ và yêu cầu chỉnh sửa thông tin chưa chính xác.</span>
                                </div>
                                <div class="p-3 bg-slate-50 rounded-xl">
                                    <span class="font-bold text-ink text-xs block">Quyền rút lại sự đồng ý</span>
                                    <span class="text-xs text-muted-foreground block mt-1">Khách hàng có thể thu hồi quyền truy cập hồ sơ bệnh án của bất kỳ cơ sở y tế nào đã được ủy quyền trước đó.</span>
                                </div>
                                <div class="p-3 bg-slate-50 rounded-xl">
                                    <span class="font-bold text-ink text-xs block">Quyền xóa dữ liệu (Quên đi)</span>
                                    <span class="text-xs text-muted-foreground block mt-1">Yêu cầu xóa hoàn toàn tài khoản người dùng và thông tin cá nhân liên kết khỏi hệ thống lưu trữ JVCare.</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Điều 6 -->
                    <div id="dieu-6" class="scroll-mt-24 rounded-3xl border border-border bg-white p-8 shadow-sm transition hover:shadow-md">
                        <div class="flex items-center gap-3 mb-4">
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-soft font-display font-bold text-brand text-sm">06</span>
                            <h2 class="font-display text-xl font-bold text-ink">Bảo mật trong tính năng chẩn đoán AI</h2>
                        </div>
                        <div class="text-sm text-muted-foreground leading-relaxed space-y-3">
                            <p>
                                Khi người dùng sử dụng tính năng chẩn đoán hỗ trợ từ trí tuệ nhân tạo (AI):
                            </p>
                            <ul class="list-disc pl-5 space-y-2 mt-2">
                                <li>Dữ liệu triệu chứng sức khỏe trước khi gửi lên máy chủ phân tích AI sẽ được **loại bỏ hoàn toàn thông tin định danh cá nhân** (De-identification/Anonymization) như tên, SĐT, CCCD để bảo vệ riêng tư tuyệt đối.</li>
                                <li>Thuật toán AI chỉ đưa ra các gợi ý và phân tích mang tính tham khảo chuyên môn, **không có giá trị thay thế kết luận chẩn đoán lâm sàng chính thức** của bác sĩ có chứng chỉ hành nghề y khoa.</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Điều 7 -->
                    <div id="dieu-7" class="scroll-mt-24 rounded-3xl border border-border bg-white p-8 shadow-sm transition hover:shadow-md">
                        <div class="flex items-center gap-3 mb-4">
                            <span class="inline-flex h-8 w-8 items-center justify-center rounded-lg bg-brand-soft font-display font-bold text-brand text-sm">07</span>
                            <h2 class="font-display text-xl font-bold text-ink">Thời hạn lưu trữ & Cam kết xóa sạch</h2>
                        </div>
                        <div class="text-sm text-muted-foreground leading-relaxed space-y-3">
                            <p>
                                <strong>Thời hạn lưu trữ:</strong> Dữ liệu y tế và bệnh án điện tử của người bệnh được lưu trữ liên tục trong thời gian sử dụng dịch vụ của cơ sở khám chữa bệnh hoặc theo thời hạn bắt buộc quy định bởi Bộ Y tế Việt Nam đối với lưu trữ bệnh án giấy/bệnh án điện tử.
                            </p>
                            <p>
                                <strong>Quy trình xóa sạch dữ liệu:</strong> Khi nhận được yêu cầu xóa dữ liệu cá nhân hợp lệ từ người dùng, JVCare sẽ tiến hành xóa vĩnh viễn (Hard Delete) thông tin tài khoản và thực hiện ghi đè ngẫu nhiên để không thể khôi phục dữ liệu y tế trên toàn bộ hệ thống cơ sở dữ liệu và các bản sao lưu dự phòng trong vòng 30 ngày kể từ ngày tiếp nhận yêu cầu.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
