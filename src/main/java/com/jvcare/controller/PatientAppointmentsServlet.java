package com.jvcare.controller;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.model.Appointment;
import com.jvcare.model.Patient;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/patient/appointments")
public class PatientAppointmentsServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    private Patient getPatient(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"PATIENT".equals(user.getRole())) return null;
        int userId = user.getUserId();
        List<Patient> all = patientDAO.getAllPatients();
        for (Patient p : all) {
            if (p.getUserId() == userId) return p;
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Patient patient = getPatient(request);
        if (patient != null) {
            List<Appointment> list = appointmentDAO.getAppointmentsByPatientId(patient.getPatientId());
            request.setAttribute("appointments", list);
            request.setAttribute("patient", patient);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/patient/appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Patient patient = getPatient(request);
        if (patient == null) {
            session.setAttribute("error", "Chưa có thông tin hồ sơ bệnh nhân, vui lòng liên hệ lễ tân.");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "create";

        if ("create".equals(action)) {
            String dateTimeStr = request.getParameter("datetime");
            String reason = request.getParameter("reason");
            
            // Extract profile fields to update patient
            String fullName = request.getParameter("fullName");
            String idCard = request.getParameter("idCard");
            String dobStr = request.getParameter("dateOfBirth");
            String address = request.getParameter("address");
            
            if (fullName != null && !fullName.isEmpty()) {
                patient.setFullName(fullName);
                patient.setIdCard(idCard);
                patient.setAddress(address);
                if (dobStr != null && !dobStr.isEmpty()) {
                    patient.setDateOfBirth(Date.valueOf(dobStr));
                }
                patientDAO.updatePatient(patient);
            }
            
            if (dateTimeStr != null && !dateTimeStr.isEmpty()) {
                LocalDateTime dateTime = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                Appointment a = new Appointment();
                a.setPatientId(patient.getPatientId());
                a.setAppointmentDate(Date.valueOf(dateTime.toLocalDate()));
                a.setAppointmentTime(Time.valueOf(dateTime.toLocalTime()));
                a.setReason(reason);
                if (appointmentDAO.createAppointment(a)) {
                    session.setAttribute("message", "Đã gửi yêu cầu đặt lịch! Chờ xác nhận từ bác sĩ.");
                } else {
                    session.setAttribute("error", "Lỗi đặt lịch, vui lòng thử lại.");
                }
            }
        } else if ("update".equals(action)) {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String dateTimeStr = request.getParameter("datetime");
            String reason = request.getParameter("reason");
            LocalDateTime dateTime = LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            
            Appointment a = new Appointment();
            a.setAppointmentId(appointmentId);
            a.setAppointmentDate(Date.valueOf(dateTime.toLocalDate()));
            a.setAppointmentTime(Time.valueOf(dateTime.toLocalTime()));
            a.setReason(reason);
            
            if (appointmentDAO.updateAppointment(a)) {
                session.setAttribute("message", "Cập nhật lịch khám thành công.");
            } else {
                session.setAttribute("error", "Không thể cập nhật lịch khám (có thể lịch đã được xác nhận).");
            }
        } else if ("delete".equals(action)) {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            if (appointmentDAO.deleteAppointment(appointmentId)) {
                session.setAttribute("message", "Đã xóa lịch khám.");
            } else {
                session.setAttribute("error", "Không thể xóa lịch khám (có thể lịch đã được xác nhận).");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/appointments");
    }
}
