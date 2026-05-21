# 🔄 TEST LẠI SAU KHI SỬA

## ✅ Đã sửa xong:

1. **Lỗi compile JSP test-doctors.jsp** - Đã sửa import và code
2. **Thêm debug logging** cho DepartmentDAO và AdminUserServlet
3. **Thêm cache control headers** để tránh browser cache
4. **Thêm warning message** trong form nếu không load được departments

---

## 🔄 BÂY GIỜ HÃY LÀM:

### Bước 1: Dừng Tomcat server hiện tại
Trong terminal đang chạy Tomcat, nhấn **Ctrl+C** để dừng server.

### Bước 2: Rebuild project
```bash
.\mvnw.cmd clean compile
```

### Bước 3: Chạy lại Tomcat
```bash
.\mvnw.cmd tomcat7:run
```

### Bước 4: Test trang test-doctors.jsp
1. Mở browser
2. Truy cập: **http://localhost:8080/JVCare_MVC/test-doctors.jsp**
3. Kiểm tra:
   - [ ] Không còn lỗi HTTP 500
   - [ ] Tất cả sections hiển thị OK
   - [ ] Section 6 hiển thị danh sách 4 bác sĩ

### Bước 5: Test tạo bác sĩ mới với logging
1. Truy cập: **http://localhost:8080/JVCare_MVC/admin/doctors**
2. Click **"Thêm bác sĩ mới"**
3. **QUAN TRỌNG:** Xem console logs trong terminal, phải thấy:
   ```
   AdminUserServlet.showCreateForm: Request from doctors page
   DepartmentDAO.getAllActiveDepartments: Executing query...
   DepartmentDAO: Added department - Khoa Tim Mạch
   DepartmentDAO: Added department - Khoa Thần Kinh
   ... (các khoa khác)
   DepartmentDAO.getAllActiveDepartments: Returned 15 departments
   AdminUserServlet.showCreateForm: Loaded 15 departments
     - Khoa Cấp Cứu
     - Khoa Chấn Thương Chỉnh Hình
     ... (danh sách các khoa)
   ```

4. Kiểm tra form:
   - [ ] Title: **"Thêm Bác sĩ"**
   - [ ] Role mặc định: **"Bác sĩ (Doctor)"**
   - [ ] Section **"Thông tin Bác sĩ"** hiển thị (vì role đã là DOCTOR)
   - [ ] Combobox **Khoa** có 15 options (không phải "Không có khoa nào")

### Bước 6: Điền form và tạo bác sĩ mới
Điền thông tin:
- **Username:** `doctor5`
- **Password:** `123456`
- **Email:** `doctor5@jvcare.com`
- **Họ tên:** `BS. Trần Văn E`
- **Số điện thoại:** `0901234570`
- **Role:** `Bác sĩ (Doctor)` (đã chọn sẵn)
- **Chuyên khoa:** `Nội khoa`
- **Khoa:** Chọn `Khoa Tiêu Hóa` (hoặc khoa khác)

Click **"Tạo bác sĩ"**

### Bước 7: Kiểm tra kết quả
Sau khi submit, kiểm tra:

1. **Console logs phải có:**
   ```
   AdminUserServlet: Creating doctor with specialization: Nội khoa, departmentId: X
   DoctorDAO: departments table exists = true
   DoctorDAO: Executing SQL: SELECT ...
   DoctorDAO: Query executed successfully
   DoctorDAO: Added doctor - ID: 1, Name: BS. Lê Văn C
   DoctorDAO: Added doctor - ID: 2, Name: BS. Nguyễn Văn A
   DoctorDAO: Added doctor - ID: 3, Name: BS. Phạm Thị D
   DoctorDAO: Added doctor - ID: 4, Name: BS. Trần Thị B
   DoctorDAO: Added doctor - ID: 5, Name: BS. Trần Văn E  <-- BÁC SĨ MỚI
   DoctorDAO.getAllDoctors() returned 5 doctors
   AdminDoctorServlet: Loaded 5 doctors, total count: 5
   ```

2. **Trang /admin/doctors phải:**
   - [ ] Hiển thị thông báo **"Tạo bác sĩ thành công!"** (màu xanh)
   - [ ] Hiển thị **"Tổng số: 5 bác sĩ"** (không phải 4)
   - [ ] Hiển thị **5 cards** bác sĩ (bao gồm bác sĩ mới)
   - [ ] Card bác sĩ mới có:
     - Tên: BS. Trần Văn E
     - Email: doctor5@jvcare.com
     - Chuyên khoa: Nội khoa
     - Badge khoa: Khoa Tiêu Hóa (hoặc khoa bạn chọn)

3. **Nếu không thấy card mới:**
   - Nhấn **Ctrl+F5** để hard refresh (xóa cache)
   - Hoặc mở **Incognito/Private window** và test lại

---

## 🐛 Nếu vẫn có vấn đề:

### Vấn đề 1: Combobox Khoa vẫn trống
**Kiểm tra console logs:**
- Nếu thấy: `AdminUserServlet.showCreateForm: Loaded 0 departments`
  → Vấn đề ở DepartmentDAO
- Nếu thấy: `DepartmentDAO SQL Error: ...`
  → Copy error message và gửi cho tôi

**Kiểm tra trong SSMS:**
```sql
SELECT * FROM departments WHERE status = 'ACTIVE';
```
- Nếu trả về 0 rows → Chạy lại INSERT trong database.sql
- Nếu trả về 15 rows → Vấn đề ở Java code

### Vấn đề 2: Sau khi tạo bác sĩ, vẫn hiển thị 4 bác sĩ
**Kiểm tra console logs:**
- Tìm dòng: `AdminDoctorServlet: Loaded X doctors, total count: Y`
- Nếu X = 5 nhưng trang hiển thị 4 → Browser cache
  - Giải pháp: Hard refresh (Ctrl+F5)
- Nếu X = 4 → Bác sĩ chưa được tạo thành công
  - Kiểm tra có error trong console không

**Kiểm tra trong SSMS:**
```sql
-- Kiểm tra users
SELECT * FROM users WHERE role = 'DOCTOR';

-- Kiểm tra doctors
SELECT * FROM doctors;

-- Nếu có user mới nhưng không có doctor record
-- → Lỗi trong AdminUserServlet.createUser()
```

### Vấn đề 3: Lỗi khi tạo bác sĩ
**Copy toàn bộ error message từ console và gửi cho tôi**

Bao gồm:
- Stack trace
- SQL error (nếu có)
- Tất cả logs từ AdminUserServlet và DoctorDAO

---

## 📸 Sau khi test xong, gửi cho tôi:

1. **Screenshot console logs** khi:
   - Mở form "Thêm bác sĩ mới"
   - Submit form tạo bác sĩ
   - Trang doctors sau khi tạo

2. **Screenshot trang /admin/doctors** sau khi tạo bác sĩ mới:
   - Phải thấy 5 cards
   - Phải thấy "Tổng số: 5 bác sĩ"

3. **Screenshot form "Thêm bác sĩ mới":**
   - Phải thấy combobox Khoa có dữ liệu

4. **Nếu có lỗi:**
   - Copy toàn bộ error message từ console

---

## ✅ Checklist cuối cùng:

- [ ] test-doctors.jsp không còn lỗi HTTP 500
- [ ] test-doctors.jsp hiển thị 4 bác sĩ ban đầu
- [ ] Form "Thêm bác sĩ" có title đúng
- [ ] Combobox Khoa có 15 options
- [ ] Có thể tạo bác sĩ mới thành công
- [ ] Sau khi tạo, hiển thị 5 bác sĩ (không phải 4)
- [ ] Card bác sĩ mới hiển thị đầy đủ thông tin
- [ ] Console logs không có error

---

**Hãy làm từng bước và cho tôi biết kết quả!** 🚀

Nếu tất cả OK → Chúng ta sẽ dọn dẹp code (xóa test files, logging) và hoàn thành task!
