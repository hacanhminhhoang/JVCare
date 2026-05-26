<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký tài khoản khách hàng — JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css" />
  </head>
  <body class="register-page" style="--bg-url: url('${pageContext.request.contextPath}/images/hero-doctor.jpg');">

    <div class="glass-container">
      
      <div class="brand-section">
        <h1 class="brand-title">Đăng ký</h1>
        <p class="brand-subtitle">Tạo hồ sơ bệnh án điện tử cá nhân hoàn toàn miễn phí</p>
      </div>

      <%-- Hiển thị lỗi đăng ký từ Controller --%>
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10" /><line x1="12" x2="12" y1="8" fill="none" y2="12" /><line x1="12" x2="12.01" y1="16" y2="16" />
          </svg>
          <c:out value="${errorMessage}" />
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/register" method="POST">
        
        <div class="input-group">
          <input type="text" name="fullName" required placeholder=" " autocomplete="off" value="<c:out value='${param.fullName}'/>" />
          <div class="icon-left">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle>
            </svg>
          </div>
          <label>Họ và tên</label>
        </div>

        <div class="input-group">
          <input type="email" name="email" required placeholder=" " autocomplete="off" value="<c:out value='${param.email}'/>" />
          <div class="icon-left">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline>
            </svg>
          </div>
          <label>Địa chỉ Email</label>
        </div>

        <div class="input-group">
          <input type="tel" name="phone" pattern="[0-9]{10,11}" required placeholder=" " autocomplete="off" value="<c:out value='${param.phone}'/>" />
          <div class="icon-left">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
            </svg>
          </div>
          <label>Số điện thoại liên hệ</label>
        </div>

        <div class="input-group">
          <input type="password" name="password" id="password" required placeholder=" " />
          <div class="icon-left">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
          </div>
          <label>Mật khẩu mật mã</label>
          
          <button type="button" id="togglePassword" class="toggle-password">
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

        <button type="submit" class="btn-submit">Đăng ký tài khoản</button>
      </form>

      <div class="form-footer">
        <span>Đã có tài khoản?</span>
        <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
      </div>
    </div>

    <script>
      document.getElementById("togglePassword").addEventListener("click", function () {
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