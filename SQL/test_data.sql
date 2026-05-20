-- =====================================================
-- TEST DATA FOR JVCARE_MVC PROJECT
-- Dữ liệu test cho các thành viên phát triển
-- =====================================================

USE JVCare_MVC;
GO

-- =====================================================
-- TASK 1: ADMIN - TEST DATA
-- =====================================================

-- Thêm nhiều users để test phân trang
INSERT INTO users (username, password_hash, email, full_name, role, phone, status) VALUES 
('doctor2', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'doctor2@jvcare.com', N'BS. Trần Thị B', 'DOCTOR', '0907654322', 'ACTIVE'),
('doctor3', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'doctor3@jvcare.com', N'BS. Lê Văn C', 'DOCTOR', '0907654323', 'ACTIVE'),
('doctor4', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'doctor4@jvcare.com', N'BS. Phạm Thị D', 'DOCTOR', '0907654324', 'ACTIVE'),
('patient2', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'patient2@jvcare.com', N'Nguyễn Thị Bệnh Nhân 2', 'PATIENT', '0987654322', 'ACTIVE'),
('patient3', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'patient3@jvcare.com', N'Trần Văn Bệnh Nhân 3', 'PATIENT', '0987654323', 'ACTIVE'),
('patient4', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'patient4@jvcare.com', N'Lê Thị Bệnh Nhân 4', 'PATIENT', '0987654324', 'ACTIVE'),
('patient5', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'patient5@jvcare.com', N'Phạm Văn Bệnh Nhân 5', 'PATIENT', '0987654325', 'ACTIVE');
GO

-- Thêm doctors với chuyên khoa khác nhau
INSERT INTO doctors (user_id, specialization) VALUES 
(4, N'Tim mạch'),
(5, N'Nhi khoa'),
(6, N'Da liễu');
GO

-- Thêm patients tương ứng
INSERT INTO patients (user_id, patient_code, full_name, date_of_birth, gender, phone, email, address, id_card) VALUES 
(7, 'BN-10002', N'Nguyễn Thị Bệnh Nhân 2', '1985-05-15', 'FEMALE', '0987654322', 'patient2@jvcare.com', N'456 Đường Lê Lợi, Quận 1, TP.HCM', '079085123456'),
(8, 'BN-10003', N'Trần Văn Bệnh Nhân 3', '1992-08-20', 'MALE', '0987654323', 'patient3@jvcare.com', N'789 Đường Trần Hưng Đạo, Quận 5, TP.HCM', '079092123456'),
(9, 'BN-10004', N'Lê Thị Bệnh Nhân 4', '1988-03-10', 'FEMALE', '0987654324', 'patient4@jvcare.com', N'321 Đường Nguyễn Trãi, Quận 1, TP.HCM', '079088123456'),
(10, 'BN-10005', N'Phạm Văn Bệnh Nhân 5', '1995-11-25', 'MALE', '0987654325', 'patient5@jvcare.com', N'654 Đường Võ Văn Tần, Quận 3, TP.HCM', '079095123456');
GO

-- =====================================================
-- TASK 2: DOCTOR - TEST DATA (Medical Records & Prescriptions)
-- =====================================================

-- Thêm medical records
INSERT INTO medical_records (patient_id, doctor_id, appointment_id, visit_date, diagnosis, treatment_plan, notes, blood_pressure, heart_rate, temperature, weight, height) VALUES 
(1, 1, 3, '2026-05-15', N'Viêm họng hạt cấp', N'Kê đơn thuốc kháng sinh, nghỉ ngơi 3 ngày', N'Bệnh nhân có tiền sử dị ứng penicillin', '120/80', 75, 38.5, 65.5, 170.0),
(2, 2, NULL, '2026-05-10', N'Cao huyết áp độ 1', N'Điều chỉnh chế độ ăn, tập thể dục, uống thuốc hạ huyết áp', N'Theo dõi huyết áp hàng ngày', '145/95', 82, 36.8, 72.0, 165.0),
(3, 3, NULL, '2026-05-12', N'Viêm da cơ địa', N'Bôi thuốc corticoid, tránh tiếp xúc chất kích ứng', N'Bệnh nhân có tiền sử gia đình bị viêm da', '115/75', 70, 36.5, 58.0, 160.0);
GO

-- Thêm prescriptions cho medical records
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
-- Đơn thuốc cho record_id = 1 (Viêm họng)
(1, N'Amoxicillin', '500mg', N'3 lần/ngày', 7, N'Uống sau ăn, uống đủ liệu trình'),
(1, N'Paracetamol', '500mg', N'Khi sốt hoặc đau', 5, N'Cách nhau ít nhất 4 giờ, tối đa 4 viên/ngày'),
(1, N'Vitamin C', '1000mg', N'1 lần/ngày', 10, N'Uống sau ăn sáng'),

-- Đơn thuốc cho record_id = 2 (Cao huyết áp)
(2, N'Amlodipine', '5mg', N'1 lần/ngày', 30, N'Uống vào buổi sáng, cùng giờ mỗi ngày'),
(2, N'Aspirin', '100mg', N'1 lần/ngày', 30, N'Uống sau ăn tối'),

-- Đơn thuốc cho record_id = 3 (Viêm da)
(3, N'Hydrocortisone cream 1%', N'Bôi mỏng', N'2 lần/ngày', 14, N'Bôi vào vùng da bị viêm, rửa tay sau khi bôi'),
(3, N'Cetirizine', '10mg', N'1 lần/ngày', 14, N'Uống vào buổi tối trước khi ngủ');
GO


-- =====================================================
-- TASK 3: PATIENT - TEST DATA (More Appointments)
-- =====================================================

-- Thêm nhiều appointments với các trạng thái khác nhau
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason, notes) VALUES 
-- Appointments cho patient 2
(2, 2, '2026-05-22', '09:00:00', 'CONFIRMED', N'Tái khám cao huyết áp', N'Mang theo kết quả đo huyết áp tại nhà'),
(2, NULL, '2026-05-28', '14:00:00', 'PENDING', N'Khám tổng quát định kỳ', NULL),

-- Appointments cho patient 3
(3, 3, '2026-05-21', '10:30:00', 'CONFIRMED', N'Tái khám da liễu', N'Đã bôi thuốc 1 tuần'),
(3, 1, '2026-05-23', '15:00:00', 'PENDING', N'Đau bụng, buồn nôn', NULL),

-- Appointments cho patient 4
(4, NULL, '2026-05-24', '08:30:00', 'PENDING', N'Khám thai định kỳ', NULL),
(4, 3, '2026-05-26', '11:00:00', 'CONFIRMED', N'Khám da mặt', NULL),

-- Appointments đã hoàn thành (COMPLETED)
(2, 2, '2026-05-10', '09:00:00', 'COMPLETED', N'Khám cao huyết áp', N'Đã khám xong'),
(3, 3, '2026-05-12', '10:00:00', 'COMPLETED', N'Khám viêm da', N'Đã khám xong'),

-- Appointments bị hủy (CANCELLED)
(4, NULL, '2026-05-18', '14:00:00', 'CANCELLED', N'Khám sức khỏe', N'Bệnh nhân hủy vì bận việc');
GO

-- Cập nhật diagnosis, condition, advice cho appointments COMPLETED
UPDATE appointments SET 
    diagnosis = N'Cao huyết áp độ 1, cần theo dõi', 
    patient_condition = N'Bệnh nhân tỉnh táo, huyết áp 145/95', 
    advice = N'Uống thuốc đều đặn, tái khám sau 2 tuần'
WHERE appointment_id IN (SELECT appointment_id FROM appointments WHERE status = 'COMPLETED' AND patient_id = 2);

UPDATE appointments SET 
    diagnosis = N'Viêm da cơ địa', 
    patient_condition = N'Vùng da bị viêm đỏ, ngứa', 
    advice = N'Bôi thuốc 2 lần/ngày, tránh gãi'
WHERE appointment_id IN (SELECT appointment_id FROM appointments WHERE status = 'COMPLETED' AND patient_id = 3);
GO

-- =====================================================
-- TASK 4: STATISTICS - TEST DATA
-- =====================================================

-- Thêm nhiều appointments trong các tháng khác nhau để test biểu đồ
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason) VALUES 
-- Tháng 4/2026
(1, 1, '2026-04-05', '09:00:00', 'COMPLETED', N'Khám định kỳ'),
(2, 2, '2026-04-10', '10:00:00', 'COMPLETED', N'Khám tim mạch'),
(3, 3, '2026-04-15', '11:00:00', 'COMPLETED', N'Khám da liễu'),
(4, 1, '2026-04-20', '14:00:00', 'COMPLETED', N'Khám nội khoa'),

-- Tháng 3/2026
(1, 2, '2026-03-08', '09:30:00', 'COMPLETED', N'Khám sức khỏe'),
(2, 3, '2026-03-12', '10:30:00', 'COMPLETED', N'Khám da'),
(3, 1, '2026-03-18', '15:00:00', 'COMPLETED', N'Khám tổng quát'),

-- Tháng 2/2026
(1, 1, '2026-02-05', '08:00:00', 'COMPLETED', N'Khám bệnh'),
(2, 2, '2026-02-15', '09:00:00', 'COMPLETED', N'Khám tim'),
(3, 3, '2026-02-25', '10:00:00', 'COMPLETED', N'Khám da');
GO

-- =====================================================
-- USEFUL QUERIES FOR TESTING
-- =====================================================

-- Query 1: Thống kê số lượng users theo role
-- SELECT role, COUNT(*) as total FROM users GROUP BY role;

-- Query 2: Thống kê appointments theo status
-- SELECT status, COUNT(*) as total FROM appointments GROUP BY status;

-- Query 3: Thống kê appointments theo tháng (năm 2026)
-- SELECT MONTH(appointment_date) as month, COUNT(*) as total 
-- FROM appointments 
-- WHERE YEAR(appointment_date) = 2026 
-- GROUP BY MONTH(appointment_date) 
-- ORDER BY month;

-- Query 4: Top 5 bác sĩ có nhiều lịch hẹn nhất
-- SELECT TOP 5 d.doctor_id, u.full_name, COUNT(a.appointment_id) as total_appointments
-- FROM doctors d
-- JOIN users u ON d.user_id = u.user_id
-- LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
-- GROUP BY d.doctor_id, u.full_name
-- ORDER BY total_appointments DESC;

-- Query 5: Danh sách bệnh nhân có nhiều lịch hẹn nhất
-- SELECT TOP 5 p.patient_id, p.full_name, COUNT(a.appointment_id) as total_appointments
-- FROM patients p
-- LEFT JOIN appointments a ON p.patient_id = a.patient_id
-- GROUP BY p.patient_id, p.full_name
-- ORDER BY total_appointments DESC;

-- Query 6: Tổng số bệnh án theo bác sĩ
-- SELECT d.doctor_id, u.full_name, COUNT(mr.record_id) as total_records
-- FROM doctors d
-- JOIN users u ON d.user_id = u.user_id
-- LEFT JOIN medical_records mr ON d.doctor_id = mr.doctor_id
-- GROUP BY d.doctor_id, u.full_name
-- ORDER BY total_records DESC;

GO

PRINT 'Test data inserted successfully!';
PRINT 'Total users: ' + CAST((SELECT COUNT(*) FROM users) AS VARCHAR);
PRINT 'Total doctors: ' + CAST((SELECT COUNT(*) FROM doctors) AS VARCHAR);
PRINT 'Total patients: ' + CAST((SELECT COUNT(*) FROM patients) AS VARCHAR);
PRINT 'Total appointments: ' + CAST((SELECT COUNT(*) FROM appointments) AS VARCHAR);
PRINT 'Total medical records: ' + CAST((SELECT COUNT(*) FROM medical_records) AS VARCHAR);
PRINT 'Total prescriptions: ' + CAST((SELECT COUNT(*) FROM prescriptions) AS VARCHAR);
GO

