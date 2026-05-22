package com.jvcare.dto;

/**
 * Data Transfer Object cho Đơn thuốc (Prescription).
 * Được dùng để truyền dữ liệu giữa Presentation Layer và Business Logic Layer.
 */
public class PrescriptionDTO {

    private int prescriptionId;
    private int recordId;
    private String medicationName;
    private String dosage;
    private String frequency;
    private int durationDays;
    private String instructions;

    // ==================== Constructors ====================

    public PrescriptionDTO() {}

    public PrescriptionDTO(int recordId, String medicationName, String dosage,
                           String frequency, int durationDays, String instructions) {
        this.recordId = recordId;
        this.medicationName = medicationName;
        this.dosage = dosage;
        this.frequency = frequency;
        this.durationDays = durationDays;
        this.instructions = instructions;
    }

    // ==================== Getters & Setters ====================

    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }

    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public String getMedicationName() { return medicationName; }
    public void setMedicationName(String medicationName) { this.medicationName = medicationName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
}
