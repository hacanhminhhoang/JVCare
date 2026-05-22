package com.jvcare.controller;

import com.jvcare.dto.PrescriptionDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import com.jvcare.model.User;
import com.jvcare.service.PrescriptionService;
import com.jvcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Presentation Layer cho Đơn thuốc của Bác sĩ.
 * Chỉ xử lý HTTP request/response, không chứa business logic.
 * Tất cả logic được ủy quyền cho PrescriptionService.
 */
@WebServlet("/doctor/prescriptions")
public class DoctorPrescriptionServlet extends HttpServlet {

    // Sử dụng Service Layer thay vì trực tiếp DAO (đúng kiến trúc 3 lớp)
    private final PrescriptionService prescriptionService = new PrescriptionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkDoctorAccess(request, response)) return;

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deletePrescription(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!checkDoctorAccess(request, response)) return;

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createPrescription(request, response);
        } else if ("update".equals(action)) {
            updatePrescription(request, response);
        }
    }

    // ==================== HANDLERS ====================

    /**
     * Xử lý thêm thuốc mới vào bệnh án.
     */
    private void createPrescription(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int doctorId = getDoctorIdFromUser(user);

        try {
            int recordId = Integer.parseInt(request.getParameter("recordId"));
            PrescriptionDTO dto = buildPrescriptionDTOFromRequest(request);
            dto.setRecordId(recordId);

            prescriptionService.createPrescription(dto, doctorId);

            response.sendRedirect(request.getContextPath() +
                "/doctor/medical-records?action=detail&id=" + recordId);

        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/prescription_form.jsp")
                   .forward(request, response);
        } catch (BusinessException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/prescription_form.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Xử lý cập nhật thông tin thuốc.
     */
    private void updatePrescription(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int doctorId = getDoctorIdFromUser(user);

        try {
            int prescriptionId = Integer.parseInt(request.getParameter("prescriptionId"));
            int recordId = Integer.parseInt(request.getParameter("recordId"));

            PrescriptionDTO dto = buildPrescriptionDTOFromRequest(request);
            dto.setPrescriptionId(prescriptionId);
            dto.setRecordId(recordId);

            prescriptionService.updatePrescription(dto, doctorId);

            response.sendRedirect(request.getContextPath() +
                "/doctor/medical-records?action=detail&id=" + recordId);

        } catch (ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/prescription_form.jsp")
                   .forward(request, response);
        } catch (BusinessException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/prescription_form.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Xử lý xóa thuốc khỏi bệnh án.
     */
    private void deletePrescription(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        int doctorId = getDoctorIdFromUser(user);

        try {
            int prescriptionId = Integer.parseInt(request.getParameter("id"));
            int recordId = Integer.parseInt(request.getParameter("recordId"));

            prescriptionService.deletePrescription(prescriptionId, doctorId);

            response.sendRedirect(request.getContextPath() +
                "/doctor/medical-records?action=detail&id=" + recordId);

        } catch (ValidationException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (BusinessException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        }
    }

    /**
     * Hiển thị form chỉnh sửa thuốc.
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int prescriptionId = Integer.parseInt(request.getParameter("id"));
            PrescriptionDTO dto = prescriptionService.getPrescriptionById(prescriptionId);

            request.setAttribute("prescription", dto);
            request.getRequestDispatcher("/WEB-INF/views/doctor/prescription_form.jsp")
                   .forward(request, response);

        } catch (ValidationException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
        } catch (BusinessException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    // ==================== PRIVATE UTILITIES ====================

    /**
     * Đọc dữ liệu từ HTTP request và tạo PrescriptionDTO.
     */
    private PrescriptionDTO buildPrescriptionDTOFromRequest(HttpServletRequest request) {
        PrescriptionDTO dto = new PrescriptionDTO();
        dto.setMedicationName(request.getParameter("medicationName"));
        dto.setDosage(request.getParameter("dosage"));
        dto.setFrequency(request.getParameter("frequency"));
        dto.setInstructions(request.getParameter("instructions"));
        try {
            dto.setDurationDays(Integer.parseInt(request.getParameter("durationDays")));
        } catch (Exception ignored) {}
        return dto;
    }

    /**
     * Kiểm tra quyền truy cập bác sĩ (xác thực session và role).
     */
    private boolean checkDoctorAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ bác sĩ mới được truy cập");
            return false;
        }
        return true;
    }

    /**
     * Lấy doctor_id từ user đang đăng nhập.
     */
    private int getDoctorIdFromUser(User user) {
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("doctor_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1; // Fallback
    }
}
