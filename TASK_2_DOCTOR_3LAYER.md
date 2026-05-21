# TASK 2: DOCTOR - BỆNH ÁN & ĐƠN THUỐC (3-LAYER)

## 📋 CẤU TRÚC 3 LỚP

```
PRESENTATION LAYER
  ├── DoctorMedicalRecordServlet.java
  └── DoctorPrescriptionServlet.java
           ↓
BUSINESS LOGIC LAYER
  ├── MedicalRecordService.java
  └── PrescriptionService.java
           ↓
DATA ACCESS LAYER
  ├── MedicalRecordDAO.java
  └── PrescriptionDAO.java
           ↓
       DATABASE
```

---

## 📝 BƯỚC 1: TẠO DTO CLASSES

### MedicalRecordDTO.java

```java
package com.jvcare.dto;

import java.sql.Timestamp;
import java.util.List;

public class MedicalRecordDTO {
    private int recordId;
    private int patientId;
    private String patientName;
    private String patientCode;
    private int doctorId;
    private String doctorName;
    private int appointmentId;
    private Timestamp visitDate;
    
    // Diagnosis & Treatment
    private String diagnosis;
    private String treatmentPlan;
    private String notes;
    
    // Vital Signs
    private String bloodPressure;
    private int heartRate;
    private double temperature;
    private double weight;
    private double height;
    
    // Calculated fields
    private double bmi;
    
    // Related data
    private List<PrescriptionDTO> prescriptions;
    
    // Constructors
    public MedicalRecordDTO() {}
    
    // Getters and Setters
    // ... (tạo đầy đủ)
}
```

### PrescriptionDTO.java

```java
package com.jvcare.dto;

public class PrescriptionDTO {
    private int prescriptionId;
    private int recordId;
    private String medicationName;
    private String dosage;
    private String frequency;
    private int durationDays;
    private String instructions;
    
    // Constructors
    public PrescriptionDTO() {}
    
    // Getters and Setters
    // ... (tạo đầy đủ)
}
```



---

## 📝 BƯỚC 2: TẠO MEDICAL RECORD SERVICE

### MedicalRecordService.java

```java
package com.jvcare.service;

import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.dao.PrescriptionDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.MedicalRecord;
import com.jvcare.dto.MedicalRecordDTO;
import com.jvcare.dto.PrescriptionDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import java.util.List;
import java.util.stream.Collectors;

public class MedicalRecordService {
    
    private MedicalRecordDAO recordDAO = new MedicalRecordDAO();
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    /**
     * Lấy tất cả bệnh án của bác sĩ
     */
    public List<MedicalRecordDTO> getRecordsByDoctor(int doctorId) 
            throws BusinessException {
        try {
            if (doctorId <= 0) {
                throw new ValidationException("Doctor ID không hợp lệ");
            }
            
            List<MedicalRecord> records = recordDAO.getRecordsByDoctorId(doctorId);
            return records.stream()
                         .map(this::convertToDTO)
                         .collect(Collectors.toList());
                         
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy danh sách bệnh án", e);
        }
    }
    
    /**
     * Lấy chi tiết bệnh án kèm đơn thuốc
     */
    public MedicalRecordDTO getRecordWithPrescriptions(int recordId) 
            throws BusinessException {
        try {
            MedicalRecord record = recordDAO.getRecordById(recordId);
            if (record == null) {
                throw new ValidationException("Bệnh án không tồn tại");
            }
            
            MedicalRecordDTO dto = convertToDTO(record);
            
            // Load prescriptions
            List<Prescription> prescriptions = 
                prescriptionDAO.getPrescriptionsByRecordId(recordId);
            dto.setPrescriptions(prescriptions.stream()
                .map(this::convertPrescriptionToDTO)
                .collect(Collectors.toList()));
            
            return dto;
            
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy chi tiết bệnh án", e);
        }
    }
    
    /**
     * Tạo bệnh án mới từ appointment
     */
    public int createRecordFromAppointment(int appointmentId, int doctorId, 
            MedicalRecordDTO recordDTO) throws BusinessException, ValidationException {
        try {
            // 1. Validate input
            validateMedicalRecord(recordDTO);
            
            // 2. Check if appointment exists and is completed
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                throw new ValidationException("Lịch hẹn không tồn tại");
            }
            
            if (!"COMPLETED".equals(appointment.getStatus())) {
                throw new BusinessException(
                    "Chỉ có thể tạo bệnh án từ lịch hẹn đã hoàn thành");
            }
            
            // 3. Check if record already exists for this appointment
            // TODO: Add method to check duplicate
            
            // 4. Validate vital signs
            validateVitalSigns(recordDTO);
            
            // 5. Calculate BMI if weight and height provided
            if (recordDTO.getWeight() > 0 && recordDTO.getHeight() > 0) {
                double bmi = calculateBMI(recordDTO.getWeight(), recordDTO.getHeight());
                recordDTO.setBmi(bmi);
            }
            
            // 6. Convert DTO to Entity
            MedicalRecord record = convertToEntity(recordDTO);
            record.setDoctorId(doctorId);
            record.setPatientId(appointment.getPatientId());
            
            // 7. Save to database
            int recordId = recordDAO.createRecordFromAppointment(
                appointmentId, doctorId, record);
            
            if (recordId <= 0) {
                throw new BusinessException("Không thể tạo bệnh án");
            }
            
            return recordId;
            
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tạo bệnh án", e);
        }
    }
    
    /**
     * Cập nhật bệnh án
     */
    public boolean updateRecord(MedicalRecordDTO recordDTO, int doctorId) 
            throws BusinessException, ValidationException {
        try {
            // Validate
            validateMedicalRecord(recordDTO);
            validateVitalSigns(recordDTO);
            
            // Check if record exists and belongs to this doctor
            MedicalRecord existingRecord = recordDAO.getRecordById(recordDTO.getRecordId());
            if (existingRecord == null) {
                throw new ValidationException("Bệnh án không tồn tại");
            }
            
            if (existingRecord.getDoctorId() != doctorId) {
                throw new BusinessException("Bạn không có quyền sửa bệnh án này");
            }
            
            // Calculate BMI
            if (recordDTO.getWeight() > 0 && recordDTO.getHeight() > 0) {
                double bmi = calculateBMI(recordDTO.getWeight(), recordDTO.getHeight());
                recordDTO.setBmi(bmi);
            }
            
            // Convert and update
            MedicalRecord record = convertToEntity(recordDTO);
            record.setDoctorId(doctorId);
            
            return recordDAO.updateRecord(record);
            
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi cập nhật bệnh án", e);
        }
    }

    
    // ==================== PRIVATE METHODS ====================
    
    /**
     * Validate medical record data
     */
    private void validateMedicalRecord(MedicalRecordDTO dto) throws ValidationException {
        if (dto == null) {
            throw new ValidationException("Medical record data không được null");
        }
        
        if (dto.getDiagnosis() == null || dto.getDiagnosis().trim().isEmpty()) {
            throw new ValidationException("Chẩn đoán không được để trống");
        }
        
        if (dto.getDiagnosis().length() > 500) {
            throw new ValidationException("Chẩn đoán không được quá 500 ký tự");
        }
        
        if (dto.getTreatmentPlan() == null || dto.getTreatmentPlan().trim().isEmpty()) {
            throw new ValidationException("Phương án điều trị không được để trống");
        }
        
        if (dto.getTreatmentPlan().length() > 1000) {
            throw new ValidationException("Phương án điều trị không được quá 1000 ký tự");
        }
    }
    
    /**
     * Validate vital signs
     */
    private void validateVitalSigns(MedicalRecordDTO dto) throws ValidationException {
        // Blood pressure format: "120/80"
        if (dto.getBloodPressure() != null && !dto.getBloodPressure().isEmpty()) {
            if (!dto.getBloodPressure().matches("\\d{2,3}/\\d{2,3}")) {
                throw new ValidationException(
                    "Huyết áp không đúng định dạng (VD: 120/80)");
            }
        }
        
        // Heart rate: 40-200 bpm
        if (dto.getHeartRate() > 0) {
            if (dto.getHeartRate() < 40 || dto.getHeartRate() > 200) {
                throw new ValidationException("Nhịp tim phải trong khoảng 40-200 bpm");
            }
        }
        
        // Temperature: 35-42°C
        if (dto.getTemperature() > 0) {
            if (dto.getTemperature() < 35 || dto.getTemperature() > 42) {
                throw new ValidationException("Nhiệt độ phải trong khoảng 35-42°C");
            }
        }
        
        // Weight: > 0 kg
        if (dto.getWeight() > 0 && dto.getWeight() > 300) {
            throw new ValidationException("Cân nặng không hợp lệ");
        }
        
        // Height: > 0 cm
        if (dto.getHeight() > 0 && (dto.getHeight() < 50 || dto.getHeight() > 250)) {
            throw new ValidationException("Chiều cao phải trong khoảng 50-250 cm");
        }
    }
    
    /**
     * Calculate BMI (Body Mass Index)
     */
    private double calculateBMI(double weight, double height) {
        // BMI = weight(kg) / (height(m))^2
        double heightInMeters = height / 100.0;
        double bmi = weight / (heightInMeters * heightInMeters);
        return Math.round(bmi * 10.0) / 10.0; // Round to 1 decimal
    }
    
    /**
     * Convert Entity to DTO
     */
    private MedicalRecordDTO convertToDTO(MedicalRecord record) {
        MedicalRecordDTO dto = new MedicalRecordDTO();
        dto.setRecordId(record.getRecordId());
        dto.setPatientId(record.getPatientId());
        dto.setPatientName(record.getPatientName());
        dto.setPatientCode(record.getPatientCode());
        dto.setDoctorId(record.getDoctorId());
        dto.setDoctorName(record.getDoctorName());
        dto.setAppointmentId(record.getAppointmentId());
        dto.setVisitDate(record.getVisitDate());
        dto.setDiagnosis(record.getDiagnosis());
        dto.setTreatmentPlan(record.getTreatmentPlan());
        dto.setNotes(record.getNotes());
        dto.setBloodPressure(record.getBloodPressure());
        dto.setHeartRate(record.getHeartRate());
        dto.setTemperature(record.getTemperature());
        dto.setWeight(record.getWeight());
        dto.setHeight(record.getHeight());
        
        // Calculate BMI if data available
        if (record.getWeight() > 0 && record.getHeight() > 0) {
            dto.setBmi(calculateBMI(record.getWeight(), record.getHeight()));
        }
        
        return dto;
    }
    
    /**
     * Convert DTO to Entity
     */
    private MedicalRecord convertToEntity(MedicalRecordDTO dto) {
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(dto.getRecordId());
        record.setPatientId(dto.getPatientId());
        record.setDoctorId(dto.getDoctorId());
        record.setAppointmentId(dto.getAppointmentId());
        record.setVisitDate(dto.getVisitDate());
        record.setDiagnosis(dto.getDiagnosis());
        record.setTreatmentPlan(dto.getTreatmentPlan());
        record.setNotes(dto.getNotes());
        record.setBloodPressure(dto.getBloodPressure());
        record.setHeartRate(dto.getHeartRate());
        record.setTemperature(dto.getTemperature());
        record.setWeight(dto.getWeight());
        record.setHeight(dto.getHeight());
        return record;
    }
}
```

