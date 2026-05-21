
package com.jvcare.model;

import java.sql.Timestamp;

public class MedicalRecord {
    private int recordId;
    private String recordCode;
    private int patientId;
    private int doctorId;
    private Timestamp visitDate;
    private String chiefComplaint;
    private String presentIllness;
    private String medicalHistory;
    private String diagnosis;
    private String treatmentPlan;
    private String status;
    private String vitalSigns;
    
    // New fields
    private int appointmentId;
    private String notes;
    private String bloodPressure;
    private int heartRate;
    private double temperature;
    private double weight;
    private double height;
    
    // Virtual fields for joined queries
    private String patientName;
    private String patientCode;
    private String doctorName;

    public MedicalRecord() {}

    public String getVitalSigns() { return vitalSigns; }
    public void setVitalSigns(String vitalSigns) { this.vitalSigns = vitalSigns; }

    // Getters and Setters
    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public String getRecordCode() { return recordCode; }
    public void setRecordCode(String recordCode) { this.recordCode = recordCode; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public Timestamp getVisitDate() { return visitDate; }
    public void setVisitDate(Timestamp visitDate) { this.visitDate = visitDate; }

    public String getChiefComplaint() { return chiefComplaint; }
    public void setChiefComplaint(String chiefComplaint) { this.chiefComplaint = chiefComplaint; }

    public String getPresentIllness() { return presentIllness; }
    public void setPresentIllness(String presentIllness) { this.presentIllness = presentIllness; }

    public String getMedicalHistory() { return medicalHistory; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getTreatmentPlan() { return treatmentPlan; }
    public void setTreatmentPlan(String treatmentPlan) { this.treatmentPlan = treatmentPlan; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

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

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getPatientCode() { return patientCode; }
    public void setPatientCode(String patientCode) { this.patientCode = patientCode; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
}
