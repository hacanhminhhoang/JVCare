# 🏥 JVCARE_MVC - HỆ THỐNG QUẢN LÝ BỆNH ÁN BỆNH NHÂN

## 📖 GIỚI THIỆU

JVCare_MVC là hệ thống quản lý bệnh án điện tử được phát triển bằng Java Servlet/JSP theo mô hình MVC. Hệ thống hỗ trợ quản lý thông tin bệnh nhân, lịch hẹn khám bệnh, bệnh án và đơn thuốc.

**Công nghệ sử dụng:**
- Java 11
- Servlet 4.0 & JSP 2.3
- SQL Server 2019
- Maven
- Bootstrap 5
- Chart.js
- Groq AI (Chatbot)

---

## 👥 THÀNH VIÊN NHÓM

| STT | Họ tên | MSSV | Nhiệm vụ | Email |
|-----|--------|------|----------|-------|
| 1 | [Hà Cảnh Minh Hoàng] | [2415053122219] | Admin - Quản lý Users & Doctors | [hcmhoang13@gmail.com] |
| 2 | [Đặng Thái Nguyên] | [2415053122224] | Doctor - Bệnh án & Đơn thuốc | [Catraconnguyen76@gmail.com] |
| 3 | [Trần Ngọc Thiết] | [22115141122121] | Patient - Đặt lịch & Hồ sơ | [tranngocthiet44@gmail.com] |
| 4 | [Lê Thế Duy] | [2415053122208] | Báo cáo & Thống kê | [letheduy1209@gmail.com] |
| 5 | [Phạm Hữu Nguyên] | [23115053122327] | Tính năng nâng cao & UI/UX | [phamhuunguyen000@gmail.com] |

---

## 🎯 CHỨC NĂNG CHÍNH

### 🔴 Module Admin
- ✅ Quản lý users (CRUD)
- ✅ Quản lý bác sĩ (CRUD)
- ✅ Quản lý bệnh nhân
- ✅ Dashboard thống kê
- ✅ Báo cáo hệ thống

### 🟢 Module Doctor
- ✅ Xem danh sách lịch hẹn
- ✅ Nhận lịch hẹn (assign)
- ✅ Hoàn thành lịch hẹn
- ✅ Tạo và quản lý bệnh án
- ✅ Kê đơn thuốc
- ✅ Xem thông tin bệnh nhân

### 🔵 Module Patient
- ✅ Đặt lịch khám bệnh
- ✅ Xem lịch hẹn của mình
- ✅ Quản lý hồ sơ cá nhân
- ✅ Xem lịch sử khám bệnh
- ✅ Xem đơn thuốc
- ✅ Chat với AI (tư vấn sức khỏe)

---

## 🗂️ CẤU TRÚC DỰ ÁN

```
JVCare_MVC/
├── SQL/
│   ├── database.sql          # Database schema
│   └── test_data.sql         # Dữ liệu test
├── src/main/
│   ├── java/com/jvcare/
│   │   ├── controller/       # Servlets
│   │   ├── dao/              # Data Access Objects
│   │   ├── model/            # Entity classes
│   │   └── util/             # Utilities (DB, AI)
│   └── webapp/
│       ├── WEB-INF/views/    # JSP files
│       ├── css/              # Stylesheets
│       ├── js/               # JavaScript
│       └── images/           # Images
├── pom.xml                   # Maven configuration
├── .env                      # Environment variables
├── TASK_DISTRIBUTION.md      # Phân chia task
└── README.md                 # File này
```

---

## 🚀 HƯỚNG DẪN CÀI ĐẶT

### 1. Yêu cầu hệ thống
- JDK 11 trở lên
- Apache Maven 3.6+
- SQL Server 2019 trở lên
- Apache Tomcat 9.0+ (hoặc dùng maven plugin)

### 2. Clone project
```bash
git clone [repository-url]
cd JVCare_MVC
```

### 3. Cấu hình database
```bash
# Tạo database
sqlcmd -S localhost -U sa -P YourPassword -i SQL/database.sql

# Import test data (optional)
sqlcmd -S localhost -U sa -P YourPassword -i SQL/test_data.sql
```

### 4. Cấu hình .env
Tạo file `.env` trong thư mục root:
```properties
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=JVCare_MVC;encrypt=false
DB_USER=sa
DB_PASSWORD=*Mật khẩu*
GROQ_API_KEY=*API Key*
```

### 5. Build và chạy project
```bash
# Build project
mvn clean install

# Chạy với Tomcat Maven Plugin
mvn tomcat7:run

# Hoặc deploy file WAR vào Tomcat
# File WAR sẽ ở: target/JVCare_MVC.war
```

### 6. Truy cập ứng dụng
```
URL: http://localhost:8080/JVCare_MVC
```

**Tài khoản test:**
- Admin: `admin@jvcare.com` / `123456`
- Doctor: `doctor@jvcare.com` / `123456`
- Patient: `patient@jvcare.com` / `123456`

---

## 📊 DATABASE SCHEMA

### Các bảng chính:
1. **users** - Thông tin đăng nhập
2. **doctors** - Thông tin bác sĩ
3. **patients** - Thông tin bệnh nhân
4. **appointments** - Lịch hẹn khám
5. **medical_records** - Bệnh án
6. **prescriptions** - Đơn thuốc

### Mối quan hệ:
```
users (1) -----> (1) doctors
users (1) -----> (1) patients
patients (1) --> (n) appointments
doctors (1) ---> (n) appointments
appointments (1) -> (1) medical_records
medical_records (1) -> (n) prescriptions
```

---

## 🔧 CÔNG NGHỆ & DEPENDENCIES

### Backend
- **javax.servlet-api** 4.0.1 - Servlet API
- **javax.servlet.jsp-api** 2.3.3 - JSP API
- **jstl** 1.2 - JSP Standard Tag Library
- **mssql-jdbc** 12.4.2 - SQL Server JDBC Driver
- **gson** 2.8.9 - JSON processing
- **jbcrypt** 0.4 - Password hashing
- **dotenv-java** 3.0.0 - Environment variables

### Frontend
- **Bootstrap 5** - UI Framework
- **Chart.js** - Biểu đồ thống kê
- **SweetAlert2** - Alert đẹp
- **jQuery** - DOM manipulation



---

## 📝 QUY TRÌNH PHÁT TRIỂN

### Git Workflow
```bash
# 1. Tạo branch cho task của mình
git checkout -b feature/*Tên*

# 2. Code và commit thường xuyên
git add .
git commit -m "Tính năng: *Tên tính năng*"

# 3. Push lên remote
git push origin feature/*Tên*

# 4. Tạo Pull Request để review
# 5. Sau khi được approve, merge vào main
```

### Commit Message Convention
```
feat: Thêm tính năng mới
fix: Sửa lỗi
docs: Cập nhật documentation
style: Format code, không thay đổi logic
refactor: Refactor code
test: Thêm test cases
chore: Cập nhật dependencies, config
```

### Code Review Checklist
- [ ] Code chạy được không lỗi
- [ ] Tuân thủ naming conventions
- [ ] Có comment đầy đủ
- [ ] Không có code duplicate
- [ ] Đã test các trường hợp edge case
- [ ] UI/UX thân thiện

---

## 🧪 TESTING

### Manual Testing
Mỗi thành viên cần test các chức năng của mình:

**Admin:**
- [ ] Thêm/sửa/xóa user
- [ ] Thêm/sửa/xóa doctor
- [ ] Tìm kiếm user
- [ ] Phân trang hoạt động

**Doctor:**
- [ ] Xem danh sách lịch hẹn
- [ ] Nhận lịch hẹn
- [ ] Tạo bệnh án
- [ ] Kê đơn thuốc
- [ ] In đơn thuốc

**Patient:**
- [ ] Đặt lịch khám
- [ ] Hủy lịch hẹn
- [ ] Cập nhật profile
- [ ] Upload avatar
- [ ] Xem lịch sử khám

**Statistics:**
- [ ] Dashboard hiển thị đúng số liệu
- [ ] Biểu đồ render đúng
- [ ] Export Excel/PDF
- [ ] Filter theo ngày

**Advanced Features:**
- [ ] Search hoạt động
- [ ] Email notification gửi được
- [ ] Pagination hoạt động
- [ ] Error pages hiển thị đúng

---

## 🐛 TROUBLESHOOTING

### Lỗi thường gặp:

**1. Cannot connect to SQL Server**
```
Giải pháp:
- Kiểm tra SQL Server đang chạy
- Enable TCP/IP trong SQL Server Configuration Manager
- Kiểm tra firewall
- Kiểm tra connection string trong .env
```

**2. 404 Not Found**
```
Giải pháp:
- Kiểm tra @WebServlet annotation
- Kiểm tra URL mapping
- Restart Tomcat server
```

**3. Session timeout**
```
Giải pháp:
- Tăng session timeout trong web.xml
- Kiểm tra filter authentication
```

**4. JSP compilation error**
```
Giải pháp:
- Clean Tomcat work directory
- Kiểm tra JSTL taglib declaration
- Restart server
```

**5. Maven dependency error**
```
Giải pháp:
- mvn clean install -U
- Xóa folder .m2/repository và build lại
```

---

## 📚 TÀI LIỆU THAM KHẢO

### Official Documentation
- [Java Servlet Specification](https://jakarta.ee/specifications/servlet/)
- [JSP Specification](https://jakarta.ee/specifications/pages/)
- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/sql-server/)
- [Maven Documentation](https://maven.apache.org/guides/)

### Tutorials
- [Servlet Tutorial - JavaTpoint](https://www.javatpoint.com/servlet-tutorial)
- [JSP Tutorial - TutorialsPoint](https://www.tutorialspoint.com/jsp/)
- [MVC Pattern in Java](https://www.baeldung.com/mvc-servlet-jsp)
- [JDBC Best Practices](https://www.baeldung.com/java-jdbc)

### Libraries
- [Bootstrap 5 Docs](https://getbootstrap.com/docs/5.0/)
- [Chart.js Docs](https://www.chartjs.org/docs/latest/)
- [SweetAlert2 Docs](https://sweetalert2.github.io/)
- [BCrypt Java](https://github.com/jeremyh/jBCrypt)

---

## 📞 LIÊN HỆ & HỖ TRỢ

**Nhóm trưởng:** [Hà Cảnh Minh Hoàng] - [2415053122219] - [hcmhoang13@gmail.com]

**Lịch họp nhóm:**
- Thứ 5 21/5/2026 9h00-14h30

**Kênh liên lạc:**
- GitHub: [[Repository URL](https://github.com/hacanhminhhoang/JVCare)]

---

## 📄 LICENSE

This project is developed for educational purposes.  
© 2026 JVCare Team - Lập trình Java Nâng cao

---

## 🎓 CREDITS

**Giảng viên hướng dẫn:** [Nguyễn Tấn THuận]  
**Môn học:** Lập trình Java Nâng cao  
**Học kỳ:** 2/2025-2026  
**Trường:** [Đại học Sư Phạm Kỹ Thuật Đà Nẵng]

---

## 📋 CHANGELOG

### Version 1.0.0 (20/05/2026)
- ✅ Hoàn thành module Login/Logout
- ✅ Hoàn thành module Patient (xem lịch hẹn, đơn thuốc)
- ✅ Hoàn thành module Doctor (xem lịch hẹn, bệnh nhân)
- ✅ Tích hợp Groq AI chatbot
- ✅ Database schema hoàn chỉnh

### Version 2.0.0 (Đang phát triển)
- 🔄 Module Admin (CRUD users, doctors)
- 🔄 Module Doctor (tạo bệnh án, kê đơn)
- 🔄 Module Patient (đặt lịch, quản lý profile)
- 🔄 Dashboard & Reports
- 🔄 Advanced features (search, email, pagination)

---