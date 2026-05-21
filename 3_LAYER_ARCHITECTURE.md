# 🏗️ KIẾN TRÚC 3 LỚP (3-LAYER ARCHITECTURE) - JVCARE_MVC

## 📋 TỔNG QUAN

Dự án JVCare_MVC áp dụng **kiến trúc 3 lớp** kết hợp với **mô hình MVC** để tạo ra một hệ thống có cấu trúc rõ ràng, dễ bảo trì và mở rộng.

---

## 🏛️ KIẾN TRÚC 3 LỚP

```
┌─────────────────────────────────────────────────────────┐
│         PRESENTATION LAYER (Tầng Giao diện)             │
│  - JSP Views                                            │
│  - Servlets (Controllers)                               │
│  - JavaScript, CSS                                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│      BUSINESS LOGIC LAYER (Tầng Nghiệp vụ)             │
│  - Service Classes                                      │
│  - Business Rules                                       │
│  - Validation Logic                                     │
│  - Transaction Management                               │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│       DATA ACCESS LAYER (Tầng Truy cập dữ liệu)        │
│  - DAO Classes                                          │
│  - Database Connection                                  │
│  - SQL Queries                                          │
│  - Model/Entity Classes                                 │
└─────────────────────────────────────────────────────────┘
                     │
                     ↓
              ┌──────────────┐
              │   DATABASE   │
              │  SQL Server  │
              └──────────────┘
```

---

## 📂 CẤU TRÚC THỨ MỤC MỚI

```
src/main/java/com/jvcare/
├── controller/              [PRESENTATION LAYER]
│   ├── AdminUserServlet.java
│   ├── DoctorMedicalRecordServlet.java
│   └── ...
│
├── service/                 [BUSINESS LOGIC LAYER - MỚI]
│   ├── UserService.java
│   ├── DoctorService.java
│   ├── PatientService.java
│   ├── AppointmentService.java
│   ├── MedicalRecordService.java
│   ├── PrescriptionService.java
│   └── StatisticsService.java
│
├── dao/                     [DATA ACCESS LAYER]
│   ├── UserDAO.java
│   ├── DoctorDAO.java
│   ├── PatientDAO.java
│   ├── AppointmentDAO.java
│   ├── MedicalRecordDAO.java
│   ├── PrescriptionDAO.java
│   └── StatisticsDAO.java
│
├── model/                   [DOMAIN MODELS]
│   ├── User.java
│   ├── Doctor.java
│   ├── Patient.java
│   ├── Appointment.java
│   ├── MedicalRecord.java
│   └── Prescription.java
│
├── dto/                     [DATA TRANSFER OBJECTS - MỚI]
│   ├── UserDTO.java
│   ├── AppointmentDTO.java
│   └── MedicalRecordDTO.java
│
├── exception/               [CUSTOM EXCEPTIONS - MỚI]
│   ├── BusinessException.java
│   ├── DataAccessException.java
│   └── ValidationException.java
│
├── util/                    [UTILITIES]
│   ├── DBConnection.java
│   ├── EmailService.java
│   ├── PaginationUtil.java
│   └── ValidationUtil.java
│
└── filter/                  [FILTERS]
    ├── AuthFilter.java
    └── RoleFilter.java
```

---

## 🎯 CHI TIẾT TỪNG LỚP

### 1️⃣ PRESENTATION LAYER (Tầng Giao diện)

**Trách nhiệm:**
- Nhận request từ người dùng
- Gọi Business Logic Layer để xử lý
- Hiển thị kết quả cho người dùng
- **KHÔNG** chứa business logic
- **KHÔNG** truy cập trực tiếp vào database

**Thành phần:**
- **Servlets (Controllers):** Xử lý HTTP requests
- **JSP Views:** Hiển thị dữ liệu
- **JavaScript/CSS:** Client-side logic

**Ví dụ:**
```java
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    
    private UserService userService = new UserService(); // Gọi Service Layer
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy parameters
            int page = Integer.parseInt(request.getParameter("page"));
            int pageSize = 10;
            
            // Gọi Service Layer (KHÔNG gọi trực tiếp DAO)
            List<UserDTO> users = userService.getAllUsers(page, pageSize);
            int totalUsers = userService.getTotalUsers();
            
            // Set attributes và forward
            request.setAttribute("users", users);
            request.setAttribute("totalPages", totalUsers / pageSize);
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp")
                   .forward(request, response);
                   
        } catch (BusinessException e) {
            request.setAttribute("error", e.getMessage());
            // Handle error
        }
    }
}
```

---

### 2️⃣ BUSINESS LOGIC LAYER (Tầng Nghiệp vụ)

**Trách nhiệm:**
- Xử lý business logic và business rules
- Validation dữ liệu
- Transaction management
- Gọi Data Access Layer để lấy/lưu dữ liệu
- Chuyển đổi giữa Entity và DTO
- **KHÔNG** xử lý HTTP request/response
- **KHÔNG** chứa SQL queries

**Thành phần:**
- **Service Classes:** Chứa business logic
- **Validation Logic:** Kiểm tra dữ liệu
- **Transaction Management:** Quản lý giao dịch

**Ví dụ:**
```java
package com.jvcare.service;

import com.jvcare.dao.UserDAO;
import com.jvcare.dao.DoctorDAO;
import com.jvcare.model.User;
import com.jvcare.model.Doctor;
import com.jvcare.dto.UserDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;
import java.util.stream.Collectors;

public class UserService {
    
    private UserDAO userDAO = new UserDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    
    /**
     * Lấy tất cả users với phân trang
     */
    public List<UserDTO> getAllUsers(int page, int pageSize) throws BusinessException {
        try {
            // Validate input
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 10;
            
            // Gọi DAO
            List<User> users = userDAO.getAllUsers(page, pageSize);
            
            // Convert Entity to DTO
            return users.stream()
                       .map(this::convertToDTO)
                       .collect(Collectors.toList());
                       
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy danh sách users", e);
        }
    }
    
    /**
     * Tạo user mới
     */
    public boolean createUser(UserDTO userDTO) throws BusinessException, ValidationException {
        try {
            // 1. Validate input
            validateUser(userDTO);
            
            // 2. Check business rules
            if (userDAO.existsByUsername(userDTO.getUsername())) {
                throw new ValidationException("Username đã tồn tại");
            }
            
            if (userDAO.existsByEmail(userDTO.getEmail())) {
                throw new ValidationException("Email đã tồn tại");
            }
            
            // 3. Hash password
            String hashedPassword = BCrypt.hashpw(userDTO.getPassword(), BCrypt.gensalt());
            
            // 4. Convert DTO to Entity
            User user = convertToEntity(userDTO);
            user.setPasswordHash(hashedPassword);
            
            // 5. Save to database
            boolean created = userDAO.createUser(user);
            
            // 6. If user is DOCTOR, create doctor record
            if (created && "DOCTOR".equals(userDTO.getRole())) {
                Doctor doctor = new Doctor();
                doctor.setUserId(user.getUserId());
                doctor.setSpecialization(userDTO.getSpecialization());
                doctorDAO.createDoctor(doctor);
            }
            
            return created;
            
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tạo user", e);
        }
    }
    
    /**
     * Cập nhật user
     */
    public boolean updateUser(UserDTO userDTO) throws BusinessException, ValidationException {
        try {
            // Validate
            validateUser(userDTO);
            
            // Check if user exists
            User existingUser = userDAO.getUserById(userDTO.getUserId());
            if (existingUser == null) {
                throw new ValidationException("User không tồn tại");
            }
            
            // Check email duplicate (exclude current user)
            if (userDAO.existsByEmailExcludingUser(userDTO.getEmail(), userDTO.getUserId())) {
                throw new ValidationException("Email đã được sử dụng");
            }
            
            // Convert and update
            User user = convertToEntity(userDTO);
            return userDAO.updateUser(user);
            
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi cập nhật user", e);
        }
    }
    
    /**
     * Xóa user (soft delete)
     */
    public boolean deleteUser(int userId) throws BusinessException {
        try {
            // Check if user can be deleted
            User user = userDAO.getUserById(userId);
            if (user == null) {
                throw new BusinessException("User không tồn tại");
            }
            
            // Business rule: Cannot delete admin if it's the last admin
            if ("ADMIN".equals(user.getRole())) {
                int adminCount = userDAO.countUsersByRole("ADMIN");
                if (adminCount <= 1) {
                    throw new BusinessException("Không thể xóa admin cuối cùng");
                }
            }
            
            return userDAO.deleteUser(userId);
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi xóa user", e);
        }
    }
    
    /**
     * Tìm kiếm users
     */
    public List<UserDTO> searchUsers(String keyword) throws BusinessException {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return getAllUsers(1, 10);
            }
            
            List<User> users = userDAO.searchUsers(keyword);
            return users.stream()
                       .map(this::convertToDTO)
                       .collect(Collectors.toList());
                       
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tìm kiếm users", e);
        }
    }
    
    /**
     * Đếm tổng số users
     */
    public int getTotalUsers() throws BusinessException {
        try {
            return userDAO.getTotalUsers();
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi đếm users", e);
        }
    }
    
    // ==================== PRIVATE METHODS ====================
    
    /**
     * Validate user data
     */
    private void validateUser(UserDTO userDTO) throws ValidationException {
        if (userDTO == null) {
            throw new ValidationException("User data không được null");
        }
        
        if (userDTO.getUsername() == null || userDTO.getUsername().trim().isEmpty()) {
            throw new ValidationException("Username không được để trống");
        }
        
        if (userDTO.getUsername().length() < 3 || userDTO.getUsername().length() > 50) {
            throw new ValidationException("Username phải từ 3-50 ký tự");
        }
        
        if (userDTO.getEmail() == null || !userDTO.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new ValidationException("Email không hợp lệ");
        }
        
        if (userDTO.getFullName() == null || userDTO.getFullName().trim().isEmpty()) {
            throw new ValidationException("Họ tên không được để trống");
        }
        
        if (userDTO.getRole() == null || 
            !List.of("ADMIN", "DOCTOR", "PATIENT").contains(userDTO.getRole())) {
            throw new ValidationException("Role không hợp lệ");
        }
    }
    
    /**
     * Convert Entity to DTO
     */
    private UserDTO convertToDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setUserId(user.getUserId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFullName(user.getFullName());
        dto.setRole(user.getRole());
        dto.setPhone(user.getPhone());
        dto.setStatus(user.getStatus());
        return dto;
    }
    
    /**
     * Convert DTO to Entity
     */
    private User convertToEntity(UserDTO dto) {
        User user = new User();
        user.setUserId(dto.getUserId());
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setFullName(dto.getFullName());
        user.setRole(dto.getRole());
        user.setPhone(dto.getPhone());
        user.setStatus(dto.getStatus());
        return user;
    }
}
```

---

### 3️⃣ DATA ACCESS LAYER (Tầng Truy cập dữ liệu)

**Trách nhiệm:**
- Truy cập database
- Thực thi SQL queries
- Chuyển đổi ResultSet thành Entity
- **KHÔNG** chứa business logic
- **KHÔNG** chứa validation logic

**Thành phần:**
- **DAO Classes:** Data Access Objects
- **Database Connection:** Quản lý kết nối
- **Entity/Model Classes:** Đại diện cho bảng trong DB

**Ví dụ:** (Giữ nguyên như hiện tại, chỉ thêm một số methods)

```java
package com.jvcare.dao;

import com.jvcare.model.User;
import com.jvcare.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    // Existing methods...
    
    /**
     * Check if username exists
     */
    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if email exists
     */
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if email exists excluding a specific user
     */
    public boolean existsByEmailExcludingUser(String email, int userId) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND user_id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Count users by role
     */
    public int countUsersByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
```



---

## 📦 DATA TRANSFER OBJECTS (DTOs)

**Mục đích:**
- Truyền dữ liệu giữa các layer
- Che giấu thông tin nhạy cảm (password, internal IDs)
- Tối ưu hóa data transfer

**Ví dụ:**

```java
package com.jvcare.dto;

public class UserDTO {
    private int userId;
    private String username;
    private String email;
    private String fullName;
    private String role;
    private String phone;
    private String status;
    
    // For creating user
    private String password;
    
    // For doctor
    private String specialization;
    
    // Constructors
    public UserDTO() {}
    
    // Getters and Setters
    // ...
}
```

```java
package com.jvcare.dto;

import java.sql.Date;
import java.sql.Time;

public class AppointmentDTO {
    private int appointmentId;
    private int patientId;
    private String patientName;
    private String patientCode;
    private int doctorId;
    private String doctorName;
    private String doctorSpecialization;
    private Date appointmentDate;
    private Time appointmentTime;
    private String status;
    private String reason;
    private String diagnosis;
    
    // Constructors, Getters, Setters
    // ...
}
```

---

## ⚠️ CUSTOM EXCEPTIONS

**Mục đích:**
- Xử lý lỗi rõ ràng theo từng layer
- Dễ dàng debug và maintain

**Ví dụ:**

```java
package com.jvcare.exception;

public class BusinessException extends Exception {
    public BusinessException(String message) {
        super(message);
    }
    
    public BusinessException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

```java
package com.jvcare.exception;

public class ValidationException extends Exception {
    public ValidationException(String message) {
        super(message);
    }
}
```

```java
package com.jvcare.exception;

public class DataAccessException extends Exception {
    public DataAccessException(String message) {
        super(message);
    }
    
    public DataAccessException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

---

## 🔄 LUỒNG XỬ LÝ REQUEST

### Ví dụ: Tạo User mới

```
1. USER (Browser)
   ↓ HTTP POST /admin/users?action=create
   
2. PRESENTATION LAYER
   AdminUserServlet.doPost()
   - Nhận parameters từ request
   - Tạo UserDTO từ parameters
   ↓
   
3. BUSINESS LOGIC LAYER
   UserService.createUser(userDTO)
   - Validate dữ liệu
   - Check business rules (duplicate username/email)
   - Hash password
   - Convert DTO to Entity
   ↓
   
4. DATA ACCESS LAYER
   UserDAO.createUser(user)
   - Thực thi SQL INSERT
   - Return result
   ↑
   
5. BUSINESS LOGIC LAYER
   - Nhận kết quả từ DAO
   - Nếu user là DOCTOR, tạo doctor record
   - Return success/failure
   ↑
   
6. PRESENTATION LAYER
   - Nhận kết quả từ Service
   - Set success message
   - Redirect hoặc forward
   ↑
   
7. USER (Browser)
   - Hiển thị kết quả
```

---

## 📋 PHÂN CHIA TASK VỚI 3-LAYER

### 🔴 TASK 1: ADMIN - QUẢN LÝ USERS & DOCTORS

**Cần tạo thêm:**

1. **Service Layer:**
   - `UserService.java`
   - `DoctorService.java`

2. **DTO:**
   - `UserDTO.java`
   - `DoctorDTO.java`

3. **Exceptions:**
   - `BusinessException.java`
   - `ValidationException.java`

4. **Cập nhật Servlet:**
   - `AdminUserServlet.java` - Gọi UserService thay vì UserDAO
   - `AdminDoctorServlet.java` - Gọi DoctorService

**Cấu trúc:**
```
controller/
  └── AdminUserServlet.java          [Gọi UserService]
service/
  ├── UserService.java                [Business Logic]
  └── DoctorService.java              [Business Logic]
dao/
  ├── UserDAO.java                    [Database Access]
  └── DoctorDAO.java                  [Database Access]
dto/
  ├── UserDTO.java                    [Data Transfer]
  └── DoctorDTO.java                  [Data Transfer]
exception/
  ├── BusinessException.java
  └── ValidationException.java
```

---

### 🟢 TASK 2: DOCTOR - BỆNH ÁN & ĐƠN THUỐC

**Cần tạo thêm:**

1. **Service Layer:**
   - `MedicalRecordService.java`
   - `PrescriptionService.java`

2. **DTO:**
   - `MedicalRecordDTO.java`
   - `PrescriptionDTO.java`

3. **Cập nhật Servlet:**
   - `DoctorMedicalRecordServlet.java` - Gọi MedicalRecordService
   - `DoctorPrescriptionServlet.java` - Gọi PrescriptionService

**Business Logic trong Service:**
- Validate vital signs (blood pressure, heart rate, temperature)
- Check if appointment is completed before creating record
- Validate medication dosage
- Calculate BMI from weight and height
- Generate prescription report

---

### 🔵 TASK 3: PATIENT - ĐẶT LỊCH & HỒ SƠ

**Cần tạo thêm:**

1. **Service Layer:**
   - `AppointmentService.java`
   - `PatientService.java`

2. **DTO:**
   - `AppointmentDTO.java`
   - `PatientDTO.java`

3. **Cập nhật Servlet:**
   - `PatientBookAppointmentServlet.java` - Gọi AppointmentService
   - `PatientProfileServlet.java` - Gọi PatientService

**Business Logic trong Service:**
- Check available time slots
- Validate appointment date (không được đặt quá khứ)
- Check duplicate appointments
- Send email confirmation (gọi EmailService)
- Validate patient profile data
- Handle avatar upload

---

### 🟡 TASK 4: BÁO CÁO & THỐNG KÊ

**Cần tạo thêm:**

1. **Service Layer:**
   - `StatisticsService.java`
   - `ReportService.java`

2. **DTO:**
   - `StatisticsDTO.java`
   - `ReportDTO.java`

3. **Cập nhật Servlet:**
   - `AdminReportServlet.java` - Gọi ReportService
   - `AdminHomeServlet.java` - Gọi StatisticsService

**Business Logic trong Service:**
- Calculate statistics
- Generate chart data
- Format data for export
- Apply filters and date ranges
- Aggregate data from multiple sources

---

### 🟣 TASK 5: TÍNH NĂNG NÂNG CAO

**Cần tạo thêm:**

1. **Service Layer:**
   - `SearchService.java`
   - `EmailService.java` (đã có trong util, có thể giữ nguyên)

2. **Utility:**
   - `ValidationUtil.java` - Centralized validation

**Business Logic:**
- Search algorithm
- Email template generation
- Pagination logic
- Security validation

---

## 📝 VÍ DỤ ĐẦY ĐỦ: APPOINTMENT SERVICE

```java
package com.jvcare.service;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.DoctorDAO;
import com.jvcare.model.Appointment;
import com.jvcare.dto.AppointmentDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import com.jvcare.util.EmailService;

import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

public class AppointmentService {
    
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    
    /**
     * Đặt lịch hẹn mới
     */
    public boolean bookAppointment(AppointmentDTO dto) 
            throws BusinessException, ValidationException {
        
        try {
            // 1. Validate input
            validateAppointment(dto);
            
            // 2. Business rules
            
            // Rule 1: Không được đặt lịch trong quá khứ
            LocalDate today = LocalDate.now();
            LocalDate appointmentDate = dto.getAppointmentDate().toLocalDate();
            
            if (appointmentDate.isBefore(today)) {
                throw new ValidationException("Không thể đặt lịch trong quá khứ");
            }
            
            // Rule 2: Không được đặt lịch quá xa (> 3 tháng)
            if (appointmentDate.isAfter(today.plusMonths(3))) {
                throw new ValidationException("Chỉ có thể đặt lịch trong vòng 3 tháng");
            }
            
            // Rule 3: Check duplicate appointment
            if (appointmentDAO.checkDuplicateAppointment(
                    dto.getPatientId(), 
                    dto.getAppointmentDate(), 
                    dto.getAppointmentTime())) {
                throw new ValidationException("Bạn đã có lịch hẹn vào thời gian này");
            }
            
            // Rule 4: Check if time slot is available
            if (dto.getDoctorId() > 0) {
                List<String> availableSlots = appointmentDAO.getAvailableTimeSlots(
                    dto.getAppointmentDate(), 
                    dto.getDoctorId()
                );
                
                String timeStr = dto.getAppointmentTime().toString().substring(0, 5);
                if (!availableSlots.contains(timeStr)) {
                    throw new ValidationException("Khung giờ này đã được đặt");
                }
            }
            
            // Rule 5: Giới hạn số lịch hẹn pending của một bệnh nhân
            int pendingCount = appointmentDAO.countPendingAppointments(dto.getPatientId());
            if (pendingCount >= 3) {
                throw new ValidationException("Bạn đã có 3 lịch hẹn đang chờ. Vui lòng hoàn thành hoặc hủy trước khi đặt mới.");
            }
            
            // 3. Convert DTO to Entity
            Appointment appointment = convertToEntity(dto);
            
            // 4. Save to database
            boolean created = appointmentDAO.createAppointment(appointment);
            
            // 5. Send email confirmation
            if (created) {
                try {
                    Patient patient = patientDAO.getPatientById(dto.getPatientId());
                    String doctorName = dto.getDoctorId() > 0 ? 
                        doctorDAO.getDoctorById(dto.getDoctorId()).getFullName() : 
                        "Chưa xác định";
                    
                    EmailService.sendAppointmentConfirmation(
                        patient.getEmail(),
                        patient.getFullName(),
                        dto.getAppointmentDate().toString(),
                        dto.getAppointmentTime().toString(),
                        doctorName
                    );
                } catch (Exception e) {
                    // Log error but don't fail the appointment creation
                    System.err.println("Failed to send email: " + e.getMessage());
                }
            }
            
            return created;
            
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi đặt lịch hẹn", e);
        }
    }
    
    /**
     * Hủy lịch hẹn
     */
    public boolean cancelAppointment(int appointmentId, int patientId) 
            throws BusinessException, ValidationException {
        
        try {
            // Get appointment
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            
            if (appointment == null) {
                throw new ValidationException("Lịch hẹn không tồn tại");
            }
            
            // Business rule: Chỉ patient của lịch hẹn mới được hủy
            if (appointment.getPatientId() != patientId) {
                throw new ValidationException("Bạn không có quyền hủy lịch hẹn này");
            }
            
            // Business rule: Chỉ hủy được lịch PENDING
            if (!"PENDING".equals(appointment.getStatus())) {
                throw new ValidationException("Chỉ có thể hủy lịch hẹn đang chờ xác nhận");
            }
            
            // Business rule: Phải hủy trước ít nhất 24 giờ
            LocalDate today = LocalDate.now();
            LocalDate appointmentDate = appointment.getAppointmentDate().toLocalDate();
            
            if (appointmentDate.isBefore(today.plusDays(1))) {
                throw new ValidationException("Phải hủy lịch trước ít nhất 24 giờ");
            }
            
            // Cancel appointment
            boolean cancelled = appointmentDAO.cancelAppointment(appointmentId, patientId);
            
            // Send cancellation email
            if (cancelled) {
                try {
                    Patient patient = patientDAO.getPatientById(patientId);
                    EmailService.sendAppointmentCancellation(
                        patient.getEmail(),
                        patient.getFullName(),
                        appointment.getAppointmentDate().toString(),
                        appointment.getAppointmentTime().toString()
                    );
                } catch (Exception e) {
                    System.err.println("Failed to send cancellation email: " + e.getMessage());
                }
            }
            
            return cancelled;
            
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi hủy lịch hẹn", e);
        }
    }
    
    /**
     * Lấy danh sách lịch hẹn của bệnh nhân
     */
    public List<AppointmentDTO> getAppointmentsByPatient(int patientId) 
            throws BusinessException {
        
        try {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(patientId);
            return appointments.stream()
                              .map(this::convertToDTO)
                              .collect(Collectors.toList());
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy danh sách lịch hẹn", e);
        }
    }
    
    // ==================== PRIVATE METHODS ====================
    
    private void validateAppointment(AppointmentDTO dto) throws ValidationException {
        if (dto == null) {
            throw new ValidationException("Appointment data không được null");
        }
        
        if (dto.getPatientId() <= 0) {
            throw new ValidationException("Patient ID không hợp lệ");
        }
        
        if (dto.getAppointmentDate() == null) {
            throw new ValidationException("Ngày hẹn không được để trống");
        }
        
        if (dto.getAppointmentTime() == null) {
            throw new ValidationException("Giờ hẹn không được để trống");
        }
        
        if (dto.getReason() == null || dto.getReason().trim().isEmpty()) {
            throw new ValidationException("Lý do khám không được để trống");
        }
        
        if (dto.getReason().length() > 500) {
            throw new ValidationException("Lý do khám không được quá 500 ký tự");
        }
    }
    
    private AppointmentDTO convertToDTO(Appointment appointment) {
        AppointmentDTO dto = new AppointmentDTO();
        dto.setAppointmentId(appointment.getAppointmentId());
        dto.setPatientId(appointment.getPatientId());
        dto.setPatientName(appointment.getPatientName());
        dto.setDoctorId(appointment.getDoctorId());
        dto.setDoctorName(appointment.getDoctorName());
        dto.setAppointmentDate(appointment.getAppointmentDate());
        dto.setAppointmentTime(appointment.getAppointmentTime());
        dto.setStatus(appointment.getStatus());
        dto.setReason(appointment.getReason());
        dto.setDiagnosis(appointment.getDiagnosis());
        return dto;
    }
    
    private Appointment convertToEntity(AppointmentDTO dto) {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(dto.getAppointmentId());
        appointment.setPatientId(dto.getPatientId());
        appointment.setDoctorId(dto.getDoctorId());
        appointment.setAppointmentDate(dto.getAppointmentDate());
        appointment.setAppointmentTime(dto.getAppointmentTime());
        appointment.setReason(dto.getReason());
        return appointment;
    }
}
```

---

## ✅ LỢI ÍCH CỦA 3-LAYER ARCHITECTURE

### 1. **Separation of Concerns**
- Mỗi layer có trách nhiệm riêng biệt
- Dễ dàng maintain và debug
- Code rõ ràng, dễ đọc

### 2. **Reusability**
- Business logic có thể tái sử dụng
- Service có thể được gọi từ nhiều controller
- DAO có thể được gọi từ nhiều service

### 3. **Testability**
- Dễ dàng unit test từng layer
- Mock dependencies dễ dàng
- Test business logic độc lập với database

### 4. **Maintainability**
- Thay đổi database không ảnh hưởng business logic
- Thay đổi UI không ảnh hưởng business logic
- Dễ dàng thêm features mới

### 5. **Security**
- Validation tập trung tại Service Layer
- DTO che giấu thông tin nhạy cảm
- Business rules được enforce nhất quán

---

## 📊 SO SÁNH: TRƯỚC VÀ SAU KHI ÁP DỤNG 3-LAYER

### ❌ TRƯỚC (Chỉ MVC):

```java
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // Servlet chứa business logic
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        
        // Validation trong servlet (BAD!)
        if (username == null || username.isEmpty()) {
            request.setAttribute("error", "Username required");
            return;
        }
        
        // Check duplicate trong servlet (BAD!)
        if (userDAO.existsByUsername(username)) {
            request.setAttribute("error", "Username exists");
            return;
        }
        
        // Hash password trong servlet (BAD!)
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        // Gọi trực tiếp DAO
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(hashedPassword);
        userDAO.createUser(user);
    }
}
```

### ✅ SAU (3-Layer):

```java
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private UserService userService = new UserService();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Servlet chỉ xử lý HTTP, không có business logic
            UserDTO userDTO = new UserDTO();
            userDTO.setUsername(request.getParameter("username"));
            userDTO.setEmail(request.getParameter("email"));
            userDTO.setPassword(request.getParameter("password"));
            
            // Gọi Service Layer (tất cả business logic ở đây)
            userService.createUser(userDTO);
            
            response.sendRedirect("users?success=true");
            
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
            // Forward to form
        } catch (BusinessException e) {
            request.setAttribute("error", "Lỗi hệ thống");
            // Forward to error page
        }
    }
}
```

---

## 🎯 CHECKLIST ÁP DỤNG 3-LAYER

### Cho mỗi feature:

- [ ] Tạo DTO classes
- [ ] Tạo Service class với business logic
- [ ] Tạo/cập nhật DAO class (chỉ database access)
- [ ] Tạo Custom Exceptions
- [ ] Cập nhật Servlet (chỉ gọi Service, không gọi DAO)
- [ ] Validate dữ liệu trong Service
- [ ] Implement business rules trong Service
- [ ] Convert giữa Entity và DTO
- [ ] Handle exceptions properly
- [ ] Write unit tests cho Service Layer

---

## 📚 TÀI LIỆU THAM KHẢO

- [3-Tier Architecture](https://www.baeldung.com/cs/three-tier-architecture)
- [Service Layer Pattern](https://www.baeldung.com/java-service-layer-validation)
- [DTO Pattern](https://www.baeldung.com/java-dto-pattern)
- [Exception Handling Best Practices](https://www.baeldung.com/java-exceptions)

