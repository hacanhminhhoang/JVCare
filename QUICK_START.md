# 🚀 QUICK START GUIDE - JVCARE_MVC

## 📋 THÔNG TIN NHANH

**Dự án:** Hệ thống Quản lý Bệnh án Bệnh nhân  
**Công nghệ:** Java Servlet/JSP + SQL Server  
**Số thành viên:** 5 người  
**Thời gian:** 6 tuần

---

## 👥 PHÂN CÔNG NHANH

| Người | Task | Mô tả ngắn |
|-------|------|------------|
| **Hà Cảnh Minh Hoàng** | Admin Module | Quản lý users & doctors (CRUD) |
| **Đặng Thái Nguyên** | Doctor Module | Tạo bệnh án & kê đơn thuốc |
| **Trần Ngọc Thiết** | Patient Module | Đặt lịch & quản lý hồ sơ |
| **Lê Thế Duy** | Reports & Stats | Dashboard, charts, export Excel/PDF |
| **Phạm Hữu Nguyên** | Advanced Features | Search, email, pagination, UI/UX |

---

## ⚡ SETUP NHANH (5 PHÚT)

### 1. Clone project
```bash
git clone [repository-url]
cd JVCare_MVC
```

### 2. Tạo database
```bash
sqlcmd -S localhost -U sa -P YourPassword -i SQL/database.sql
sqlcmd -S localhost -U sa -P YourPassword -i SQL/test_data.sql
```

### 3. Tạo file .env
```properties
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=JVCare_MVC;encrypt=false
DB_USER=sa
DB_PASSWORD=*Mật khẩu*
GROQ_API_KEY=*API Key*
```

### 4. Build & Run
```bash
mvn clean install
mvn tomcat7:run
```

### 5. Truy cập
```
URL: http://localhost:8080/JVCare_MVC
Login: admin@jvcare.com/123456 hoặc doctor@jvcare.com/123456 hoặc patient@jvcare.com/123456
```

---

## 📂 TÀI LIỆU QUAN TRỌNG

1. **TASK_DISTRIBUTION.md** - Chi tiết từng task
2. **PROGRESS_CHECKLIST.md** - Theo dõi tiến độ
3. **TASK_X_GUIDE.md** - Hướng dẫn cụ thể cho từng task
4. **README.md** - Tổng quan dự án

---

## 🎯 NHIỆM VỤ CỦA TỪNG THÀNH VIÊN

### 📍 Hà Cảnh Minh Hoàng (Admin):
**Đọc:** `TASK_1_ADMIN_GUIDE.md`  
**Làm:**
1. Tạo `DoctorDAO.java` và `Doctor.java`
2. Cập nhật `UserDAO.java` với CRUD methods
3. Tạo `AdminUserServlet.java` và `AdminDoctorServlet.java`
4. Tạo 4 JSP files: users.jsp, user_form.jsp, doctors.jsp, doctor_form.jsp

**Deliverables:** 2 Servlets + 2 DAOs + 4 JSPs

---

### 📍 Đặng Thái Nguyên (Doctor):
**Đọc:** `TASK_DISTRIBUTION.md` (Task 2)  
**Làm:**
1. Cập nhật `MedicalRecordDAO.java` và `PrescriptionDAO.java`
2. Tạo `DoctorMedicalRecordServlet.java`
3. Tạo `DoctorPrescriptionServlet.java`
4. Tạo 4 JSP files cho medical records & prescriptions
5. Tích hợp workflow: Complete appointment → Create record

**Deliverables:** 2 Servlets + 2 DAOs + 4 JSPs + Print template

---

### 📍 Trần Ngọc Thiết (Patient):
**Đọc:** `TASK_DISTRIBUTION.md` (Task 3)  
**Làm:**
1. Tạo `PatientBookAppointmentServlet.java`
2. Tạo `PatientProfileServlet.java`
3. Tạo `PatientMedicalHistoryServlet.java`
4. Cập nhật `AppointmentDAO.java` và `PatientDAO.java`
5. Tạo 4 JSP files + tích hợp FullCalendar

**Deliverables:** 3 Servlets + 2 DAOs + 4 JSPs + Calendar

---

### 📍 Lê Thế Duy (Reports):
**Đọc:** `TASK_DISTRIBUTION.md` (Task 4)  
**Làm:**
1. Tạo `StatisticsDAO.java` với các query thống kê
2. Tạo `AdminReportServlet.java`
3. Cập nhật `AdminHomeServlet.java` và `DoctorHomeServlet.java`
4. Tích hợp Chart.js cho biểu đồ
5. Implement export Excel/PDF

**Deliverables:** 2 Servlets + 1 DAO + 5 JSPs + Charts + Export

---

### 📍 Phạm Hữu Nguyên (Advanced):
**Đọc:** `TASK_DISTRIBUTION.md` (Task 5)  
**Làm:**
1. Tạo `SearchServlet.java` với AJAX
2. Tạo `EmailService.java` với JavaMail
3. Tạo `PaginationUtil.java`
4. Tạo `AuthFilter.java` và `RoleFilter.java`
5. Cải thiện UI/UX (responsive, loading, toast)
6. Tạo error pages (404, 403, 500)

**Deliverables:** 1 Servlet + 2 Services + 2 Filters + 3 JSPs + UI improvements

---

## 🔧 CÔNG CỤ CẦN CÀI

- ✅ JDK 11+
- ✅ Maven 3.6+
- ✅ SQL Server 2019+
- ✅ Git
- ✅ IDE (IntelliJ IDEA / Eclipse / VS Code)
- ✅ Postman (test API - optional)

---

## 📞 KHI GẶP VẤN ĐỀ

1. **Đọc TROUBLESHOOTING** trong README.md
2. **Hỏi trong group chat** Zalo/Discord
3. **Tạo issue** trên GitHub
4. **Liên hệ nhóm trưởng:** hcmhoang13@gmail.com

---

## ✅ CHECKLIST HÀNG NGÀY

- [ ] Pull code mới nhất từ main
- [ ] Code ít nhất 2-3 tiếng
- [ ] Commit code (ít nhất 1 commit/ngày)
- [ ] Update PROGRESS_CHECKLIST.md
- [ ] Test chức năng vừa làm
- [ ] Push code lên GitHub

---

## 🎓 TIPS QUAN TRỌNG

1. **Đọc code hiện có** trước khi bắt đầu
2. **Copy pattern** từ code đã có (VD: LoginServlet, PatientHomeServlet)
3. **Test thường xuyên** - đừng code quá nhiều rồi mới test
4. **Commit nhỏ** - mỗi feature một commit
5. **Hỏi sớm** - đừng mắc kẹt quá 30 phút
6. **Review code** của nhau trước khi merge

---

## 📅 DEADLINE QUAN TRỌNG

- **Lần 2:** Task 1 & 3 hoàn thành
- **Lần 3:** Task 2 hoàn thành
- **Lần 4:** Task 4 hoàn thành
- **Lần 5:** Task 5 hoàn thành + Integration
- **Lần 6:** Documentation + Presentation

---

## 🚀 BẮT ĐẦU NGAY!

1. Đọc file `TASK_DISTRIBUTION.md` để hiểu tổng quan
2. Đọc hướng dẫn chi tiết cho task của bạn
3. Setup môi trường theo hướng dẫn trên
4. Tạo branch: `git checkout -b feature/*Tên*`
5. Bắt đầu code!

---

## 📚 TÀI LIỆU THAM KHẢO NHANH

- [Servlet Tutorial](https://www.javatpoint.com/servlet-tutorial)
- [JSP Tutorial](https://www.tutorialspoint.com/jsp/)
- [Bootstrap 5](https://getbootstrap.com/docs/5.0/)
- [Chart.js](https://www.chartjs.org/)
- [SQL Server](https://docs.microsoft.com/en-us/sql/)