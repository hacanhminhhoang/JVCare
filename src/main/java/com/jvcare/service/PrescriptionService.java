package com.jvcare.service;

import com.jvcare.dao.PrescriptionDAO;
import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.dto.PrescriptionDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import com.jvcare.model.MedicalRecord;
import com.jvcare.model.Prescription;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Business Logic Layer cho Đơn thuốc.
 * Xử lý validate, kiểm tra quyền sở hữu, và chuyển đổi DTO ↔ Entity
 * trước khi gọi xuống PrescriptionDAO.
 */
public class PrescriptionService {

    private final PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private final MedicalRecordDAO recordDAO = new MedicalRecordDAO();

    // ==================== PUBLIC METHODS ====================

    /**
     * Lấy danh sách đơn thuốc theo bệnh án.
     */
    public List<PrescriptionDTO> getPrescriptionsByRecord(int recordId) throws BusinessException {
        try {
            if (recordId <= 0) {
                throw new ValidationException("Record ID không hợp lệ");
            }
            List<Prescription> list = prescriptionDAO.getPrescriptionsByRecordId(recordId);
            return list.stream().map(this::convertToDTO).collect(Collectors.toList());
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy danh sách đơn thuốc", e);
        }
    }

    /**
     * Lấy chi tiết một đơn thuốc theo ID.
     */
    public PrescriptionDTO getPrescriptionById(int prescriptionId) throws BusinessException {
        try {
            Prescription p = prescriptionDAO.getPrescriptionById(prescriptionId);
            if (p == null) {
                throw new ValidationException("Đơn thuốc không tồn tại");
            }
            return convertToDTO(p);
        } catch (ValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi lấy chi tiết đơn thuốc", e);
        }
    }

    /**
     * Thêm thuốc mới vào bệnh án.
     * Kiểm tra bệnh án tồn tại và validate dữ liệu thuốc trước khi lưu.
     */
    public boolean createPrescription(PrescriptionDTO dto, int doctorId)
            throws BusinessException, ValidationException {
        try {
            // Validate dữ liệu đầu vào
            validatePrescription(dto);

            // Kiểm tra bệnh án tồn tại và thuộc về bác sĩ này
            checkRecordOwnership(dto.getRecordId(), doctorId);

            // Chuyển DTO → Entity và lưu
            Prescription p = convertToEntity(dto);
            return prescriptionDAO.createPrescription(p);

        } catch (ValidationException e) {
            throw e;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi thêm đơn thuốc", e);
        }
    }

    /**
     * Cập nhật thông tin đơn thuốc.
     * Chỉ bác sĩ sở hữu bệnh án mới được cập nhật.
     */
    public boolean updatePrescription(PrescriptionDTO dto, int doctorId)
            throws BusinessException, ValidationException {
        try {
            validatePrescription(dto);

            // Kiểm tra đơn thuốc tồn tại
            Prescription existing = prescriptionDAO.getPrescriptionById(dto.getPrescriptionId());
            if (existing == null) {
                throw new ValidationException("Đơn thuốc không tồn tại");
            }

            // Kiểm tra quyền sở hữu thông qua bệnh án
            checkRecordOwnership(existing.getRecordId(), doctorId);

            Prescription p = convertToEntity(dto);
            return prescriptionDAO.updatePrescription(p);

        } catch (ValidationException e) {
            throw e;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi cập nhật đơn thuốc", e);
        }
    }

    /**
     * Xóa một đơn thuốc.
     * Chỉ bác sĩ sở hữu bệnh án mới được xóa.
     */
    public boolean deletePrescription(int prescriptionId, int doctorId)
            throws BusinessException, ValidationException {
        try {
            Prescription existing = prescriptionDAO.getPrescriptionById(prescriptionId);
            if (existing == null) {
                throw new ValidationException("Đơn thuốc không tồn tại");
            }

            // Kiểm tra quyền sở hữu thông qua bệnh án
            checkRecordOwnership(existing.getRecordId(), doctorId);

            return prescriptionDAO.deletePrescription(prescriptionId);

        } catch (ValidationException e) {
            throw e;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi xóa đơn thuốc", e);
        }
    }

    // ==================== PRIVATE HELPER METHODS ====================

    /**
     * Validate dữ liệu đơn thuốc.
     */
    private void validatePrescription(PrescriptionDTO dto) throws ValidationException {
        if (dto == null) {
            throw new ValidationException("Dữ liệu đơn thuốc không được null");
        }
        if (dto.getMedicationName() == null || dto.getMedicationName().trim().isEmpty()) {
            throw new ValidationException("medicationName", "Tên thuốc không được để trống");
        }
        if (dto.getMedicationName().length() > 150) {
            throw new ValidationException("medicationName", "Tên thuốc không được quá 150 ký tự");
        }
        if (dto.getDosage() == null || dto.getDosage().trim().isEmpty()) {
            throw new ValidationException("dosage", "Liều dùng không được để trống");
        }
        if (dto.getDurationDays() < 0) {
            throw new ValidationException("durationDays", "Số ngày dùng thuốc không hợp lệ");
        }
        if (dto.getDurationDays() > 365) {
            throw new ValidationException("durationDays", "Số ngày dùng thuốc không được quá 365 ngày");
        }
    }

    /**
     * Kiểm tra bác sĩ có quyền thao tác trên bệnh án không.
     */
    private void checkRecordOwnership(int recordId, int doctorId)
            throws BusinessException, ValidationException {
        MedicalRecord record = recordDAO.getRecordById(recordId);
        if (record == null) {
            throw new ValidationException("Bệnh án không tồn tại");
        }
        if (record.getDoctorId() != doctorId) {
            throw new BusinessException("Bạn không có quyền thao tác trên đơn thuốc này");
        }
    }

    /**
     * Chuyển đổi Prescription Entity → DTO.
     */
    private PrescriptionDTO convertToDTO(Prescription p) {
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

    /**
     * Chuyển đổi DTO → Prescription Entity.
     */
    private Prescription convertToEntity(PrescriptionDTO dto) {
        Prescription p = new Prescription();
        p.setPrescriptionId(dto.getPrescriptionId());
        p.setRecordId(dto.getRecordId());
        p.setMedicationName(dto.getMedicationName());
        p.setDosage(dto.getDosage());
        p.setFrequency(dto.getFrequency());
        p.setDurationDays(dto.getDurationDays());
        p.setInstructions(dto.getInstructions());
        return p;
    }
}
