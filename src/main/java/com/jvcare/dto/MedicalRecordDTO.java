package com.jvcare.dto;

import java.sql.Timestamp;
import java.util.List;

/**
 * Data Transfer Object cho Bệnh án (MedicalRecord).
 * Được dùng để truyền dữ liệu giữa Presentation Layer và Business Logic Layer.
 * Có thêm trường bmi (tính toán từ weight & height) và danh sách đơn thuốc.
 */
public class MedicalRecordDTO {

    private int recordId;
    private int patientId;
    private String patientName;
    private String patientCode;
    private int doctorId;
    private String doctorName;
    private int appointmentId;
    private Timestamp visitDate;

    // Chẩn đoán & Điều trị
    private String diagnosis;
    private String treatmentPlan;
    private String notes;

    // Chỉ số sinh hiệu
    private String bloodPressure;
    private int heartRate;
    private double temperature;
    private double weight;
    private double height;

    // Trường tính toán
    private double bmi;

    // Danh sách thuốc kèm theo
    private List<PrescriptionDTO> prescriptions;

    // ==================== Constructors ====================

    public MedicalRecordDTO() {}

    // ==================== Getters & Setters ====================

    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getPatientCode() { return patientCode; }
    public void setPatientCode(String patientCode) { this.patientCode = patientCode; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public Timestamp getVisitDate() { return visitDate; }
    public void setVisitDate(Timestamp visitDate) { this.visitDate = visitDate; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getTreatmentPlan() { return treatmentPlan; }
    public void setTreatmentPlan(String treatmentPlan) { this.treatmentPlan = treatmentPlan; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getBloodPressure() { return bloodPressure; }
    public void setBloodPressure(String bloodPressure) { this.bloodPressure = bloodPressure; }

    public int getHeartRate() { return heartRate; }
    public void setHeartRate(int heartRate) { this.heartRate = heartRate; }

    public double getTemperature() { return temperature; }
    public void setTemperature(double temperature) { this.temperature = temperature; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public double getHeight() { return height; }
    public void setHeight(double height) { this.height = height; }

    public double getBmi() { return bmi; }
    public void setBmi(double bmi) { this.bmi = bmi; }

    public List<PrescriptionDTO> getPrescriptions() { return prescriptions; }
    public void setPrescriptions(List<PrescriptionDTO> prescriptions) {
        this.prescriptions = prescriptions;
    }

    /**
     * Trả về phân loại BMI theo chuẩn WHO
     */
    public String getBmiCategory() {
        if (bmi <= 0) return "Chưa có dữ liệu";
        if (bmi < 18.5) return "Thiếu cân";
        if (bmi < 25.0) return "Bình thường";
        if (bmi < 30.0) return "Thừa cân";
        return "Béo phì";
    }
}
