CREATE DATABASE JVCare_MVC;
GO

USE JVCare_MVC;
GO

-- 1. Table users
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL, -- ADMIN, DOCTOR, PATIENT
    phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);
GO

-- 2. Table doctors
CREATE TABLE doctors (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    specialization NVARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
GO

-- 3. Table patients
CREATE TABLE patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT, -- NULL if patient doesn't have login account
    patient_code VARCHAR(20) UNIQUE NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    address NVARCHAR(255),
    allergies NVARCHAR(255),
    chronic_diseases NVARCHAR(255),
    avatar_url VARCHAR(255),
    id_card VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);
GO

-- 4. Table appointments
CREATE TABLE appointments (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, CONFIRMED, COMPLETED, CANCELLED
    reason NVARCHAR(500),
    notes NVARCHAR(500),
    diagnosis NVARCHAR(500),
    patient_condition NVARCHAR(500),
    advice NVARCHAR(500),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE SET NULL
);
GO

-- 5. Table medical_records
CREATE TABLE medical_records (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT,
    appointment_id INT,
    visit_date DATE NOT NULL,
    diagnosis NVARCHAR(500),
    treatment_plan NVARCHAR(1000),
    notes NVARCHAR(1000),
    blood_pressure VARCHAR(20),
    heart_rate INT,
    temperature DECIMAL(4,1),
    weight DECIMAL(5,1),
    height DECIMAL(5,1),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE NO ACTION,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE NO ACTION
);
GO

-- 6. Table prescriptions
CREATE TABLE prescriptions (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    record_id INT NOT NULL,
    medication_name NVARCHAR(150) NOT NULL,
    dosage NVARCHAR(100),
    frequency NVARCHAR(100),
    duration_days INT,
    instructions NVARCHAR(500),
    FOREIGN KEY (record_id) REFERENCES medical_records(record_id) ON DELETE CASCADE
);
GO

-----------------------------------------------------
-- INSERT SAMPLE DATA
-----------------------------------------------------
-- (Password hash is a dummy BCrypt hash for "123456", UserDAO falls back to "123456" anyway)

INSERT INTO users (username, password_hash, email, full_name, role, phone, status) VALUES 
('admin', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'admin@jvcare.com', N'Quản trị viên', 'ADMIN', '0901234567', 'ACTIVE'),
('doctor', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'doctor@jvcare.com', N'BS. Nguyễn Văn A', 'DOCTOR', '0907654321', 'ACTIVE'),
('patient', '$2a$10$D8bT8bT8bT8bT8bT8bT8b.x', 'patient@jvcare.com', N'Nguyễn Văn Bệnh Nhân', 'PATIENT', '0987654321', 'ACTIVE');

INSERT INTO doctors (user_id, specialization) VALUES 
(2, N'Nội khoa Tồng hợp');

INSERT INTO patients (user_id, patient_code, full_name, date_of_birth, gender, phone, email, address, id_card) VALUES 
(3, 'BN-10001', N'Nguyễn Văn Bệnh Nhân', '1990-01-01', 'MALE', '0987654321', 'patient@jvcare.com', N'123 Đường Nguyễn Huệ, Quận 1, TP.HCM', '079090123456');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason) VALUES 
(1, NULL, '2026-05-25', '09:00:00', 'PENDING', N'Khám sức khỏe tổng quát'),
(1, 1, '2026-05-20', '10:30:00', 'CONFIRMED', N'Đau đầu chóng mặt'),
(1, 1, '2026-05-15', '08:00:00', 'COMPLETED', N'Sốt nhẹ 38 độ');

UPDATE appointments SET 
    diagnosis = N'Viêm họng hạt', 
    patient_condition = N'Bệnh nhân tỉnh, tiếp xúc tốt', 
    advice = N'Uống nhiều nước ấm, nghỉ ngơi'
WHERE status = 'COMPLETED';
GO
