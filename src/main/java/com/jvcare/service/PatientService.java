package com.jvcare.service;

import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.model.Patient;
import com.jvcare.model.MedicalRecord;
import com.jvcare.dto.PatientDTO;
import com.jvcare.dto.MedicalRecordDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.stream.Collectors;

public class PatientService {
    
    private final PatientDAO patientDAO = new PatientDAO();
    private final MedicalRecordDAO recordDAO = new MedicalRecordDAO();
    
    public PatientDTO getPatientByUserId(int userId) throws BusinessException {
        try {
            Patient p = patientDAO.getPatientByUserId(userId);
            if (p == null) return null;
            return convertToDTO(p);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thông tin bệnh nhân", e);
        }
    }
    
    public PatientDTO getPatientById(int patientId) throws BusinessException {
        try {
            Patient p = patientDAO.getPatientById(patientId);
            if (p == null) return null;
            return convertToDTO(p);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thông tin bệnh nhân theo ID", e);
        }
    }
    
    public boolean updateProfile(PatientDTO patientDTO) throws BusinessException, ValidationException {
        try {
            validatePatientData(patientDTO);
            
            Patient existing = patientDAO.getPatientById(patientDTO.getPatientId());
            if (existing == null) {
                throw new ValidationException("Bệnh nhân không tồn tại");
            }
            
            Patient p = convertToEntity(patientDTO);
            return patientDAO.updatePatientProfile(p);
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi cập nhật hồ sơ bệnh nhân", e);
        }
    }
    
    public String uploadAvatar(int patientId, String fileName, InputStream fileContent, String uploadPath) 
            throws BusinessException, ValidationException {
        try {
            Patient existing = patientDAO.getPatientById(patientId);
            if (existing == null) {
                throw new ValidationException("Bệnh nhân không tồn tại");
            }
            
            // Validate file extension
            String ext = "";
            int i = fileName.lastIndexOf('.');
            if (i > 0) {
                ext = fileName.substring(i + 1).toLowerCase();
            }
            if (!ext.equals("jpg") && !ext.equals("png") && !ext.equals("jpeg")) {
                throw new ValidationException("Định dạng file không hợp lệ (chỉ chấp nhận JPG/PNG/JPEG)");
            }
            
            // Save file
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            String newFileName = "avatar_" + patientId + "_" + System.currentTimeMillis() + "." + ext;
            File destFile = new File(uploadDir, newFileName);
            Files.copy(fileContent, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            
            String avatarUrl = "images/avatars/" + newFileName;
            existing.setAvatarUrl(avatarUrl);
            patientDAO.updatePatientProfile(existing);
            
            return avatarUrl;
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tải ảnh đại diện lên", e);
        }
    }
    
    public List<MedicalRecordDTO> getMedicalHistory(int patientId) throws BusinessException {
        try {
            List<MedicalRecord> list = recordDAO.getRecordsByPatientId(patientId);
            return list.stream().map(this::convertRecordToDTO).collect(Collectors.toList());
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy lịch sử bệnh án", e);
        }
    }
    
    private void validatePatientData(PatientDTO dto) throws ValidationException {
        if (dto == null) {
            throw new ValidationException("Dữ liệu bệnh nhân không được để trống");
        }
        if (dto.getFullName() == null || dto.getFullName().trim().isEmpty()) {
            throw new ValidationException("Họ tên không được để trống");
        }
        if (dto.getPhone() != null && !dto.getPhone().matches("^0[35789]\\d{8}$")) {
            throw new ValidationException("Số điện thoại không hợp lệ (VD: 0987654321)");
        }
        if (dto.getEmail() != null && !dto.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new ValidationException("Email không hợp lệ");
        }
    }
    
    private PatientDTO convertToDTO(Patient p) {
        PatientDTO dto = new PatientDTO();
        dto.setPatientId(p.getPatientId());
        dto.setUserId(p.getUserId());
        dto.setPatientCode(p.getPatientCode());
        dto.setFullName(p.getFullName());
        dto.setDateOfBirth(p.getDateOfBirth());
        dto.setGender(p.getGender());
        dto.setPhone(p.getPhone());
        dto.setEmail(p.getEmail());
        dto.setAddress(p.getAddress());
        dto.setAllergies(p.getAllergies());
        dto.setChronicDiseases(p.getChronicDiseases());
        dto.setAvatarUrl(p.getAvatarUrl());
        dto.setIdCard(p.getIdCard());
        return dto;
    }
    
    private Patient convertToEntity(PatientDTO dto) {
        Patient p = new Patient();
        p.setPatientId(dto.getPatientId());
        p.setUserId(dto.getUserId());
        p.setPatientCode(dto.getPatientCode());
        p.setFullName(dto.getFullName());
        p.setDateOfBirth(dto.getDateOfBirth());
        p.setGender(dto.getGender());
        p.setPhone(dto.getPhone());
        p.setEmail(dto.getEmail());
        p.setAddress(dto.getAddress());
        p.setAllergies(dto.getAllergies());
        p.setChronicDiseases(dto.getChronicDiseases());
        p.setAvatarUrl(dto.getAvatarUrl());
        p.setIdCard(dto.getIdCard());
        return p;
    }
    
    private MedicalRecordDTO convertRecordToDTO(MedicalRecord record) {
        MedicalRecordDTO dto = new MedicalRecordDTO();
        dto.setRecordId(record.getRecordId());
        dto.setRecordCode(record.getRecordCode());
        dto.setPatientId(record.getPatientId());
        dto.setDoctorId(record.getDoctorId());
        dto.setAppointmentId(record.getAppointmentId());
        dto.setVisitDate(record.getVisitDate());
        dto.setChiefComplaint(record.getChiefComplaint());
        dto.setDiagnosis(record.getDiagnosis());
        dto.setTreatmentPlan(record.getTreatmentPlan());
        dto.setNotes(record.getNotes());
        dto.setBloodPressure(record.getBloodPressure());
        dto.setHeartRate(record.getHeartRate());
        dto.setTemperature(record.getTemperature());
        dto.setWeight(record.getWeight());
        dto.setHeight(record.getHeight());
        dto.setPatientName(record.getPatientName());
        dto.setPatientCode(record.getPatientCode());
        dto.setDoctorName(record.getDoctorName());
        return dto;
    }
}
