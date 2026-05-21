<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin Bác sĩ - JVCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
</head>
<body>
    <div class="container mt-4">
        <div class="card shadow">
            <div class="card-header bg-info text-white">
                <h4 class="mb-0">
                    <i class="bi bi-person-badge"></i> Thông tin Bác sĩ
                </h4>
            </div>
            <div class="card-body">
                <p class="text-muted">
                    <i class="bi bi-info-circle"></i> 
                    Để chỉnh sửa thông tin bác sĩ, vui lòng sử dụng chức năng 
                    <a href="${pageContext.request.contextPath}/admin/users">Quản lý Users</a>
                </p>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/admin/doctors" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại danh sách
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                        <i class="bi bi-people"></i> Quản lý Users
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
