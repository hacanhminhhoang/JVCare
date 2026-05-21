# Hướng dẫn Debug vấn đề không hiển thị card bác sĩ

## Các thay đổi đã thực hiện:

### 1. Sửa AdminUserServlet.java
- Thêm logic phát hiện request từ trang doctors (qua Referer header)
- Set attribute `fromDoctors=true` khi request đến từ `/admin/doctors`
- Set attribute `defaultRole=DOCTOR` khi tạo mới từ trang doctors
- Load danh sách departments cho combobox
- Xử lý tạo/cập nhật doctor record khi role là DOCTOR
- Redirect về đúng trang sau khi tạo/sửa (doctors hoặc users)

### 2. Sửa user_form.jsp
- Title động: hiển thị "Bác sĩ" khi `fromDoctors=true`, ngược lại hiển thị "Nhân viên"
- Thêm option DOCTOR vào combobox Role
- Thêm section "Thông tin Bác sĩ" với 2 fields:
  - Chuyên khoa (specialization) - required khi role là DOCTOR
  - Khoa (departmentId) - combobox từ bảng departments
- JavaScript để toggle hiển thị doctor fields khi chọn role DOCTOR
- Nút Hủy và Submit redirect về đúng trang

### 3. Sửa DoctorDAO.java
- Đơn giản hóa logic getAllDoctors() - luôn dùng LEFT JOIN với departments
- Thêm logging để debug: in ra số lượng doctors tìm được
- Thêm error logging khi có exception

## Các bước để test và debug:

### Bước 1: Kiểm tra database
Mở SQL Server Management Studio và chạy các query sau:

```sql
-- Kiểm tra bảng departments có tồn tại không
SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'departments';

-- Kiểm tra dữ liệu trong bảng departments
SELECT * FROM departments;

-- Kiểm tra dữ liệu trong bảng doctors
SELECT * FROM doctors;

-- Kiểm tra dữ liệu trong bảng users với role DOCTOR
SELECT * FROM users WHERE role = 'DOCTOR';

-- Kiểm tra JOIN giữa doctors, users và departments
SELECT d.doctor_id, d.user_id, d.specialization, d.department_id,
       u.full_name, u.email, u.phone, u.status,
       dept.department_name
FROM doctors d
JOIN users u ON d.user_id = u.user_id
LEFT JOIN departments dept ON d.department_id = dept.department_id
ORDER BY u.full_name;
```

### Bước 2: Chạy lại SQL script nếu cần
Nếu bảng departments chưa tồn tại hoặc thiếu dữ liệu:

```sql
-- Chạy lại file SQL/database.sql
-- Hoặc chỉ chạy phần tạo bảng departments và insert data
```

### Bước 3: Test với trang debug
1. Start server Tomcat
2. Truy cập: `http://localhost:8080/JVCare_MVC/test-doctors.jsp`
3. Trang này sẽ hiển thị:
   - Tổng số doctors tìm được
   - Bảng chi tiết thông tin từng doctor
   - Error message nếu có lỗi

### Bước 4: Kiểm tra console logs
Khi truy cập trang admin/doctors, kiểm tra console output:
- Nên thấy dòng: `DoctorDAO.getAllDoctors() returned X doctors`
- Nếu có lỗi, sẽ thấy stack trace

### Bước 5: Test tạo bác sĩ mới
1. Truy cập: `http://localhost:8080/JVCare_MVC/admin/doctors`
2. Click "Thêm bác sĩ mới"
3. Kiểm tra:
   - Title phải là "Thêm Bác sĩ" (không phải "Thêm Nhân viên")
   - Role mặc định phải là "Bác sĩ (Doctor)"
   - Phải hiển thị section "Thông tin Bác sĩ" với 2 fields: Chuyên khoa và Khoa
4. Điền form và submit
5. Sau khi tạo thành công, phải redirect về `/admin/doctors` (không phải `/admin/users`)

### Bước 6: Test sửa bác sĩ
1. Từ trang `/admin/doctors`, click "Sửa thông tin" trên một card bác sĩ
2. Kiểm tra:
   - Title phải là "Sửa Bác sĩ"
   - Phải hiển thị section "Thông tin Bác sĩ" với dữ liệu hiện tại
   - Combobox Khoa phải chọn đúng khoa hiện tại
3. Sửa thông tin và submit
4. Sau khi cập nhật thành công, phải redirect về `/admin/doctors`

## Các vấn đề có thể gặp và cách khắc phục:

### Vấn đề 1: Không có card bác sĩ nào hiển thị
**Nguyên nhân có thể:**
- Bảng departments chưa được tạo → chạy lại SQL script
- Không có dữ liệu trong bảng doctors → tạo bác sĩ mới
- Lỗi SQL trong DoctorDAO → kiểm tra console logs

**Cách khắc phục:**
1. Chạy test-doctors.jsp để xem có lỗi gì
2. Kiểm tra console logs
3. Chạy lại SQL/database.sql

### Vấn đề 2: Form hiển thị "Thêm Nhân viên" thay vì "Thêm Bác sĩ"
**Nguyên nhân:**
- Referer header không được gửi hoặc không chứa "/admin/doctors"

**Cách khắc phục:**
- Đảm bảo click vào link "Thêm bác sĩ mới" từ trang `/admin/doctors`
- Không mở link trong tab mới (right-click > open in new tab)

### Vấn đề 3: Không hiển thị combobox Khoa
**Nguyên nhân:**
- Bảng departments chưa có dữ liệu
- DepartmentDAO.getAllActiveDepartments() trả về list rỗng

**Cách khắc phục:**
- Chạy lại phần INSERT departments trong SQL/database.sql

### Vấn đề 4: Lỗi khi tạo/sửa bác sĩ
**Nguyên nhân:**
- Foreign key constraint vi phạm
- Thiếu required fields

**Cách khắc phục:**
- Kiểm tra console logs để xem error message chi tiết
- Đảm bảo department_id tồn tại trong bảng departments

## Sau khi test xong:
- Xóa file test-doctors.jsp (không cần thiết cho production)
- Commit và push code nếu mọi thứ hoạt động tốt
