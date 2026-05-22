package com.jvcare.controller;

import com.jvcare.service.StatisticsService;
import com.jvcare.dto.StatisticsDTO;
import com.jvcare.model.User;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/index")
public class AdminHomeServlet extends HttpServlet {
    
    private StatisticsService statisticsService;
    
    @Override
    public void init() throws ServletException {
        super.init();
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
        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        try {
            StatisticsDTO stats = statisticsService.getAdminStatistics();
            
            // Convert to JSON for charts
            Gson gson = new Gson();
            String monthlyJson = gson.toJson(stats.getAppointmentsByMonth());
            String statusJson = gson.toJson(stats.getAppointmentsByStatus());
            String roleJson = gson.toJson(stats.getUsersByRole());
            
            request.setAttribute("stats", stats);
            request.setAttribute("monthlyJson", monthlyJson);
            request.setAttribute("statusJson", statusJson);
            request.setAttribute("roleJson", roleJson);
            request.setAttribute("currentYear", java.time.Year.now().getValue());
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy dữ liệu thống kê: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/index.jsp").forward(request, response);
    }
}
