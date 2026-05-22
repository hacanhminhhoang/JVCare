package com.jvcare.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Prescription {
    private int prescriptionId;
    private int patientId;
    private Timestamp prescriptionDate;
    
    // Joined from details and medications
    private String medicationName;
    private String dosage;
    private String instructions;
    
    // New fields mapping to prescriptions table
    private int recordId;
    private String frequency;
    private int durationDays;

    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public Timestamp getPrescriptionDate() { return prescriptionDate; }
    public void setPrescriptionDate(Timestamp prescriptionDate) { this.prescriptionDate = prescriptionDate; }

    public String getMedicationName() { return medicationName; }
    public void setMedicationName(String medicationName) { this.medicationName = medicationName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }

    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }
}
