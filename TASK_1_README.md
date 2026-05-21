# TASK 1: ADMIN - QUẢN LÝ USERS & DOCTORS

**Thành viên thực hiện:** Hà Cảnh Minh Hoàng  
**Branch:** `feature/task1-admin-ha-canh-minh-hoang`  
**Trạng thái:** ✅ Hoàn thành 100%

---

## 📊 TỔNG QUAN CÔNG VIỆC

Module quản trị viên cho phép ADMIN quản lý users và doctors trong hệ thống JVCare.

### Chức năng chính:
- ✅ Quản lý Users (CRUD)
- ✅ Quản lý Doctors (View & Search)
- ✅ Phân trang danh sách
- ✅ Tìm kiếm users/doctors
- ✅ Validation đầy đủ
- ✅ Soft delete (set status = INACTIVE)
- ✅ Kiến trúc 3-Layer (Presentation - Business Logic - Data Access)

---

## 🏗️ KIẾN TRÚC 3-LAYER

```
┌─────────────────────────────────────────┐
│     PRESENTATION LAYER (Controller)     │
│  - AdminUserServlet.java                │
│  - AdminDoctorServlet.java              │
│  - JSP Views (users.jsp, doctors.jsp)  │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│    BUSINESS LOGIC LAYER (Service)       │
│  - UserService.java                     │
│  - DoctorService.java                   │
│  - DTOs (UserDTO, DoctorDTO)            │
│  - Exceptions (Business, Validation)    │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│      DATA ACCESS LAYER (DAO)            │
│  - UserDAO.java                         │
│  - DoctorDAO.java                       │
│  - Models (User, Doctor)                │
└─────────────────────────────────────────┘
```

---

## 📁 CẤU TRÚC FILE ĐÃ TẠO

### Models
- ✅ `src/main/java/com/jvcare/model/Doctor.java`

### DAOs (Data Access Layer)
- ✅ `src/main/java/com/jvcare/dao/UserDAO.java` (cập nhật)
- ✅ `src/main/java/com/jvcare/dao/DoctorDAO.java`

### DTOs (Data Transfer Objects)
- ✅ `src/main/java/com/jvcare/dto/UserDTO.java`
- ✅ `src/main/java/com/jvcare/dto/DoctorDTO.java`

### Exceptions
- ✅ `src/main/java/com/jvcare/exception/BusinessException.java`
- ✅ `src/main/java/com/jvcare/exception/ValidationException.java`

### Services (Business Logic Layer)
- ✅ `src/main/java/com/jvcare/service/UserService.java`
- ✅ `src/main/java/com/jvcare/service/DoctorService.java`

### Controllers (Presentation Layer)
- ✅ `src/main/java/com/jvcare/controller/AdminUserServlet.java`
- ✅ `src/main/java/com/jvcare/controller/AdminDoctorServlet.java`

### Views (JSP)
- ✅ `src/main/webapp/WEB-INF/views/admin/users.jsp`
- ✅ `src/main/webapp/WEB-INF/views/admin/user_form.jsp`
- ✅ `src/main/webapp/WEB-INF/views/admin/doctors.jsp`
- ✅ `src/main/webapp/WEB-INF/views/admin/doctor_form.jsp`

---

## 🔄 QUY TRÌNH PHÁT TRIỂN (4 GIAI ĐOẠN)

### Phase 1 (25%) - MVC Basic Structure ✅
**Commit:** `feat: thêm Doctor model và DAO cơ bản - hoàn thành 25%`

- Tạo Doctor model
- Tạo DoctorDAO với CRUD methods
- Cập nhật UserDAO với các methods mới:
  - `getAllUsers(page, pageSize)`
  - `getTotalUsers()`
  - `searchUsers(keyword)`
  - `getUserById(userId)`
  - `createUser(user)`
  - `updateUser(user)`
  - `deleteUser(userId)` - soft delete
  - `existsByUsername(username)`
  - `existsByEmail(email)`
  - `existsByEmailExcludingUser(email, userId)`
  - `countUsersByRole(role)`

### Phase 2 (50%) - Servlets ✅
**Commit:** `feat: thêm Admin servlets cho quản lý user và doctor - hoàn thành 50%`

- Tạo AdminUserServlet với các actions:
  - `listUsers()` - hiển thị danh sách với phân trang
  - `showCreateForm()` - form tạo user mới
  - `showEditForm()` - form sửa user
  - `createUser()` - xử lý tạo user
  - `updateUser()` - xử lý cập nhật user
  - `deleteUser()` - soft delete user
  - `searchUsers()` - tìm kiếm users
  - `checkAdminAccess()` - kiểm tra quyền ADMIN

- Tạo AdminDoctorServlet với các actions:
  - `listDoctors()` - hiển thị danh sách doctors
  - `viewDoctor()` - xem chi tiết doctor
  - `searchDoctors()` - tìm kiếm doctors

### Phase 3 (75%) - JSP Views ✅
**Commit:** `feat: thêm giao diện JSP cho admin quản lý users và doctors - hoàn thành 75%`

- Tạo `users.jsp`:
  - Sidebar navigation
  - Search box
  - Users table với pagination
  - Role & Status badges
  - Action buttons (Edit, Delete)
  - Success/Error messages

- Tạo `user_form.jsp`:
  - Form tạo/sửa user
  - Validation HTML5
  - Toggle specialization field cho DOCTOR
  - JavaScript validation

- Tạo `doctors.jsp`:
  - Grid view với doctor cards
  - Table view chi tiết
  - Search functionality
  - Statistics display

- Tạo `doctor_form.jsp`:
  - Placeholder form (quản lý qua Users)

### Phase 4 (100%) - 3-Layer Architecture ✅
**Commit:** `feat: tích hợp kiến trúc 3-Layer với Service layer - hoàn thành 100%`

- Tạo DTOs:
  - `UserDTO` - transfer data giữa layers
  - `DoctorDTO` - transfer data giữa layers

- Tạo Custom Exceptions:
  - `BusinessException` - lỗi business logic
  - `ValidationException` - lỗi validation

- Tạo Services:
  - `UserService` - business logic cho User:
    - Validation đầy đủ (username, password, email, phone, role)
    - Check duplicate username/email
    - Hash password với BCrypt
    - Business rules (không xóa admin cuối cùng)
    - Convert Entity ↔ DTO
  
  - `DoctorService` - business logic cho Doctor:
    - Lấy danh sách doctors
    - Tìm kiếm doctors
    - Cập nhật specialization

---

## 🧪 TESTING CHECKLIST

### Quản lý Users
- ✅ Xem danh sách users với phân trang
- ✅ Tạo user mới (ADMIN, DOCTOR, PATIENT)
- ✅ Validate required fields
- ✅ Check duplicate username/email
- ✅ Hash password với BCrypt
- ✅ Tự động tạo doctor record khi role = DOCTOR
- ✅ Sửa user (không cho sửa username, role)
- ✅ Xóa user (soft delete)
- ✅ Không xóa được chính mình
- ✅ Không xóa được admin cuối cùng
- ✅ Tìm kiếm users theo tên, email, username

### Quản lý Doctors
- ✅ Xem danh sách doctors (Grid & Table view)
- ✅ Hiển thị specialization
- ✅ Tìm kiếm doctors theo tên, chuyên khoa, email
- ✅ Sửa doctor qua Users management

### Validation
- ✅ Username: 3-50 ký tự, chỉ chữ cái, số, gạch dưới
- ✅ Password: tối thiểu 6 ký tự
- ✅ Email: format hợp lệ
- ✅ Phone: 10-11 chữ số
- ✅ Specialization: bắt buộc cho DOCTOR

### Authorization
- ✅ Chỉ ADMIN mới truy cập được admin module
- ✅ Redirect về login nếu chưa đăng nhập
- ✅ Hiển thị 403 Forbidden nếu không phải ADMIN

---

## 🚀 HƯỚNG DẪN SỬ DỤNG

### 1. Truy cập Admin Module
```
URL: http://localhost:8080/JVCare_MVC/admin/users
Yêu cầu: Đăng nhập với role ADMIN
```

### 2. Quản lý Users
- **Xem danh sách:** `/admin/users`
- **Thêm user:** `/admin/users?action=create`
- **Sửa user:** `/admin/users?action=edit&id={userId}`
- **Xóa user:** `/admin/users?action=delete&id={userId}`
- **Tìm kiếm:** `/admin/users?action=search&keyword={keyword}`

### 3. Quản lý Doctors
- **Xem danh sách:** `/admin/doctors`
- **Tìm kiếm:** `/admin/doctors?action=search&keyword={keyword}`
- **Sửa doctor:** Qua Users management

---

## 📊 THỐNG KÊ CODE

| Loại File | Số lượng | Dòng code (ước tính) |
|-----------|----------|----------------------|
| Models    | 1        | ~80                  |
| DAOs      | 2        | ~550                 |
| DTOs      | 2        | ~150                 |
| Exceptions| 2        | ~20                  |
| Services  | 2        | ~640                 |
| Controllers| 2       | ~510                 |
| JSP Views | 4        | ~670                 |
| **TỔNG**  | **15**   | **~2,620 dòng**      |

---

## 🔗 LIÊN KẾT GITHUB

- **Branch:** https://github.com/hacanhminhhoang/JVCare/tree/feature/task1-admin-ha-canh-minh-hoang
- **Pull Request:** Tạo PR từ branch trên về `main`

---

## 📝 GHI CHÚ

### Điểm mạnh:
- ✅ Kiến trúc 3-Layer rõ ràng, dễ maintain
- ✅ Validation đầy đủ ở cả client và server
- ✅ Business logic tách biệt khỏi Controller
- ✅ Sử dụng DTO để transfer data an toàn
- ✅ Custom exceptions cho error handling
- ✅ Soft delete thay vì hard delete
- ✅ BCrypt cho password security
- ✅ Responsive UI với Bootstrap 5

### Có thể cải thiện:
- 🔄 Thêm unit tests cho Service layer
- 🔄 Implement logging (Log4j)
- 🔄 Thêm activity log (audit trail)
- 🔄 Export danh sách ra Excel
- 🔄 Import users từ CSV
- 🔄 Reset password functionality
- 🔄 Email notification khi tạo user mới

---

## 👨‍💻 THÔNG TIN THÀNH VIÊN

**Họ tên:** Hà Cảnh Minh Hoàng  
**Nhiệm vụ:** Task 1 - Admin Module  
**Thời gian:** 21/05/2026  
**Trạng thái:** ✅ Hoàn thành 100%

---

**Ngày hoàn thành:** 21/05/2026  
**Phiên bản:** 1.0.0
