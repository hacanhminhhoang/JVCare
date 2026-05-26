package com.jvcare.controller;

import com.jvcare.dto.PatientDTO;
import com.jvcare.service.PatientService;
import com.jvcare.model.User;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/patient/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 2,      // 2 MB
    maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class PatientProfileServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkPatientAccess(request, response)) return;

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            PatientDTO patient = patientService.getPatientByUserId(user.getUserId());
            if (patient == null) {
                request.setAttribute("error", "Chưa có thông tin hồ sơ bệnh nhân. Vui lòng liên hệ lễ tân.");
            } else {
                request.setAttribute("patient", patient);
            }
            
            request.getRequestDispatcher("/WEB-INF/views/patient/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/patient/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkPatientAccess(request, response)) return;

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            PatientDTO patient = patientService.getPatientByUserId(user.getUserId());
            if (patient == null) {
                request.setAttribute("error", "Hồ sơ bệnh nhân không tồn tại!");
                doGet(request, response);
                return;
            }

            // Extract fields
            String fullName = request.getParameter("fullName");
            String dobStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String idCard = request.getParameter("idCard");
            String allergies = request.getParameter("allergies");
            String chronicDiseases = request.getParameter("chronicDiseases");

            patient.setFullName(fullName);
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                patient.setDateOfBirth(Date.valueOf(dobStr));
            }
            patient.setGender(gender);
            patient.setPhone(phone);
            patient.setEmail(email);
            patient.setAddress(address);
            patient.setIdCard(idCard);
            patient.setAllergies(allergies);
            patient.setChronicDiseases(chronicDiseases);

            // Handle file upload
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                InputStream fileContent = filePart.getInputStream();
                // Store path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "avatars";
                
                String newAvatarUrl = patientService.uploadAvatar(patient.getPatientId(), fileName, fileContent, uploadPath);
                patient.setAvatarUrl(newAvatarUrl);
            }

            boolean success = patientService.updateProfile(patient);
            if (success) {
                session.setAttribute("message", "Cập nhật hồ sơ cá nhân thành công.");
                response.sendRedirect(request.getContextPath() + "/patient/profile");
                return;
            } else {
                request.setAttribute("error", "Cập nhật hồ sơ cá nhân thất bại.");
            }

        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        doGet(request, response);
    }

    private String getFileName(final Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private boolean checkPatientAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        return true;
    }
}
