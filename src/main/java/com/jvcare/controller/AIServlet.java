package com.jvcare.controller;

import com.jvcare.dao.MedicalRecordDAO;
import com.jvcare.model.MedicalRecord;
import com.jvcare.model.User;
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
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        com.jvcare.dao.PatientDAO patientDAO = new com.jvcare.dao.PatientDAO();
        com.jvcare.model.Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        int patientId = patient != null ? patient.getPatientId() : -1;

        List<MedicalRecord> records = recordDAO.getRecordsByPatientId(patientId);
        
        // Build prompt context from records
        StringBuilder contextBuilder = new StringBuilder();
        contextBuilder.append("Hồ sơ bệnh án của bệnh nhân:\n");
        for (MedicalRecord r : records) {
            contextBuilder.append("- Ngày khám: ").append(r.getVisitDate())
                          .append(", Chẩn đoán: ").append(r.getDiagnosis() != null ? r.getDiagnosis() : "Không rõ")
                          .append(", Hướng điều trị: ").append(r.getTreatmentPlan() != null ? r.getTreatmentPlan() : "Không rõ")
                          .append(", Ghi chú: ").append(r.getNotes() != null ? r.getNotes() : "Không có")
                          .append("\n");
        }

        String systemPrompt = "Bạn là trợ lý AI y tế chuyên nghiệp của hệ thống JVCare. " +
                "LƯU Ý QUAN TRỌNG: Người đang chat với bạn là BỆNH NHÂN (không phải bác sĩ). Hãy xưng hô là 'tôi' và gọi người dùng là 'bạn'. Tuyệt đối không gọi người dùng là bác sĩ.\n" +
                "Nhiệm vụ của bạn: Dựa vào hồ sơ bệnh án dưới đây để trả lời câu hỏi của bệnh nhân một cách thân thiện, dễ hiểu và ân cần.\n" +
                "Luôn có disclaimer ở cuối rằng đây chỉ là thông tin tham khảo, không thay thế chẩn đoán của bác sĩ.\n\n" +
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
