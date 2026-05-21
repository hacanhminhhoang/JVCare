# TASK 3: PATIENT - ĐẶT LỊCH & HỒ SƠ (3-LAYER)

## 📋 CẤU TRÚC 3 LỚP

```
PRESENTATION LAYER
  ├── PatientBookAppointmentServlet.java
  ├── PatientProfileServlet.java
  └── PatientMedicalHistoryServlet.java
           ↓
BUSINESS LOGIC LAYER
  ├── AppointmentService.java
  └── PatientService.java
           ↓
DATA ACCESS LAYER
  ├── AppointmentDAO.java
  └── PatientDAO.java
```

---

## 📝 BƯỚC 1: TẠO DTO CLASSES

### AppointmentDTO.java

```java
package com.jvcare.dto;

import java.sql.Date;
import java.sql.Time;

public class AppointmentDTO {
    private int appointmentId;
    private int patientId;
    private String patientName;
    private String patientCode;
    private int doctorId;
    private String doctorName;
    private String doctorSpecialization;
    private Date appointmentDate;
    private Time appointmentTime;
    private String status;
    private String reason;
    private String notes;
    private String diagnosis;
    private String patientCondition;
    private String advice;
    
    // Constructors, Getters, Setters
}
```

### PatientDTO.java

```java
package com.jvcare.dto;

import java.sql.Date;

public class PatientDTO {
    private int patientId;
    private int userId;
    private String patientCode;
    private String fullName;
    private Date dateOfBirth;
    private String gender;
    private String phone;
    private String email;
    private String address;
    private String allergies;
    private String chronicDiseases;
    private String avatarUrl;
    private String idCard;
    
    // Constructors, Getters, Setters
}
```

---

## 📝 BƯỚC 2: TẠO APPOINTMENT SERVICE

### AppointmentService.java (Xem file 3_LAYER_ARCHITECTURE.md để có code đầy đủ)

**Business Rules:**
- Không đặt lịch trong quá khứ
- Không đặt lịch quá xa (> 3 tháng)
- Check duplicate appointment
- Check time slot availability
- Giới hạn 3 pending appointments/patient
- Chỉ hủy được lịch PENDING
- Phải hủy trước ít nhất 24 giờ
- Gửi email confirmation

**Key Methods:**
```java
public boolean bookAppointment(AppointmentDTO dto)
public boolean cancelAppointment(int appointmentId, int patientId)
public List<AppointmentDTO> getAppointmentsByPatient(int patientId)
public List<String> getAvailableTimeSlots(Date date, int doctorId)
private void validateAppointment(AppointmentDTO dto)
```

---

## 📝 BƯỚC 3: TẠO PATIENT SERVICE

### PatientService.java

```java
package com.jvcare.service;

import com.jvcare.dao.PatientDAO;
import com.jvcare.model.Patient;
import com.jvcare.dto.PatientDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;

public class PatientService {
    
    private PatientDAO patientDAO = new PatientDAO();
    
    public PatientDTO getPatientByUserId(int userId) throws BusinessException {
        // Implementation
    }
    
    public boolean updateProfile(PatientDTO patientDTO) 
            throws BusinessException, ValidationException {
        // 1. Validate
        validatePatientData(patientDTO);
        
        // 2. Check exists
        // 3. Update
        // 4. Return result
    }
    
    public String uploadAvatar(int patientId, MultipartFile file) 
            throws BusinessException, ValidationException {
        // 1. Validate file (size < 2MB, format: jpg/png)
        // 2. Save file to /images/avatars/
        // 3. Update patient avatar_url
        // 4. Return file URL
    }
    
    private void validatePatientData(PatientDTO dto) throws ValidationException {
        // Validate phone, email, etc.
    }
}
```

---

## 📝 BƯỚC 4: CẬP NHẬT SERVLET

### PatientBookAppointmentServlet.java

```java
@WebServlet("/patient/book-appointment")
public class PatientBookAppointmentServlet extends HttpServlet {
    
    private AppointmentService appointmentService = new AppointmentService();
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Create DTO from request
            AppointmentDTO dto = new AppointmentDTO();
            dto.setPatientId(getPatientIdFromSession(request));
            dto.setAppointmentDate(Date.valueOf(request.getParameter("date")));
            dto.setAppointmentTime(Time.valueOf(request.getParameter("time") + ":00"));
            dto.setReason(request.getParameter("reason"));
            
            // Call Service
            boolean success = appointmentService.bookAppointment(dto);
            
            if (success) {
                response.sendRedirect("appointments?success=true");
            }
            
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
            // Forward back to form
        } catch (BusinessException e) {
            // Handle error
        }
    }
}
```

---

## ✅ CHECKLIST

- [ ] Tạo AppointmentDTO.java
- [ ] Tạo PatientDTO.java
- [ ] Tạo AppointmentService.java với business rules
- [ ] Tạo PatientService.java
- [ ] Cập nhật PatientBookAppointmentServlet
- [ ] Cập nhật PatientProfileServlet
- [ ] Cập nhật PatientMedicalHistoryServlet
- [ ] Test tất cả chức năng

