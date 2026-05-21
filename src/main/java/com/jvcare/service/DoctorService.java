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
