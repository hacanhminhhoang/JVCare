# 🏗️ HƯỚNG DẪN TRIỂN KHAI 3-LAYER CHO TẤT CẢ TASKS

## 📋 TỔNG QUAN

Tài liệu này hướng dẫn cách áp dụng kiến trúc 3 lớp cho tất cả 5 tasks trong dự án JVCare_MVC.

---

## 🎯 CẤU TRÚC CHUNG CHO MỖI TASK

Mỗi task cần tạo các thành phần sau:

### 1. **DTO Layer** (Data Transfer Objects)
- Truyền dữ liệu giữa các layer
- Che giấu thông tin nhạy cảm
- Tối ưu hóa data transfer

### 2. **Service Layer** (Business Logic)
- Xử lý business logic
- Validation dữ liệu
- Transaction management
- Gọi DAO để truy cập database

### 3. **DAO Layer** (Data Access)
- Truy cập database
- Thực thi SQL queries
- Chuyển đổi ResultSet → Entity

### 4. **Controller Layer** (Presentation)
- Xử lý HTTP requests
- Gọi Service Layer
- Forward/Redirect views

### 5. **Exception Layer**
- Custom exceptions
- Error handling

---

## 📊 PHÂN CHIA CHI TIẾT THEO TASK

### 🔴 TASK 1: ADMIN - USERS & DOCTORS

#### DTOs cần tạo:
```java
dto/
├── UserDTO.java
│   - userId, username, email, fullName, role, phone, status
│   - password (chỉ khi tạo mới)
│   - specialization (nếu là doctor)
│
└── DoctorDTO.java
    - doctorId, userId, fullName, email, phone
    - specialization, status
    - totalAppointments, totalPatients (statistics)
```

#### Services cần tạo:
```java
service/
├── UserService.java
│   - getAllUsers(page, pageSize): List<UserDTO>
│   - getUserById(userId): UserDTO
│   - createUser(userDTO): boolean
│   - updateUser(userDTO): boolean
│   - deleteUser(userId): boolean
│   - searchUsers(keyword): List<UserDTO>
│   - getTotalUsers(): int
│   - validateUser(userDTO, isCreate): void
│   - convertToDTO(user): UserDTO
│   - convertToEntity(userDTO): User
│
└── DoctorService.java
    - getAllDoctors(): List<DoctorDTO>
    - getDoctorById(doctorId): DoctorDTO
    - createDoctor(doctorDTO): boolean
    - updateDoctor(doctorDTO): boolean
    - deleteDoctor(doctorId): boolean
    - getDoctorStatistics(doctorId): Map<String, Integer>
```

#### Business Rules trong Service:
- Username phải unique, 3-50 ký tự, chỉ chữ cái/số/underscore
- Email phải hợp lệ và unique
- Password tối thiểu 6 ký tự (khi tạo mới)
- Không thể xóa admin cuối cùng
- Doctor phải có specialization
- Hash password với BCrypt
- Soft delete (set status = INACTIVE)

---

### 🟢 TASK 2: DOCTOR - BỆNH ÁN & ĐƠN THUỐC

#### DTOs cần tạo:
```java
dto/
├── MedicalRecordDTO.java
│   - recordId, patientId, patientName, patientCode
│   - doctorId, doctorName, visitDate
│   - diagnosis, treatmentPlan, notes
│   - bloodPressure, heartRate, temperature, weight, height
│   - prescriptions: List<PrescriptionDTO>
│
└── PrescriptionDTO.java
    - prescriptionId, recordId
    - medicationName, dosage, frequency
    - durationDays, instructions
```

#### Services cần tạo:
```java
service/
├── MedicalRecordService.java
│   - getAllRecordsByDoctor(doctorId): List<MedicalRecordDTO>
│   - getRecordById(recordId): MedicalRecordDTO
│   - createRecord(recordDTO): int (return recordId)
│   - createRecordFromAppointment(appointmentId, recordDTO): int
│   - updateRecord(recordDTO): boolean
│   - getRecordWithPrescriptions(recordId): MedicalRecordDTO
│   - validateVitalSigns(recordDTO): void
│   - calculateBMI(weight, height): double
│
└── PrescriptionService.java
    - getPrescriptionsByRecord(recordId): List<PrescriptionDTO>
    - addPrescription(prescriptionDTO): boolean
    - updatePrescription(prescriptionDTO): boolean
    - deletePrescription(prescriptionId): boolean
    - validateMedication(prescriptionDTO): void
    - generatePrescriptionReport(recordId): String
```

#### Business Rules trong Service:
- Vital signs validation:
  - Blood pressure: format "120/80"
  - Heart rate: 40-200 bpm
  - Temperature: 35-42°C
  - Weight: > 0 kg
  - Height: > 0 cm
- Diagnosis không được để trống
- Treatment plan không được để trống
- Chỉ tạo được record từ appointment đã COMPLETED
- Medication name không được để trống
- Dosage và frequency phải hợp lệ
- Duration phải > 0 ngày

---

### 🔵 TASK 3: PATIENT - ĐẶT LỊCH & HỒ SƠ

#### DTOs cần tạo:
```java
dto/
├── AppointmentDTO.java
│   - appointmentId, patientId, patientName, patientCode
│   - doctorId, doctorName, doctorSpecialization
│   - appointmentDate, appointmentTime
│   - status, reason, diagnosis
│
└── PatientDTO.java
    - patientId, userId, patientCode
    - fullName, dateOfBirth, gender
    - phone, email, address
    - allergies, chronicDiseases
    - avatarUrl, idCard
```

#### Services cần tạo:
```java
service/
├── AppointmentService.java
│   - bookAppointment(appointmentDTO): boolean
│   - getAppointmentsByPatient(patientId): List<AppointmentDTO>
│   - getAppointmentById(appointmentId): AppointmentDTO
│   - updateAppointment(appointmentDTO): boolean
│   - cancelAppointment(appointmentId, patientId): boolean
│   - getAvailableTimeSlots(date, doctorId): List<String>
│   - checkDuplicateAppointment(patientId, date, time): boolean
│   - sendConfirmationEmail(appointmentDTO): void
│
└── PatientService.java
    - getPatientByUserId(userId): PatientDTO
    - getPatientById(patientId): PatientDTO
    - updateProfile(patientDTO): boolean
    - uploadAvatar(patientId, file): String
    - getMedicalHistory(patientId): List<MedicalRecordDTO>
    - validatePatientData(patientDTO): void
```

#### Business Rules trong Service:
- Không đặt lịch trong quá khứ
- Không đặt lịch quá xa (> 3 tháng)
- Check duplicate appointment
- Check time slot availability
- Giới hạn 3 pending appointments/patient
- Chỉ hủy được lịch PENDING
- Phải hủy trước ít nhất 24 giờ
- Gửi email confirmation sau khi đặt
- Validate phone number format
- Validate email format
- Avatar file size < 2MB, format: jpg/png

---

### 🟡 TASK 4: BÁO CÁO & THỐNG KÊ

#### DTOs cần tạo:
```java
dto/
├── StatisticsDTO.java
│   - totalUsers, totalDoctors, totalPatients
│   - totalAppointments, pendingAppointments
│   - completedAppointments, cancelledAppointments
│   - totalRecords, totalPrescriptions
│   - appointmentsByMonth: Map<Integer, Integer>
│   - appointmentsByStatus: Map<String, Integer>
│
└── ReportDTO.java
    - reportType, reportDate
    - filters: Map<String, Object>
    - data: List<Map<String, Object>>
    - summary: Map<String, Object>
```

#### Services cần tạo:
```java
service/
├── StatisticsService.java
│   - getAdminStatistics(): StatisticsDTO
│   - getDoctorStatistics(doctorId): StatisticsDTO
│   - getUserCountByRole(): Map<String, Integer>
│   - getAppointmentsByStatus(): Map<String, Integer>
│   - getAppointmentsByMonth(year): Map<Integer, Integer>
│   - getDoctorPerformance(): List<Map<String, Object>>
│   - getPatientStatistics(): Map<String, Integer>
│
└── ReportService.java
    - generateAppointmentReport(filters): ReportDTO
    - generateDoctorReport(filters): ReportDTO
    - generatePatientReport(filters): ReportDTO
    - exportToExcel(reportDTO): byte[]
    - exportToPDF(reportDTO): byte[]
    - applyFilters(data, filters): List<Map<String, Object>>
```

#### Business Rules trong Service:
- Validate date ranges
- Default to current month if no filter
- Aggregate data from multiple sources
- Calculate percentages and trends
- Format data for charts
- Apply pagination for large reports
- Cache frequently accessed statistics
- Validate export format (excel/pdf)

---

### 🟣 TASK 5: TÍNH NĂNG NÂNG CAO

#### DTOs cần tạo:
```java
dto/
├── SearchResultDTO.java
│   - resultType (patient/doctor/appointment)
│   - id, name, code
│   - additionalInfo: Map<String, String>
│   - relevanceScore: double
│
└── EmailDTO.java
    - to, subject, body
    - attachments: List<String>
    - template, templateData: Map<String, Object>
```

#### Services cần tạo:
```java
service/
├── SearchService.java
│   - searchGlobal(keyword): List<SearchResultDTO>
│   - searchPatients(keyword): List<PatientDTO>
│   - searchDoctors(keyword): List<DoctorDTO>
│   - searchAppointments(keyword): List<AppointmentDTO>
│   - calculateRelevance(item, keyword): double
│   - highlightMatches(text, keyword): String
│
├── EmailService.java (nâng cấp từ util)
│   - sendAppointmentConfirmation(appointmentDTO): boolean
│   - sendAppointmentReminder(appointmentDTO): boolean
│   - sendCancellationNotice(appointmentDTO): boolean
│   - sendBulkEmail(recipients, template, data): boolean
│   - renderTemplate(template, data): String
│   - validateEmailAddress(email): boolean
│
└── ValidationService.java
    - validateEmail(email): boolean
    - validatePhone(phone): boolean
    - validateDate(date): boolean
    - validatePassword(password): boolean
    - sanitizeInput(input): String
    - checkXSS(input): boolean
```

#### Business Rules trong Service:
- Search: minimum 2 characters
- Search: limit results to 10 per type
- Search: fuzzy matching algorithm
- Email: validate SMTP configuration
- Email: retry failed sends (max 3 times)
- Email: queue for bulk sending
- Validation: centralized rules
- Security: XSS prevention
- Security: SQL injection prevention
- Pagination: max 100 items per page

---

## 🔄 WORKFLOW CHUẨN CHO MỖI FEATURE

### 1. Tạo DTO
```java
// Example: UserDTO.java
package com.jvcare.dto;

public class UserDTO {
    // Fields
    private int userId;
    private String username;
    // ... other fields
    
    // Constructors
    public UserDTO() {}
    
    // Getters and Setters
    // ...
}
```

### 2. Tạo Custom Exceptions (nếu cần)
```java
// Example: UserNotFoundException.java
package com.jvcare.exception;

public class UserNotFoundException extends BusinessException {
    public UserNotFoundException(String message) {
        super(message);
    }
}
```

### 3. Tạo Service với Business Logic
```java
// Example: UserService.java
package com.jvcare.service;

public class UserService {
    private UserDAO userDAO = new UserDAO();
    
    public UserDTO getUserById(int userId) throws BusinessException {
        // 1. Validate input
        if (userId <= 0) {
            throw new ValidationException("Invalid user ID");
        }
        
        // 2. Call DAO
        User user = userDAO.getUserById(userId);
        
        // 3. Check result
        if (user == null) {
            throw new UserNotFoundException("User not found");
        }
        
        // 4. Convert to DTO
        return convertToDTO(user);
    }
    
    // Private helper methods
    private UserDTO convertToDTO(User user) { ... }
    private User convertToEntity(UserDTO dto) { ... }
    private void validateUser(UserDTO dto) { ... }
}
```

### 4. Cập nhật Servlet để gọi Service
```java
// Example: AdminUserServlet.java
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private UserService userService = new UserService();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            
            // Call Service (NOT DAO)
            UserDTO user = userService.getUserById(userId);
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/admin/user.jsp")
                   .forward(request, response);
                   
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
            // Handle validation error
        } catch (BusinessException e) {
            request.setAttribute("error", "System error");
            // Handle business error
        }
    }
}
```

### 5. Giữ nguyên DAO (chỉ database access)
```java
// Example: UserDAO.java
public class UserDAO {
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        // Execute SQL and return User entity
    }
}
```

---

## ✅ CHECKLIST TRIỂN KHAI 3-LAYER

### Cho mỗi feature:

#### Phase 1: Design
- [ ] Xác định DTOs cần thiết
- [ ] Xác định business rules
- [ ] Xác định validation rules
- [ ] Thiết kế Service methods

#### Phase 2: Implementation
- [ ] Tạo DTO classes
- [ ] Tạo Custom Exceptions (nếu cần)
- [ ] Tạo Service class
- [ ] Implement business logic trong Service
- [ ] Implement validation trong Service
- [ ] Implement conversion methods (Entity ↔ DTO)
- [ ] Cập nhật Servlet (gọi Service thay vì DAO)
- [ ] Cập nhật DAO (nếu cần thêm methods)

#### Phase 3: Testing
- [ ] Unit test cho Service methods
- [ ] Test validation logic
- [ ] Test business rules
- [ ] Test exception handling
- [ ] Integration test

#### Phase 4: Documentation
- [ ] Comment code đầy đủ
- [ ] Document business rules
- [ ] Document validation rules
- [ ] Update README

---

## 🎯 LỢI ÍCH CỦA 3-LAYER

### 1. **Separation of Concerns**
- Controller: HTTP handling
- Service: Business logic
- DAO: Database access

### 2. **Reusability**
- Service methods có thể gọi từ nhiều controllers
- Business logic không bị duplicate

### 3. **Testability**
- Dễ dàng unit test Service layer
- Mock dependencies dễ dàng

### 4. **Maintainability**
- Thay đổi database không ảnh hưởng business logic
- Thay đổi UI không ảnh hưởng business logic

### 5. **Security**
- Validation tập trung
- DTO che giấu thông tin nhạy cảm
- Business rules được enforce nhất quán

---

## 📚 TÀI LIỆU THAM KHẢO

- **[3_LAYER_ARCHITECTURE.md](3_LAYER_ARCHITECTURE.md)** - Kiến trúc chi tiết
- **[TASK_1_ADMIN_3LAYER.md](TASK_1_ADMIN_3LAYER.md)** - Ví dụ đầy đủ Task 1
- [Service Layer Pattern](https://www.baeldung.com/java-service-layer-validation)
- [DTO Pattern](https://www.baeldung.com/java-dto-pattern)
- [Exception Handling](https://www.baeldung.com/java-exceptions)

---

**Áp dụng 3-Layer Architecture sẽ làm cho dự án của bạn chuyên nghiệp và dễ bảo trì hơn rất nhiều! 🚀**

