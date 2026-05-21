package com.jvcare.dto;

public class DoctorDTO {
    private int doctorId;
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String specialization;
    private String status;
    
    // Statistics
    private int totalAppointments;
    private int totalPatients;
    
    // Constructors
    public DoctorDTO() {}
    
    // Getters and Setters
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getTotalAppointments() {
        return totalAppointments;
    }
    
    public void setTotalAppointments(int totalAppointments) {
        this.totalAppointments = totalAppointments;
    }
    
    public int getTotalPatients() {
        return totalPatients;
    }
    
    public void setTotalPatients(int totalPatients) {
        this.totalPatients = totalPatients;
    }
}
