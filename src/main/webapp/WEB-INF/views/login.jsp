<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập — JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css" />
  </head>
  <body class="login-page" style="--bg-url: url('${pageContext.request.contextPath}/images/login_bg_doctor.png');">

    <div class="glass-container">
      
      <div class="brand-section">
        <h1 class="brand-title">JVCare</h1>
        <p class="brand-subtitle">Hệ thống quản lý hồ sơ bệnh án điện tử toàn diện</p>
      </div>

      <%-- Hiển thị thông báo lỗi hệ thống --%>
      <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10" /><line x1="12" x2="12" y1="8" fill="none" y2="12" /><line x1="12" x2="12.01" y1="16" y2="16" />
          </svg>
          <c:out value="${errorMessage}" />
        </div>
      </c:if>

      <%-- Hiển thị thông báo thành công --%>
      <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>
          </svg>
          <c:out value="${successMessage}" />
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="POST">
        
        <div class="input-group">
          <input type="email" name="email" required placeholder="example@email.com" autocomplete="off" value="<c:out value='${param.email}'/>" />
          <div class="icon-left">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline>
            </svg>
          </div>
          <label>Email đăng nhập</label>
        </div>

        <div class="input-group">
          <input type="password" name="password" id="password" required placeholder="password" />
          <div class="icon-left">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
            </svg>
          </div>
          <label>Mật khẩu</label>
          
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

        <button type="submit" class="btn-submit">Đăng nhập</button>
      </form>

      <div class="form-footer">
        <span>Chưa có tài khoản bệnh nhân?</span>
        <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
      </div>

      <p class="notice-text">
        Mọi thông tin bệnh án đều được bảo mật chặt chẽ.<br/>
        Vui lòng liên hệ quầy lễ tân nếu cần hỗ trợ.
      </p>
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