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
import java.util.ArrayList;

/**
 * Service Layer cho User - chứa business logic
 */
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
            List<UserDTO> dtoList = new ArrayList<>();
            
            for (User user : users) {
                dtoList.add(convertToDTO(user));
            }
            
            return dtoList;
                       
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
            user.setUsername(existingUser.getUsername()); // Keep username
            user.setRole(existingUser.getRole()); // Keep role
            
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
            List<UserDTO> dtoList = new ArrayList<>();
            
            for (User user : users) {
                dtoList.add(convertToDTO(user));
            }
            
            return dtoList;
                       
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
            
            UserDTO dto = convertToDTO(user);
            
            // Nếu là DOCTOR, lấy thêm specialization
            if ("DOCTOR".equals(user.getRole())) {
                Doctor doctor = doctorDAO.getDoctorByUserId(userId);
                if (doctor != null) {
                    dto.setSpecialization(doctor.getSpecialization());
                }
            }
            
            return dto;
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
        if (userDTO.getRole() == null) {
            throw new ValidationException("Role không được để trống");
        }
        
        if (!userDTO.getRole().equals("ADMIN") && 
            !userDTO.getRole().equals("DOCTOR") && 
            !userDTO.getRole().equals("PATIENT")) {
            throw new ValidationException("Role không hợp lệ");
        }
        
        // Phone validation (optional)
        if (userDTO.getPhone() != null && !userDTO.getPhone().isEmpty()) {
            if (!userDTO.getPhone().matches("^[0-9]{10,11}$")) {
                throw new ValidationException("Số điện thoại không hợp lệ (phải có 10-11 chữ số)");
            }
        }
        
        // Specialization validation for DOCTOR
        if ("DOCTOR".equals(userDTO.getRole()) && isCreate) {
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
