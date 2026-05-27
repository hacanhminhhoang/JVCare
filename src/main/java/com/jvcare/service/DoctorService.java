package com.jvcare.service;

import com.jvcare.dao.DoctorDAO;
import com.jvcare.model.Doctor;
import com.jvcare.dto.DoctorDTO;
import com.jvcare.exception.BusinessException;

import java.util.List;
import java.util.ArrayList;

/**
 * Service Layer cho Doctor - chứa business logic
 */
public class DoctorService {
    
    private DoctorDAO doctorDAO = new DoctorDAO();
    private com.jvcare.dao.UserDAO userDAO = new com.jvcare.dao.UserDAO();
    
    /**
     * Lấy tất cả doctors
     */
    public List<DoctorDTO> getAllDoctors() throws BusinessException {
        try {
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            List<DoctorDTO> dtoList = new ArrayList<>();
            
            for (Doctor doctor : doctors) {
                dtoList.add(convertToDTO(doctor));
            }
            
            return dtoList;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy danh sách bác sĩ", e);
        }
    }
    
    /**
     * Lấy doctor theo ID
     */
    public DoctorDTO getDoctorById(int doctorId) throws BusinessException {
        try {
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            if (doctor == null) {
                return null;
            }
            return convertToDTO(doctor);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thông tin bác sĩ", e);
        }
    }
    
    /**
     * Tìm kiếm doctors
     */
    public List<DoctorDTO> searchDoctors(String keyword) throws BusinessException {
        try {
            if (keyword == null || keyword.trim().isEmpty()) {
                return getAllDoctors();
            }
            
            List<Doctor> doctors = doctorDAO.searchDoctors(keyword);
            List<DoctorDTO> dtoList = new ArrayList<>();
            
            for (Doctor doctor : doctors) {
                dtoList.add(convertToDTO(doctor));
            }
            
            return dtoList;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tìm kiếm bác sĩ", e);
        }
    }
    
    /**
     * Đếm tổng số doctors
     */
    public int getTotalDoctors() throws BusinessException {
        try {
            return doctorDAO.getTotalDoctors();
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi đếm số bác sĩ", e);
        }
    }
    
    /**
     * Cập nhật specialization của doctor
     */
    public boolean updateDoctorSpecialization(int doctorId, String specialization) throws BusinessException {
        try {
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            if (doctor == null) {
                throw new BusinessException("Bác sĩ không tồn tại");
            }
            
            doctor.setSpecialization(specialization);
            return doctorDAO.updateDoctor(doctor);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi cập nhật chuyên khoa", e);
        }
    }

    /**
     * Thêm mới Bác sĩ (Tạo User -> Tạo Doctor)
     */
    public boolean addDoctor(Doctor doctor, String password) throws BusinessException {
        try {
            if (doctor.getEmail() == null || doctor.getEmail().isEmpty()) {
                throw new BusinessException("Email không được để trống!");
            }
            if (userDAO.existsByEmail(doctor.getEmail())) {
                throw new BusinessException("Email đã tồn tại trong hệ thống!");
            }
            if (password == null || password.isEmpty()) {
                throw new BusinessException("Mật khẩu không được để trống!");
            }

            com.jvcare.model.User user = new com.jvcare.model.User();
            user.setUsername(doctor.getEmail());
            user.setPasswordHash(password);
            user.setFullName(doctor.getFullName());
            user.setEmail(doctor.getEmail());
            user.setPhone(doctor.getPhone());
            user.setRole("DOCTOR");
            user.setStatus(doctor.getStatus() != null ? doctor.getStatus() : "ACTIVE");

            boolean userCreated = userDAO.createUser(user);
            if (!userCreated) {
                throw new BusinessException("Không thể tạo tài khoản người dùng cho Bác sĩ!");
            }

            doctor.setUserId(user.getUserId());
            boolean doctorCreated = doctorDAO.createDoctor(doctor);
            
            if (!doctorCreated) {
                userDAO.deleteUser(user.getUserId());
                throw new BusinessException("Không thể tạo hồ sơ Bác sĩ!");
            }
            
            return true;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi thêm mới bác sĩ", e);
        }
    }

    /**
     * Cập nhật thông tin Bác sĩ
     */
    public boolean updateDoctor(Doctor doctor, String newPassword) throws BusinessException {
        try {
            com.jvcare.model.User user = userDAO.getUserById(doctor.getUserId());
            if (user == null) {
                throw new BusinessException("Không tìm thấy tài khoản người dùng của Bác sĩ!");
            }

            user.setFullName(doctor.getFullName());
            user.setEmail(doctor.getEmail());
            user.setPhone(doctor.getPhone());
            user.setStatus(doctor.getStatus());
            
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                user.setPasswordHash(newPassword.trim());
            }

            boolean userUpdated = userDAO.updateUser(user);
            if (!userUpdated) {
                throw new BusinessException("Lỗi khi cập nhật thông tin tài khoản!");
            }

            boolean doctorUpdated = doctorDAO.updateDoctor(doctor);
            if (!doctorUpdated) {
                throw new BusinessException("Lỗi khi cập nhật chuyên khoa Bác sĩ!");
            }
            
            return true;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi cập nhật bác sĩ", e);
        }
    }

    /**
     * Xóa Bác sĩ
     */
    public boolean deleteDoctor(int doctorId, int userId) throws BusinessException {
        try {
            boolean doctorDeleted = doctorDAO.deleteDoctor(doctorId);
            if (!doctorDeleted) {
                throw new BusinessException("Không thể xóa hồ sơ Bác sĩ!");
            }
            
            userDAO.deleteUser(userId);
            
            return true;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi xóa bác sĩ", e);
        }
    }
    
    // ==================== PRIVATE METHODS ====================
    
    /**
     * Convert Entity to DTO
     */
    private DoctorDTO convertToDTO(Doctor doctor) {
        DoctorDTO dto = new DoctorDTO();
        dto.setDoctorId(doctor.getDoctorId());
        dto.setUserId(doctor.getUserId());
        dto.setFullName(doctor.getFullName());
        dto.setEmail(doctor.getEmail());
        dto.setPhone(doctor.getPhone());
        dto.setSpecialization(doctor.getSpecialization());
        dto.setStatus(doctor.getStatus());
        return dto;
    }
}
