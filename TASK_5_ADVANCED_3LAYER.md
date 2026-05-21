# TASK 5: TÍNH NĂNG NÂNG CAO & UX/UI (3-LAYER)

## 📋 CẤU TRÚC 3 LỚP

```
PRESENTATION LAYER
  ├── SearchServlet.java
  └── (Other servlets use services)
           ↓
BUSINESS LOGIC LAYER
  ├── SearchService.java
  ├── EmailService.java
  └── ValidationService.java
           ↓
DATA ACCESS LAYER
  └── (Use existing DAOs)
```

---

## 📝 BƯỚC 1: TẠO DTO CLASSES

### SearchResultDTO.java

```java
package com.jvcare.dto;

import java.util.Map;

public class SearchResultDTO {
    private String resultType; // patient, doctor, appointment
    private int id;
    private String name;
    private String code;
    private Map<String, String> additionalInfo;
    private double relevanceScore;
    
    // Constructors, Getters, Setters
}
```

### EmailDTO.java

```java
package com.jvcare.dto;

import java.util.List;
import java.util.Map;

public class EmailDTO {
    private String to;
    private String subject;
    private String body;
    private List<String> attachments;
    private String template;
    private Map<String, Object> templateData;
    
    // Constructors, Getters, Setters
}
```

---

## 📝 BƯỚC 2: TẠO SEARCH SERVICE

### SearchService.java

```java
package com.jvcare.service;

import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.DoctorDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.dto.SearchResultDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class SearchService {
    
    private PatientDAO patientDAO = new PatientDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    /**
     * Tìm kiếm global (tất cả loại)
     */
    public List<SearchResultDTO> searchGlobal(String keyword) 
            throws BusinessException, ValidationException {
        
        // Validate
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new ValidationException("Từ khóa tìm kiếm không được để trống");
        }
        
        if (keyword.length() < 2) {
            throw new ValidationException("Từ khóa phải có ít nhất 2 ký tự");
        }
        
        try {
            List<SearchResultDTO> results = new ArrayList<>();
            
            // Search patients
            results.addAll(searchPatients(keyword));
            
            // Search doctors
            results.addAll(searchDoctors(keyword));
            
            // Search appointments
            results.addAll(searchAppointments(keyword));
            
            // Sort by relevance score
            results.sort((a, b) -> 
                Double.compare(b.getRelevanceScore(), a.getRelevanceScore()));
            
            // Limit to top 30 results
            return results.stream().limit(30).collect(Collectors.toList());
            
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tìm kiếm", e);
        }
    }
    
    /**
     * Tìm kiếm bệnh nhân
     */
    public List<SearchResultDTO> searchPatients(String keyword) 
            throws BusinessException {
        try {
            List<Patient> patients = patientDAO.searchPatients(keyword);
            
            return patients.stream()
                .limit(10)
                .map(p -> {
                    SearchResultDTO result = new SearchResultDTO();
                    result.setResultType("patient");
                    result.setId(p.getPatientId());
                    result.setName(p.getFullName());
                    result.setCode(p.getPatientCode());
                    result.setRelevanceScore(
                        calculateRelevance(p.getFullName(), keyword));
                    
                    Map<String, String> info = new HashMap<>();
                    info.put("phone", p.getPhone());
                    info.put("email", p.getEmail());
                    result.setAdditionalInfo(info);
                    
                    return result;
                })
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            throw new BusinessException("Lỗi khi tìm kiếm bệnh nhân", e);
        }
    }
    
    /**
     * Tìm kiếm bác sĩ
     */
    public List<SearchResultDTO> searchDoctors(String keyword) 
            throws BusinessException {
        // Similar implementation
        return new ArrayList<>();
    }
    
    /**
     * Tìm kiếm lịch hẹn
     */
    public List<SearchResultDTO> searchAppointments(String keyword) 
            throws BusinessException {
        // Similar implementation
        return new ArrayList<>();
    }
    
    /**
     * Tính điểm relevance (fuzzy matching)
     */
    private double calculateRelevance(String text, String keyword) {
        if (text == null || keyword == null) return 0.0;
        
        text = text.toLowerCase();
        keyword = keyword.toLowerCase();
        
        // Exact match
        if (text.equals(keyword)) return 1.0;
        
        // Starts with
        if (text.startsWith(keyword)) return 0.9;
        
        // Contains
        if (text.contains(keyword)) return 0.7;
        
        // Fuzzy match (Levenshtein distance)
        int distance = levenshteinDistance(text, keyword);
        double similarity = 1.0 - ((double) distance / Math.max(text.length(), keyword.length()));
        
        return similarity > 0.5 ? similarity * 0.6 : 0.0;
    }
    
    /**
     * Levenshtein distance algorithm
     */
    private int levenshteinDistance(String s1, String s2) {
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];
        
        for (int i = 0; i <= s1.length(); i++) {
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0) {
                    dp[i][j] = j;
                } else if (j == 0) {
                    dp[i][j] = i;
                } else {
                    dp[i][j] = Math.min(
                        dp[i - 1][j - 1] + (s1.charAt(i - 1) == s2.charAt(j - 1) ? 0 : 1),
                        Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1)
                    );
                }
            }
        }
        
        return dp[s1.length()][s2.length()];
    }
}
```

---

## 📝 BƯỚC 3: TẠO EMAIL SERVICE (Nâng cấp)

### EmailService.java

```java
package com.jvcare.service;

import com.jvcare.dto.EmailDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailService {
    
    private static final String SMTP_HOST = System.getenv("SMTP_HOST");
    private static final String SMTP_PORT = System.getenv("SMTP_PORT");
    private static final String SMTP_USER = System.getenv("SMTP_USER");
    private static final String SMTP_PASSWORD = System.getenv("SMTP_PASSWORD");
    
    /**
     * Gửi email
     */
    public boolean sendEmail(EmailDTO emailDTO) 
            throws BusinessException, ValidationException {
        
        // Validate
        validateEmail(emailDTO);
        
        try {
            // Setup properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            
            // Create session
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
                }
            });
            
            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, 
                InternetAddress.parse(emailDTO.getTo()));
            message.setSubject(emailDTO.getSubject());
            
            // Render template if provided
            String body = emailDTO.getTemplate() != null ?
                renderTemplate(emailDTO.getTemplate(), emailDTO.getTemplateData()) :
                emailDTO.getBody();
            
            message.setContent(body, "text/html; charset=utf-8");
            
            // Send
            Transport.send(message);
            return true;
            
        } catch (MessagingException e) {
            throw new BusinessException("Lỗi khi gửi email", e);
        }
    }
    
    /**
     * Render email template
     */
    private String renderTemplate(String template, Map<String, Object> data) {
        // Simple template engine
        String result = template;
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            result = result.replace("{{" + entry.getKey() + "}}", 
                entry.getValue().toString());
        }
        return result;
    }
    
    /**
     * Validate email data
     */
    private void validateEmail(EmailDTO dto) throws ValidationException {
        if (dto.getTo() == null || !dto.getTo().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new ValidationException("Email người nhận không hợp lệ");
        }
        
        if (dto.getSubject() == null || dto.getSubject().trim().isEmpty()) {
            throw new ValidationException("Tiêu đề email không được để trống");
        }
        
        if (dto.getBody() == null && dto.getTemplate() == null) {
            throw new ValidationException("Nội dung email không được để trống");
        }
    }
}
```

---

## 📝 BƯỚC 4: TẠO VALIDATION SERVICE

### ValidationService.java

```java
package com.jvcare.service;

import com.jvcare.exception.ValidationException;

public class ValidationService {
    
    /**
     * Validate email format
     */
    public static boolean validateEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
    
    /**
     * Validate phone number (Vietnam format)
     */
    public static boolean validatePhone(String phone) {
        return phone != null && phone.matches("^(0|\\+84)[0-9]{9}$");
    }
    
    /**
     * Validate password strength
     */
    public static boolean validatePassword(String password) 
            throws ValidationException {
        if (password == null || password.length() < 6) {
            throw new ValidationException("Password phải có ít nhất 6 ký tự");
        }
        
        // Check for at least one letter and one number
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        
        if (!hasLetter || !hasDigit) {
            throw new ValidationException(
                "Password phải chứa cả chữ và số");
        }
        
        return true;
    }
    
    /**
     * Sanitize input (prevent XSS)
     */
    public static String sanitizeInput(String input) {
        if (input == null) return null;
        
        return input.replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("/", "&#x2F;");
    }
    
    /**
     * Check for XSS attempts
     */
    public static boolean checkXSS(String input) {
        if (input == null) return false;
        
        String[] xssPatterns = {
            "<script", "javascript:", "onerror=", "onload=",
            "<iframe", "<object", "<embed"
        };
        
        String lowerInput = input.toLowerCase();
        for (String pattern : xssPatterns) {
            if (lowerInput.contains(pattern)) {
                return true;
            }
        }
        
        return false;
    }
}
```

---

## ✅ CHECKLIST

- [ ] Tạo SearchResultDTO.java
- [ ] Tạo EmailDTO.java
- [ ] Tạo SearchService.java với fuzzy matching
- [ ] Nâng cấp EmailService.java
- [ ] Tạo ValidationService.java
- [ ] Cập nhật SearchServlet
- [ ] Implement AJAX search
- [ ] Tạo AuthFilter.java
- [ ] Tạo RoleFilter.java
- [ ] Tạo error pages (404, 403, 500)
- [ ] Implement pagination utility
- [ ] Test tất cả chức năng

