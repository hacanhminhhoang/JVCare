package com.jvcare.controller;

import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.DoctorDAO;
import com.jvcare.model.Patient;
import com.jvcare.model.User;
import com.jvcare.model.Doctor;
import com.jvcare.service.StatisticsService;
import com.jvcare.dto.StatisticsDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/index")
public class DoctorHomeServlet extends HttpServlet {
    private PatientDAO patientDAO;
    private DoctorDAO doctorDAO;
    private StatisticsService statisticsService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.patientDAO = new PatientDAO();
        this.doctorDAO = new DoctorDAO();
        this.statisticsService = new StatisticsService();
    }

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

        try {
            // Get doctor profile
            Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
            
            if (doctor != null) {
                // Get statistics
                StatisticsDTO stats = statisticsService.getDoctorStatistics(doctor.getDoctorId());
                request.setAttribute("stats", stats);
            }
            
            // Get patients for list
            List<Patient> patients = patientDAO.getAllPatients();
            request.setAttribute("patients", patients);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu: " + e.getMessage());
        }

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
