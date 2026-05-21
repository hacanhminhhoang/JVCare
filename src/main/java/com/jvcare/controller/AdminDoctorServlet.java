package com.jvcare.controller;

import com.jvcare.dao.DoctorDAO;
import com.jvcare.dao.UserDAO;
import com.jvcare.dao.DepartmentDAO;
import com.jvcare.model.Doctor;
import com.jvcare.model.User;
import com.jvcare.model.Department;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/doctors")
public class AdminDoctorServlet extends HttpServlet {
    
    private DoctorDAO doctorDAO = new DoctorDAO();
    private UserDAO userDAO = new UserDAO();
    private DepartmentDAO departmentDAO = new DepartmentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra authentication và authorization
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            viewDoctor(request, response);
        } else if ("create".equals(action)) {
            showCreateForm(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("delete".equals(action)) {
            deleteDoctor(request, response);
        } else if ("search".equals(action)) {
            searchDoctors(request, response);
        } else {
            listDoctors(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách doctors
     */
    private void listDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Disable cache để luôn load dữ liệu mới
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        int totalDoctors = doctorDAO.getTotalDoctors();
        
        System.out.println("AdminDoctorServlet: Loaded " + doctors.size() + " doctors, total count: " + totalDoctors);
        
        // Lấy thông báo success nếu có
        String success = request.getParameter("success");
        if (success != null) {
            switch (success) {
                case "created":
                    request.setAttribute("successMessage", "Tạo bác sĩ thành công!");
                    break;
                case "updated":
                    request.setAttribute("successMessage", "Cập nhật bác sĩ thành công!");
                    break;
                case "deleted":
                    request.setAttribute("successMessage", "Xóa bác sĩ thành công!");
                    break;
            }
        }
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("totalDoctors", totalDoctors);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/doctors.jsp").forward(request, response);
    }
    
    /**
     * Xem chi tiết doctor
     */
    private void viewDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int doctorId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorDAO.getDoctorById(doctorId);
        
        if (doctor == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bác sĩ không tồn tại");
            return;
        }
        
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/WEB-INF/views/admin/doctor_detail.jsp").forward(request, response);
    }
    
    /**
     * Tìm kiếm doctors
     */
    private void searchDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            listDoctors(request, response);
            return;
        }
        
        List<Doctor> doctors = doctorDAO.searchDoctors(keyword);
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalDoctors", doctors.size());
        
        request.getRequestDispatcher("/WEB-INF/views/admin/doctors.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form tạo
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Department> departments = departmentDAO.getAllActiveDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/WEB-INF/views/admin/doctor_form.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form sửa
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        Doctor doctor = doctorDAO.getDoctorByUserId(userId);
        User user = userDAO.getUserById(userId);
        
        if (doctor == null || user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bác sĩ không tồn tại");
            return;
        }
        
        List<Department> departments = departmentDAO.getAllActiveDepartments();
        request.setAttribute("departments", departments);
        request.setAttribute("editUser", user);
        request.setAttribute("doctor", doctor);
        request.getRequestDispatcher("/WEB-INF/views/admin/doctor_form.jsp").forward(request, response);
    }
    
    /**
     * Xóa bác sĩ
     */
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            userDAO.deleteUser(userId);
            response.sendRedirect(request.getContextPath() + "/admin/doctors?success=deleted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/doctors?error=delete_failed");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createDoctor(request, response);
        } else if ("update".equals(action)) {
            updateDoctor(request, response);
        } else if ("search".equals(action)) {
            searchDoctors(request, response);
        }
    }
    
    private void createDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String specialization = request.getParameter("specialization");
            String departmentIdStr = request.getParameter("departmentId");
            
            if (userDAO.existsByUsername(username) || userDAO.existsByEmail(email)) {
                request.setAttribute("error", "Username hoặc Email đã tồn tại");
                showCreateForm(request, response);
                return;
            }
            
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setEmail(email);
            user.setFullName(fullName);
            user.setRole("DOCTOR");
            user.setPhone(phone);
            user.setStatus("ACTIVE");
            
            if (userDAO.createUser(user)) {
                Doctor doctor = new Doctor();
                doctor.setUserId(user.getUserId());
                doctor.setSpecialization(specialization);
                if (departmentIdStr != null && !departmentIdStr.trim().isEmpty()) {
                    doctor.setDepartmentId(Integer.parseInt(departmentIdStr));
                }
                doctorDAO.createDoctor(doctor);
                response.sendRedirect(request.getContextPath() + "/admin/doctors?success=created");
            } else {
                request.setAttribute("error", "Không thể tạo user bác sĩ");
                showCreateForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showCreateForm(request, response);
        }
    }
    
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String specialization = request.getParameter("specialization");
            String departmentIdStr = request.getParameter("departmentId");
            
            User existingUser = userDAO.getUserById(userId);
            if (existingUser == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            if (userDAO.existsByEmailExcludingUser(email, userId)) {
                request.setAttribute("error", "Email đã được sử dụng");
                showEditForm(request, response);
                return;
            }
            
            existingUser.setEmail(email);
            existingUser.setFullName(fullName);
            existingUser.setPhone(phone);
            existingUser.setStatus(status);
            
            if (userDAO.updateUser(existingUser)) {
                Doctor doctor = doctorDAO.getDoctorByUserId(userId);
                if (doctor != null) {
                    doctor.setSpecialization(specialization);
                    if (departmentIdStr != null && !departmentIdStr.trim().isEmpty()) {
                        doctor.setDepartmentId(Integer.parseInt(departmentIdStr));
                    } else {
                        doctor.setDepartmentId(null);
                    }
                    doctorDAO.updateDoctor(doctor);
                }
                response.sendRedirect(request.getContextPath() + "/admin/doctors?success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật user bác sĩ");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    /**
     * Kiểm tra quyền truy cập ADMIN
     */
    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này");
            return false;
        }
        
        return true;
    }
}
