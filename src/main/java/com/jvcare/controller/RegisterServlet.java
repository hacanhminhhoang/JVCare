package com.jvcare.controller;

import com.jvcare.dao.UserDAO;
import com.jvcare.dao.PatientDAO;
import com.jvcare.model.User;
import com.jvcare.model.Patient;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Basic validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tất cả thông tin.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Check if email already registered
        if (userDAO.existsByEmail(email)) {
            request.setAttribute("errorMessage", "Email này đã được sử dụng. Vui lòng chọn email khác.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Check if username (email) is taken
        if (userDAO.existsByUsername(email)) {
            request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        try {
            // Hash password with BCrypt
            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

            // Create User
            User user = new User();
            user.setUsername(email); // Use email as username
            user.setPasswordHash(passwordHash);
            user.setEmail(email);
            user.setFullName(fullName);
            user.setRole("PATIENT");
            user.setPhone(phone);
            user.setStatus("ACTIVE");

            boolean userCreated = userDAO.createUser(user);

            if (userCreated && user.getUserId() > 0) {
                // Create linked Patient profile
                Patient patient = new Patient();
                patient.setUserId(user.getUserId());
                patient.setFullName(fullName);
                patient.setPhone(phone);
                patient.setEmail(email);
                patient.setGender("OTHER"); // Default gender
                patient.setDateOfBirth(Date.valueOf("1990-01-01")); // Default DOB
                patient.setAddress(""); // Default empty address
                patient.setAllergies("");
                patient.setChronicDiseases("");
                patient.setAvatarUrl("");

                boolean patientCreated = patientDAO.createPatientWithUser(patient);

                if (patientCreated) {
                    request.setAttribute("successMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Có lỗi xảy ra khi khởi tạo hồ sơ bệnh nhân.");
                    request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo tài khoản người dùng.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
