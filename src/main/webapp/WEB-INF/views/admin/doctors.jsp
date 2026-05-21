<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Bác sĩ - JVCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .doctor-card {
            transition: transform 0.2s;
            cursor: pointer;
        }
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .specialization-badge {
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-2 d-md-block bg-light sidebar">
                <div class="position-sticky pt-3">
                    <h5 class="px-3 text-primary">JVCare Admin</h5>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/home">
                                <i class="bi bi-house-door"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                                <i class="bi bi-people"></i> Quản lý Users
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/doctors">
                                <i class="bi bi-person-badge"></i> Quản lý Bác sĩ
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-10 ms-sm-auto px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="bi bi-person-badge"></i> Quản lý Bác sĩ
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Thêm Bác sĩ mới
                        </a>
                    </div>
                </div>

                <!-- Success Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle"></i> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Search Box -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/doctors" method="get" class="d-flex">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" class="form-control me-2" 
                                   placeholder="Tìm kiếm theo tên, chuyên khoa, email..." 
                                   value="${keyword}">
                            <button type="submit" class="btn btn-outline-primary">
                                <i class="bi bi-search"></i> Tìm
                            </button>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <span class="text-muted">Tổng số: <strong>${totalDoctors}</strong> bác sĩ</span>
                    </div>
                </div>

                <!-- Doctors Grid -->
                <div class="row">
                    <c:choose>
                        <c:when test="${empty doctors}">
                            <div class="col-12 text-center py-5">
                                <i class="bi bi-inbox" style="font-size: 4rem; color: #ccc;"></i>
                                <p class="text-muted mt-3">Chưa có bác sĩ nào trong hệ thống</p>
                                <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-primary">
                                    <i class="bi bi-plus-circle"></i> Thêm bác sĩ đầu tiên
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="doctor" items="${doctors}">
                                <div class="col-md-4 mb-4">
                                    <div class="card doctor-card h-100">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" 
                                                     style="width: 60px; height: 60px; font-size: 1.5rem;">
                                                    <i class="bi bi-person-fill"></i>
                                                </div>
                                                <div class="ms-3">
                                                    <h5 class="card-title mb-0">${doctor.fullName}</h5>
                                                    <small class="text-muted">ID: ${doctor.doctorId}</small>
                                                </div>
                                            </div>
                                            
                                            <div class="mb-2">
                                                <span class="badge bg-info specialization-badge">
                                                    <i class="bi bi-hospital"></i> ${doctor.specialization}
                                                </span>
                                            </div>
                                            
                                            <div class="mb-2">
                                                <i class="bi bi-envelope"></i> 
                                                <small>${doctor.email}</small>
                                            </div>
                                            
                                            <div class="mb-2">
                                                <i class="bi bi-telephone"></i> 
                                                <small>${doctor.phone}</small>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <c:choose>
                                                    <c:when test="${doctor.status == 'ACTIVE'}">
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-check-circle"></i> Đang hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                            <i class="bi bi-x-circle"></i> Không hoạt động
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <div class="d-flex justify-content-between">
                                                <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${doctor.userId}" 
                                                   class="btn btn-sm btn-warning">
                                                    <i class="bi bi-pencil"></i> Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/doctors?action=view&id=${doctor.doctorId}" 
                                                   class="btn btn-sm btn-info">
                                                    <i class="bi bi-eye"></i> Chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Table View (Alternative) -->
                <div class="mt-4">
                    <h5>Danh sách chi tiết</h5>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Chuyên khoa</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doctor" items="${doctors}">
                                    <tr>
                                        <td>${doctor.doctorId}</td>
                                        <td><strong>${doctor.fullName}</strong></td>
                                        <td>
                                            <span class="badge bg-info">${doctor.specialization}</span>
                                        </td>
                                        <td>${doctor.email}</td>
                                        <td>${doctor.phone}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${doctor.status == 'ACTIVE'}">
                                                    <span class="badge bg-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${doctor.userId}" 
                                               class="btn btn-sm btn-warning" title="Sửa">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/doctors?action=view&id=${doctor.doctorId}" 
                                               class="btn btn-sm btn-info" title="Chi tiết">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
