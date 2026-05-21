package com.jvcare.model;

public class Doctor {
    private int doctorId;
    private int userId;
    private String specialization;
    
    // Thông tin từ bảng users (JOIN)
    private String fullName;
    private String email;
    private String phone;
    private String status;
    
    // Constructors
    public Doctor() {}
    
    public Doctor(int doctorId, int userId, String specialization) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.specialization = specialization;
    }
    
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
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
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
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
}
