-- ========================================
-- TEST DATA FOR TASK 2: DOCTOR MODULE
-- Quản lý Appointments và Medical Records
-- ========================================

USE JVCare_MVC_Member2; -- Thay đổi tên database theo thành viên
GO

-- ========================================
-- 1. USERS DATA (Prerequisites)
-- ========================================

-- Doctor user (password: 123456)
INSERT INTO users (username, password, email, full_name, role, phone, status, created_at) VALUES
('doctor1', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'doctor1@jvcare.com', 'Bác sĩ Nguyễn Văn A', 'DOCTOR', '0901234568', 'ACTIVE', GETDATE());

-- Patient users (password: 123456)
INSERT INTO users (username, password, email, full_name, role, phone, status, created_at) VALUES
('patient1', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'patient1@jvcare.com', 'Nguyễn Thị B', 'PATIENT', '0901234571', 'ACTIVE', GETDATE()),
('patient2', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'patient2@jvcare.com', 'Trần Văn C', 'PATIENT', '0901234572', 'ACTIVE', GETDATE()),
('patient3', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'patient3@jvcare.com', 'Lê Thị D', 'PATIENT', '0901234573', 'ACTIVE', GETDATE());

-- ========================================
-- 2. DOCTORS DATA
-- ========================================

DECLARE @doctor1_id INT = (SELECT user_id FROM users WHERE username = 'doctor1');

INSERT INTO doctors (user_id, specialization, license_number, experience_years, education, bio, consultation_fee, status) VALUES
(@doctor1_id, 'Nội khoa', 'BS001234', 10, 'Đại học Y Hà Nội', 'Chuyên khoa Nội tổng quát, Tim mạch', 200000, 'ACTIVE');

-- ========================================
-- 3. PATIENTS DATA
-- ========================================

DECLARE @patient1_id INT = (SELECT user_id FROM users WHERE username = 'patient1');
DECLARE @patient2_id INT = (SELECT user_id FROM users WHERE username = 'patient2');
DECLARE @patient3_id INT = (SELECT user_id FROM users WHERE username = 'patient3');

INSERT INTO patients (user_id, date_of_birth, gender, address, emergency_contact, blood_type, allergies) VALUES
(@patient1_id, '1990-05-15', 'F', '123 Nguyễn Huệ, Q1, TP.HCM', '0909999991', 'A+', 'Không'),
(@patient2_id, '1985-08-20', 'M', '456 Lê Lợi, Q3, TP.HCM', '0909999992', 'O+', 'Penicillin'),
(@patient3_id, '1995-12-10', 'F', '789 Trần Hưng Đạo, Q5, TP.HCM', '0909999993', 'B+', 'Không');

-- ========================================
-- 4. APPOINTMENTS DATA
-- ========================================

DECLARE @doctor_id INT = (SELECT doctor_id FROM doctors WHERE user_id = @doctor1_id);
DECLARE @pat1_id INT = (SELECT patient_id FROM patients WHERE user_id = @patient1_id);
DECLARE @pat2_id INT = (SELECT patient_id FROM patients WHERE user_id = @patient2_id);
DECLARE @pat3_id INT = (SELECT patient_id FROM patients WHERE user_id = @patient3_id);

-- Appointments với các status khác nhau
INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason, status, notes, created_at) VALUES
-- PENDING appointments
(@pat1_id, @doctor_id, DATEADD(day, 1, GETDATE()), 'Khám tổng quát', 'PENDING', 'Bệnh nhân mới', GETDATE()),
(@pat2_id, @doctor_id, DATEADD(day, 2, GETDATE()), 'Đau ngực', 'PENDING', 'Cần khám gấp', GETDATE()),

-- CONFIRMED appointments
(@pat1_id, @doctor_id, DATEADD(hour, 2, GETDATE()), 'Tái khám', 'CONFIRMED', 'Đã xác nhận', DATEADD(day, -1, GETDATE())),
(@pat3_id, @doctor_id, DATEADD(day, 3, GETDATE()), 'Khám định kỳ', 'CONFIRMED', 'Khám sức khỏe định kỳ', GETDATE()),

-- COMPLETED appointments (for medical records)
(@pat1_id, @doctor_id, DATEADD(day, -7, GETDATE()), 'Cảm cúm', 'COMPLETED', 'Đã hoàn thành', DATEADD(day, -10, GETDATE())),
(@pat2_id, @doctor_id, DATEADD(day, -14, GETDATE()), 'Đau dạ dày', 'COMPLETED', 'Đã hoàn thành', DATEADD(day, -15, GETDATE())),
(@pat3_id, @doctor_id, DATEADD(day, -21, GETDATE()), 'Cao huyết áp', 'COMPLETED', 'Đã hoàn thành', DATEADD(day, -22, GETDATE())),

-- CANCELLED appointment
(@pat2_id, @doctor_id, DATEADD(day, -3, GETDATE()), 'Khám tổng quát', 'CANCELLED', 'Bệnh nhân hủy', DATEADD(day, -5, GETDATE()));

-- ========================================
-- 5. MEDICAL RECORDS DATA
-- ========================================

-- Get completed appointment IDs
DECLARE @apt1_id INT = (SELECT TOP 1 appointment_id FROM appointments WHERE status = 'COMPLETED' AND patient_id = @pat1_id ORDER BY appointment_date DESC);
DECLARE @apt2_id INT = (SELECT TOP 1 appointment_id FROM appointments WHERE status = 'COMPLETED' AND patient_id = @pat2_id ORDER BY appointment_date DESC);
DECLARE @apt3_id INT = (SELECT TOP 1 appointment_id FROM appointments WHERE status = 'COMPLETED' AND patient_id = @pat3_id ORDER BY appointment_date DESC);

-- Medical records với vital signs
INSERT INTO medical_records (appointment_id, patient_id, doctor_id, diagnosis, treatment, notes, 
                             blood_pressure, heart_rate, temperature, weight, height, bmi, record_date) VALUES
-- Record 1: Cảm cúm
(@apt1_id, @pat1_id, @doctor_id, 
 'Cảm cúm thông thường', 
 'Nghỉ ngơi, uống nhiều nước, dùng thuốc hạ sốt', 
 'Tái khám sau 3 ngày nếu không thuyên giảm',
 '120/80', 85, 38.5, 55.0, 165.0, 20.2, DATEADD(day, -7, GETDATE())),

-- Record 2: Đau dạ dày
(@apt2_id, @pat2_id, @doctor_id,
 'Viêm dạ dày cấp',
 'Ăn uống điều độ, tránh thức ăn cay nóng, dùng thuốc kháng acid',
 'Tái khám sau 1 tuần',
 '130/85', 78, 37.2, 70.0, 175.0, 22.9, DATEADD(day, -14, GETDATE())),

-- Record 3: Cao huyết áp
(@apt3_id, @pat3_id, @doctor_id,
 'Tăng huyết áp độ 1',
 'Chế độ ăn ít muối, tập thể dục, dùng thuốc hạ huyết áp',
 'Theo dõi huyết áp hàng ngày, tái khám sau 2 tuần',
 '145/95', 82, 37.0, 62.0, 160.0, 24.2, DATEADD(day, -21, GETDATE()));

-- ========================================
-- 6. PRESCRIPTIONS DATA
-- ========================================

DECLARE @record1_id INT = (SELECT TOP 1 record_id FROM medical_records WHERE patient_id = @pat1_id ORDER BY record_date DESC);
DECLARE @record2_id INT = (SELECT TOP 1 record_id FROM medical_records WHERE patient_id = @pat2_id ORDER BY record_date DESC);
DECLARE @record3_id INT = (SELECT TOP 1 record_id FROM medical_records WHERE patient_id = @pat3_id ORDER BY record_date DESC);

-- Prescriptions
INSERT INTO prescriptions (appointment_id, doctor_id, patient_id, notes, created_at) VALUES
(@apt1_id, @doctor_id, @pat1_id, 'Uống thuốc sau ăn', DATEADD(day, -7, GETDATE())),
(@apt2_id, @doctor_id, @pat2_id, 'Uống thuốc trước ăn 30 phút', DATEADD(day, -14, GETDATE())),
(@apt3_id, @doctor_id, @pat3_id, 'Uống thuốc đều đặn mỗi ngày', DATEADD(day, -21, GETDATE()));

-- Prescription medications
DECLARE @pres1_id INT = (SELECT TOP 1 prescription_id FROM prescriptions WHERE patient_id = @pat1_id ORDER BY created_at DESC);
DECLARE @pres2_id INT = (SELECT TOP 1 prescription_id FROM prescriptions WHERE patient_id = @pat2_id ORDER BY created_at DESC);
DECLARE @pres3_id INT = (SELECT TOP 1 prescription_id FROM prescriptions WHERE patient_id = @pat3_id ORDER BY created_at DESC);

INSERT INTO prescription_medications (prescription_id, medication_name, dosage, frequency, duration, instructions) VALUES
-- Prescription 1: Cảm cúm
(@pres1_id, 'Paracetamol', '500mg', '3 lần/ngày', '5 ngày', 'Uống khi sốt'),
(@pres1_id, 'Vitamin C', '1000mg', '1 lần/ngày', '7 ngày', 'Uống sau ăn sáng'),

-- Prescription 2: Đau dạ dày
(@pres2_id, 'Omeprazole', '20mg', '2 lần/ngày', '14 ngày', 'Uống trước ăn 30 phút'),
(@pres2_id, 'Sucralfate', '1g', '3 lần/ngày', '14 ngày', 'Uống trước bữa ăn'),

-- Prescription 3: Cao huyết áp
(@pres3_id, 'Amlodipine', '5mg', '1 lần/ngày', '30 ngày', 'Uống vào buổi sáng'),
(@pres3_id, 'Aspirin', '100mg', '1 lần/ngày', '30 ngày', 'Uống sau ăn tối');

-- ========================================
-- TEST QUERIES
-- ========================================

-- Kiểm tra appointments
SELECT 'Appointments' as TableName, COUNT(*) as TotalRecords FROM appointments;
SELECT a.appointment_id, u.full_name as patient_name, a.appointment_date, a.reason, a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN users u ON p.user_id = u.user_id
ORDER BY a.appointment_date DESC;

-- Kiểm tra medical records
SELECT 'Medical Records' as TableName, COUNT(*) as TotalRecords FROM medical_records;
SELECT mr.record_id, u.full_name as patient_name, mr.diagnosis, mr.blood_pressure, mr.heart_rate, mr.temperature, mr.bmi
FROM medical_records mr
JOIN patients p ON mr.patient_id = p.patient_id
JOIN users u ON p.user_id = u.user_id;

-- Kiểm tra prescriptions
SELECT 'Prescriptions' as TableName, COUNT(*) as TotalRecords FROM prescriptions;
SELECT p.prescription_id, u.full_name as patient_name, COUNT(pm.medication_id) as medication_count
FROM prescriptions p
JOIN patients pat ON p.patient_id = pat.patient_id
JOIN users u ON pat.user_id = u.user_id
LEFT JOIN prescription_medications pm ON p.prescription_id = pm.prescription_id
GROUP BY p.prescription_id, u.full_name;

GO

-- ========================================
-- NOTES
-- ========================================
-- 
-- TEST ACCOUNT:
-- Doctor: doctor1 / 123456
--
-- TEST SCENARIOS:
-- 1. Login as doctor1
-- 2. View all appointments
-- 3. Filter appointments by status (PENDING, CONFIRMED, COMPLETED)
-- 4. Filter appointments by date range
-- 5. View appointment detail
-- 6. View patient medical history
-- 7. Create medical record with vital signs
-- 8. Verify BMI calculation
-- 9. Create prescription
-- 10. Update appointment status
-- 11. Validate vital signs (heart rate, blood pressure, temperature)
-- 12. Cannot update COMPLETED appointment
--
-- ========================================
