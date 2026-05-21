package com.jvcare.controller;

import com.jvcare.dao.UserDAO;
import com.jvcare.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra authentication và authorization
        if (!checkAdminAccess(request, response)) return;
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            showCreateForm(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        } else if ("search".equals(action)) {
            searchUsers(request, response);
        } else {
            listUsers(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!checkAdminAccess(request, response)) return;
        
        // Set encoding để hỗ trợ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách users với phân trang
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy tham số phân trang
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Lấy danh sách users
        List<User> users = userDAO.getAllUsers(page, pageSize);
        int totalUsers = userDAO.getTotalUsers();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        
        // Lấy thông báo success nếu có
        String success = request.getParameter("success");
        if (success != null) {
            switch (success) {
                case "created":
                    request.setAttribute("successMessage", "Tạo user thành công!");
                    break;
                case "updated":
                    request.setAttribute("successMessage", "Cập nhật user thành công!");
                    break;
                case "deleted":
                    request.setAttribute("successMessage", "Xóa user thành công!");
                    break;
            }
        }
        
        // Set attributes
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        
        // Forward to view
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form tạo user mới
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Không set attribute "user" để form biết đây là tạo mới
        request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form sửa user
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(userId);
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User không tồn tại");
            return;
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
    }
    
    /**
     * Tạo user mới
     */
    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy dữ liệu từ form
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String role = request.getParameter("role");
            String phone = request.getParameter("phone");
            
            // Validate
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("error", "Username không được để trống");
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
                return;
            }
            
            if (password == null || password.length() < 6) {
                request.setAttribute("error", "Password phải có ít nhất 6 ký tự");
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra duplicate username
            if (userDAO.existsByUsername(username)) {
                request.setAttribute("error", "Username đã tồn tại");
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra duplicate email
            if (userDAO.existsByEmail(email)) {
                request.setAttribute("error", "Email đã tồn tại");
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
                return;
            }
            
            // Hash password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            
            // Tạo User object
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(hashedPassword);
            user.setEmail(email);
            user.setFullName(fullName);
            user.setRole(role);
            user.setPhone(phone);
            user.setStatus("ACTIVE");
            
            // Lưu vào database
            boolean success = userDAO.createUser(user);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
            } else {
                request.setAttribute("error", "Không thể tạo user");
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Cập nhật user
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy dữ liệu từ form
            int userId = Integer.parseInt(request.getParameter("userId"));
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            
            // Kiểm tra user tồn tại
            User existingUser = userDAO.getUserById(userId);
            if (existingUser == null) {
                request.setAttribute("error", "User không tồn tại");
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra duplicate email (trừ user hiện tại)
            if (userDAO.existsByEmailExcludingUser(email, userId)) {
                request.setAttribute("error", "Email đã được sử dụng");
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật User
            existingUser.setEmail(email);
            existingUser.setFullName(fullName);
            existingUser.setPhone(phone);
            existingUser.setStatus(status);
            
            boolean success = userDAO.updateUser(existingUser);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
            } else {
                request.setAttribute("error", "Không thể cập nhật user");
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Xóa user (soft delete)
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            
            // Kiểm tra không được xóa chính mình
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser.getUserId() == userId) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=cannot_delete_self");
                return;
            }
            
            // Kiểm tra không xóa admin cuối cùng
            User user = userDAO.getUserById(userId);
            if ("ADMIN".equals(user.getRole())) {
                int adminCount = userDAO.countUsersByRole("ADMIN");
                if (adminCount <= 1) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=last_admin");
                    return;
                }
            }
            
            // Xóa user (soft delete)
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=delete_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users?error=system_error");
        }
    }
    
    /**
     * Tìm kiếm users
     */
    private void searchUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            listUsers(request, response);
            return;
        }
        
        List<User> users = userDAO.searchUsers(keyword);
        
        request.setAttribute("users", users);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalUsers", users.size());
        
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
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
