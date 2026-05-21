-- ========================================
-- TEST DATA FOR TASK 1: ADMIN MODULE
-- Quản lý Users và Doctors
-- ========================================

USE JVCare_MVC_Member1; -- Thay đổi tên database theo thành viên
GO

-- ========================================
-- 1. USERS DATA
-- ========================================

-- Admin user (password: 123456)
INSERT INTO users (username, password, email, full_name, role, phone, status, created_at) VALUES
('admin', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'admin@jvcare.com', 'Administrator', 'ADMIN', '0901234567', 'ACTIVE', GETDATE());

-- Doctor users (password: 123456)
INSERT INTO users (username, password, email, full_name, role, phone, status, created_at) VALUES
('doctor1', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'doctor1@jvcare.com', 'Bác sĩ Nguyễn Văn A', 'DOCTOR', '0901234568', 'ACTIVE', GETDATE()),
('doctor2', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'doctor2@jvcare.com', 'Bác sĩ Trần Thị B', 'DOCTOR', '0901234569', 'ACTIVE', GETDATE()),
('doctor3', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'doctor3@jvcare.com', 'Bác sĩ Lê Văn C', 'DOCTOR', '0901234570', 'ACTIVE', GETDATE());

-- Patient users (password: 123456)
INSERT INTO users (username, password, email, full_name, role, phone, status, created_at) VALUES
('patient1', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'patient1@jvcare.com', 'Nguyễn Thị D', 'PATIENT', '0901234571', 'ACTIVE', GETDATE()),
('patient2', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'patient2@jvcare.com', 'Trần Văn E', 'PATIENT', '0901234572', 'ACTIVE', GETDATE()),
('patient3', '$2a$10$rZ5qH8qH8qH8qH8qH8qH8.N8qH8qH8qH8qH8qH8qH8qH8qH8qH8qH', 'patient3@jvcare.com', 'Lê Thị F', 'PATIENT', '0901234573', 'ACTIVE', GETDATE());

-- ========================================
-- 2. DOCTORS DATA
-- ========================================

-- Get user IDs for doctors
DECLARE @doctor1_id INT = (SELECT user_id FROM users WHERE username = 'doctor1');
DECLARE @doctor2_id INT = (SELECT user_id FROM users WHERE username = 'doctor2');
DECLARE @doctor3_id INT = (SELECT user_id FROM users WHERE username = 'doctor3');

-- Insert doctor details
INSERT INTO doctors (user_id, specialization, license_number, experience_years, education, bio, consultation_fee, status) VALUES
(@doctor1_id, 'Nội khoa', 'BS001234', 10, 'Đại học Y Hà Nội', 'Chuyên khoa Nội tổng quát, Tim mạch', 200000, 'ACTIVE'),
(@doctor2_id, 'Nhi khoa', 'BS001235', 8, 'Đại học Y Dược TP.HCM', 'Chuyên khoa Nhi, Dinh dưỡng trẻ em', 250000, 'ACTIVE'),
(@doctor3_id, 'Da liễu', 'BS001236', 5, 'Đại học Y Huế', 'Chuyên khoa Da liễu, Thẩm mỹ da', 300000, 'ACTIVE');

-- ========================================
-- 3. PATIENTS DATA (for testing)
-- ========================================

DECLARE @patient1_id INT = (SELECT user_id FROM users WHERE username = 'patient1');
DECLARE @patient2_id INT = (SELECT user_id FROM users WHERE username = 'patient2');
DECLARE @patient3_id INT = (SELECT user_id FROM users WHERE username = 'patient3');

INSERT INTO patients (user_id, date_of_birth, gender, address, emergency_contact, blood_type, allergies) VALUES
(@patient1_id, '1990-05-15', 'F', '123 Nguyễn Huệ, Q1, TP.HCM', '0909999991', 'A+', 'Không'),
(@patient2_id, '1985-08-20', 'M', '456 Lê Lợi, Q3, TP.HCM', '0909999992', 'O+', 'Penicillin'),
(@patient3_id, '1995-12-10', 'F', '789 Trần Hưng Đạo, Q5, TP.HCM', '0909999993', 'B+', 'Không');

-- ========================================
-- TEST QUERIES
-- ========================================

-- Kiểm tra users
SELECT 'Users' as TableName, COUNT(*) as TotalRecords FROM users;
SELECT user_id, username, email, full_name, role, status FROM users;

-- Kiểm tra doctors
SELECT 'Doctors' as TableName, COUNT(*) as TotalRecords FROM doctors;
SELECT d.doctor_id, u.full_name, d.specialization, d.license_number, d.experience_years, d.consultation_fee
FROM doctors d
JOIN users u ON d.user_id = u.user_id;

-- Kiểm tra patients
SELECT 'Patients' as TableName, COUNT(*) as TotalRecords FROM patients;
SELECT p.patient_id, u.full_name, p.date_of_birth, p.gender, p.blood_type
FROM patients p
JOIN users u ON p.user_id = u.user_id;

GO

-- ========================================
-- NOTES
-- ========================================
-- 
-- TEST ACCOUNTS:
-- Admin: admin / 123456
-- Doctor: doctor1 / 123456
-- Patient: patient1 / 123456
--
-- TEST SCENARIOS:
-- 1. Login as admin
-- 2. View all users
-- 3. Create new user
-- 4. Update user info
-- 5. Delete user
-- 6. Search users
-- 7. View all doctors
-- 8. Create new doctor
-- 9. Update doctor info
-- 10. Delete doctor
--
-- ========================================
