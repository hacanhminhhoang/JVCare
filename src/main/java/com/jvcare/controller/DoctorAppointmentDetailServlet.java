package com.jvcare.controller;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.model.Appointment;
import com.jvcare.model.Patient;
import com.jvcare.model.User;
import com.jvcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/doctor/appointment-detail")
public class DoctorAppointmentDetailServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    private int getDoctorId(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"DOCTOR".equals(user.getRole())) return -1;
        
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getUserId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("doctor_id");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return -1;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int doctorId = getDoctorId(request);
        if (doctorId == -1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            return;
        }

        int appointmentId = Integer.parseInt(idStr);
        Appointment a = null;
        for (Appointment app : appointmentDAO.getAllAppointmentsForDoctor(doctorId)) {
            if (app.getAppointmentId() == appointmentId) {
                a = app;
                break;
            }
        }

        if (a == null) {
            session.setAttribute("error", "Không tìm thấy hồ sơ hoặc bạn không có quyền xem.");
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
            return;
        }

        Patient patient = patientDAO.getPatientById(a.getPatientId());
        
        request.setAttribute("appointment", a);
        request.setAttribute("patient", patient);
        request.setAttribute("currentDoctorId", doctorId);
        
        request.getRequestDispatcher("/WEB-INF/views/doctor/appointment_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int doctorId = getDoctorId(request);
        if (doctorId == -1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if ("complete".equals(action)) {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String diagnosis = request.getParameter("diagnosis");
            String condition = request.getParameter("patientCondition");
            String advice = request.getParameter("advice");
            if (appointmentDAO.completeAppointment(appointmentId, doctorId, diagnosis, condition, advice)) {
                session.setAttribute("message", "Đã cập nhật hồ sơ khám thành công.");
            } else {
                session.setAttribute("error", "Lỗi: Không thể hoàn thành lịch khám (có thể bạn không phải là bác sĩ phụ trách).");
            }
            response.sendRedirect(request.getContextPath() + "/doctor/appointment-detail?id=" + appointmentId);
        } else {
            response.sendRedirect(request.getContextPath() + "/doctor/appointments");
        }
    }
}
