<%@ page contentType="text/html;charset=UTF-8" language="java"
isErrorPage="true" %>
<!DOCTYPE html>
<html>
  <head>
    <title>500 - Lỗi máy chủ</title>
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
        background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
      }
      .error-content {
        text-align: center;
        color: white;
      }
      .error-code {
        font-size: 120px;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="error-page">
      <div class="error-content">
        <div class="error-code">500</div>
        <h2>Lỗi máy chủ</h2>
        <p>Đã xảy ra lỗi trong quá trình xử lý. Vui lòng thử lại sau.</p>
        <a
          href="${pageContext.request.contextPath}/"
          class="btn btn-light btn-lg mt-3"
        >
          Về trang chủ
        </a>
      </div>
    </div>
  </body>
</html>
