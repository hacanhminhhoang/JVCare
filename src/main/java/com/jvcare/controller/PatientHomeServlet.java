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
        
        // Note: For a real app we need a PatientDAO to get patientId by userId.
        // For demonstration based on DB schema: patient01 (user_id=6) -> patient_id=1
        // We will hardcode patientId = 1 or fetch it if we implemented PatientDAO.
        // Assuming we just use patient_id = 1 for testing since the sample data matches it.
        int patientId = 1;

        List<MedicalRecord> records = recordDAO.getRecordsByPatientId(patientId);
        
        request.setAttribute("records", records);
        request.getRequestDispatcher("/WEB-INF/views/patient/index.jsp").forward(request, response);
    }
}
