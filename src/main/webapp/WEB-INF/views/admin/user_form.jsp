<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${user != null ? 'Sửa' : 'Thêm'} User - JVCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        .form-container { max-width: 800px; margin: 0 auto; }
        .required::after { content: " *"; color: red; }
    </style>
</head>
<body>
    <div class="container mt-4 form-container">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    <i class="bi bi-person-${user != null ? 'gear' : 'plus'}"></i>
                    ${user != null ? 'Sửa' : 'Thêm'} User
                </h4>
            </div>
            <div class="card-body">
                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/admin/users" id="userForm">
                    <input type="hidden" name="action" value="${user != null ? 'update' : 'create'}">
                    <c:if test="${user != null}">
                        <input type="hidden" name="userId" value="${user.userId}">
                    </c:if>

                    <div class="row">
                        <!-- Username -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Username</label>
                            <input type="text" name="username" class="form-control" 
                                   value="${user.username}" 
                                   required 
                                   ${user != null ? 'readonly' : ''}
                                   pattern="[a-zA-Z0-9_]{3,50}"
                                   title="Username phải từ 3-50 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới">
                            <c:if test="${user != null}">
                                <small class="text-muted">Username không thể thay đổi</small>
                            </c:if>
                        </div>

                        <!-- Password (chỉ hiện khi tạo mới) -->
                        <c:if test="${user == null}">
                            <div class="col-md-6 mb-3">
                                <label class="form-label required">Password</label>
                                <input type="password" name="password" class="form-control" 
                                       required minlength="6"
                                       title="Password phải có ít nhất 6 ký tự">
                                <small class="text-muted">Tối thiểu 6 ký tự</small>
                            </div>
                        </c:if>
                    </div>

                    <div class="row">
                        <!-- Full Name -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Họ tên</label>
                            <input type="text" name="fullName" class="form-control" 
                                   value="${user.fullName}" 
                                   required maxlength="100">
                        </div>

                        <!-- Email -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Email</label>
                            <input type="email" name="email" class="form-control" 
                                   value="${user.email}" 
                                   required>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Phone -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" 
                                   value="${user.phone}"
                                   pattern="[0-9]{10,11}"
                                   title="Số điện thoại phải có 10-11 chữ số">
                        </div>

                        <!-- Role -->
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Role</label>
                            <select name="role" class="form-select" required 
                                    ${user != null ? 'disabled' : ''}
                                    onchange="toggleSpecialization()">
                                <option value="">-- Chọn role --</option>
                                <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                <option value="DOCTOR" ${user.role == 'DOCTOR' ? 'selected' : ''}>Doctor</option>
                                <option value="PATIENT" ${user.role == 'PATIENT' ? 'selected' : ''}>Patient</option>
                            </select>
                            <c:if test="${user != null}">
                                <input type="hidden" name="role" value="${user.role}">
                                <small class="text-muted">Role không thể thay đổi</small>
                            </c:if>
                        </div>
                    </div>

                    <!-- Specialization (chỉ hiện cho DOCTOR) -->
                    <div class="mb-3" id="specializationDiv" style="display: ${user.role == 'DOCTOR' ? 'block' : 'none'};">
                        <label class="form-label required">Chuyên khoa</label>
                        <input type="text" name="specialization" class="form-control" 
                               value="${specialization}"
                               placeholder="VD: Nội khoa, Ngoại khoa, Tim mạch...">
                        <small class="text-muted">Bắt buộc cho bác sĩ</small>
                    </div>

                    <!-- Status (chỉ hiện khi sửa) -->
                    <c:if test="${user != null}">
                        <div class="mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>
                                    Active - Hoạt động
                                </option>
                                <option value="INACTIVE" ${user.status == 'INACTIVE' ? 'selected' : ''}>
                                    Inactive - Không hoạt động
                                </option>
                            </select>
                        </div>
                    </c:if>

                    <!-- Buttons -->
                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> ${user != null ? 'Cập nhật' : 'Tạo mới'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle specialization field based on role
        function toggleSpecialization() {
            const roleSelect = document.querySelector('select[name="role"]');
            const specializationDiv = document.getElementById('specializationDiv');
            const specializationInput = document.querySelector('input[name="specialization"]');
            
            if (roleSelect.value === 'DOCTOR') {
                specializationDiv.style.display = 'block';
                specializationInput.required = true;
            } else {
                specializationDiv.style.display = 'none';
                specializationInput.required = false;
            }
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            toggleSpecialization();
        });

        // Form validation
        document.getElementById('userForm').addEventListener('submit', function(e) {
            const roleSelect = document.querySelector('select[name="role"]');
            const specializationInput = document.querySelector('input[name="specialization"]');
            
            if (roleSelect.value === 'DOCTOR' && !specializationInput.value.trim()) {
                e.preventDefault();
                alert('Vui lòng nhập chuyên khoa cho bác sĩ!');
                specializationInput.focus();
                return false;
            }
        });
    </script>
</body>
</html>
