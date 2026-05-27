package com.jvcare.controller;

import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.model.MedicalRecord;
import com.jvcare.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/index")
public class PatientHomeServlet extends HttpServlet {
    private MedicalRecordDAO recordDAO = new MedicalRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        com.jvcare.dao.PatientDAO patientDAO = new com.jvcare.dao.PatientDAO();
        com.jvcare.model.Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        int patientId = patient != null ? patient.getPatientId() : -1;

        if (patientId != -1) {
            List<MedicalRecord> allRecords = recordDAO.getRecordsByPatientId(patientId);
            
            // Pagination: 12 items per page
            int pageSize = 12;
            int totalItems = allRecords.size();
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
            List<MedicalRecord> records = (start < totalItems) ? allRecords.subList(start, end) : new java.util.ArrayList<>();
            
            request.setAttribute("records", records);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
        }

        request.getRequestDispatcher("/WEB-INF/views/patient/index.jsp").forward(request, response);
    }
}
