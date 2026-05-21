package com.jvcare.service;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.dao.PrescriptionDAO;
import com.jvcare.dto.MedicalRecordDTO;
import com.jvcare.dto.PrescriptionDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import com.jvcare.model.Appointment;
import com.jvcare.model.MedicalRecord;
import com.jvcare.model.Prescription;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Business Logic Layer cho Bệnh án.
 * Xử lý logic nghiệp vụ: validate, tính toán BMI, kiểm tra quyền sở hữu bệnh án,
 * chuyển đổi giữa Entity và DTO trước khi gọi xuống DAO layer.
 */
public class MedicalRecordService {

    private final MedicalRecordDAO recordDAO = new MedicalRecordDAO();
    private final PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    // ==================== PUBLIC METHODS ====================

    /**
     * Lấy danh sách bệnh án theo bác sĩ.
     */
    public List<MedicalRecordDTO> getRecordsByDoctor(int doctorId) throws BusinessException {
        try {
            if (doctorId <= 0) {
                throw new ValidationException("Doctor ID không hợp lệ");
            }
            List<MedicalRecord> records = recordDAO.getRecordsByDoctorId(doctorId);
            return records.stream()
                          .map(this::convertToDTO)
                          .collect(Collectors.toList());
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy danh sách bệnh án", e);
        }
    }

    /**
     * Lấy chi tiết một bệnh án kèm danh sách đơn thuốc.
     */
    public MedicalRecordDTO getRecordWithPrescriptions(int recordId) throws BusinessException {
        try {
            MedicalRecord record = recordDAO.getRecordById(recordId);
            if (record == null) {
                throw new ValidationException("Bệnh án không tồn tại");
            }

            MedicalRecordDTO dto = convertToDTO(record);

            // Nạp danh sách đơn thuốc liên quan
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByRecordId(recordId);
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
     * Tạo bệnh án mới từ một lịch hẹn đã hoàn thành.
     */
    public int createRecordFromAppointment(int appointmentId, int doctorId,
            MedicalRecordDTO recordDTO) throws BusinessException, ValidationException {
        try {
            // 1. Validate dữ liệu đầu vào
            validateMedicalRecord(recordDTO);
            validateVitalSigns(recordDTO);

            // 2. Kiểm tra lịch hẹn tồn tại và đã hoàn thành
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                throw new ValidationException("Lịch hẹn không tồn tại");
            }
            if (!"COMPLETED".equals(appointment.getStatus())) {
                throw new BusinessException("Chỉ có thể tạo bệnh án từ lịch hẹn đã hoàn thành");
            }

            // 3. Tính BMI nếu có đủ dữ liệu
            if (recordDTO.getWeight() > 0 && recordDTO.getHeight() > 0) {
                recordDTO.setBmi(calculateBMI(recordDTO.getWeight(), recordDTO.getHeight()));
            }

            // 4. Chuyển DTO → Entity và lưu vào database
            MedicalRecord record = convertToEntity(recordDTO);
            record.setDoctorId(doctorId);
            record.setPatientId(appointment.getPatientId());

            int newRecordId = recordDAO.createRecordFromAppointment(appointmentId, doctorId, record);
            if (newRecordId <= 0) {
                throw new BusinessException("Không thể tạo bệnh án, vui lòng thử lại");
            }

            return newRecordId;

        } catch (ValidationException e) {
            throw e;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tạo bệnh án", e);
        }
    }

    /**
     * Cập nhật thông tin bệnh án. Chỉ bác sĩ tạo ra bệnh án mới được sửa.
     */
    public boolean updateRecord(MedicalRecordDTO recordDTO, int doctorId)
            throws BusinessException, ValidationException {
        try {
            // Validate dữ liệu
            validateMedicalRecord(recordDTO);
            validateVitalSigns(recordDTO);

            // Kiểm tra bệnh án tồn tại và thuộc về bác sĩ này
            MedicalRecord existing = recordDAO.getRecordById(recordDTO.getRecordId());
            if (existing == null) {
                throw new ValidationException("Bệnh án không tồn tại");
            }
            if (existing.getDoctorId() != doctorId) {
                throw new BusinessException("Bạn không có quyền sửa bệnh án này");
            }

            // Tính BMI nếu đủ dữ liệu
            if (recordDTO.getWeight() > 0 && recordDTO.getHeight() > 0) {
                recordDTO.setBmi(calculateBMI(recordDTO.getWeight(), recordDTO.getHeight()));
            }

            // Chuyển DTO → Entity và cập nhật
            MedicalRecord record = convertToEntity(recordDTO);
            record.setDoctorId(doctorId);

            return recordDAO.updateRecord(record);

        } catch (ValidationException e) {
            throw e;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi cập nhật bệnh án", e);
        }
    }

    // ==================== PRIVATE HELPER METHODS ====================

    /**
     * Validate các trường bắt buộc của bệnh án.
     */
    private void validateMedicalRecord(MedicalRecordDTO dto) throws ValidationException {
        if (dto == null) {
            throw new ValidationException("Dữ liệu bệnh án không được null");
        }
        if (dto.getDiagnosis() == null || dto.getDiagnosis().trim().isEmpty()) {
            throw new ValidationException("diagnosis", "Chẩn đoán không được để trống");
        }
        if (dto.getDiagnosis().length() > 500) {
            throw new ValidationException("diagnosis", "Chẩn đoán không được quá 500 ký tự");
        }
        if (dto.getTreatmentPlan() == null || dto.getTreatmentPlan().trim().isEmpty()) {
            throw new ValidationException("treatmentPlan", "Phương án điều trị không được để trống");
        }
        if (dto.getTreatmentPlan().length() > 1000) {
            throw new ValidationException("treatmentPlan", "Phương án điều trị không được quá 1000 ký tự");
        }
    }

    /**
     * Validate các chỉ số sinh hiệu theo chuẩn y tế.
     */
    private void validateVitalSigns(MedicalRecordDTO dto) throws ValidationException {
        // Huyết áp: định dạng "120/80"
        if (dto.getBloodPressure() != null && !dto.getBloodPressure().isEmpty()) {
            if (!dto.getBloodPressure().matches("\\d{2,3}/\\d{2,3}")) {
                throw new ValidationException("bloodPressure", "Huyết áp không đúng định dạng (VD: 120/80)");
            }
        }
        // Nhịp tim: 40 - 200 bpm
        if (dto.getHeartRate() > 0) {
            if (dto.getHeartRate() < 40 || dto.getHeartRate() > 200) {
                throw new ValidationException("heartRate", "Nhịp tim phải trong khoảng 40–200 bpm");
            }
        }
        // Nhiệt độ: 35 - 42°C
        if (dto.getTemperature() > 0) {
            if (dto.getTemperature() < 35 || dto.getTemperature() > 42) {
                throw new ValidationException("temperature", "Nhiệt độ phải trong khoảng 35–42°C");
            }
        }
        // Cân nặng: ≤ 300 kg
        if (dto.getWeight() > 300) {
            throw new ValidationException("weight", "Cân nặng không hợp lệ (tối đa 300 kg)");
        }
        // Chiều cao: 50 - 250 cm
        if (dto.getHeight() > 0 && (dto.getHeight() < 50 || dto.getHeight() > 250)) {
            throw new ValidationException("height", "Chiều cao phải trong khoảng 50–250 cm");
        }
    }

    /**
     * Tính chỉ số BMI. BMI = cân nặng(kg) / (chiều cao(m))²
     */
    private double calculateBMI(double weight, double height) {
        double heightInMeters = height / 100.0;
        double bmi = weight / (heightInMeters * heightInMeters);
        return Math.round(bmi * 10.0) / 10.0; // Làm tròn 1 chữ số thập phân
    }

    /**
     * Chuyển đổi Entity → DTO (bổ sung tính toán BMI).
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

        if (record.getWeight() > 0 && record.getHeight() > 0) {
            dto.setBmi(calculateBMI(record.getWeight(), record.getHeight()));
        }
        return dto;
    }

    /**
     * Chuyển đổi DTO → Entity.
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

    /**
     * Chuyển đổi Prescription Entity → PrescriptionDTO.
     */
    private PrescriptionDTO convertPrescriptionToDTO(Prescription p) {
        PrescriptionDTO dto = new PrescriptionDTO();
        dto.setPrescriptionId(p.getPrescriptionId());
        dto.setRecordId(p.getRecordId());
        dto.setMedicationName(p.getMedicationName());
        dto.setDosage(p.getDosage());
        dto.setFrequency(p.getFrequency());
        dto.setDurationDays(p.getDurationDays());
        dto.setInstructions(p.getInstructions());
        return dto;
    }
}
