# PHÂN CHIA NHIỆM VỤ DỰ ÁN JVCARE_MVC
## Hệ thống Quản lý Bệnh án Bệnh nhân

**Ngày phân chia:** 20/05/2026  
**Deadline báo cáo cuối kỳ:** Hoàn thành trước 29/05/2026

---

## 📋 TỔNG QUAN DỰ ÁN HIỆN TẠI

### ✅ Đã hoàn thành:
- Hệ thống đăng nhập (Login/Logout)
- Quản lý lịch hẹn cơ bản (Patient & Doctor)
- Xem danh sách đơn thuốc (Patient)
- Xem chi tiết bệnh nhân (Doctor)
- Tích hợp AI chatbot (Groq AI)
- Database schema hoàn chỉnh

### ❌ Còn thiếu (CẦN PHÁT TRIỂN):
1. **Module Admin** - Quản lý toàn bộ hệ thống
2. **Module Doctor** - Quản lý bệnh án và đơn thuốc
3. **Module Patient** - Đặt lịch và quản lý hồ sơ
4. **Báo cáo & Thống kê** - Dashboard và reports
5. **Tính năng nâng cao** - Search, Filter, Export, Email

---

## 👥 PHÂN CHIA TASK CHO 5 THÀNH VIÊN


### 🔴 TASK 1: ADMIN - QUẢN LÝ NGƯỜI DÙNG & BÁC SĨ
**Thành viên:** Hà Cảnh Minh Hoàng 

#### Mô tả:
Phát triển module quản trị viên để quản lý users, doctors và patients trong hệ thống.

#### Công việc chi tiết:

**1. Quản lý Users (CRUD)**
- [ ] `AdminUserServlet.java` - Servlet quản lý users
  - GET: Hiển thị danh sách users (phân trang)
  - POST: Thêm user mới (admin, doctor, patient)
  - PUT: Cập nhật thông tin user
  - DELETE: Xóa/vô hiệu hóa user
- [ ] `UserDAO.java` - Thêm methods:
  - `getAllUsers()` - Lấy tất cả users
  - `createUser(User user)` - Tạo user mới
  - `updateUser(User user)` - Cập nhật user
  - `deleteUser(int userId)` - Xóa user
  - `searchUsers(String keyword)` - Tìm kiếm user

**2. Quản lý Doctors**
- [ ] `AdminDoctorServlet.java` - Servlet quản lý bác sĩ
  - Thêm/sửa/xóa bác sĩ
  - Gán chuyên khoa cho bác sĩ
- [ ] `DoctorDAO.java` - Tạo file mới với methods:
  - `getAllDoctors()` - Lấy danh sách bác sĩ
  - `createDoctor(Doctor doctor)` - Thêm bác sĩ
  - `updateDoctor(Doctor doctor)` - Cập nhật bác sĩ
  - `deleteDoctor(int doctorId)` - Xóa bác sĩ

**3. Views (JSP)**
- [ ] `/admin/users.jsp` - Danh sách users
- [ ] `/admin/user_form.jsp` - Form thêm/sửa user
- [ ] `/admin/doctors.jsp` - Danh sách bác sĩ
- [ ] `/admin/doctor_form.jsp` - Form thêm/sửa bác sĩ

**4. Validation & Security**
- [ ] Validate email format, phone number
- [ ] Check duplicate username/email
- [ ] Hash password với BCrypt
- [ ] Authorization check (chỉ ADMIN mới truy cập)

#### Deliverables:
- 2 Servlets (AdminUserServlet, AdminDoctorServlet)
- 1 DAO mới (DoctorDAO) + update UserDAO
- 4 JSP files
- SQL script cho test data


---

### 🟢 TASK 2: DOCTOR - QUẢN LÝ BỆNH ÁN & ĐƠN THUỐC
**Thành viên:** Đặng Thái Nguyên

#### Mô tả:
Phát triển chức năng cho bác sĩ tạo và quản lý bệnh án, đơn thuốc cho bệnh nhân.

#### Công việc chi tiết:

**1. Quản lý Medical Records**
- [ ] `DoctorMedicalRecordServlet.java` - Servlet quản lý bệnh án
  - GET: Xem danh sách bệnh án của bệnh nhân
  - POST: Tạo bệnh án mới sau khi khám
  - PUT: Cập nhật bệnh án
  - GET `/detail`: Xem chi tiết bệnh án
- [ ] Update `MedicalRecordDAO.java`:
  - `getRecordById(int recordId)` - Lấy chi tiết bệnh án
  - `updateRecord(MedicalRecord record)` - Cập nhật bệnh án
  - `getRecordsByDoctorId(int doctorId)` - Bệnh án của bác sĩ
  - `getRecordWithPrescriptions(int recordId)` - Bệnh án + đơn thuốc

**2. Quản lý Prescriptions**
- [ ] `DoctorPrescriptionServlet.java` - Servlet quản lý đơn thuốc
  - POST: Thêm thuốc vào đơn
  - PUT: Cập nhật thông tin thuốc
  - DELETE: Xóa thuốc khỏi đơn
- [ ] Update `PrescriptionDAO.java`:
  - `createPrescription(Prescription p)` - Thêm thuốc
  - `updatePrescription(Prescription p)` - Cập nhật thuốc
  - `deletePrescription(int prescriptionId)` - Xóa thuốc
  - `getPrescriptionsByRecordId(int recordId)` - Lấy đơn thuốc

**3. Workflow: Hoàn thành lịch hẹn → Tạo bệnh án**
- [ ] Tích hợp với `DoctorAppointmentDetailServlet`
- [ ] Sau khi complete appointment → redirect tạo medical record
- [ ] Link appointment_id với record_id trong database

**4. Views (JSP)**
- [ ] `/doctor/medical_records.jsp` - Danh sách bệnh án
- [ ] `/doctor/medical_record_form.jsp` - Form tạo/sửa bệnh án
- [ ] `/doctor/medical_record_detail.jsp` - Chi tiết bệnh án + đơn thuốc
- [ ] `/doctor/prescription_form.jsp` - Form thêm thuốc

**5. Features nâng cao**
- [ ] In đơn thuốc (Print prescription)
- [ ] Validate liều lượng thuốc
- [ ] Gợi ý thuốc phổ biến (dropdown)

#### Deliverables:
- 2 Servlets mới
- Update 2 DAOs
- 4 JSP files
- Print prescription template (PDF/HTML)


---

### 🔵 TASK 3: PATIENT - ĐẶT LỊCH & QUẢN LÝ HỒ SƠ
**Thành viên:** Trần Ngọc Thiết

#### Mô tả:
Phát triển chức năng cho bệnh nhân đặt lịch khám, quản lý hồ sơ cá nhân và xem lịch sử khám bệnh.

#### Công việc chi tiết:

**1. Đặt lịch khám (Book Appointment)**
- [ ] `PatientBookAppointmentServlet.java` - Servlet đặt lịch
  - GET: Hiển thị form đặt lịch + danh sách bác sĩ
  - POST: Tạo appointment mới
  - PUT: Cập nhật lịch hẹn (nếu còn PENDING)
  - DELETE: Hủy lịch hẹn
- [ ] Update `AppointmentDAO.java`:
  - `getAvailableTimeSlots(Date date, int doctorId)` - Lấy giờ trống
  - `checkDuplicateAppointment()` - Kiểm tra trùng lịch
  - `cancelAppointment(int appointmentId)` - Hủy lịch

**2. Quản lý hồ sơ cá nhân**
- [ ] `PatientProfileServlet.java` - Servlet quản lý profile
  - GET: Xem thông tin cá nhân
  - POST: Cập nhật thông tin (tên, SĐT, địa chỉ, dị ứng, bệnh mạn tính)
  - POST `/upload-avatar`: Upload ảnh đại diện
- [ ] Update `PatientDAO.java`:
  - `getPatientByUserId(int userId)` - Lấy patient từ user_id
  - `updatePatientProfile(Patient p)` - Cập nhật profile

**3. Xem lịch sử khám bệnh**
- [ ] `PatientMedicalHistoryServlet.java` - Servlet xem lịch sử
  - GET: Danh sách bệnh án của bệnh nhân
  - GET `/detail`: Chi tiết bệnh án + đơn thuốc
- [ ] Tích hợp với `MedicalRecordDAO` và `PrescriptionDAO`

**4. Views (JSP)**
- [ ] `/patient/book_appointment.jsp` - Form đặt lịch
- [ ] `/patient/profile.jsp` - Hồ sơ cá nhân
- [ ] `/patient/medical_history.jsp` - Lịch sử khám bệnh
- [ ] `/patient/medical_history_detail.jsp` - Chi tiết bệnh án

**5. Features nâng cao**
- [ ] Calendar view cho lịch hẹn (FullCalendar.js)
- [ ] Upload avatar (lưu vào folder /images/avatars/)
- [ ] Notification khi lịch hẹn được xác nhận
- [ ] Filter lịch sử theo ngày, bác sĩ

#### Deliverables:
- 3 Servlets mới
- Update 2 DAOs
- 4 JSP files
- JavaScript cho calendar và upload avatar


---

### 🟡 TASK 4: BÁO CÁO & THỐNG KÊ (DASHBOARD)
**Thành viên:** Lê Thế Duy

#### Mô tả:
Phát triển dashboard và báo cáo thống kê cho Admin và Doctor.

#### Công việc chi tiết:

**1. Admin Dashboard**
- [ ] Update `AdminHomeServlet.java` - Thêm statistics
  - Tổng số users (admin, doctor, patient)
  - Tổng số lịch hẹn (pending, confirmed, completed)
  - Tổng số bệnh án
  - Biểu đồ lịch hẹn theo tháng
- [ ] `AdminReportServlet.java` - Servlet báo cáo
  - GET `/appointments`: Báo cáo lịch hẹn
  - GET `/patients`: Báo cáo bệnh nhân
  - GET `/doctors`: Báo cáo hiệu suất bác sĩ
  - GET `/export`: Export báo cáo ra Excel/PDF

**2. Doctor Dashboard**
- [ ] Update `DoctorHomeServlet.java` - Thêm statistics
  - Số lịch hẹn hôm nay
  - Số bệnh nhân đã khám
  - Số bệnh án đã tạo
  - Lịch hẹn sắp tới

**3. Statistics DAO**
- [ ] `StatisticsDAO.java` - DAO mới cho thống kê
  - `getTotalUsers()` - Tổng users
  - `getTotalAppointments()` - Tổng lịch hẹn
  - `getAppointmentsByStatus()` - Lịch hẹn theo status
  - `getAppointmentsByMonth(int year)` - Lịch hẹn theo tháng
  - `getDoctorPerformance(int doctorId)` - Hiệu suất bác sĩ
  - `getPatientStatistics()` - Thống kê bệnh nhân

**4. Views (JSP)**
- [ ] Update `/admin/index.jsp` - Dashboard với charts
- [ ] Update `/doctor/index.jsp` - Dashboard bác sĩ
- [ ] `/admin/reports.jsp` - Trang báo cáo
- [ ] `/admin/report_appointments.jsp` - Báo cáo lịch hẹn
- [ ] `/admin/report_doctors.jsp` - Báo cáo bác sĩ

**5. Charts & Visualization**
- [ ] Tích hợp Chart.js hoặc Google Charts
- [ ] Biểu đồ cột: Lịch hẹn theo tháng
- [ ] Biểu đồ tròn: Phân bố status lịch hẹn
- [ ] Biểu đồ đường: Xu hướng bệnh nhân mới

**6. Export Reports**
- [ ] Export to Excel (Apache POI)
- [ ] Export to PDF (iText hoặc JasperReports)
- [ ] Filter theo ngày, tháng, năm

#### Deliverables:
- 1 Servlet mới (AdminReportServlet)
- 1 DAO mới (StatisticsDAO)
- Update 2 Servlets (AdminHomeServlet, DoctorHomeServlet)
- 5 JSP files
- Chart.js integration
- Export functionality (Excel/PDF)


---

### 🟣 TASK 5: TÍNH NĂNG NÂNG CAO & UX/UI
**Thành viên:** Phạm Hữu Nguyên

#### Mô tả:
Phát triển các tính năng nâng cao: tìm kiếm, filter, email notification, và cải thiện UI/UX.

#### Công việc chi tiết:

**1. Search & Filter**
- [ ] `SearchServlet.java` - Servlet tìm kiếm global
  - Tìm kiếm bệnh nhân (tên, mã BN, SĐT)
  - Tìm kiếm bác sĩ (tên, chuyên khoa)
  - Tìm kiếm lịch hẹn (mã, ngày, bệnh nhân)
- [ ] AJAX search với autocomplete
- [ ] Filter lịch hẹn theo: status, ngày, bác sĩ
- [ ] Filter bệnh án theo: ngày, bác sĩ, chẩn đoán

**2. Email Notification**
- [ ] `EmailService.java` - Service gửi email
  - Gửi email xác nhận lịch hẹn
  - Gửi email nhắc nhở trước 1 ngày
  - Gửi email khi lịch hẹn bị hủy
- [ ] Tích hợp JavaMail API
- [ ] Email templates (HTML)
- [ ] Cấu hình SMTP trong .env

**3. Pagination**
- [ ] `PaginationUtil.java` - Utility class cho phân trang
- [ ] Áp dụng pagination cho:
  - Danh sách users
  - Danh sách bệnh nhân
  - Danh sách lịch hẹn
  - Danh sách bệnh án

**4. UI/UX Improvements**
- [ ] Responsive design cho mobile
- [ ] Loading spinner khi submit form
- [ ] Toast notifications (success/error messages)
- [ ] Confirm dialog trước khi xóa
- [ ] Form validation (client-side với JavaScript)
- [ ] Date picker cho appointment date
- [ ] Time picker cho appointment time

**5. Security Enhancements**
- [ ] `AuthFilter.java` - Filter kiểm tra authentication
- [ ] `RoleFilter.java` - Filter kiểm tra authorization
- [ ] CSRF protection
- [ ] XSS prevention
- [ ] SQL injection prevention (PreparedStatement)
- [ ] Session timeout handling

**6. Error Handling**
- [ ] Custom error pages (404, 403, 500)
- [ ] `/error/404.jsp` - Page not found
- [ ] `/error/403.jsp` - Access denied
- [ ] `/error/500.jsp` - Server error
- [ ] Logging errors to file

#### Deliverables:
- 1 Servlet (SearchServlet)
- 2 Services (EmailService, PaginationUtil)
- 2 Filters (AuthFilter, RoleFilter)
- 3 Error JSP pages
- JavaScript libraries (jQuery, Bootstrap, SweetAlert2)
- Email templates
- Updated CSS for responsive design


---

## 📊 BẢNG TỔNG HỢP CÔNG VIỆC

| Task | Thành viên | Servlets | DAOs | JSPs | Thời gian ước tính |
|------|-----------|----------|------|------|-------------------|
| Task 1 | Hà Cảnh Minh Hoàng | 2 | 2 | 4 | 2-3 ngày |
| Task 2 | Đặng Thái Nguyên | 2 | 2 | 4 | 2-3 ngày |
| Task 3 | Trần Ngọc Thiết | 3 | 2 | 4 | 2-3 ngày |
| Task 4 | Lê Thế Duy | 2 | 1 | 5 | 1-2 ngày |
| Task 5 | Phạm Hữu Nguyên | 1 | 0 | 3 | 1-2 ngày |

---

## 🔗 PHỤ THUỘC GIỮA CÁC TASK

```
Task 1 (Admin - Users/Doctors)
    ↓
Task 2 (Doctor - Medical Records) ← Task 3 (Patient - Appointments)
    ↓
Task 4 (Reports & Statistics)
    ↓
Task 5 (Advanced Features & UI/UX)
```

**Gợi ý thứ tự phát triển:**
1. **Lần 1** Task 1 + Task 3 (song song)
2. **Lần 2:** Task 2 (phụ thuộc Task 1)
3. **Lần 3:** Task 4 (phụ thuộc Task 1, 2, 3)
4. **Lần 4:** Task 5 (tích hợp tất cả)

---

## 📝 QUY TRÌNH LÀM VIỆC

### 1. Setup môi trường
```bash
# Clone project
git clone [repository-url]

# Import database
sqlcmd -S localhost -U sa -P [password] -i SQL/database.sql

# Cấu hình .env
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=JVCare_MVC
DB_USER=sa
DB_PASSWORD=*Mật khẩu*
GROQ_API_KEY=*API Key*

# Build project
mvn clean install

# Run project
mvn tomcat7:run
```

### 2. Git workflow
```bash
# Tạo branch cho task của mình
git checkout -b feature/*Tên*

# Commit thường xuyên
git add .
git commit -m "feat: *Tên chức năng*"

# Push lên remote
git push origin feature/*Tên*

# Tạo Pull Request để review
```

### 3. Naming conventions
- **Servlet:** `[Module][Feature]Servlet.java` (VD: `AdminUserServlet.java`)
- **DAO:** `[Entity]DAO.java` (VD: `DoctorDAO.java`)
- **Model:** `[Entity].java` (VD: `Doctor.java`)
- **JSP:** `[module]/[feature].jsp` (VD: `admin/users.jsp`)
- **URL mapping:** `/[module]/[feature]` (VD: `/admin/users`)


---

## 🎯 TIÊU CHÍ ĐÁNH GIÁ BÁO CÁO CUỐI KỲ

### 1. Chức năng (40%)
- [ ] Hoàn thành đầy đủ các chức năng được giao
- [ ] Không có lỗi runtime
- [ ] Xử lý exception đúng cách
- [ ] Validation đầy đủ

### 2. Code quality (25%)
- [ ] Code sạch, dễ đọc
- [ ] Tuân thủ naming conventions
- [ ] Comment đầy đủ
- [ ] Không duplicate code
- [ ] Sử dụng design pattern phù hợp (MVC, DAO)

### 3. Database (15%)
- [ ] Query tối ưu
- [ ] Sử dụng PreparedStatement
- [ ] Đóng connection đúng cách
- [ ] Transaction handling (nếu cần)

### 4. UI/UX (10%)
- [ ] Giao diện đẹp, thân thiện
- [ ] Responsive design
- [ ] Thông báo lỗi rõ ràng
- [ ] Loading state

### 5. Documentation (10%)
- [ ] README.md cho task của mình
- [ ] Hướng dẫn cài đặt
- [ ] API documentation (nếu có)
- [ ] Test cases

---

## 📚 TÀI LIỆU THAM KHẢO

### Java Servlet & JSP
- [Oracle Servlet Tutorial](https://docs.oracle.com/javaee/7/tutorial/servlets.htm)
- [JSP Tutorial](https://www.javatpoint.com/jsp-tutorial)
- [JSTL Tags](https://www.tutorialspoint.com/jsp/jsp_standard_tag_library.htm)

### Database
- [SQL Server JDBC](https://docs.microsoft.com/en-us/sql/connect/jdbc/)
- [PreparedStatement Best Practices](https://www.baeldung.com/java-prepared-statement)

### Frontend
- [Bootstrap 5](https://getbootstrap.com/docs/5.0/)
- [Chart.js](https://www.chartjs.org/docs/latest/)
- [SweetAlert2](https://sweetalert2.github.io/)
- [FullCalendar](https://fullcalendar.io/docs)

### Libraries
- [Apache POI (Excel)](https://poi.apache.org/)
- [iText (PDF)](https://itextpdf.com/en)
- [JavaMail API](https://javaee.github.io/javamail/)
- [BCrypt](https://github.com/jeremyh/jBCrypt)

---

## 🐛 TROUBLESHOOTING

### Lỗi thường gặp:

**1. Connection refused to SQL Server**
```
Solution: Kiểm tra SQL Server đang chạy, enable TCP/IP trong SQL Server Configuration Manager
```

**2. ClassNotFoundException: com.microsoft.sqlserver.jdbc.SQLServerDriver**
```
Solution: mvn clean install để download dependencies
```

**3. 404 Not Found khi truy cập servlet**
```
Solution: Kiểm tra @WebServlet annotation hoặc web.xml mapping
```

**4. Session null**
```
Solution: Kiểm tra đã login chưa, session timeout
```

**5. JSP không compile**
```
Solution: Clean Tomcat work directory, restart server
```

---

## 📞 LIÊN HỆ & HỖ TRỢ

**Nhóm trưởng:** Hà Cảnh Minh Hoàng - 2415053122219 - hcmhoang13@gmail.com

**Lịch họp nhóm:**
- Thứ 5 21/5/2026 9h00-14h30

**Kênh liên lạc:**

- GitHub: [JVCare](https://github.com/hacanhminhhoang/JVCare)

---

## ✅ CHECKLIST TRƯỚC KHI NỘP BÁI

- [ ] Code chạy được không lỗi
- [ ] Đã test tất cả chức năng
- [ ] Đã commit và push code lên GitHub
- [ ] Đã viết README.md cho task của mình
- [ ] Đã merge code vào branch main (sau khi review)
- [ ] Đã chuẩn bị slide thuyết trình
- [ ] Đã chuẩn bị demo video (nếu cần)

---
