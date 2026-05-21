# TASK 1: ADMIN - QUẢN LÝ USERS & DOCTORS (3-LAYER)

## 📋 CẤU TRÚC 3 LỚP

```
PRESENTATION LAYER
  └── AdminUserServlet.java
           ↓
BUSINESS LOGIC LAYER
  └── UserService.java
           ↓
DATA ACCESS LAYER
  └── UserDAO.java
           ↓
       DATABASE
```

---

## 📝 BƯỚC 1: TẠO DTO CLASSES

### UserDTO.java

```java
package com.jvcare.dto;

public class UserDTO {
    private int userId;
    private String username;
    private String password; // Only for creation
    private String email;
    private String fullName;
    private String role; // ADMIN, DOCTOR, PATIENT
    private String phone;
    private String status; // ACTIVE, INACTIVE
    
    // For doctor
    private String specialization;
    
    // Constructors
    public UserDTO() {}
    
    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }
}
```

### DoctorDTO.java

```java
package com.jvcare.dto;

public class DoctorDTO {
    private int doctorId;
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String specialization;
    private String status;
    
    // Statistics
    private int totalAppointments;
    private int totalPatients;
    
    // Constructors
    public DoctorDTO() {}
    
    // Getters and Setters
    // ... (tạo đầy đủ)
}
```

---

## 📝 BƯỚC 2: TẠO CUSTOM EXCEPTIONS

### BusinessException.java

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

### ValidationException.java

```java
package com.jvcare.exception;

public class ValidationException extends Exception {
    public ValidationException(String message) {
        super(message);
    }
}
```

---

## 📝 BƯỚC 3: TẠO USER SERVICE

### UserService.java

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
            // Validate pagination parameters
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 10;
            
            List<User> users = userDAO.getAllUsers(page, pageSize);
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
            validateUser(userDTO, true);
            
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
            user.setStatus("ACTIVE");
            
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
            validateUser(userDTO, false);
            
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
            user.setPasswordHash(existingUser.getPasswordHash()); // Keep old password
            
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
    public boolean deleteUser(int userId) throws BusinessException, ValidationException {
        try {
            // Check if user exists
            User user = userDAO.getUserById(userId);
            if (user == null) {
                throw new ValidationException("User không tồn tại");
            }
            
            // Business rule: Cannot delete admin if it's the last admin
            if ("ADMIN".equals(user.getRole())) {
                int adminCount = userDAO.countUsersByRole("ADMIN");
                if (adminCount <= 1) {
                    throw new BusinessException("Không thể xóa admin cuối cùng trong hệ thống");
                }
            }
            
            // Business rule: Cannot delete user with active appointments
            // TODO: Check if user has active appointments
            
            return userDAO.deleteUser(userId);
            
        } catch (ValidationException e) {
            throw e;
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
     * Lấy user theo ID
     */
    public UserDTO getUserById(int userId) throws BusinessException {
        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                return null;
            }
            return convertToDTO(user);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thông tin user", e);
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
    private void validateUser(UserDTO userDTO, boolean isCreate) throws ValidationException {
        if (userDTO == null) {
            throw new ValidationException("User data không được null");
        }
        
        // Username validation
        if (userDTO.getUsername() == null || userDTO.getUsername().trim().isEmpty()) {
            throw new ValidationException("Username không được để trống");
        }
        
        if (userDTO.getUsername().length() < 3 || userDTO.getUsername().length() > 50) {
            throw new ValidationException("Username phải từ 3-50 ký tự");
        }
        
        if (!userDTO.getUsername().matches("^[a-zA-Z0-9_]+$")) {
            throw new ValidationException("Username chỉ được chứa chữ cái, số và dấu gạch dưới");
        }
        
        // Password validation (only for creation)
        if (isCreate) {
            if (userDTO.getPassword() == null || userDTO.getPassword().isEmpty()) {
                throw new ValidationException("Password không được để trống");
            }
            
            if (userDTO.getPassword().length() < 6) {
                throw new ValidationException("Password phải có ít nhất 6 ký tự");
            }
        }
        
        // Email validation
        if (userDTO.getEmail() == null || !userDTO.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new ValidationException("Email không hợp lệ");
        }
        
        // Full name validation
        if (userDTO.getFullName() == null || userDTO.getFullName().trim().isEmpty()) {
            throw new ValidationException("Họ tên không được để trống");
        }
        
        if (userDTO.getFullName().length() > 100) {
            throw new ValidationException("Họ tên không được quá 100 ký tự");
        }
        
        // Role validation
        if (userDTO.getRole() == null || 
            !List.of("ADMIN", "DOCTOR", "PATIENT").contains(userDTO.getRole())) {
            throw new ValidationException("Role không hợp lệ");
        }
        
        // Phone validation (optional)
        if (userDTO.getPhone() != null && !userDTO.getPhone().isEmpty()) {
            if (!userDTO.getPhone().matches("^[0-9]{10,11}$")) {
                throw new ValidationException("Số điện thoại không hợp lệ");
            }
        }
        
        // Specialization validation for DOCTOR
        if ("DOCTOR".equals(userDTO.getRole())) {
            if (userDTO.getSpecialization() == null || userDTO.getSpecialization().trim().isEmpty()) {
                throw new ValidationException("Chuyên khoa không được để trống cho bác sĩ");
            }
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
        // Note: Password is NOT included in DTO for security
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

## 📝 BƯỚC 4: CẬP NHẬT SERVLET

### AdminUserServlet.java (Sử dụng Service Layer)

```java
package com.jvcare.controller;

import com.jvcare.service.UserService;
import com.jvcare.dto.UserDTO;
import com.jvcare.model.User;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    
    private UserService userService = new UserService(); // Gọi Service, KHÔNG gọi DAO
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                showEditForm(request, response);
            } else if ("delete".equals(action)) {
                deleteUser(request, response);
            } else {
                listUsers(request, response);
            }
        } catch (BusinessException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createUser(request, response);
            } else if ("update".equals(action)) {
                updateUser(request, response);
            }
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp")
                   .forward(request, response);
        } catch (BusinessException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp")
                   .forward(request, response);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, BusinessException {
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Call Service Layer
        List<UserDTO> users = userService.getAllUsers(page, pageSize);
        int totalUsers = userService.getTotalUsers();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        
        // Set attributes
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        // Forward to view
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp")
               .forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, BusinessException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        
        // Call Service Layer
        UserDTO user = userService.getUserById(userId);
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp")
               .forward(request, response);
    }
    
    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, BusinessException, ValidationException {
        
        // Create DTO from request parameters
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername(request.getParameter("username"));
        userDTO.setPassword(request.getParameter("password"));
        userDTO.setEmail(request.getParameter("email"));
        userDTO.setFullName(request.getParameter("fullName"));
        userDTO.setRole(request.getParameter("role"));
        userDTO.setPhone(request.getParameter("phone"));
        userDTO.setSpecialization(request.getParameter("specialization"));
        
        // Call Service Layer (all business logic here)
        boolean success = userService.createUser(userDTO);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
        } else {
            throw new BusinessException("Không thể tạo user");
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, BusinessException, ValidationException {
        
        // Create DTO from request parameters
        UserDTO userDTO = new UserDTO();
        userDTO.setUserId(Integer.parseInt(request.getParameter("userId")));
        userDTO.setEmail(request.getParameter("email"));
        userDTO.setFullName(request.getParameter("fullName"));
        userDTO.setPhone(request.getParameter("phone"));
        userDTO.setStatus(request.getParameter("status"));
        
        // Call Service Layer
        boolean success = userService.updateUser(userDTO);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
        } else {
            throw new BusinessException("Không thể cập nhật user");
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, BusinessException, ValidationException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        
        // Call Service Layer
        boolean success = userService.deleteUser(userId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
        } else {
            throw new BusinessException("Không thể xóa user");
        }
    }
    
    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        
        return true;
    }
}
```

---

## ✅ CHECKLIST HOÀN THÀNH

- [ ] Tạo UserDTO.java
- [ ] Tạo DoctorDTO.java
- [ ] Tạo BusinessException.java
- [ ] Tạo ValidationException.java
- [ ] Tạo UserService.java với đầy đủ business logic
- [ ] Tạo DoctorService.java
- [ ] Cập nhật AdminUserServlet.java (gọi Service)
- [ ] Cập nhật AdminDoctorServlet.java (gọi Service)
- [ ] Test tất cả chức năng
- [ ] Viết unit tests cho Service Layer

