package com.jvcare.controller;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.Appointment;
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
import java.util.List;

@WebServlet("/doctor/appointments")
public class DoctorAppointmentsServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền Bác sĩ.");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null) tab = "all";
        
        String statusFilter = null;
        if ("pending".equals(tab)) statusFilter = "PENDING";
        else if ("confirmed".equals(tab)) statusFilter = "CONFIRMED";
        else if ("completed".equals(tab)) statusFilter = "COMPLETED";

        int page = 1;
        int itemsPerPage = 12;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) { page = 1; }
        }

        int totalAppointments = appointmentDAO.getTotalAppointments(doctorId, statusFilter);
        int totalPages = (int) Math.ceil((double) totalAppointments / itemsPerPage);

        if (page > totalPages && totalPages > 0) page = totalPages;
        if (page < 1) page = 1;

        int offset = (page - 1) * itemsPerPage;

        List<Appointment> appointments = appointmentDAO.getAppointmentsWithPagination(doctorId, statusFilter, offset, itemsPerPage);

        request.setAttribute("appointments", appointments);
        request.setAttribute("currentTab", tab);
        request.setAttribute("currentDoctorId", doctorId);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/WEB-INF/views/doctor/appointments.jsp").forward(request, response);
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

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

    // Doctor nhận lịch khám
    if ("assign".equals(action)) {

        int appointmentId =
                Integer.parseInt(request.getParameter("appointmentId"));

        if (appointmentDAO.assignDoctor(appointmentId, doctorId)) {

            session.setAttribute(
                    "message",
                    "Đã nhận lịch hẹn khám."
            );

        } else {

            session.setAttribute(
                    "error",
                    "Không thể nhận lịch khám."
            );
        }
    }


if ("complete".equals(action)) {

    int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

    String diagnosis = request.getParameter("diagnosis");
    String condition = request.getParameter("patientCondition");
    String advice = request.getParameter("advice");

    if (appointmentDAO.completeAppointment(
            appointmentId,
            doctorId,
            diagnosis,
            condition,
            advice)) {

        session.setAttribute("message",
                "Đã cập nhật hồ sơ khám thành công.");

    } else {

        session.setAttribute("error",
                "Không thể hoàn thành hồ sơ.");

    }

    response.sendRedirect(
            request.getContextPath()
            + "/doctor/appointment-detail?id="
            + appointmentId);

    return;
}
    response.sendRedirect(
            request.getContextPath()
            + "/doctor/appointments"
    );
}
}
