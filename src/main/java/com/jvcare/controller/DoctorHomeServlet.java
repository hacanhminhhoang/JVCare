package com.jvcare.controller;

import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.model.MedicalRecord;
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
import java.util.List;

@WebServlet("/doctor/index")
public class DoctorHomeServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private MedicalRecordDAO recordDAO = new MedicalRecordDAO();

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

        List<Patient> patients = patientDAO.getAllPatients();
        request.setAttribute("patients", patients);

        request.getRequestDispatcher("/WEB-INF/views/doctor/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String patientIdStr = request.getParameter("patientId");

        if ("delete".equals(action) && patientIdStr != null) {
            int pid = Integer.parseInt(patientIdStr);
            boolean success = patientDAO.deletePatient(pid);
            if (success) {
                request.getSession().setAttribute("message", "Đã xóa hồ sơ bệnh nhân thành công.");
            } else {
                request.getSession().setAttribute("error", "Không thể xóa bệnh nhân. Vui lòng kiểm tra lại ràng buộc dữ liệu.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/doctor/index");
    }
}
