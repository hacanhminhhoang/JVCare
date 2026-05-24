<%@ page contentType="text/html;charset=UTF-8" language="java"
isErrorPage="true" %>
<!DOCTYPE html>
<html>
  <head>
    <title>404 - Không tìm thấy trang</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
    />
    <style>
      .error-page {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
      .error-content {
        text-align: center;
        color: white;
      }
      .error-code {
        font-size: 120px;
        font-weight: bold;
        margin-bottom: 20px;
      }
    </style>
  </head>
  <body>
    <div class="error-page">
      <div class="error-content">
        <div class="error-code">404</div>
        <h2>Không tìm thấy trang</h2>
        <p>Trang bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
        <a
          href="${pageContext.request.contextPath}/"
          class="btn btn-light btn-lg mt-3"
        >
          <i class="bi bi-house"></i> Về trang chủ
        </a>
      </div>
    </div>
  </body>
</html>
