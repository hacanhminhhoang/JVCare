# 📊 BẢNG THEO DÕI TIẾN ĐỘ DỰ ÁN JVCARE_MVC

**Ngày bắt đầu:** 20/05/2026  
**Deadline:** 28/05/2026
**Cập nhật lần cuối:** 20/05/2026

---

## 🔴 TASK 1: ADMIN - QUẢN LÝ NGƯỜI DÙNG & BÁC SĨ
**Thành viên:** Hà Cảnh Minh Hoàng
**Tiến độ:** 100% 🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩

### Backend
- [x] Tạo `Doctor.java` model
- [x] Tạo `DoctorDAO.java` với CRUD methods
- [x] Cập nhật `UserDAO.java` với methods mới
  - [x] `getAllUsers(page, pageSize)`
  - [x] `getTotalUsers()`
  - [x] `searchUsers(keyword)`
  - [x] `createUser(user)`
  - [x] `updateUser(user)`
  - [x] `deleteUser(userId)`
- [x] Tạo `AdminUserServlet.java`
  - [x] GET: List users
  - [x] GET: Show edit form
  - [x] POST: Create user
  - [x] POST: Update user
  - [x] GET: Delete user
- [x] Tạo `AdminDoctorServlet.java`
  - [x] GET: List doctors
  - [x] GET: Show edit form
  - [x] POST: Create doctor
  - [x] POST: Update doctor
  - [x] GET: Delete doctor

### Frontend
- [x] Tạo `/admin/users.jsp`
- [x] Tạo `/admin/user_form.jsp`
- [x] Tạo `/admin/doctors.jsp`
- [x] Tạo `/admin/doctor_form.jsp`

### Testing
- [x] Test thêm user mới
- [x] Test sửa user
- [x] Test xóa user (soft delete)
- [x] Test tìm kiếm user
- [x] Test phân trang
- [x] Test validation (duplicate username/email)
- [x] Test thêm/sửa/xóa doctor

### Documentation
- [x] Viết README cho task
- [x] Comment code đầy đủ
- [x] Tạo test data SQL

---

## 🟢 TASK 2: DOCTOR - QUẢN LÝ BỆNH ÁN & ĐƠN THUỐC
**Thành viên:** Đặng Thái Nguyên
**Tiến độ:** 100% 🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩

### Backend
- [x] Cập nhật `MedicalRecordDAO.java`
  - [x] `getRecordById(recordId)`
  - [x] `updateRecord(record)`
  - [x] `getRecordsByDoctorId(doctorId)`
  - [x] `getRecordWithPrescriptions(recordId)`
- [x] Cập nhật `PrescriptionDAO.java`
  - [x] `createPrescription(prescription)`
  - [x] `updatePrescription(prescription)`
  - [x] `deletePrescription(prescriptionId)`
  - [x] `getPrescriptionsByRecordId(recordId)`
- [x] Tạo `DoctorMedicalRecordServlet.java`
  - [x] GET: List medical records
  - [x] GET: Show record detail
  - [x] POST: Create record
  - [x] POST: Update record
- [x] Tạo `DoctorPrescriptionServlet.java`
  - [x] POST: Add medication
  - [x] POST: Update medication
  - [x] GET: Delete medication

### Frontend
- [x] Tạo `/doctor/medical_records.jsp`
- [x] Tạo `/doctor/medical_record_form.jsp`
- [x] Tạo `/doctor/medical_record_detail.jsp`
- [x] Tạo `/doctor/prescription_form.jsp` (Tích hợp inline qua beautiful overlay modal)
- [x] Tạo print prescription template (Tích hợp chức năng in đơn thuốc trực tiếp)

### Integration
- [x] Tích hợp với `DoctorAppointmentDetailServlet`
- [x] Link appointment → medical record
- [x] Workflow: Complete appointment → Create record

### Testing
- [x] Test tạo bệnh án
- [x] Test cập nhật bệnh án
- [x] Test thêm thuốc vào đơn
- [x] Test sửa/xóa thuốc
- [x] Test in đơn thuốc
- [x] Test validation liều lượng

### Documentation
- [x] Viết README cho task (Xem TASK_2_DOCTOR_GUIDE.md & walkthrough.md)
- [x] Comment code đầy đủ
- [x] Hướng dẫn workflow

---

## 🔵 TASK 3: PATIENT - ĐẶT LỊCH & QUẢN LÝ HỒ SƠ
**Thành viên:** Lê Thế Duy
**Tiến độ:** 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

### Backend
- [ ] Tạo `PatientBookAppointmentServlet.java`
  - [ ] GET: Show booking form
  - [ ] POST: Create appointment
  - [ ] POST: Update appointment
  - [ ] GET: Cancel appointment
- [ ] Tạo `PatientProfileServlet.java`
  - [ ] GET: Show profile
  - [ ] POST: Update profile
  - [ ] POST: Upload avatar
- [ ] Tạo `PatientMedicalHistoryServlet.java`
  - [ ] GET: List medical history
  - [ ] GET: Show record detail
- [ ] Cập nhật `AppointmentDAO.java`
  - [ ] `getAvailableTimeSlots(date, doctorId)`
  - [ ] `checkDuplicateAppointment()`
  - [ ] `cancelAppointment(appointmentId)`
- [ ] Cập nhật `PatientDAO.java`
  - [ ] `getPatientByUserId(userId)`
  - [ ] `updatePatientProfile(patient)`

### Frontend
- [ ] Tạo `/patient/book_appointment.jsp`
- [ ] Tạo `/patient/profile.jsp`
- [ ] Tạo `/patient/medical_history.jsp`
- [ ] Tạo `/patient/medical_history_detail.jsp`
- [ ] Tích hợp FullCalendar.js

### Features
- [ ] Calendar view cho lịch hẹn
- [ ] Upload avatar functionality
- [ ] Notification khi lịch được xác nhận
- [ ] Filter lịch sử theo ngày, bác sĩ

### Testing
- [ ] Test đặt lịch mới
- [ ] Test cập nhật lịch hẹn
- [ ] Test hủy lịch hẹn
- [ ] Test cập nhật profile
- [ ] Test upload avatar
- [ ] Test xem lịch sử khám
- [ ] Test filter

### Documentation
- [ ] Viết README cho task
- [ ] Comment code đầy đủ
- [ ] Hướng dẫn sử dụng calendar



---

## 🟡 TASK 4: BÁO CÁO & THỐNG KÊ (DASHBOARD)
**Thành viên:** Hà Cảnh Minh Hoàng 
**Tiến độ:** 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

### Backend
- [ ] Tạo `StatisticsDAO.java`
  - [ ] `getTotalUsers()`
  - [ ] `getTotalAppointments()`
  - [ ] `getAppointmentsByStatus()`
  - [ ] `getAppointmentsByMonth(year)`
  - [ ] `getDoctorPerformance(doctorId)`
  - [ ] `getPatientStatistics()`
- [ ] Tạo `AdminReportServlet.java`
  - [ ] GET `/appointments`: Báo cáo lịch hẹn
  - [ ] GET `/patients`: Báo cáo bệnh nhân
  - [ ] GET `/doctors`: Báo cáo bác sĩ
  - [ ] GET `/export`: Export Excel/PDF
- [ ] Cập nhật `AdminHomeServlet.java`
  - [ ] Thêm statistics vào dashboard
- [ ] Cập nhật `DoctorHomeServlet.java`
  - [ ] Thêm statistics cho doctor

### Frontend
- [ ] Cập nhật `/admin/index.jsp` với charts
- [ ] Cập nhật `/doctor/index.jsp` với statistics
- [ ] Tạo `/admin/reports.jsp`
- [ ] Tạo `/admin/report_appointments.jsp`
- [ ] Tạo `/admin/report_doctors.jsp`

### Charts & Visualization
- [ ] Tích hợp Chart.js
- [ ] Biểu đồ cột: Lịch hẹn theo tháng
- [ ] Biểu đồ tròn: Phân bố status
- [ ] Biểu đồ đường: Xu hướng bệnh nhân mới
- [ ] Responsive charts

### Export Functionality
- [ ] Export to Excel (Apache POI)
  - [ ] Export danh sách users
  - [ ] Export danh sách appointments
  - [ ] Export báo cáo bác sĩ
- [ ] Export to PDF (iText)
  - [ ] PDF report template
  - [ ] Header/Footer
  - [ ] Charts in PDF

### Testing
- [ ] Test dashboard statistics
- [ ] Test charts rendering
- [ ] Test export Excel
- [ ] Test export PDF
- [ ] Test filter theo ngày/tháng/năm
- [ ] Test responsive design

### Documentation
- [ ] Viết README cho task
- [ ] Comment code đầy đủ
- [ ] Hướng dẫn sử dụng charts
- [ ] Hướng dẫn export

---

## 🟣 TASK 5: TÍNH NĂNG NÂNG CAO & UX/UI
**Thành viên:** Phạm Hữu Nguyên 
**Tiến độ:** 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

### Search & Filter
- [ ] Tạo `SearchServlet.java`
  - [ ] Search patients
  - [ ] Search doctors
  - [ ] Search appointments
- [ ] AJAX autocomplete search
- [ ] Filter appointments (status, date, doctor)
- [ ] Filter medical records (date, doctor, diagnosis)

### Email Notification
- [ ] Tạo `EmailService.java`
  - [ ] Send appointment confirmation
  - [ ] Send reminder (1 day before)
  - [ ] Send cancellation notice
- [ ] Tích hợp JavaMail API
- [ ] Tạo HTML email templates
- [ ] Cấu hình SMTP trong .env

### Pagination
- [ ] Tạo `PaginationUtil.java`
- [ ] Áp dụng pagination cho:
  - [ ] Danh sách users
  - [ ] Danh sách patients
  - [ ] Danh sách appointments
  - [ ] Danh sách medical records

### UI/UX Improvements
- [ ] Responsive design cho mobile
- [ ] Loading spinner
- [ ] Toast notifications (SweetAlert2)
- [ ] Confirm dialog trước khi xóa
- [ ] Form validation (client-side)
- [ ] Date picker
- [ ] Time picker
- [ ] Smooth animations

### Security Enhancements
- [ ] Tạo `AuthFilter.java`
- [ ] Tạo `RoleFilter.java`
- [ ] CSRF protection
- [ ] XSS prevention
- [ ] SQL injection prevention
- [ ] Session timeout handling

### Error Handling
- [ ] Tạo `/error/404.jsp`
- [ ] Tạo `/error/403.jsp`
- [ ] Tạo `/error/500.jsp`
- [ ] Logging errors to file
- [ ] User-friendly error messages

### Testing
- [ ] Test search functionality
- [ ] Test email sending
- [ ] Test pagination
- [ ] Test responsive design
- [ ] Test security filters
- [ ] Test error pages
- [ ] Test form validation

### Documentation
- [ ] Viết README cho task
- [ ] Comment code đầy đủ
- [ ] Security best practices document
- [ ] UI/UX guidelines

---

## 📈 TỔNG QUAN TIẾN ĐỘ

| Task | Thành viên | Tiến độ | Status |
|------|-----------|---------|--------|
| Task 1 | Hà Cảnh Minh Hoàng | 100% | 🟢 Completed |
| Task 2 | Đặng Thái Nguyên | 1% | 🟡 In Progress |
| Task 3 | Lê Thế Duy | 1% | 🟡 In Progress |
| Task 4 | Hà Cảnh Minh Hoàng | 1% | 🟡 In Progress |
| Task 5 | Phạm Hữu Nguyên | 1% | 🟡 In Progress |

**Tổng tiến độ dự án:** 20% 🟩🟩⬜⬜⬜⬜⬜⬜⬜⬜

### Status Legend:
- 🔴 Not Started (0%)
- 🟡 In Progress (1-99%)
- 🟢 Completed (100%)
- 🔵 Testing
- ⚪ Blocked

---

## 📅 LỊCH TRÌNH DỰ KIẾN

### Lần 1 (20/05 - 22/05)
- [ ] Task 1: Setup & Backend (50%)
- [ ] Task 3: Setup & Backend (50%)
- [ ] Họp nhóm: Review tiến độ

### Lần 2 (22/05 - 23/05)
- [ ] Task 1: Frontend & Testing (100%)
- [ ] Task 2: Backend (50%)
- [ ] Task 3: Frontend & Testing (100%)
- [ ] Họp nhóm: Review & merge code

### Lần 3 (23/05 - 24/05)
- [ ] Task 2: Frontend & Testing (100%)
- [ ] Task 4: Backend & Charts (50%)
- [ ] Họp nhóm: Integration testing

### Lần 4 (24/05 - 25/05)
- [ ] Task 4: Export & Testing (100%)
- [ ] Task 5: Search & Email (50%)
- [ ] Họp nhóm: Review tiến độ

### Lần 5 (25/05 - 26/05)
- [ ] Task 5: UI/UX & Security (100%)
- [ ] Integration testing toàn bộ hệ thống
- [ ] Bug fixing
- [ ] Họp nhóm: Final review

### Lần 6 (27/05 - 28/05)
- [ ] Hoàn thiện documentation
- [ ] Chuẩn bị slide thuyết trình
- [ ] Rehearsal presentation
### FINAL (29/05)
- [ ] **NỘP BÀI CUỐI KỲ**

---

## 🐛 BUG TRACKING

### Critical Bugs
*Chưa có bug nào được báo cáo*

### Major Bugs
*Chưa có bug nào được báo cáo*

### Minor Bugs
*Chưa có bug nào được báo cáo*

---

## 📝 MEETING NOTES

### Meeting #1 - [Ngày 20/05]
**Tham dự:** 5/5
**Nội dung:**
- Phân chia task
- Setup môi trường
- Thống nhất coding conventions

---

## 💡 IDEAS & IMPROVEMENTS

### Tính năng bổ sung (nếu có thời gian):
- [ ] Multi-language support (i18n)
- [ ] Dark mode
- [ ] Mobile app (React Native)
- [ ] Video call với bác sĩ
- [ ] Payment integration
- [ ] SMS notification
- [ ] QR code check-in
- [ ] Appointment reminder via Zalo

---

## 🎯 DEFINITION OF DONE

Một task được coi là hoàn thành khi:
- ✅ Code chạy được không lỗi
- ✅ Đã test tất cả chức năng
- ✅ Code đã được review
- ✅ Comment đầy đủ
- ✅ Documentation hoàn chỉnh
- ✅ Đã commit và push lên GitHub
- ✅ Đã merge vào branch main

---

**Checklist này sẽ được cập nhật thường xuyên để có thể theo dõi tiến độ!**
