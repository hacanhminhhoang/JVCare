package com.jvcare.controller;

import com.jvcare.dto.MedicalRecordDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import com.jvcare.model.User;
import com.jvcare.service.MedicalRecordService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Presentation Layer - In đơn thuốc.
 * Servlet nhận yêu cầu in đơn thuốc, lấy dữ liệu qua MedicalRecordService
 * rồi forward sang print_prescription.jsp để hiển thị bản in.
 * URL: GET /doctor/medical-records/print?id={recordId}
 */
@WebServlet("/doctor/medical-records/print")
public class DoctorPrintPrescriptionServlet extends HttpServlet {

    private final MedicalRecordService recordService = new MedicalRecordService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ bác sĩ mới được in đơn thuốc");
            return;
        }

        try {
            int recordId = Integer.parseInt(request.getParameter("id"));

            // Lấy bệnh án kèm đơn thuốc qua Service Layer
            MedicalRecordDTO record = recordService.getRecordWithPrescriptions(recordId);

            request.setAttribute("record", record);
            request.setAttribute("prescriptions", record.getPrescriptions());

            request.getRequestDispatcher("/WEB-INF/views/doctor/print_prescription.jsp")
                   .forward(request, response);

        } catch (ValidationException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bệnh án không tồn tại: " + e.getMessage());
        } catch (BusinessException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bệnh án không hợp lệ");
        }
    }
}
