# HƯỚNG DẪN TASK 5: TÍNH NĂNG NÂNG CAO & UX/UI

## 📋 TỔNG QUAN
Phát triển các tính năng nâng cao: tìm kiếm, filter, email notification, pagination và cải thiện UI/UX.

**Thời gian ước tính:** 1-2 ngày

---

## 🗂️ CẤU TRÚC FILE CẦN TẠO

```
src/main/java/com/jvcare/
├── controller/
│   └── SearchServlet.java                     [MỚI]
├── filter/
│   ├── AuthFilter.java                        [MỚI]
│   └── RoleFilter.java                        [MỚI]
└── util/
    ├── EmailService.java                      [MỚI]
    └── PaginationUtil.java                    [MỚI]

src/main/webapp/
├── WEB-INF/views/error/
│   ├── 404.jsp                                [MỚI]
│   ├── 403.jsp                                [MỚI]
│   └── 500.jsp                                [MỚI]
└── js/
    ├── search.js                              [MỚI]
    ├── validation.js                          [MỚI]
    └── notifications.js                       [MỚI]
```

---

## 📝 BƯỚC 1: TẠO SEARCH SERVLET

**File:** `src/main/java/com/jvcare/controller/SearchServlet.java`

```java
package com.jvcare.controller;

import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.Patient;
import com.jvcare.model.Appointment;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    
    private PatientDAO patientDAO = new PatientDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String query = request.getParameter("q");
        String type = request.getParameter("type"); // patient, doctor, appointment
        
        if (query == null || query.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        Map<String, Object> results = new HashMap<>();
        
        if ("patient".equals(type)) {
            results.put("patients", searchPatients(query));
        } else if ("appointment".equals(type)) {
            results.put("appointments", searchAppointments(query));
        } else {
            // Search all
            results.put("patients", searchPatients(query));
            results.put("appointments", searchAppointments(query));
        }
        
        // Return JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Gson gson = new Gson();
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(results));
        out.flush();
    }
    
    private List<Map<String, String>> searchPatients(String query) {
        List<Map<String, String>> results = new ArrayList<>();
        List<Patient> patients = patientDAO.getAllPatients();
        
        for (Patient p : patients) {
            if (matchesQuery(p, query)) {
                Map<String, String> item = new HashMap<>();
                item.put("id", String.valueOf(p.getPatientId()));
                item.put("name", p.getFullName());
                item.put("code", p.getPatientCode());
                item.put("phone", p.getPhone());
                results.add(item);
                
                if (results.size() >= 10) break; // Limit results
            }
        }
        return results;
    }
    
    private List<Map<String, String>> searchAppointments(String query) {
        // Similar implementation
        return new ArrayList<>();
    }
    
    private boolean matchesQuery(Patient p, String query) {
        String q = query.toLowerCase();
        return (p.getFullName() != null && p.getFullName().toLowerCase().contains(q)) ||
               (p.getPatientCode() != null && p.getPatientCode().toLowerCase().contains(q)) ||
               (p.getPhone() != null && p.getPhone().contains(q));
    }
}
```

---

## 📝 BƯỚC 2: TẠO EMAIL SERVICE

**File:** `src/main/java/com/jvcare/util/EmailService.java`

```java
package com.jvcare.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import io.github.cdimascio.dotenv.Dotenv;

public class EmailService {
    
    private static final Dotenv dotenv = Dotenv.load();
    private static final String SMTP_HOST = dotenv.get("SMTP_HOST", "smtp.gmail.com");
    private static final String SMTP_PORT = dotenv.get("SMTP_PORT", "587");
    private static final String SMTP_USER = dotenv.get("SMTP_USER");
    private static final String SMTP_PASSWORD = dotenv.get("SMTP_PASSWORD");
    
    /**
     * Gửi email xác nhận lịch hẹn
     */
    public static boolean sendAppointmentConfirmation(String toEmail, String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        String subject = "Xác nhận lịch hẹn - JVCare";
        String body = buildAppointmentConfirmationEmail(patientName, appointmentDate, 
                                                        appointmentTime, doctorName);
        
        return sendEmail(toEmail, subject, body);
    }
    
    /**
     * Gửi email nhắc nhở lịch hẹn
     */
    public static boolean sendAppointmentReminder(String toEmail, String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        String subject = "Nhắc nhở lịch hẹn - JVCare";
        String body = buildAppointmentReminderEmail(patientName, appointmentDate, 
                                                     appointmentTime, doctorName);
        
        return sendEmail(toEmail, subject, body);
    }
    
    /**
     * Gửi email hủy lịch hẹn
     */
    public static boolean sendAppointmentCancellation(String toEmail, String patientName, 
            String appointmentDate, String appointmentTime) {
        
        String subject = "Thông báo hủy lịch hẹn - JVCare";
        String body = buildAppointmentCancellationEmail(patientName, appointmentDate, appointmentTime);
        
        return sendEmail(toEmail, subject, body);
    }
    
    /**
     * Core method để gửi email
     */
    private static boolean sendEmail(String toEmail, String subject, String body) {
        
        if (SMTP_USER == null || SMTP_PASSWORD == null) {
            System.err.println("SMTP credentials not configured in .env");
            return false;
        }
        
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, "JVCare System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            Transport.send(message);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Build HTML email template cho xác nhận lịch hẹn
     */
    private static String buildAppointmentConfirmationEmail(String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        return "<!DOCTYPE html>" +
               "<html><head><meta charset='UTF-8'></head><body>" +
               "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
               "<h2 style='color: #2c3e50;'>Xác nhận lịch hẹn</h2>" +
               "<p>Kính gửi <strong>" + patientName + "</strong>,</p>" +
               "<p>Lịch hẹn của bạn đã được xác nhận:</p>" +
               "<div style='background: #f8f9fa; padding: 15px; border-radius: 5px;'>" +
               "<p><strong>Ngày:</strong> " + appointmentDate + "</p>" +
               "<p><strong>Giờ:</strong> " + appointmentTime + "</p>" +
               "<p><strong>Bác sĩ:</strong> " + doctorName + "</p>" +
               "</div>" +
               "<p>Vui lòng đến đúng giờ. Xin cảm ơn!</p>" +
               "<hr style='border: 1px solid #eee;'>" +
               "<p style='color: #7f8c8d; font-size: 12px;'>JVCare - Hệ thống quản lý bệnh án</p>" +
               "</div></body></html>";
    }
    
    private static String buildAppointmentReminderEmail(String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        return "<!DOCTYPE html>" +
               "<html><head><meta charset='UTF-8'></head><body>" +
               "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
               "<h2 style='color: #e74c3c;'>Nhắc nhở lịch hẹn</h2>" +
               "<p>Kính gửi <strong>" + patientName + "</strong>,</p>" +
               "<p>Đây là lời nhắc về lịch hẹn của bạn vào ngày mai:</p>" +
               "<div style='background: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107;'>" +
               "<p><strong>Ngày:</strong> " + appointmentDate + "</p>" +
               "<p><strong>Giờ:</strong> " + appointmentTime + "</p>" +
               "<p><strong>Bác sĩ:</strong> " + doctorName + "</p>" +
               "</div>" +
               "<p>Vui lòng đến đúng giờ. Nếu không thể đến, vui lòng hủy lịch trước 24 giờ.</p>" +
               "<hr style='border: 1px solid #eee;'>" +
               "<p style='color: #7f8c8d; font-size: 12px;'>JVCare - Hệ thống quản lý bệnh án</p>" +
               "</div></body></html>";
    }
    
    private static String buildAppointmentCancellationEmail(String patientName, 
            String appointmentDate, String appointmentTime) {
        
        return "<!DOCTYPE html>" +
               "<html><head><meta charset='UTF-8'></head><body>" +
               "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
               "<h2 style='color: #e74c3c;'>Thông báo hủy lịch hẹn</h2>" +
               "<p>Kính gửi <strong>" + patientName + "</strong>,</p>" +
               "<p>Lịch hẹn của bạn đã được hủy:</p>" +
               "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; border-left: 4px solid #dc3545;'>" +
               "<p><strong>Ngày:</strong> " + appointmentDate + "</p>" +
               "<p><strong>Giờ:</strong> " + appointmentTime + "</p>" +
               "</div>" +
               "<p>Nếu bạn muốn đặt lịch mới, vui lòng truy cập hệ thống.</p>" +
               "<hr style='border: 1px solid #eee;'>" +
               "<p style='color: #7f8c8d; font-size: 12px;'>JVCare - Hệ thống quản lý bệnh án</p>" +
               "</div></body></html>";
    }
}
```

---

## 📝 BƯỚC 3: TẠO PAGINATION UTIL

**File:** `src/main/java/com/jvcare/util/PaginationUtil.java`

```java
package com.jvcare.util;

public class PaginationUtil {
    
    private int currentPage;
    private int pageSize;
    private int totalItems;
    private int totalPages;
    
    public PaginationUtil(int currentPage, int pageSize, int totalItems) {
        this.currentPage = currentPage > 0 ? currentPage : 1;
        this.pageSize = pageSize > 0 ? pageSize : 10;
        this.totalItems = totalItems;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);
    }
    
    public int getOffset() {
        return (currentPage - 1) * pageSize;
    }
    
    public int getLimit() {
        return pageSize;
    }
    
    public boolean hasPrevious() {
        return currentPage > 1;
    }
    
    public boolean hasNext() {
        return currentPage < totalPages;
    }
    
    public int getPreviousPage() {
        return hasPrevious() ? currentPage - 1 : 1;
    }
    
    public int getNextPage() {
        return hasNext() ? currentPage + 1 : totalPages;
    }
    
    // Getters
    public int getCurrentPage() { return currentPage; }
    public int getPageSize() { return pageSize; }
    public int getTotalItems() { return totalItems; }
    public int getTotalPages() { return totalPages; }
    
    /**
     * Generate HTML pagination links
     */
    public String generatePaginationHTML(String baseUrl) {
        StringBuilder html = new StringBuilder();
        html.append("<nav><ul class='pagination'>");
        
        // Previous button
        if (hasPrevious()) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?page=").append(getPreviousPage()).append("'>Previous</a>");
            html.append("</li>");
        }
        
        // Page numbers
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, currentPage + 2);
        
        for (int i = startPage; i <= endPage; i++) {
            html.append("<li class='page-item ").append(i == currentPage ? "active" : "").append("'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?page=").append(i).append("'>").append(i).append("</a>");
            html.append("</li>");
        }
        
        // Next button
        if (hasNext()) {
            html.append("<li class='page-item'>");
            html.append("<a class='page-link' href='").append(baseUrl)
                .append("?page=").append(getNextPage()).append("'>Next</a>");
            html.append("</li>");
        }
        
        html.append("</ul></nav>");
        return html.toString();
    }
}
```



---

## 📝 BƯỚC 4: TẠO AUTH FILTER

**File:** `src/main/java/com/jvcare/filter/AuthFilter.java`

```java
package com.jvcare.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/doctor/*", "/patient/*"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String loginURI = httpRequest.getContextPath() + "/login";
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isLoginRequest = httpRequest.getRequestURI().equals(loginURI);
        boolean isStaticResource = httpRequest.getRequestURI().contains("/css/") || 
                                   httpRequest.getRequestURI().contains("/js/") ||
                                   httpRequest.getRequestURI().contains("/images/");
        
        if (isLoggedIn || isLoginRequest || isStaticResource) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(loginURI);
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
```

---

## 📝 BƯỚC 5: TẠO ROLE FILTER

**File:** `src/main/java/com/jvcare/filter/RoleFilter.java`

```java
package com.jvcare.filter;

import com.jvcare.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/doctor/*", "/patient/*"})
public class RoleFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String requestURI = httpRequest.getRequestURI();
            
            boolean hasAccess = false;
            
            if (requestURI.contains("/admin/") && "ADMIN".equals(user.getRole())) {
                hasAccess = true;
            } else if (requestURI.contains("/doctor/") && "DOCTOR".equals(user.getRole())) {
                hasAccess = true;
            } else if (requestURI.contains("/patient/") && "PATIENT".equals(user.getRole())) {
                hasAccess = true;
            }
            
            if (hasAccess) {
                chain.doFilter(request, response);
            } else {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
                    "Bạn không có quyền truy cập trang này");
            }
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}
```

---

## 📝 BƯỚC 6: TẠO ERROR PAGES

**File:** `src/main/webapp/WEB-INF/views/error/404.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>404 - Không tìm thấy trang</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <style>
        .error-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .error-content {
            text-align: center;
            color: white;
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="error-page">
        <div class="error-content">
            <div class="error-code">404</div>
            <h2>Không tìm thấy trang</h2>
            <p>Trang bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-lg mt-3">
                <i class="bi bi-house"></i> Về trang chủ
            </a>
        </div>
    </div>
</body>
</html>
```

**File:** `src/main/webapp/WEB-INF/views/error/403.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>403 - Truy cập bị từ chối</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <style>
        .error-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .error-content {
            text-align: center;
            color: white;
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="error-page">
        <div class="error-content">
            <div class="error-code">403</div>
            <h2>Truy cập bị từ chối</h2>
            <p>Bạn không có quyền truy cập trang này.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-lg mt-3">
                Về trang chủ
            </a>
        </div>
    </div>
</body>
</html>
```

**File:** `src/main/webapp/WEB-INF/views/error/500.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>500 - Lỗi máy chủ</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <style>
        .error-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }
        .error-content {
            text-align: center;
            color: white;
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="error-page">
        <div class="error-content">
            <div class="error-code">500</div>
            <h2>Lỗi máy chủ</h2>
            <p>Đã xảy ra lỗi trong quá trình xử lý. Vui lòng thử lại sau.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-lg mt-3">
                Về trang chủ
            </a>
        </div>
    </div>
</body>
</html>
```

---

## 📝 BƯỚC 7: TẠO JAVASCRIPT FILES

**File:** `src/main/webapp/js/validation.js`

```javascript
/**
 * Form validation utilities
 */

// Validate email format
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

// Validate phone number (Vietnam format)
function validatePhone(phone) {
    const re = /^(0|\+84)[0-9]{9}$/;
    return re.test(phone);
}

// Validate required fields
function validateRequired(value) {
    return value !== null && value.trim() !== '';
}

// Add validation to form
function addFormValidation(formId) {
    const form = document.getElementById(formId);
    if (!form) return;
    
    form.addEventListener('submit', function(e) {
        let isValid = true;
        const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
        
        inputs.forEach(input => {
            if (!validateRequired(input.value)) {
                isValid = false;
                input.classList.add('is-invalid');
                showError(input, 'Trường này là bắt buộc');
            } else {
                input.classList.remove('is-invalid');
                hideError(input);
            }
            
            // Email validation
            if (input.type === 'email' && input.value && !validateEmail(input.value)) {
                isValid = false;
                input.classList.add('is-invalid');
                showError(input, 'Email không hợp lệ');
            }
            
            // Phone validation
            if (input.type === 'tel' && input.value && !validatePhone(input.value)) {
                isValid = false;
                input.classList.add('is-invalid');
                showError(input, 'Số điện thoại không hợp lệ');
            }
        });
        
        if (!isValid) {
            e.preventDefault();
        }
    });
}

function showError(input, message) {
    let errorDiv = input.nextElementSibling;
    if (!errorDiv || !errorDiv.classList.contains('invalid-feedback')) {
        errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback';
        input.parentNode.insertBefore(errorDiv, input.nextSibling);
    }
    errorDiv.textContent = message;
}

function hideError(input) {
    const errorDiv = input.nextElementSibling;
    if (errorDiv && errorDiv.classList.contains('invalid-feedback')) {
        errorDiv.remove();
    }
}
```

**File:** `src/main/webapp/js/notifications.js`

```javascript
/**
 * Toast notifications using SweetAlert2
 * Requires: <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
 */

function showSuccess(message) {
    Swal.fire({
        icon: 'success',
        title: 'Thành công!',
        text: message,
        timer: 3000,
        showConfirmButton: false,
        toast: true,
        position: 'top-end'
    });
}

function showError(message) {
    Swal.fire({
        icon: 'error',
        title: 'Lỗi!',
        text: message,
        timer: 3000,
        showConfirmButton: false,
        toast: true,
        position: 'top-end'
    });
}

function showInfo(message) {
    Swal.fire({
        icon: 'info',
        title: 'Thông báo',
        text: message,
        timer: 3000,
        showConfirmButton: false,
        toast: true,
        position: 'top-end'
    });
}

function confirmDelete(message, callback) {
    Swal.fire({
        title: 'Xác nhận xóa?',
        text: message || 'Bạn có chắc muốn xóa? Hành động này không thể hoàn tác!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed && callback) {
            callback();
        }
    });
}

function showLoading(message) {
    Swal.fire({
        title: message || 'Đang xử lý...',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
}

function hideLoading() {
    Swal.close();
}
```

---

## 📝 BƯỚC 8: CẬP NHẬT .ENV FILE

Thêm cấu hình SMTP vào file `.env`:

```properties
# Database
DB_URL=jdbc:sqlserver://localhost:1433;databaseName=JVCare_MVC;encrypt=false
DB_USER=sa
DB_PASSWORD=YourPassword

# Groq AI
GROQ_API_KEY=your_groq_api_key

# Email SMTP (Gmail example)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

**Lưu ý:** Với Gmail, bạn cần tạo App Password thay vì dùng password thường.

---

## 📝 BƯỚC 9: CẬP NHẬT POM.XML

Thêm dependencies cho email:

```xml
<!-- JavaMail API -->
<dependency>
    <groupId>com.sun.mail</groupId>
    <artifactId>javax.mail</artifactId>
    <version>1.6.2</version>
</dependency>

<!-- Apache POI for Excel export -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>5.2.3</version>
</dependency>

<!-- iText for PDF export -->
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itextpdf</artifactId>
    <version>5.5.13.3</version>
</dependency>
```

---

## 🧪 TESTING CHECKLIST

### Search Functionality
- [ ] Search patients by name
- [ ] Search patients by code
- [ ] Search patients by phone
- [ ] AJAX autocomplete works
- [ ] Results limit to 10 items

### Email Notifications
- [ ] Send appointment confirmation
- [ ] Send appointment reminder
- [ ] Send cancellation notice
- [ ] HTML email renders correctly
- [ ] SMTP configuration works

### Pagination
- [ ] Previous/Next buttons work
- [ ] Page numbers display correctly
- [ ] Active page highlighted
- [ ] Works with different page sizes

### Security Filters
- [ ] AuthFilter redirects to login
- [ ] RoleFilter blocks unauthorized access
- [ ] Session timeout handled
- [ ] CSRF protection works

### Error Pages
- [ ] 404 page displays correctly
- [ ] 403 page displays correctly
- [ ] 500 page displays correctly
- [ ] Links back to home work

### UI/UX
- [ ] Responsive design on mobile
- [ ] Loading spinner shows
- [ ] Toast notifications work
- [ ] Confirm dialogs work
- [ ] Form validation works

---

## 💡 TIPS & BEST PRACTICES

1. **Email Testing:** Dùng [Mailtrap.io](https://mailtrap.io) để test email trong development
2. **Search Performance:** Implement debounce cho AJAX search (delay 300ms)
3. **Pagination:** Cache results để tránh query lại database
4. **Security:** Always validate input trên cả client và server
5. **Error Handling:** Log errors vào file để debug
6. **UI/UX:** Test trên nhiều browsers (Chrome, Firefox, Edge)

---

## 📚 TÀI LIỆU THAM KHẢO

- [JavaMail API Guide](https://javaee.github.io/javamail/)
- [SweetAlert2 Documentation](https://sweetalert2.github.io/)
- [Bootstrap 5 Forms](https://getbootstrap.com/docs/5.0/forms/validation/)
- [Servlet Filters](https://www.baeldung.com/java-servlet-filters)
- [Apache POI Tutorial](https://www.baeldung.com/java-microsoft-excel)

