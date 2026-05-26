package com.jvcare.dto;

import java.sql.Date;
import java.sql.Time;

public class AppointmentDTO {
    private int appointmentId;
    private int patientId;
    private String patientName;
    private String patientCode;
    private int doctorId;
    private String doctorName;
    private String doctorSpecialization;
    private Date appointmentDate;
    private Time appointmentTime;
    private String status;
    private String reason;
    private String notes;
    private String diagnosis;
    private String patientCondition;
    private String advice;

    public AppointmentDTO() {}

    public AppointmentDTO(int appointmentId, int patientId, String patientName, String patientCode, 
                          int doctorId, String doctorName, String doctorSpecialization, 
                          Date appointmentDate, Time appointmentTime, String status, 
                          String reason, String notes, String diagnosis, 
                          String patientCondition, String advice) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.patientName = patientName;
        this.patientCode = patientCode;
        this.doctorId = doctorId;
        this.doctorName = doctorName;
        this.doctorSpecialization = doctorSpecialization;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.status = status;
        this.reason = reason;
        this.notes = notes;
        this.diagnosis = diagnosis;
        this.patientCondition = patientCondition;
        this.advice = advice;
    }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

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

    public String getDoctorSpecialization() { return doctorSpecialization; }
    public void setDoctorSpecialization(String doctorSpecialization) { this.doctorSpecialization = doctorSpecialization; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public Time getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(Time appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getPatientCondition() { return patientCondition; }
    public void setPatientCondition(String patientCondition) { this.patientCondition = patientCondition; }

    public String getAdvice() { return advice; }
    public void setAdvice(String advice) { this.advice = advice; }
}
