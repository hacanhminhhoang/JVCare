package com.jvcare.controller;

import com.jvcare.dto.AppointmentDTO;
import com.jvcare.dto.PatientDTO;
import com.jvcare.dto.DoctorDTO;
import com.jvcare.service.AppointmentService;
import com.jvcare.service.PatientService;
import com.jvcare.service.DoctorService;
import com.jvcare.model.User;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/patient/book-appointment")
public class PatientBookAppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;
    private PatientService patientService;
    private DoctorService doctorService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        patientService = new PatientService();
        doctorService = new DoctorService();
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
                request.setAttribute("error", "Không tìm thấy thông tin bệnh nhân tương ứng với tài khoản này.");
            }
            
            List<DoctorDTO> doctors = doctorService.getAllDoctors();
            
            request.setAttribute("patient", patient);
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("/WEB-INF/views/patient/book_appointment.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/patient/book_appointment.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkPatientAccess(request, response)) return;

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            PatientDTO patient = patientService.getPatientByUserId(user.getUserId());

            if (patient == null) {
                request.setAttribute("error", "Hồ sơ bệnh nhân không tồn tại!");
                doGet(request, response);
                return;
            }

            String dateStr = request.getParameter("appointmentDate");
            String timeStr = request.getParameter("appointmentTime");
            String reason = request.getParameter("reason");
            String docIdStr = request.getParameter("doctorId");

            AppointmentDTO dto = new AppointmentDTO();
            dto.setPatientId(patient.getPatientId());
            dto.setAppointmentDate(Date.valueOf(dateStr));
            dto.setAppointmentTime(Time.valueOf(timeStr + ":00"));
            dto.setReason(reason);
            dto.setStatus("PENDING");

            if (docIdStr != null && !docIdStr.trim().isEmpty()) {
                dto.setDoctorId(Integer.parseInt(docIdStr));
            }

            boolean success = appointmentService.bookAppointment(dto);

            if (success) {
                session.setAttribute("message", "Đặt lịch thành công! Đang chờ bác sĩ xác nhận.");
                response.sendRedirect(request.getContextPath() + "/patient/appointments");
                return;
            } else {
                request.setAttribute("error", "Đặt lịch thất bại!");
            }

        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        doGet(request, response);
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