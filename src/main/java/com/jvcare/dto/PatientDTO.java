package com.jvcare.dto;

import java.sql.Date;

public class PatientDTO {
    private int patientId;
    private int userId;
    private String patientCode;
    private String fullName;
    private Date dateOfBirth;
    private String gender;
    private String phone;
    private String email;
    private String address;
    private String allergies;
    private String chronicDiseases;
    private String avatarUrl;
    private String idCard;

    public PatientDTO() {}

    public PatientDTO(int patientId, int userId, String patientCode, String fullName, Date dateOfBirth, 
                      String gender, String phone, String email, String address, String allergies, 
                      String chronicDiseases, String avatarUrl, String idCard) {
        this.patientId = patientId;
        this.userId = userId;
        this.patientCode = patientCode;
        this.fullName = fullName;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.allergies = allergies;
        this.chronicDiseases = chronicDiseases;
        this.avatarUrl = avatarUrl;
        this.idCard = idCard;
    }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getPatientCode() { return patientCode; }
    public void setPatientCode(String patientCode) { this.patientCode = patientCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }

    public String getChronicDiseases() { return chronicDiseases; }
    public void setChronicDiseases(String chronicDiseases) { this.chronicDiseases = chronicDiseases; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getIdCard() { return idCard; }
    public void setIdCard(String idCard) { this.idCard = idCard; }
}
