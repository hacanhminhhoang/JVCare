# HƯỚNG DẪN TASK 1: ADMIN - QUẢN LÝ NGƯỜI DÙNG & BÁC SĨ

## 📋 TỔNG QUAN
Phát triển module quản trị viên để quản lý users, doctors và patients trong hệ thống.

---

## 🗂️ CẤU TRÚC FILE CẦN TẠO

```
src/main/java/com/jvcare/
├── controller/
│   ├── AdminUserServlet.java          [MỚI]
│   └── AdminDoctorServlet.java        [MỚI]
├── dao/
│   ├── UserDAO.java                   [CẬP NHẬT]
│   └── DoctorDAO.java                 [MỚI]
└── model/
    └── Doctor.java                    [MỚI]

src/main/webapp/WEB-INF/views/admin/
├── users.jsp                          [MỚI]
├── user_form.jsp                      [MỚI]
├── doctors.jsp                        [MỚI]
└── doctor_form.jsp                    [MỚI]
```

---

## 📝 BƯỚC 1: TẠO MODEL DOCTOR

**File:** `src/main/java/com/jvcare/model/Doctor.java`

```java
package com.jvcare.model;

public class Doctor {
    private int doctorId;
    private int userId;
    private String specialization;
    
    // Thông tin từ bảng users (JOIN)
    private String fullName;
    private String email;
    private String phone;
    private String status;
    
    // Constructors
    public Doctor() {}
    
    // Getters and Setters
    // ... (tạo đầy đủ)
}
```

---

## 📝 BƯỚC 2: TẠO DOCTOR DAO

**File:** `src/main/java/com/jvcare/dao/DoctorDAO.java`

```java
package com.jvcare.dao;

import com.jvcare.model.Doctor;
import com.jvcare.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {
    
    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT d.*, u.full_name, u.email, u.phone, u.status " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToDoctor(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // TODO: Implement các methods khác
    // - getDoctorById(int doctorId)
    // - createDoctor(Doctor doctor)
    // - updateDoctor(Doctor doctor)
    // - deleteDoctor(int doctorId)
    
    private Doctor mapResultSetToDoctor(ResultSet rs) throws SQLException {
        // Map ResultSet to Doctor object
    }
}
```



---

## 📝 BƯỚC 3: CẬP NHẬT USER DAO

**File:** `src/main/java/com/jvcare/dao/UserDAO.java`

Thêm các methods sau:

```java
// Lấy tất cả users với phân trang
public List<User> getAllUsers(int page, int pageSize) {
    List<User> list = new ArrayList<>();
    int offset = (page - 1) * pageSize;
    String sql = "SELECT * FROM users ORDER BY user_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    // Implementation...
}

// Đếm tổng số users
public int getTotalUsers() {
    String sql = "SELECT COUNT(*) FROM users";
    // Implementation...
}

// Tìm kiếm users
public List<User> searchUsers(String keyword) {
    String sql = "SELECT * FROM users WHERE full_name LIKE ? OR email LIKE ? OR username LIKE ?";
    // Implementation...
}

// Tạo user mới
public boolean createUser(User user) {
    String sql = "INSERT INTO users (username, password_hash, email, full_name, role, phone, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
    // Implementation...
}

// Cập nhật user
public boolean updateUser(User user) {
    String sql = "UPDATE users SET email=?, full_name=?, phone=?, status=? WHERE user_id=?";
    // Implementation...
}

// Xóa user (soft delete - set status = 'INACTIVE')
public boolean deleteUser(int userId) {
    String sql = "UPDATE users SET status='INACTIVE' WHERE user_id=?";
    // Implementation...
}
```

---

## 📝 BƯỚC 4: TẠO ADMIN USER SERVLET

**File:** `src/main/java/com/jvcare/controller/AdminUserServlet.java`

```java
package com.jvcare.controller;

import com.jvcare.dao.UserDAO;
import com.jvcare.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra authentication và authorization
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        } else {
            listUsers(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Phân trang
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }
        
        List<User> users = userDAO.getAllUsers(page, pageSize);
        int totalUsers = userDAO.getTotalUsers();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }
    
    // TODO: Implement các methods khác
    // - showEditForm()
    // - createUser()
    // - updateUser()
    // - deleteUser()
    // - checkAdminAccess()
}
```



---

## 📝 BƯỚC 5: TẠO JSP - DANH SÁCH USERS

**File:** `src/main/webapp/WEB-INF/views/admin/users.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý Users - JVCare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>Quản lý Users</h2>
        
        <!-- Search & Add button -->
        <div class="row mb-3">
            <div class="col-md-6">
                <input type="text" id="searchInput" class="form-control" placeholder="Tìm kiếm user...">
            </div>
            <div class="col-md-6 text-end">
                <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-primary">
                    <i class="bi bi-plus"></i> Thêm User
                </a>
            </div>
        </div>
        
        <!-- Users table -->
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.userId}</td>
                        <td>${user.username}</td>
                        <td>${user.fullName}</td>
                        <td>${user.email}</td>
                        <td><span class="badge bg-info">${user.role}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${user.status == 'ACTIVE'}">
                                    <span class="badge bg-success">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.userId}" 
                               class="btn btn-sm btn-warning">Sửa</a>
                            <a href="${pageContext.request.contextPath}/admin/users?action=delete&id=${user.userId}" 
                               class="btn btn-sm btn-danger" 
                               onclick="return confirm('Bạn có chắc muốn xóa user này?')">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <!-- Pagination -->
        <nav>
            <ul class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

---

## 📝 BƯỚC 6: TẠO JSP - FORM USER

**File:** `src/main/webapp/WEB-INF/views/admin/user_form.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${user != null ? 'Sửa' : 'Thêm'} User - JVCare</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>${user != null ? 'Sửa' : 'Thêm'} User</h2>
        
        <form method="post" action="${pageContext.request.contextPath}/admin/users">
            <input type="hidden" name="action" value="${user != null ? 'update' : 'create'}">
            <c:if test="${user != null}">
                <input type="hidden" name="userId" value="${user.userId}">
            </c:if>
            
            <div class="mb-3">
                <label class="form-label">Username *</label>
                <input type="text" name="username" class="form-control" 
                       value="${user.username}" required ${user != null ? 'readonly' : ''}>
            </div>
            
            <c:if test="${user == null}">
                <div class="mb-3">
                    <label class="form-label">Password *</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
            </c:if>
            
            <div class="mb-3">
                <label class="form-label">Họ tên *</label>
                <input type="text" name="fullName" class="form-control" 
                       value="${user.fullName}" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Email *</label>
                <input type="email" name="email" class="form-control" 
                       value="${user.email}" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input type="text" name="phone" class="form-control" 
                       value="${user.phone}">
            </div>
            
            <div class="mb-3">
                <label class="form-label">Role *</label>
                <select name="role" class="form-select" required>
                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                    <option value="DOCTOR" ${user.role == 'DOCTOR' ? 'selected' : ''}>Doctor</option>
                    <option value="PATIENT" ${user.role == 'PATIENT' ? 'selected' : ''}>Patient</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Status</label>
                <select name="status" class="form-select">
                    <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                    <option value="INACTIVE" ${user.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Hủy</a>
        </form>
    </div>
</body>
</html>
```



---

## 🧪 TESTING

### Test Cases cần kiểm tra:

1. **Xem danh sách users**
   - [ ] Hiển thị đúng danh sách
   - [ ] Phân trang hoạt động
   - [ ] Hiển thị đúng role và status

2. **Thêm user mới**
   - [ ] Validate required fields
   - [ ] Check duplicate username/email
   - [ ] Hash password với BCrypt
   - [ ] Redirect về danh sách sau khi thêm

3. **Sửa user**
   - [ ] Load đúng thông tin user
   - [ ] Không cho sửa username
   - [ ] Cập nhật thành công

4. **Xóa user**
   - [ ] Confirm trước khi xóa
   - [ ] Soft delete (set status = INACTIVE)
   - [ ] Không xóa được chính mình

5. **Tìm kiếm**
   - [ ] Tìm theo tên, email, username
   - [ ] Hiển thị kết quả đúng

---

## 📊 SQL QUERIES CẦN DÙNG

```sql
-- Lấy tất cả users với phân trang
SELECT * FROM users 
ORDER BY user_id 
OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;

-- Đếm tổng users
SELECT COUNT(*) FROM users;

-- Tìm kiếm users
SELECT * FROM users 
WHERE full_name LIKE ? OR email LIKE ? OR username LIKE ?;

-- Kiểm tra duplicate username
SELECT COUNT(*) FROM users WHERE username = ?;

-- Kiểm tra duplicate email
SELECT COUNT(*) FROM users WHERE email = ?;

-- Thêm user mới
INSERT INTO users (username, password_hash, email, full_name, role, phone, status) 
VALUES (?, ?, ?, ?, ?, ?, ?);

-- Cập nhật user
UPDATE users 
SET email=?, full_name=?, phone=?, status=? 
WHERE user_id=?;

-- Soft delete user
UPDATE users SET status='INACTIVE' WHERE user_id=?;
```

---

## ✅ CHECKLIST HOÀN THÀNH

- [ ] Tạo model Doctor.java
- [ ] Tạo DoctorDAO.java với đầy đủ CRUD
- [ ] Cập nhật UserDAO.java với các methods mới
- [ ] Tạo AdminUserServlet.java
- [ ] Tạo AdminDoctorServlet.java
- [ ] Tạo users.jsp
- [ ] Tạo user_form.jsp
- [ ] Tạo doctors.jsp
- [ ] Tạo doctor_form.jsp
- [ ] Test tất cả chức năng
- [ ] Viết README.md cho task
- [ ] Commit và push code

---

## 🎓 GỢI Ý NÂNG CAO

1. **Export danh sách users ra Excel**
2. **Import users từ CSV file**
3. **Reset password cho user**
4. **Gửi email welcome khi tạo user mới**
5. **Activity log - ghi lại ai đã thêm/sửa/xóa user**
6. **Bulk actions - xóa nhiều users cùng lúc**

