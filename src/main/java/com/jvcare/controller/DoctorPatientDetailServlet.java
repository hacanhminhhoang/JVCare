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
        request.setCharacterEncoding("UTF-8");
        String patientIdStr = request.getParameter("patientId");
        
        Patient p = new Patient();
        p.setFullName(request.getParameter("fullName"));
        p.setPhone(request.getParameter("phone"));
        
        String dobStr = request.getParameter("dateOfBirth");
        if (dobStr != null && !dobStr.isEmpty()) {
            p.setDateOfBirth(Date.valueOf(dobStr));
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
            e.printStackTrace();
        }
        p.setAvatarUrl(avatarUrl);
        
        boolean isUpdate = (patientIdStr != null && !patientIdStr.isEmpty());
        if (isUpdate) {
            p.setPatientId(Integer.parseInt(patientIdStr));
            patientDAO.updatePatient(p);
            request.getSession().setAttribute("message", "Đã cập nhật thông tin bệnh nhân.");
        } else {
            patientDAO.createPatient(p);
            request.getSession().setAttribute("message", "Đã tạo hồ sơ bệnh nhân mới.");
        }
        
        // Save vitals if provided (for simplicity we just create a new record if we have vitals)
        String weight = request.getParameter("weight");
        String height = request.getParameter("height");
        String heartRate = request.getParameter("heartRate");
        
        if ((weight != null && !weight.isEmpty()) || (height != null && !height.isEmpty()) || (heartRate != null && !heartRate.isEmpty())) {
            JsonObject vitals = new JsonObject();
            vitals.addProperty("weight", weight);
            vitals.addProperty("height", height);
            vitals.addProperty("heartRate", heartRate);
            
            // In a real app we'd get the actual created patient ID if it's a new patient. 
            // For simplicity, let's just do it for update
            if (isUpdate) {
                MedicalRecord r = new MedicalRecord();
                r.setPatientId(p.getPatientId());
                r.setDoctorId(1); // demo doctor
                r.setVisitDate(new java.sql.Timestamp(System.currentTimeMillis()));
                r.setChiefComplaint("Cập nhật sinh hiệu");
                r.setDiagnosis("Khám tổng quát");
                r.setTreatmentPlan("Theo dõi thêm");
                r.setVitalSigns(vitals.toString());
                recordDAO.createRecord(r);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/index");
    }
}
