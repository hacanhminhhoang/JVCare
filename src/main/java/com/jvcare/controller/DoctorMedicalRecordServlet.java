package com.jvcare.controller;

import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dto.MedicalRecordDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import com.jvcare.model.Appointment;
import com.jvcare.model.User;
import com.jvcare.service.MedicalRecordService;
import com.jvcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

/**
 * Presentation Layer cho Bệnh án của Bác sĩ.
 * Chỉ xử lý HTTP request/response, không chứa business logic.
 * Tất cả logic được ủy quyền cho MedicalRecordService.
 */
@WebServlet("/doctor/medical-records")
public class DoctorMedicalRecordServlet extends HttpServlet {

    // Sử dụng Service Layer thay vì trực tiếp DAO (đúng kiến trúc 3 lớp)
    private final MedicalRecordService recordService = new MedicalRecordService();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ bác sĩ mới được truy cập");
            return;
        }

        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            showRecordDetail(request, response, user);
        } else if ("create".equals(action)) {
            showCreateForm(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response, user);
        } else {
            listRecords(request, response, user);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ bác sĩ mới được truy cập");
            return;
        }

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createRecord(request, response, user);
        } else if ("update".equals(action)) {
            updateRecord(request, response, user);
        }
    }

    // ==================== GET HANDLERS ====================

    /**
     * Hiển thị danh sách bệnh án của bác sĩ đang đăng nhập.
     */
    private void listRecords(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int doctorId = getDoctorIdFromUser(user);
            List<MedicalRecordDTO> records = recordService.getRecordsByDoctor(doctorId);
            request.setAttribute("records", records);
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_records.jsp")
                   .forward(request, response);
        } catch (BusinessException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_records.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Hiển thị chi tiết bệnh án kèm đơn thuốc.
     */
    private void showRecordDetail(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            MedicalRecordDTO record = recordService.getRecordWithPrescriptions(recordId);

            request.setAttribute("record", record);
            request.setAttribute("prescriptions", record.getPrescriptions());
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_detail.jsp")
                   .forward(request, response);
        } catch (ValidationException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (BusinessException e) {
            request.setAttribute("errorMessage", e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    /**
     * Hiển thị form tạo bệnh án mới (có thể prefill từ lịch hẹn).
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("appointmentId");
        if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                request.setAttribute("appointment", appointment);
            } catch (NumberFormatException ignored) {}
        }
        request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
               .forward(request, response);
    }

    /**
     * Hiển thị form chỉnh sửa bệnh án.
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int recordId = Integer.parseInt(request.getParameter("id"));
            // Dùng service để lấy dữ liệu (kèm validation ownership sẽ thực hiện ở update)
            MedicalRecordDTO record = recordService.getRecordWithPrescriptions(recordId);
            request.setAttribute("record", record);
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
                   .forward(request, response);
        } catch (ValidationException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (BusinessException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    // ==================== POST HANDLERS ====================

    /**
     * Xử lý tạo bệnh án mới.
     */
    private void createRecord(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int doctorId = getDoctorIdFromUser(user);
            String appointmentIdStr = request.getParameter("appointmentId");

            // Đọc dữ liệu form vào DTO
            MedicalRecordDTO dto = buildRecordDTOFromRequest(request);

            int recordId;
            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                recordId = recordService.createRecordFromAppointment(appointmentId, doctorId, dto);
            } else {
                // Tạo thông thường (không từ lịch hẹn) - chuyển về danh sách nếu thành công
                dto.setDoctorId(doctorId);
                recordId = -1;
                // TODO: Implement createRecord (không từ appointment) nếu cần
            }

            if (recordId > 0) {
                response.sendRedirect(request.getContextPath() +
                    "/doctor/medical-records?action=detail&id=" + recordId);
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/medical-records");
            }

        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
                   .forward(request, response);
        } catch (BusinessException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Xử lý cập nhật bệnh án.
     */
    private void updateRecord(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            int doctorId = getDoctorIdFromUser(user);
            int recordId = Integer.parseInt(request.getParameter("recordId"));

            MedicalRecordDTO dto = buildRecordDTOFromRequest(request);
            dto.setRecordId(recordId);

            boolean success = recordService.updateRecord(dto, doctorId);

            if (success) {
                response.sendRedirect(request.getContextPath() +
                    "/doctor/medical-records?action=detail&id=" + recordId);
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật bệnh án");
                request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
                       .forward(request, response);
            }

        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
                   .forward(request, response);
        } catch (BusinessException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/medical_record_form.jsp")
                   .forward(request, response);
        }
    }

    // ==================== PRIVATE UTILITIES ====================

    /**
     * Đọc dữ liệu từ HTTP request và tạo MedicalRecordDTO.
     */
    private MedicalRecordDTO buildRecordDTOFromRequest(HttpServletRequest request) {
        MedicalRecordDTO dto = new MedicalRecordDTO();
        dto.setDiagnosis(request.getParameter("diagnosis"));
        dto.setTreatmentPlan(request.getParameter("treatmentPlan"));
        dto.setNotes(request.getParameter("notes"));
        dto.setBloodPressure(request.getParameter("bloodPressure"));

        try { dto.setPatientId(Integer.parseInt(request.getParameter("patientId"))); }
        catch (Exception ignored) {}
        try { dto.setHeartRate(Integer.parseInt(request.getParameter("heartRate"))); }
        catch (Exception ignored) {}
        try { dto.setTemperature(Double.parseDouble(request.getParameter("temperature"))); }
        catch (Exception ignored) {}
        try { dto.setWeight(Double.parseDouble(request.getParameter("weight"))); }
        catch (Exception ignored) {}
        try { dto.setHeight(Double.parseDouble(request.getParameter("height"))); }
        catch (Exception ignored) {}

        return dto;
    }

    /**
     * Lấy doctor_id từ user đang đăng nhập (tra cứu trong bảng doctors).
     */
    private int getDoctorIdFromUser(User user) {
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("doctor_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1; // Fallback
    }
}
