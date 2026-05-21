USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'JVCare_MVC')
    DROP DATABASE JVCare_MVC;
GO
CREATE DATABASE JVCare_MVC
    COLLATE Vietnamese_CI_AS;
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

-- Tạo bảng Departments (Khoa)
CREATE TABLE departments (
    department_id INT PRIMARY KEY IDENTITY(1,1),
    department_code VARCHAR(20) UNIQUE NOT NULL,
    department_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    head_doctor_id INT,
    phone VARCHAR(20),
    location NVARCHAR(200),
    status VARCHAR(10) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (head_doctor_id) REFERENCES doctors(doctor_id) ON DELETE SET NULL
);
GO

CREATE TRIGGER trg_departments_updated_at
ON departments
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE departments
    SET updated_at = CURRENT_TIMESTAMP
    FROM inserted i
    WHERE departments.department_id = i.department_id;
END;
GO

ALTER TABLE doctors 
ADD department_id INT;
GO

ALTER TABLE doctors
ADD FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL;
GO

INSERT INTO departments (department_code, department_name, description, phone, location, status) VALUES
('CARDIO', N'Khoa Tim Mạch', N'Chuyên khoa điều trị các bệnh về tim mạch, huyết áp, mạch máu', '0901234567', N'Tầng 3, Khu A', 'ACTIVE'),
('NEURO', N'Khoa Thần Kinh', N'Chuyên khoa điều trị các bệnh về thần kinh, não bộ', '0901234568', N'Tầng 4, Khu A', 'ACTIVE'),
('ORTHO', N'Khoa Chấn Thương Chỉnh Hình', N'Chuyên khoa điều trị các bệnh về xương khớp, chấn thương', '0901234569', N'Tầng 2, Khu B', 'ACTIVE'),
('PEDIA', N'Khoa Nhi', N'Chuyên khoa điều trị các bệnh về trẻ em', '0901234570', N'Tầng 1, Khu C', 'ACTIVE'),
('OBGYN', N'Khoa Sản Phụ Khoa', N'Chuyên khoa điều trị các bệnh về phụ nữ, thai sản', '0901234571', N'Tầng 2, Khu C', 'ACTIVE'),
('GASTRO', N'Khoa Tiêu Hóa', N'Chuyên khoa điều trị các bệnh về dạ dày, ruột, gan mật', '0901234572', N'Tầng 3, Khu B', 'ACTIVE'),
('ENDO', N'Khoa Nội Tiết', N'Chuyên khoa điều trị các bệnh về nội tiết, đái tháo đường', '0901234573', N'Tầng 4, Khu B', 'ACTIVE'),
('DERMA', N'Khoa Da Liễu', N'Chuyên khoa điều trị các bệnh về da', '0901234574', N'Tầng 1, Khu D', 'ACTIVE'),
('ENT', N'Khoa Tai Mũi Họng', N'Chuyên khoa điều trị các bệnh về tai mũi họng', '0901234575', N'Tầng 2, Khu D', 'ACTIVE'),
('OPHTHAL', N'Khoa Mắt', N'Chuyên khoa điều trị các bệnh về mắt', '0901234576', N'Tầng 3, Khu D', 'ACTIVE'),
('DENTAL', N'Khoa Răng Hàm Mặt', N'Chuyên khoa điều trị các bệnh về răng miệng', '0901234577', N'Tầng 1, Khu E', 'ACTIVE'),
('ONCO', N'Khoa Ung Bướu', N'Chuyên khoa điều trị các bệnh ung thư', '0901234578', N'Tầng 5, Khu A', 'ACTIVE'),
('NEPHRO', N'Khoa Thận - Tiết Niệu', N'Chuyên khoa điều trị các bệnh về thận, tiết niệu', '0901234579', N'Tầng 4, Khu C', 'ACTIVE'),
('PULMO', N'Khoa Hô Hấp', N'Chuyên khoa điều trị các bệnh về phổi, đường hô hấp', '0901234580', N'Tầng 5, Khu B', 'ACTIVE'),
('EMERGENCY', N'Khoa Cấp Cứu', N'Khoa cấp cứu và hồi sức tích cực', '0901234581', N'Tầng 1, Khu A', 'ACTIVE');
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
