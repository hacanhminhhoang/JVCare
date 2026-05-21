# 🔍 HƯỚNG DẪN TEST NGAY BÂY GIỜ

Server Tomcat đã chạy thành công! Làm theo các bước sau:

## Bước 1: Kiểm tra Database (QUAN TRỌNG!)

Mở **SQL Server Management Studio (SSMS)** và chạy file `check-database.sql`:

```sql
-- Hoặc copy paste từ file check-database.sql
USE JVCare_MVC;
GO

-- 1. Kiểm tra bảng departments có tồn tại không
SELECT COUNT(*) AS departments_table_exists 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'departments';
GO

-- 2. Kiểm tra users với role DOCTOR
SELECT user_id, username, email, full_name, role, status 
FROM users 
WHERE role = 'DOCTOR';
GO

-- 3. Kiểm tra bảng doctors
SELECT * FROM doctors;
GO

-- 4. Test query JOIN (giống DoctorDAO)
SELECT d.doctor_id, d.user_id, d.specialization, d.department_id,
       u.full_name, u.email, u.phone, u.status,
       dept.department_name
FROM doctors d
JOIN users u ON d.user_id = u.user_id
LEFT JOIN departments dept ON d.department_id = dept.department_id
ORDER BY u.full_name;
GO
```

### ❓ Kết quả mong đợi:
- Query 1: Phải trả về `1` (bảng departments tồn tại)
- Query 2: Phải có ít nhất 1 user với role DOCTOR
- Query 3: Phải có ít nhất 1 record trong bảng doctors
- Query 4: Phải trả về danh sách bác sĩ với đầy đủ thông tin

### ⚠️ Nếu bảng departments KHÔNG tồn tại:
Chạy lại file `SQL/database.sql` để tạo bảng và insert dữ liệu mẫu.

---

## Bước 2: Test với trang Debug

1. Mở trình duyệt
2. Truy cập: **http://localhost:8080/JVCare_MVC/test-doctors.jsp**

### 📊 Trang này sẽ hiển thị:

#### Section 1: Database Connection Test
- ✅ Màu xanh = kết nối thành công
- ❌ Màu đỏ = kết nối thất bại

#### Section 2: Check Tables Existence
- Kiểm tra 3 bảng: users, doctors, departments
- Tất cả phải có dấu ✅

#### Section 3: Check Users with DOCTOR Role
- Hiển thị danh sách users có role = DOCTOR
- Phải có ít nhất 1 user

#### Section 4: Check Doctors Table Records
- Hiển thị tất cả records trong bảng doctors
- Phải có ít nhất 1 record

#### Section 5: Testing getTotalDoctors()
- Hiển thị tổng số doctors (ví dụ: 4)

#### Section 6: Testing getAllDoctors()
- **ĐÂY LÀ PHẦN QUAN TRỌNG NHẤT!**
- Nếu hiển thị "0 doctors" → có lỗi SQL
- Nếu hiển thị danh sách bác sĩ → OK!

---

## Bước 3: Kiểm tra Console Logs

Trong cửa sổ terminal đang chạy Tomcat, tìm các dòng log:

```
DoctorDAO: departments table exists = true/false
DoctorDAO: Executing SQL: SELECT ...
DoctorDAO: Query executed successfully
DoctorDAO: Added doctor - ID: X, Name: ...
DoctorDAO.getAllDoctors() returned X doctors
```

### 🔍 Phân tích logs:

**Nếu thấy:**
```
DoctorDAO: departments table exists = false
```
→ Bảng departments chưa được tạo → Chạy lại SQL/database.sql

**Nếu thấy:**
```
DoctorDAO SQL Error: ...
SQL State: ...
Error Code: ...
```
→ Copy toàn bộ error message và gửi cho tôi

**Nếu thấy:**
```
DoctorDAO.getAllDoctors() returned 0 doctors
```
Nhưng getTotalDoctors() trả về 4
→ Có lỗi trong SQL JOIN hoặc mapResultSetToDoctor()

---

## Bước 4: Test trang Admin Doctors

1. Truy cập: **http://localhost:8080/JVCare_MVC/admin/doctors**
2. Đăng nhập với:
   - Email: `admin@jvcare.com`
   - Password: `123456`

### 📋 Kiểm tra:
- [ ] Có hiển thị "Tổng số: X bác sĩ" không?
- [ ] Có hiển thị các card bác sĩ không?
- [ ] Nếu không có card → xem console logs

---

## Bước 5: Test tạo bác sĩ mới

1. Từ trang `/admin/doctors`, click **"Thêm bác sĩ mới"**
2. Kiểm tra form:
   - [ ] Title phải là **"Thêm Bác sĩ"** (không phải "Thêm Nhân viên")
   - [ ] Role mặc định phải là **"Bác sĩ (Doctor)"**
   - [ ] Phải có section **"Thông tin Bác sĩ"** với 2 fields:
     - Chuyên khoa (required)
     - Khoa (combobox)

3. Điền thông tin:
   - Username: `doctor2`
   - Password: `123456`
   - Email: `doctor2@jvcare.com`
   - Họ tên: `BS. Nguyễn Văn B`
   - Số điện thoại: `0901234568`
   - Role: `Bác sĩ (Doctor)` (đã chọn sẵn)
   - Chuyên khoa: `Tim mạch`
   - Khoa: Chọn một khoa từ combobox

4. Click **"Tạo bác sĩ"**

5. Sau khi tạo thành công:
   - [ ] Phải redirect về `/admin/doctors`
   - [ ] Phải hiển thị thông báo "Tạo bác sĩ thành công!"
   - [ ] Phải thấy card của bác sĩ mới

---

## 🐛 Các lỗi thường gặp và cách khắc phục:

### Lỗi 1: Bảng departments không tồn tại
**Triệu chứng:** test-doctors.jsp hiển thị ❌ cho departments table

**Khắc phục:**
```sql
-- Chạy lại file SQL/database.sql trong SSMS
-- Hoặc chỉ chạy phần tạo bảng departments:
USE JVCare_MVC;
GO

CREATE TABLE departments (
    department_id INT PRIMARY KEY IDENTITY(1,1),
    department_code VARCHAR(20) UNIQUE NOT NULL,
    department_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    head_doctor_id INT,
    phone VARCHAR(20),
    location NVARCHAR(200),
    status VARCHAR(10) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (head_doctor_id) REFERENCES doctors(doctor_id) ON DELETE SET NULL
);
GO

-- Insert dữ liệu mẫu (copy từ database.sql)
```

### Lỗi 2: getAllDoctors() trả về 0 nhưng getTotalDoctors() trả về 4
**Triệu chứng:** Trang doctors hiển thị "Tổng số: 4 bác sĩ" nhưng không có card

**Khắc phục:**
1. Kiểm tra console logs để xem error message
2. Kiểm tra query JOIN trong SSMS có chạy được không
3. Gửi error message cho tôi

### Lỗi 3: Form hiển thị "Thêm Nhân viên" thay vì "Thêm Bác sĩ"
**Triệu chứng:** Click "Thêm bác sĩ mới" nhưng form title sai

**Khắc phục:**
- Đảm bảo click vào link từ trang `/admin/doctors`
- Không mở link trong tab mới (right-click > open in new tab)
- Nếu vẫn sai → clear browser cache và thử lại

### Lỗi 4: Không có combobox Khoa trong form
**Triệu chứng:** Form không hiển thị dropdown Khoa

**Khắc phục:**
1. Kiểm tra bảng departments có dữ liệu không
2. Chọn role "Bác sĩ (Doctor)" để hiển thị section "Thông tin Bác sĩ"

---

## 📸 Sau khi test xong:

Hãy chụp màn hình và gửi cho tôi:
1. Screenshot trang **test-doctors.jsp** (toàn bộ trang)
2. Screenshot trang **/admin/doctors** (có hiển thị card không?)
3. Screenshot **console logs** trong terminal (các dòng DoctorDAO...)
4. Nếu có lỗi → copy toàn bộ error message

---

## ✅ Checklist tổng hợp:

- [ ] Database connection thành công
- [ ] Bảng departments tồn tại và có dữ liệu
- [ ] Có ít nhất 1 user với role DOCTOR
- [ ] Có ít nhất 1 record trong bảng doctors
- [ ] Query JOIN chạy thành công trong SSMS
- [ ] test-doctors.jsp hiển thị danh sách bác sĩ
- [ ] Console logs không có error
- [ ] Trang /admin/doctors hiển thị card bác sĩ
- [ ] Form "Thêm bác sĩ" hiển thị đúng title
- [ ] Có thể tạo bác sĩ mới thành công

---

**Hãy làm theo từng bước và cho tôi biết kết quả nhé!** 🚀
