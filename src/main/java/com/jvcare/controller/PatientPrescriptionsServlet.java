package com.jvcare.controller;

import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.PrescriptionDAO;
import com.jvcare.model.Patient;
import com.jvcare.model.Prescription;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/prescriptions")
public class PatientPrescriptionsServlet extends HttpServlet {
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"PATIENT".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền bệnh nhân.");
            return;
        }

        // Dummy logic to find patient_id by user_id
        int userId = user.getUserId();
        List<Patient> all = patientDAO.getAllPatients();
        int patientId = -1;
        for (Patient p : all) {
            if (p.getUserId() == userId) {
                patientId = p.getPatientId();
                break;
            }
        }

        if (patientId != -1) {
            List<Prescription> allList = prescriptionDAO.getPrescriptionsByPatientId(patientId);
            
            // Pagination: 12 items per page
            int pageSize = 12;
            int totalItems = allList.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (totalPages < 1) totalPages = 1;
            
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try { page = Integer.parseInt(pageParam); } catch (NumberFormatException e) { page = 1; }
            }
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;
            
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalItems);
            List<Prescription> pageList = (start < totalItems) ? allList.subList(start, end) : new java.util.ArrayList<>();
            
            request.setAttribute("prescriptions", pageList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
        }

        request.getRequestDispatcher("/WEB-INF/views/patient/prescriptions.jsp").forward(request, response);
    }
}
