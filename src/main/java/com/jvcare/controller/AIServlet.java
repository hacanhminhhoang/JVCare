package com.jvcare.controller;

import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.model.MedicalRecord;
import com.jvcare.util.GroqAIClient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/ai")
public class AIServlet extends HttpServlet {
    private MedicalRecordDAO recordDAO = new MedicalRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to the JSP page
        request.getRequestDispatcher("/WEB-INF/views/patient/ai.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String question = request.getParameter("question");
        
        // In a real app, we would get patientId from the session
        // For testing, we use patientId = 1 (Nguyễn Văn An from sample data)
        int patientId = 1; 

        List<MedicalRecord> records = recordDAO.getRecordsByPatientId(patientId);
        
        // Build prompt context from records
        StringBuilder contextBuilder = new StringBuilder();
        contextBuilder.append("Hồ sơ bệnh án của bệnh nhân:\n");
        for (MedicalRecord r : records) {
            contextBuilder.append("- Ngày khám: ").append(r.getVisitDate())
                          .append(", Chẩn đoán: ").append(r.getDiagnosis())
                          .append(", Hướng điều trị: ").append(r.getTreatmentPlan())
                          .append(", Bệnh sử: ").append(r.getMedicalHistory())
                          .append(", Lý do khám: ").append(r.getChiefComplaint())
                          .append("\n");
        }

        String systemPrompt = "Bạn là trợ lý AI y tế chuyên nghiệp của hệ thống JVCare. " +
                "Bạn sẽ dựa vào hồ sơ bệnh án dưới đây để trả lời câu hỏi của bệnh nhân một cách dễ hiểu, ân cần. " +
                "Luôn có disclaimer rằng đây chỉ là thông tin tham khảo, không thay thế bác sĩ.\n\n" +
                contextBuilder.toString();

        String aiReply = "";
        try {
            aiReply = GroqAIClient.getCompletion(systemPrompt, question);
        } catch (Exception e) {
            aiReply = "Xin lỗi, đã xảy ra lỗi khi kết nối với AI: " + e.getMessage();
            e.printStackTrace();
        }

        request.setAttribute("question", question);
        request.setAttribute("reply", aiReply);
        request.getRequestDispatcher("/WEB-INF/views/patient/ai.jsp").forward(request, response);
    }
}
