package com.jvcare.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.model.MedicalRecord;
import com.jvcare.model.Patient;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.util.List;

@WebServlet("/doctor/patient-detail")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class DoctorPatientDetailServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private MedicalRecordDAO recordDAO = new MedicalRecordDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền bác sĩ.");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int pid = Integer.parseInt(idStr);
            Patient p = patientDAO.getPatientById(pid);
            if (p != null) {
                request.setAttribute("patient", p);
                
                // Get latest vital signs
                List<MedicalRecord> records = recordDAO.getRecordsByPatientId(pid);
                if (!records.isEmpty()) {
                    MedicalRecord latest = records.get(0);
                    request.setAttribute("latestRecord", latest);
                    
                    String vitalsJson = latest.getVitalSigns();
                    if (vitalsJson != null && !vitalsJson.isEmpty()) {
                        JsonObject vitals = gson.fromJson(vitalsJson, JsonObject.class);
                        if (vitals.has("weight")) request.setAttribute("weight", vitals.get("weight").getAsString());
                        if (vitals.has("height")) request.setAttribute("height", vitals.get("height").getAsString());
                        if (vitals.has("heartRate")) request.setAttribute("heartRate", vitals.get("heartRate").getAsString());
                    }
                }
            } else {
                request.getSession().setAttribute("error", "Hồ sơ bệnh nhân không tồn tại hoặc đã bị xóa.");
                response.sendRedirect(request.getContextPath() + "/doctor/index");
                return;
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/doctor/patient_details.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String patientIdStr = request.getParameter("patientId");
            
            Patient p = new Patient();
            p.setFullName(request.getParameter("fullName"));
            p.setPhone(request.getParameter("phone"));
            
            String dobStr = request.getParameter("dateOfBirth");
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    p.setDateOfBirth(Date.valueOf(dobStr));
                } catch (IllegalArgumentException e) {
                    System.err.println("Invalid date format: " + dobStr);
                }
            }
            
            p.setGender(request.getParameter("gender"));
            p.setAddress(request.getParameter("address"));
            p.setAllergies(request.getParameter("allergies"));
            p.setChronicDiseases(request.getParameter("chronicDiseases"));
            
            // Handle Avatar Upload
            String avatarUrl = request.getParameter("currentAvatar");
            try {
                Part avatarPart = request.getPart("avatar");
                if (avatarPart != null && avatarPart.getSize() > 0) {
                    String fileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
                    String uploadDir = getServletContext().getRealPath("/") + "uploads/avatars";
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    File saveFile = new File(uploadDirFile, uniqueFileName);
                    Files.copy(avatarPart.getInputStream(), saveFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    avatarUrl = request.getContextPath() + "/uploads/avatars/" + uniqueFileName;
                }
            } catch (Exception e) {
                System.err.println("Avatar upload error: " + e.getMessage());
            }
            p.setAvatarUrl(avatarUrl);
            
            // Determine if this is an update or create
            // patientIdStr can be "", "0", or null for new patients
            int parsedPatientId = 0;
            try {
                if (patientIdStr != null && !patientIdStr.isEmpty()) {
                    parsedPatientId = Integer.parseInt(patientIdStr);
                }
            } catch (NumberFormatException e) {
                parsedPatientId = 0;
            }
            
            boolean isUpdate = (parsedPatientId > 0);
            if (isUpdate) {
                p.setPatientId(parsedPatientId);
                boolean updated = patientDAO.updatePatient(p);
                if (updated) {
                    request.getSession().setAttribute("message", "Đã cập nhật thông tin bệnh nhân.");
                } else {
                    request.getSession().setAttribute("error", "Không thể cập nhật bệnh nhân. Vui lòng kiểm tra dữ liệu.");
                }
            } else {
                boolean created = patientDAO.createPatient(p);
                if (created) {
                    request.getSession().setAttribute("message", "Đã tạo hồ sơ bệnh nhân mới.");
                } else {
                    request.getSession().setAttribute("error", "Không thể tạo hồ sơ bệnh nhân. Vui lòng kiểm tra dữ liệu nhập.");
                    response.sendRedirect(request.getContextPath() + "/doctor/index");
                    return;
                }
            }
            
            // Create initial medical record if it's a new patient OR if vitals are provided
            if (p.getPatientId() > 0) {
                String weight = request.getParameter("weight");
                String height = request.getParameter("height");
                String heartRate = request.getParameter("heartRate");
                
                boolean hasVitals = (weight != null && !weight.trim().isEmpty()) 
                                 || (height != null && !height.trim().isEmpty()) 
                                 || (heartRate != null && !heartRate.trim().isEmpty());
                
                if (!isUpdate || hasVitals) {
                    User user = (User) request.getSession().getAttribute("user");
                    if (user != null) {
                        com.jvcare.dao.DoctorDAO doctorDAO = new com.jvcare.dao.DoctorDAO();
                        com.jvcare.model.Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
                        
                        if (doctor != null) {
                            MedicalRecord r = new MedicalRecord();
                            r.setPatientId(p.getPatientId());
                            r.setDoctorId(doctor.getDoctorId());
                            r.setVisitDate(new java.sql.Timestamp(System.currentTimeMillis()));
                            
                            r.setDiagnosis(!isUpdate ? "Khám ban đầu" : "Cập nhật sinh hiệu");
                            r.setTreatmentPlan("");
                            r.setNotes(!isUpdate ? "Tạo hồ sơ bệnh nhân mới" : "Cập nhật sinh hiệu");
                            
                            if (weight != null && !weight.trim().isEmpty()) {
                                try { r.setWeight(Double.parseDouble(weight.trim())); } catch(NumberFormatException ignored) {}
                            }
                            if (height != null && !height.trim().isEmpty()) {
                                try { r.setHeight(Double.parseDouble(height.trim())); } catch(NumberFormatException ignored) {}
                            }
                            if (heartRate != null && !heartRate.trim().isEmpty()) {
                                try { r.setHeartRate(Integer.parseInt(heartRate.trim())); } catch(NumberFormatException ignored) {}
                            }
                            
                            try {
                                recordDAO.createRecord(r);
                            } catch (Exception vitalsEx) {
                                System.err.println("Warning: Could not save vitals: " + vitalsEx.getMessage());
                            }
                        }
                    }
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/doctor/index");
        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.getSession().setAttribute("error", "Lỗi server: " + e.getMessage());
                if (!response.isCommitted()) {
                    response.sendRedirect(request.getContextPath() + "/doctor/index");
                }
            } catch (Exception ex) {
                System.err.println("Failed to redirect after error: " + ex.getMessage());
            }
        }
    }
}
