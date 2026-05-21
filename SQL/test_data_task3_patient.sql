-- ========================================
-- TEST DATA FOR TASK 3: PATIENT MODULE
-- Quản lý Appointments và Prescriptions (Patient View)
-- ========================================

USE JVCare_MVC_Member3; -- Thay đổi tên database theo thành viên
GO

-- ========================================
-- 1. USERS DATA
-- ========================================

-- Doctor users (password: 123456)
INSERT INTO users (username, password, email, full_name, role, phone, status, created_at) VALUES
('doctor1', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'doctor1@jvcare.com', 'Bác sĩ Nguyễn Văn A', 'DOCTOR', '0901234568', 'ACTIVE', GETDATE()),
('doctor2', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'doctor2@jvcare.com', 'Bác sĩ Trần Thị B', 'DOCTOR', '0901234569', 'ACTIVE', GETDATE());

-- Patient user (password: 123456)
INSERT INTO users (username, password, email, full_name, role, phone, status, created_at) VALUES
('patient1', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'patient1@jvcare.com', 'Nguyễn Thị C', 'PATIENT', '0901234571', 'ACTIVE', GETDATE());

-- ========================================
-- 2. DOCTORS DATA
-- ========================================

DECLARE @doctor1_id INT = (SELECT user_id FROM users WHERE username = 'doctor1');
DECLARE @doctor2_id INT = (SELECT user_id FROM users WHERE username = 'doctor2');

INSERT INTO doctors (user_id, specialization, license_number, experience_years, education, consultation_fee, status) VALUES
(@doctor1_id, 'Nội khoa', 'BS001234', 10, 'Đại học Y Hà Nội', 200000, 'ACTIVE'),
(@doctor2_id, 'Nhi khoa', 'BS001235', 8, 'Đại học Y Dược TP.HCM', 250000, 'ACTIVE');

-- ========================================
-- 3. PATIENTS DATA
-- ========================================

DECLARE @patient1_id INT = (SELECT user_id FROM users WHERE username = 'patient1');

INSERT INTO patients (user_id, date_of_birth, gender, address, emergency_contact, blood_type, allergies) VALUES
(@patient1_id, '1990-05-15', 'F', '123 Nguyễn Huệ, Q1, TP.HCM', '0909999991', 'A+', 'Không');

-- ========================================
-- 4. APPOINTMENTS DATA
-- ========================================

DECLARE @doc1_id INT = (SELECT doctor_id FROM doctors WHERE user_id = @doctor1_id);
DECLARE @doc2_id INT = (SELECT doctor_id FROM doctors WHERE user_id = @doctor2_id);
DECLARE @pat_id INT = (SELECT patient_id FROM patients WHERE user_id = @patient1_id);

-- Appointments với các status khác nhau
INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason, status, notes, created_at) VALUES
-- Upcoming appointments
(@pat_id, @doc1_id, DATEADD(day, 1, GETDATE()), 'Khám tổng quát', 'PENDING', 'Lần đầu khám', GETDATE()),
(@pat_id, @doc2_id, DATEADD(day, 3, GETDATE()), 'Khám định kỳ', 'CONFIRMED', 'Đã xác nhận', GETDATE()),
(@pat_id, @doc1_id, DATEADD(day, 7, GETDATE()), 'Tái khám', 'PENDING', 'Tái khám sau điều trị', GETDATE()),

-- Past appointments
(@pat_id, @doc1_id, DATEADD(day, -7, GETDATE()), 'Cảm cúm', 'COMPLETED', 'Đã hoàn thành', DATEADD(day, -10, GETDATE())),
(@pat_id, @doc1_id, DATEADD(day, -14, GETDATE()), 'Đau đầu', 'COMPLETED', 'Đã hoàn thành', DATEADD(day, -15, GETDATE())),
(@pat_id, @doc2_id, DATEADD(day, -30, GETDATE()), 'Khám sức khỏe', 'COMPLETED', 'Đã hoàn thành', DATEADD(day, -32, GETDATE())),

-- Cancelled appointment
(@pat_id, @doc1_id, DATEADD(day, -3, GETDATE()), 'Khám tổng quát', 'CANCELLED', 'Bận việc đột xuất', DATEADD(day, -5, GETDATE()));

-- ========================================
-- 5. MEDICAL RECORDS DATA
-- ========================================

-- Get completed appointment IDs
DECLARE @apt1_id INT = (SELECT TOP 1 appointment_id FROM appointments WHERE status = 'COMPLETED' AND appointment_date = DATEADD(day, -7, CAST(GETDATE() AS DATE)));
DECLARE @apt2_id INT = (SELECT TOP 1 appointment_id FROM appointments WHERE status = 'COMPLETED' AND appointment_date = DATEADD(day, -14, CAST(GETDATE() AS DATE)));
DECLARE @apt3_id INT = (SELECT TOP 1 appointment_id FROM appointments WHERE status = 'COMPLETED' AND appointment_date = DATEADD(day, -30, CAST(GETDATE() AS DATE)));

-- Medical records
INSERT INTO medical_records (appointment_id, patient_id, doctor_id, diagnosis, treatment, notes,
                             blood_pressure, heart_rate, temperature, weight, height, bmi, record_date) VALUES
(@apt1_id, @pat_id, @doc1_id,
 'Cảm cúm thông thường',
 'Nghỉ ngơi, uống nhiều nước, dùng thuốc hạ sốt',
 'Tái khám nếu không thuyên giảm',
 '120/80', 85, 38.5, 55.0, 165.0, 20.2, DATEADD(day, -7, GETDATE())),

(@apt2_id, @pat_id, @doc1_id,
 'Đau đầu do căng thẳng',
 'Nghỉ ngơi, giảm stress, massage',
 'Tránh làm việc quá sức',
 '118/78', 72, 37.0, 55.0, 165.0, 20.2, DATEADD(day, -14, GETDATE())),

(@apt3_id, @pat_id, @doc2_id,
 'Sức khỏe tốt',
 'Duy trì chế độ ăn uống và tập luyện',
 'Khám định kỳ 6 tháng/lần',
 '115/75', 68, 36.8, 54.5, 165.0, 20.0, DATEADD(day, -30, GETDATE()));

-- ========================================
-- 6. PRESCRIPTIONS DATA
-- ========================================

-- Prescriptions
INSERT INTO prescriptions (appointment_id, doctor_id, patient_id, notes, created_at) VALUES
(@apt1_id, @doc1_id, @pat_id, 'Uống thuốc sau ăn', DATEADD(day, -7, GETDATE())),
(@apt2_id, @doc1_id, @pat_id, 'Uống khi đau đầu', DATEADD(day, -14, GETDATE()));

-- Prescription medications
DECLARE @pres1_id INT = (SELECT TOP 1 prescription_id FROM prescriptions WHERE appointment_id = @apt1_id);
DECLARE @pres2_id INT = (SELECT TOP 1 prescription_id FROM prescriptions WHERE appointment_id = @apt2_id);

INSERT INTO prescription_medications (prescription_id, medication_name, dosage, frequency, duration, instructions) VALUES
-- Prescription 1: Cảm cúm
(@pres1_id, 'Paracetamol', '500mg', '3 lần/ngày', '5 ngày', 'Uống khi sốt'),
(@pres1_id, 'Vitamin C', '1000mg', '1 lần/ngày', '7 ngày', 'Uống sau ăn sáng'),
(@pres1_id, 'Cough Syrup', '10ml', '3 lần/ngày', '5 ngày', 'Uống sau ăn'),

-- Prescription 2: Đau đầu
(@pres2_id, 'Ibuprofen', '400mg', 'Khi cần', '10 ngày', 'Uống khi đau đầu, tối đa 3 lần/ngày'),
(@pres2_id, 'Vitamin B Complex', '1 viên', '1 lần/ngày', '30 ngày', 'Uống sau ăn sáng');

-- ========================================
-- TEST QUERIES
-- ========================================

-- Kiểm tra appointments của patient
SELECT 'Patient Appointments' as Info, COUNT(*) as Total FROM appointments WHERE patient_id = @pat_id;
SELECT a.appointment_id, u.full_name as doctor_name, d.specialization, a.appointment_date, a.reason, a.status
FROM appointments a
JOIN doctors doc ON a.doctor_id = doc.doctor_id
JOIN users u ON doc.user_id = u.user_id
JOIN patients p ON a.patient_id = p.patient_id
WHERE p.user_id = @patient1_id
ORDER BY a.appointment_date DESC;

-- Kiểm tra prescriptions của patient
SELECT 'Patient Prescriptions' as Info, COUNT(*) as Total FROM prescriptions WHERE patient_id = @pat_id;
SELECT pr.prescription_id, u.full_name as doctor_name, pr.created_at, pr.notes,
       COUNT(pm.medication_id) as medication_count
FROM prescriptions pr
JOIN doctors doc ON pr.doctor_id = doc.doctor_id
JOIN users u ON doc.user_id = u.user_id
LEFT JOIN prescription_medications pm ON pr.prescription_id = pm.prescription_id
WHERE pr.patient_id = @pat_id
GROUP BY pr.prescription_id, u.full_name, pr.created_at, pr.notes
ORDER BY pr.created_at DESC;

-- Kiểm tra prescription details
SELECT pr.prescription_id, pm.medication_name, pm.dosage, pm.frequency, pm.duration, pm.instructions
FROM prescriptions pr
JOIN prescription_medications pm ON pr.prescription_id = pm.prescription_id
WHERE pr.patient_id = @pat_id
ORDER BY pr.created_at DESC, pm.medication_name;

GO

-- ========================================
-- NOTES
-- ========================================
--
-- TEST ACCOUNT:
-- Patient: patient1 / 123456
--
-- TEST SCENARIOS:
-- 1. Login as patient1
-- 2. View all appointments (upcoming and past)
-- 3. Book new appointment
-- 4. Cancel PENDING appointment
-- 5. Cannot cancel CONFIRMED or COMPLETED appointment
-- 6. View prescriptions
-- 7. View prescription details with medications
-- 8. Filter prescriptions by date
-- 9. Print prescription
-- 10. Validate appointment date (not in past, not too far in future)
--
-- BUSINESS RULES TO TEST:
-- - Cannot book appointment in the past
-- - Cannot book appointment more than 3 months in future
-- - Can only cancel PENDING appointments
-- - Cannot cancel appointments within 24 hours of appointment time
-- - Can view all own appointments and prescriptions
-- - Cannot view other patients' data
--
-- ========================================
