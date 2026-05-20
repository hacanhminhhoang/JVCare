# 📊 BẢNG THEO DÕI TIẾN ĐỘ DỰ ÁN JVCARE_MVC

**Ngày bắt đầu:** 20/05/2026  
**Deadline:** [Điền deadline]  
**Cập nhật lần cuối:** 20/05/2026

---

## 🔴 TASK 1: ADMIN - QUẢN LÝ NGƯỜI DÙNG & BÁC SĨ
**Thành viên:** [Tên thành viên 1]  
**Tiến độ:** 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

### Backend
- [ ] Tạo `Doctor.java` model
- [ ] Tạo `DoctorDAO.java` với CRUD methods
- [ ] Cập nhật `UserDAO.java` với methods mới
  - [ ] `getAllUsers(page, pageSize)`
  - [ ] `getTotalUsers()`
  - [ ] `searchUsers(keyword)`
  - [ ] `createUser(user)`
  - [ ] `updateUser(user)`
  - [ ] `deleteUser(userId)`
- [ ] Tạo `AdminUserServlet.java`
  - [ ] GET: List users
  - [ ] GET: Show edit form
  - [ ] POST: Create user
  - [ ] POST: Update user
  - [ ] GET: Delete user
- [ ] Tạo `AdminDoctorServlet.java`
  - [ ] GET: List doctors
  - [ ] GET: Show edit form
  - [ ] POST: Create doctor
  - [ ] POST: Update doctor
  - [ ] GET: Delete doctor

### Frontend
- [ ] Tạo `/admin/users.jsp`
- [ ] Tạo `/admin/user_form.jsp`
- [ ] Tạo `/admin/doctors.jsp`
- [ ] Tạo `/admin/doctor_form.jsp`

### Testing
- [ ] Test thêm user mới
- [ ] Test sửa user
- [ ] Test xóa user (soft delete)
- [ ] Test tìm kiếm user
- [ ] Test phân trang
- [ ] Test validation (duplicate username/email)
- [ ] Test thêm/sửa/xóa doctor

### Documentation
- [ ] Viết README cho task
- [ ] Comment code đầy đủ
- [ ] Tạo test data SQL

---

## 🟢 TASK 2: DOCTOR - QUẢN LÝ BỆNH ÁN & ĐƠN THUỐC
**Thành viên:** [Tên thành viên 2]  
**Tiến độ:** 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

### Backend
- [ ] Cập nhật `MedicalRecordDAO.java`
  - [ ] `getRecordById(recordId)`
  - [ ] `updateRecord(record)`
  - [ ] `getRecordsByDoctorId(doctorId)`
  - [ ] `getRecordWithPrescriptions(recordId)`
- [ ] Cập nhật `PrescriptionDAO.java`
  - [ ] `createPrescription(prescription)`
  - [ ] `updatePrescription(prescription)`
  - [ ] `deletePrescription(prescriptionId)`
  - [ ] `getPrescriptionsByRecordId(recordId)`
- [ ] Tạo `DoctorMedicalRecordServlet.java`
  - [ ] GET: List medical records
  - [ ] GET: Show record detail
  - [ ] POST: Create record
  - [ ] POST: Update record
- [ ] Tạo `DoctorPrescriptionServlet.java`
  - [ ] POST: Add medication
  - [ ] POST: Update medication
  - [ ] GET: Delete medication

### Frontend
- [ ] Tạo `/doctor/medical_records.jsp`
- [ ] Tạo `/doctor/medical_record_form.jsp`
- [ ] Tạo `/doctor/medical_record_detail.jsp`
- [ ] Tạo `/doctor/prescription_form.jsp`
- [ ] Tạo print prescription template

### Integration
- [ ] Tích hợp với `DoctorAppointmentDetailServlet`
- [ ] Link appointment → medical record
- [ ] Workflow: Complete appointment → Create record

### Testing
- [ ] Test tạo bệnh án
- [ ] Test cập nhật bệnh án
- [ ] Test thêm thuốc vào đơn
- [ ] Test sửa/xóa thuốc
- [ ] Test in đơn thuốc
- [ ] Test validation liều lượng

### Documentation
- [ ] Viết README cho task
- [ ] Comment code đầy đủ
- [ ] Hướng dẫn workflow

---

## 🔵 TASK 3: PATIENT - ĐẶT LỊCH & QUẢN LÝ HỒ SƠ
**Thành viên:** [Tên thành viên 3]  
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
**Thành viên:** [Tên thành viên 4]  
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
**Thành viên:** [Tên thành viên 5]  
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
| Task 1 | [TÊN 1] | 0% | 🔴 Not Started |
| Task 2 | [TÊN 2] | 0% | 🔴 Not Started |
| Task 3 | [TÊN 3] | 0% | 🔴 Not Started |
| Task 4 | [TÊN 4] | 0% | 🔴 Not Started |
| Task 5 | [TÊN 5] | 0% | 🔴 Not Started |

**Tổng tiến độ dự án:** 0% ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜

### Status Legend:
- 🔴 Not Started (0%)
- 🟡 In Progress (1-99%)
- 🟢 Completed (100%)
- 🔵 Testing
- ⚪ Blocked

---

## 📅 LỊCH TRÌNH DỰ KIẾN

### Tuần 1 (20/05 - 26/05)
- [ ] Task 1: Setup & Backend (50%)
- [ ] Task 3: Setup & Backend (50%)
- [ ] Họp nhóm: Review tiến độ

### Tuần 2 (27/05 - 02/06)
- [ ] Task 1: Frontend & Testing (100%)
- [ ] Task 2: Backend (50%)
- [ ] Task 3: Frontend & Testing (100%)
- [ ] Họp nhóm: Review & merge code

### Tuần 3 (03/06 - 09/06)
- [ ] Task 2: Frontend & Testing (100%)
- [ ] Task 4: Backend & Charts (50%)
- [ ] Họp nhóm: Integration testing

### Tuần 4 (10/06 - 16/06)
- [ ] Task 4: Export & Testing (100%)
- [ ] Task 5: Search & Email (50%)
- [ ] Họp nhóm: Review tiến độ

### Tuần 5 (17/06 - 23/06)
- [ ] Task 5: UI/UX & Security (100%)
- [ ] Integration testing toàn bộ hệ thống
- [ ] Bug fixing
- [ ] Họp nhóm: Final review

### Tuần 6 (24/06 - 30/06)
- [ ] Hoàn thiện documentation
- [ ] Chuẩn bị slide thuyết trình
- [ ] Quay video demo
- [ ] Rehearsal presentation
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

### Meeting #1 - [Ngày]
**Tham dự:** [Danh sách]  
**Nội dung:**
- Phân chia task
- Setup môi trường
- Thống nhất coding conventions

**Action items:**
- [ ] [Action 1]
- [ ] [Action 2]

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

**Cập nhật checklist này thường xuyên để theo dõi tiến độ!**

