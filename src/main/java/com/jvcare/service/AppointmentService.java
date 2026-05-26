package com.jvcare.service;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.Appointment;
import com.jvcare.dto.AppointmentDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AppointmentService {
    
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    public boolean bookAppointment(AppointmentDTO dto) throws BusinessException, ValidationException {
        try {
            validateAppointment(dto);
            
            // Check business rules
            
            // 1. Giới hạn 3 pending appointments / patient
            List<AppointmentDTO> list = getAppointmentsByPatient(dto.getPatientId());
            long pendingCount = list.stream().filter(a -> "PENDING".equalsIgnoreCase(a.getStatus())).count();
            if (pendingCount >= 3) {
                throw new ValidationException("Bệnh nhân không được đặt quá 3 lịch hẹn ở trạng thái PENDING");
            }
            
            // 2. Check duplicate appointment
            if (appointmentDAO.checkDuplicateAppointment(dto.getPatientId(), dto.getAppointmentDate(), dto.getAppointmentTime())) {
                throw new ValidationException("Bạn đã có lịch hẹn vào thời gian này!");
            }
            
            // Convert to Entity and Save
            Appointment a = convertToEntity(dto);
            boolean success = appointmentDAO.createAppointment(a);
            
            if (success) {
                sendConfirmationEmail(dto);
            }
            return success;
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi đặt lịch khám", e);
        }
    }
    
    public List<AppointmentDTO> getAppointmentsByPatient(int patientId) throws BusinessException {
        try {
            List<Appointment> list = appointmentDAO.getAppointmentsByPatientId(patientId);
            List<AppointmentDTO> dtoList = new ArrayList<>();
            for (Appointment a : list) {
                dtoList.add(convertToDTO(a));
            }
            return dtoList;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy danh sách lịch hẹn của bệnh nhân", e);
        }
    }
    
    public AppointmentDTO getAppointmentById(int appointmentId) throws BusinessException {
        try {
            Appointment a = appointmentDAO.getAppointmentById(appointmentId);
            if (a == null) return null;
            return convertToDTO(a);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy thông tin lịch hẹn", e);
        }
    }
    
    public boolean cancelAppointment(int appointmentId, int patientId) throws BusinessException, ValidationException {
        try {
            Appointment a = appointmentDAO.getAppointmentById(appointmentId);
            if (a == null) {
                throw new ValidationException("Lịch hẹn không tồn tại");
            }
            if (a.getPatientId() != patientId) {
                throw new ValidationException("Không có quyền hủy lịch hẹn này");
            }
            if (!"PENDING".equalsIgnoreCase(a.getStatus())) {
                throw new ValidationException("Chỉ được hủy lịch hẹn ở trạng thái PENDING");
            }
            
            // Phải hủy trước ít nhất 24 giờ
            LocalDate appDate = a.getAppointmentDate().toLocalDate();
            LocalTime appTime = a.getAppointmentTime().toLocalTime();
            java.time.LocalDateTime appDateTime = java.time.LocalDateTime.of(appDate, appTime);
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            
            if (now.plusHours(24).isAfter(appDateTime)) {
                throw new ValidationException("Phải hủy lịch hẹn trước ít nhất 24 giờ so với giờ hẹn");
            }
            
            return appointmentDAO.cancelAppointment(appointmentId, patientId);
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi hủy lịch hẹn", e);
        }
    }
    
    public List<String> getAvailableTimeSlots(Date date, int doctorId) throws BusinessException {
        try {
            return appointmentDAO.getAvailableTimeSlots(date, doctorId);
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy khung giờ trống", e);
        }
    }
    
    private void validateAppointment(AppointmentDTO dto) throws ValidationException {
        if (dto == null) {
            throw new ValidationException("Dữ liệu cuộc hẹn không được trống");
        }
        if (dto.getAppointmentDate() == null) {
            throw new ValidationException("Ngày hẹn không được để trống");
        }
        if (dto.getAppointmentTime() == null) {
            throw new ValidationException("Giờ hẹn không được để trống");
        }
        
        LocalDate today = LocalDate.now();
        LocalDate appDate = dto.getAppointmentDate().toLocalDate();
        
        if (appDate.isBefore(today)) {
            throw new ValidationException("Không thể đặt lịch trong quá khứ");
        }
        if (appDate.isAfter(today.plusMonths(3))) {
            throw new ValidationException("Không thể đặt lịch hẹn trước quá 3 tháng");
        }
        if (dto.getReason() == null || dto.getReason().trim().isEmpty()) {
            throw new ValidationException("Vui lòng nhập lý do khám bệnh");
        }
    }
    
    public void sendConfirmationEmail(AppointmentDTO dto) {
        System.out.println("Gửi email xác nhận cuộc hẹn thành công cho bệnh nhân tại ID: " + dto.getPatientId());
    }
    
    // Helpers
    private AppointmentDTO convertToDTO(Appointment a) {
        AppointmentDTO dto = new AppointmentDTO();
        dto.setAppointmentId(a.getAppointmentId());
        dto.setPatientId(a.getPatientId());
        dto.setPatientName(a.getPatientName());
        dto.setDoctorId(a.getDoctorId());
        dto.setDoctorName(a.getDoctorName());
        dto.setDoctorSpecialization(a.getDoctorSpecialization());
        dto.setAppointmentDate(a.getAppointmentDate());
        dto.setAppointmentTime(a.getAppointmentTime());
        dto.setStatus(a.getStatus());
        dto.setReason(a.getReason());
        dto.setNotes(a.getNotes());
        dto.setDiagnosis(a.getDiagnosis());
        dto.setPatientCondition(a.getPatientCondition());
        dto.setAdvice(a.getAdvice());
        return dto;
    }
    
    private Appointment convertToEntity(AppointmentDTO dto) {
        Appointment a = new Appointment();
        a.setAppointmentId(dto.getAppointmentId());
        a.setPatientId(dto.getPatientId());
        a.setDoctorId(dto.getDoctorId());
        a.setAppointmentDate(dto.getAppointmentDate());
        a.setAppointmentTime(dto.getAppointmentTime());
        a.setStatus(dto.getStatus());
        a.setReason(dto.getReason());
        a.setNotes(dto.getNotes());
        a.setDiagnosis(dto.getDiagnosis());
        a.setPatientCondition(dto.getPatientCondition());
        a.setAdvice(dto.getAdvice());
        return a;
    }
}
