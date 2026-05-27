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
    visit_date DATETIME NOT NULL,
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
-- BẢNG EMPLOYEE_ROLES - Quản lý vai trò nhân viên
-----------------------------------------------------
CREATE TABLE employee_roles (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_code VARCHAR(50) UNIQUE NOT NULL,
    role_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    status VARCHAR(10) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE'))
);
GO

-- Insert các vai trò nhân viên
INSERT INTO employee_roles (role_code, role_name, description) VALUES
('RECEPTIONIST', N'Lễ Tân', N'Tiếp đón bệnh nhân, đăng ký khám bệnh'),
('CLEANER', N'Nhân Viên Vệ Sinh', N'Vệ sinh phòng khám, khu vực chung'),
('MAINTENANCE', N'Nhân Viên Bảo Trì', N'Bảo trì thiết bị y tế, cơ sở vật chất'),
('SECURITY', N'Nhân Viên Bảo Vệ', N'Bảo vệ an ninh phòng khám'),
('NURSE', N'Điều Dưỡng', N'Hỗ trợ bác sĩ, chăm sóc bệnh nhân'),
('PHARMACIST', N'Dược Sĩ', N'Quản lý thuốc, phát thuốc cho bệnh nhân'),
('LAB_TECH', N'Kỹ Thuật Viên Xét Nghiệm', N'Thực hiện xét nghiệm y khoa'),
('ACCOUNTANT', N'Kế Toán', N'Quản lý tài chính, kế toán'),
('HR', N'Nhân Sự', N'Quản lý nhân sự, tuyển dụng');
GO

-- Thêm cột employee_role_id vào bảng users
ALTER TABLE users ADD employee_role_id INT;
GO

ALTER TABLE users
ADD FOREIGN KEY (employee_role_id) REFERENCES employee_roles(role_id) ON DELETE SET NULL;
GO

-----------------------------------------------------
-- DỮ LIỆU MẪU
-----------------------------------------------------
-- Password: 123456 (BCrypt hash hoặc fallback)

-- Tạo tài khoản test
INSERT INTO users (username, password_hash, email, full_name, role, phone, status) VALUES 
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'admin@jvcare.com', N'Nguyễn Văn Admin', 'ADMIN', '0901234567', 'ACTIVE'),
('doctor', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'doctor@jvcare.com', N'Trần Thị Bác Sĩ', 'DOCTOR', '09123456789', 'ACTIVE'),
('patient', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'patient@jvcare.com', N'Tui là bệnh nhân', 'PATIENT', '09987654321', 'ACTIVE');
GO

-- Tạo tài khoản bác sĩ (10 bác sĩ các chuyên khoa)
INSERT INTO users (username, password_hash, email, full_name, role, phone, status) VALUES 
('bs.nguyenvana', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'nguyenvana@jvcare.com', N'BS. Nguyễn Văn A', 'DOCTOR', '0907654321', 'ACTIVE'),
('bs.tranthib', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'tranthib@jvcare.com', N'BS. Trần Thị B', 'DOCTOR', '0907654322', 'ACTIVE'),
('bs.lequangc', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'lequangc@jvcare.com', N'BS. Lê Quang C', 'DOCTOR', '0907654323', 'ACTIVE'),
('bs.phamthid', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'phamthid@jvcare.com', N'BS. Phạm Thị D', 'DOCTOR', '0907654324', 'ACTIVE'),
('bs.hoangvane', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'hoangvane@jvcare.com', N'BS. Hoàng Văn E', 'DOCTOR', '0907654325', 'ACTIVE'),
('bs.vuthif', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vuthif@jvcare.com', N'BS. Vũ Thị F', 'DOCTOR', '0907654326', 'ACTIVE'),
('bs.dangvang', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dangvang@jvcare.com', N'BS. Đặng Văn G', 'DOCTOR', '0907654327', 'ACTIVE'),
('bs.buithih', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'buithih@jvcare.com', N'BS. Bùi Thị H', 'DOCTOR', '0907654328', 'ACTIVE'),
('bs.dovani', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dovani@jvcare.com', N'BS. Đỗ Văn I', 'DOCTOR', '0907654329', 'ACTIVE'),
('bs.ngothik', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'ngothik@jvcare.com', N'BS. Ngô Thị K', 'DOCTOR', '0907654330', 'ACTIVE');
GO

-- Tạo thông tin bác sĩ với chuyên khoa
INSERT INTO doctors (user_id, specialization, department_id) VALUES 
(2, N'Tim Mạch', 1),
(3, N'Thần Kinh', 2),
(4, N'Chấn Thương Chỉnh Hình', 3),
(5, N'Nhi Khoa', 4),
(6, N'Sản Phụ Khoa', 5),
(7, N'Tiêu Hóa', 6),
(8, N'Nội Tiết', 7),
(9, N'Da Liễu', 8),
(10, N'Tai Mũi Họng', 9),
(11, N'Mắt', 10);
GO

-- Tạo tài khoản lễ tân
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('letan.nguyenthil', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'letan1@jvcare.com', N'Nguyễn Thị Lan', 'STAFF', '0908111111', 'ACTIVE', 1),
('letan.tranvanm', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'letan2@jvcare.com', N'Trần Văn Minh', 'STAFF', '0908111112', 'ACTIVE', 1),
('letan.lethinhung', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'letan3@jvcare.com', N'Lê Thị Nhung', 'STAFF', '0908111113', 'ACTIVE', 1),
('letan.phamvanp', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'letan4@jvcare.com', N'Phạm Văn Phong', 'STAFF', '0908111114', 'ACTIVE', 1),
('letan.hoangthiq', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'letan5@jvcare.com', N'Hoàng Thị Quỳnh', 'STAFF', '0908111115', 'ACTIVE', 1);
GO

-- Tạo tài khoản nhân viên vệ sinh
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('vesinh.nguyenvanr', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh1@jvcare.com', N'Nguyễn Văn Rồng', 'STAFF', '0908222221', 'ACTIVE', 2),
('vesinh.tranthis', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh2@jvcare.com', N'Trần Thị Sương', 'STAFF', '0908222222', 'ACTIVE', 2),
('vesinh.levant', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh3@jvcare.com', N'Lê Văn Tùng', 'STAFF', '0908222223', 'ACTIVE', 2),
('vesinh.phamthiu', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh4@jvcare.com', N'Phạm Thị Uyên', 'STAFF', '0908222224', 'ACTIVE', 2),
('vesinh.hoangvanv', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh5@jvcare.com', N'Hoàng Văn Vũ', 'STAFF', '0908222225', 'ACTIVE', 2),
('vesinh.vuthix', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh6@jvcare.com', N'Vũ Thị Xuân', 'STAFF', '0908222226', 'ACTIVE', 2),
('vesinh.dangvany', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh7@jvcare.com', N'Đặng Văn Yên', 'STAFF', '0908222227', 'ACTIVE', 2),
('vesinh.buithiz', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'vesinh8@jvcare.com', N'Bùi Thị Zung', 'STAFF', '0908222228', 'ACTIVE', 2);
GO

-- Tạo tài khoản nhân viên bảo trì thiết bị
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('baotri.nguyenvana1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baotri1@jvcare.com', N'Nguyễn Văn An', 'STAFF', '0908333331', 'ACTIVE', 3),
('baotri.tranthib1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baotri2@jvcare.com', N'Trần Thị Bình', 'STAFF', '0908333332', 'ACTIVE', 3),
('baotri.levanc1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baotri3@jvcare.com', N'Lê Văn Cường', 'STAFF', '0908333333', 'ACTIVE', 3),
('baotri.phamthid1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baotri4@jvcare.com', N'Phạm Thị Dung', 'STAFF', '0908333334', 'ACTIVE', 3),
('baotri.hoangvane1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baotri5@jvcare.com', N'Hoàng Văn Em', 'STAFF', '0908333335', 'ACTIVE', 3),
('baotri.vuthif1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baotri6@jvcare.com', N'Vũ Thị Phượng', 'STAFF', '0908333336', 'ACTIVE', 3),
('baotri.dangvang1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baotri7@jvcare.com', N'Đặng Văn Giang', 'STAFF', '0908333337', 'ACTIVE', 3);
GO

-- Tạo tài khoản nhân viên bảo vệ
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('baove.nguyenvanh1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baove1@jvcare.com', N'Nguyễn Văn Hùng', 'STAFF', '0908444441', 'ACTIVE', 4),
('baove.tranthii1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baove2@jvcare.com', N'Trần Thị Oanh', 'STAFF', '0908444442', 'ACTIVE', 4),
('baove.levank1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baove3@jvcare.com', N'Lê Văn Kiên', 'STAFF', '0908444443', 'ACTIVE', 4),
('baove.phamthil1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baove4@jvcare.com', N'Phạm Thị Linh', 'STAFF', '0908444444', 'ACTIVE', 4),
('baove.hoangvanm1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'baove5@jvcare.com', N'Hoàng Văn Mạnh', 'STAFF', '0908444445', 'ACTIVE', 4);
GO

-- Tạo tài khoản điều dưỡng
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('dieuduong.nguyenthin1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dieuduong1@jvcare.com', N'Nguyễn Thị Nga', 'STAFF', '0908555551', 'ACTIVE', 5),
('dieuduong.tranvano1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dieuduong2@jvcare.com', N'Trần Văn Ơn', 'STAFF', '0908555552', 'ACTIVE', 5),
('dieuduong.lethip1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dieuduong3@jvcare.com', N'Lê Thị Phương', 'STAFF', '0908555553', 'ACTIVE', 5),
('dieuduong.phamvanq1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dieuduong4@jvcare.com', N'Phạm Văn Quân', 'STAFF', '0908555554', 'ACTIVE', 5),
('dieuduong.hoangthir1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dieuduong5@jvcare.com', N'Hoàng Thị Rạng', 'STAFF', '0908555555', 'ACTIVE', 5),
('dieuduong.vuvans1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'dieuduong6@jvcare.com', N'Vũ Văn Sơn', 'STAFF', '0908555556', 'ACTIVE', 5);
GO

-- Tạo tài khoản dược sĩ
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('duocsi.nguyenthit1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'duocsi1@jvcare.com', N'Nguyễn Thị Tâm', 'STAFF', '0908666661', 'ACTIVE', 6),
('duocsi.tranvanu1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'duocsi2@jvcare.com', N'Trần Văn Út', 'STAFF', '0908666662', 'ACTIVE', 6),
('duocsi.lethiv1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'duocsi3@jvcare.com', N'Lê Thị Vân', 'STAFF', '0908666663', 'ACTIVE', 6),
('duocsi.phamvanx1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'duocsi4@jvcare.com', N'Phạm Văn Xuân', 'STAFF', '0908666664', 'ACTIVE', 6);
GO

-- Tạo tài khoản kỹ thuật viên xét nghiệm
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('xetnghiem.nguyenvany1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'xetnghiem1@jvcare.com', N'Nguyễn Văn Yên', 'STAFF', '0908777771', 'ACTIVE', 7),
('xetnghiem.tranthiz1', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'xetnghiem2@jvcare.com', N'Trần Thị Zung', 'STAFF', '0908777772', 'ACTIVE', 7),
('xetnghiem.levana2', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'xetnghiem3@jvcare.com', N'Lê Văn Anh', 'STAFF', '0908777773', 'ACTIVE', 7);
GO

-- Tạo tài khoản kế toán
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('ketoan.phamthib2', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'ketoan1@jvcare.com', N'Phạm Thị Bích', 'STAFF', '0908888881', 'ACTIVE', 8),
('ketoan.hoangvanc2', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'ketoan2@jvcare.com', N'Hoàng Văn Cường', 'STAFF', '0908888882', 'ACTIVE', 8);
GO

-- Tạo tài khoản nhân sự
INSERT INTO users (username, password_hash, email, full_name, role, phone, status, employee_role_id) VALUES 
('nhansu.vuthid2', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'nhansu1@jvcare.com', N'Vũ Thị Duyên', 'STAFF', '0908999991', 'ACTIVE', 9),
('nhansu.dangvane2', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'nhansu2@jvcare.com', N'Đặng Văn Em', 'STAFF', '0908999992', 'ACTIVE', 9);
GO

-- Tạo tài khoản bệnh nhân có đăng ký
INSERT INTO users (username, password_hash, email, full_name, role, phone, status) VALUES 
('bn.nguyenvana', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn1@gmail.com', N'Nguyễn Văn An', 'PATIENT', '0981111111', 'ACTIVE'),
('bn.tranthib', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn2@gmail.com', N'Trần Thị Bình', 'PATIENT', '0981111112', 'ACTIVE'),
('bn.levanc', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn3@gmail.com', N'Lê Văn Cường', 'PATIENT', '0981111113', 'ACTIVE'),
('bn.phamthid', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn4@gmail.com', N'Phạm Thị Dung', 'PATIENT', '0981111114', 'ACTIVE'),
('bn.hoangvane', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn5@gmail.com', N'Hoàng Văn Em', 'PATIENT', '0981111115', 'ACTIVE'),
('bn.vuthif', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn6@gmail.com', N'Vũ Thị Phượng', 'PATIENT', '0981111116', 'ACTIVE'),
('bn.dangvang', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn7@gmail.com', N'Đặng Văn Giang', 'PATIENT', '0981111117', 'ACTIVE'),
('bn.buithih', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn8@gmail.com', N'Bùi Thị Hoa', 'PATIENT', '0981111118', 'ACTIVE'),
('bn.dovani', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn9@gmail.com', N'Đỗ Văn Ích', 'PATIENT', '0981111119', 'ACTIVE'),
('bn.ngothik', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8JZzm/jXZvXZvXZvXZvXZvXZvXZvXO', 'bn10@gmail.com', N'Ngô Thị Kim', 'PATIENT', '0981111120', 'ACTIVE');
GO

-- Tạo thông tin bệnh nhân có tài khoản
INSERT INTO patients (user_id, patient_code, full_name, date_of_birth, gender, phone, email, address, id_card, allergies, chronic_diseases) VALUES 
(52, 'BN-10001', N'Nguyễn Văn An', '1985-03-15', 'MALE', '0981111111', 'bn1@gmail.com', N'123 Lê Lợi, Q1, TP.HCM', '079085012345', N'Không', N'Không'),
(53, 'BN-10002', N'Trần Thị Bình', '1990-07-22', 'FEMALE', '0981111112', 'bn2@gmail.com', N'456 Nguyễn Huệ, Q1, TP.HCM', '079090023456', N'Phấn hoa', N'Hen suyễn'),
(54, 'BN-10003', N'Lê Văn Cường', '1978-11-30', 'MALE', '0981111113', 'bn3@gmail.com', N'789 Trần Hưng Đạo, Q5, TP.HCM', '079078034567', N'Hải sản', N'Tiểu đường type 2'),
(55, 'BN-10004', N'Phạm Thị Dung', '1995-05-18', 'FEMALE', '0981111114', 'bn4@gmail.com', N'321 Lý Thường Kiệt, Q10, TP.HCM', '079095045678', N'Không', N'Không'),
(56, 'BN-10005', N'Hoàng Văn Em', '1982-09-25', 'MALE', '0981111115', 'bn5@gmail.com', N'654 Võ Văn Tần, Q3, TP.HCM', '079082056789', N'Penicillin', N'Cao huyết áp'),
(57, 'BN-10006', N'Vũ Thị Phượng', '1988-12-10', 'FEMALE', '0981111116', 'bn6@gmail.com', N'987 Điện Biên Phủ, Bình Thạnh, TP.HCM', '079088067890', N'Không', N'Không'),
(58, 'BN-10007', N'Đặng Văn Giang', '1975-02-14', 'MALE', '0981111117', 'bn7@gmail.com', N'147 Cách Mạng Tháng 8, Q3, TP.HCM', '079075078901', N'Bụi', N'Viêm xoang mãn tính'),
(59, 'BN-10008', N'Bùi Thị Hoa', '1992-06-08', 'FEMALE', '0981111118', 'bn8@gmail.com', N'258 Hai Bà Trưng, Q1, TP.HCM', '079092089012', N'Không', N'Không'),
(60, 'BN-10009', N'Đỗ Văn Ích', '1980-10-20', 'MALE', '0981111119', 'bn9@gmail.com', N'369 Pasteur, Q3, TP.HCM', '079080090123', N'Tôm cua', N'Gout'),
(61, 'BN-10010', N'Ngô Thị Kim', '1998-04-12', 'FEMALE', '0981111120', 'bn10@gmail.com', N'741 Nguyễn Thị Minh Khai, Q3, TP.HCM', '079098001234', N'Không', N'Không');
GO

-- Tạo bệnh nhân không có tài khoản (walk-in)
INSERT INTO patients (user_id, patient_code, full_name, date_of_birth, gender, phone, email, address, id_card, allergies, chronic_diseases) VALUES 
(NULL, 'BN-10011', N'Lương Văn Long', '1970-01-05', 'MALE', '0982222221', NULL, N'852 Lê Văn Sỹ, Q3, TP.HCM', '079070112345', N'Không', N'Đau khớp mãn tính'),
(NULL, 'BN-10012', N'Mai Thị Mai', '1987-08-17', 'FEMALE', '0982222222', NULL, N'963 Hoàng Văn Thụ, Tân Bình, TP.HCM', '079087123456', N'Sữa', N'Không'),
(NULL, 'BN-10013', N'Trương Văn Nam', '1993-03-28', 'MALE', '0982222223', NULL, N'159 Cộng Hòa, Tân Bình, TP.HCM', '079093134567', N'Không', N'Không'),
(NULL, 'BN-10014', N'Đinh Thị Oanh', '1965-11-11', 'FEMALE', '0982222224', NULL, N'357 Trường Chinh, Q12, TP.HCM', '079065145678', N'Aspirin', N'Suy tim'),
(NULL, 'BN-10015', N'Dương Văn Phúc', '1991-07-03', 'MALE', '0982222225', NULL, N'486 Quang Trung, Gò Vấp, TP.HCM', '079091156789', N'Không', N'Không'),
(NULL, 'BN-10016', N'Cao Thị Quỳnh', '1984-12-25', 'FEMALE', '0982222226', NULL, N'753 Phan Văn Trị, Gò Vấp, TP.HCM', '079084167890', N'Phấn hoa', N'Viêm mũi dị ứng'),
(NULL, 'BN-10017', N'Tô Văn Rồng', '1977-05-19', 'MALE', '0982222227', NULL, N'951 Lũy Bán Bích, Tân Phú, TP.HCM', '079077178901', N'Không', N'Viêm gan B'),
(NULL, 'BN-10018', N'Lý Thị Sương', '1996-09-07', 'FEMALE', '0982222228', NULL, N'246 Tân Sơn Nhì, Tân Phú, TP.HCM', '079096189012', N'Không', N'Không'),
(NULL, 'BN-10019', N'Hồ Văn Tài', '1972-02-28', 'MALE', '0982222229', NULL, N'135 Lạc Long Quân, Q11, TP.HCM', '079072190123', N'Thuốc kháng sinh', N'Sỏi thận'),
(NULL, 'BN-10020', N'Võ Thị Uyên', '1989-06-16', 'FEMALE', '0982222230', NULL, N'864 Âu Cơ, Tân Bình, TP.HCM', '079089201234', N'Không', N'Không'),
(NULL, 'BN-10021', N'Phan Văn Việt', '1994-10-09', 'MALE', '0982222231', NULL, N'579 Hòa Bình, Tân Phú, TP.HCM', '079094212345', N'Không', N'Không'),
(NULL, 'BN-10022', N'Tạ Thị Xuân', '1981-04-21', 'FEMALE', '0982222232', NULL, N'792 Tân Kỳ Tân Quý, Tân Phú, TP.HCM', '079081223456', N'Tôm', N'Mề đay mãn tính');
GO

PRINT N'✓ Đã tạo dữ liệu users và patients thành công!';
GO

-----------------------------------------------------
-- DỮ LIỆU LỊCH HẸN (APPOINTMENTS)
-----------------------------------------------------
-- Tạo 33 lịch hẹn: 10 hoàn thành, 10 đã xác nhận, 10 chờ xác nhận, 3 đã hủy

-- Lịch hẹn đã hoàn thành (COMPLETED) - có medical records
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason, notes, diagnosis, patient_condition, advice) VALUES 
(1, 1, '2024-01-15', '08:00:00', 'COMPLETED', N'Khám tim định kỳ', N'Bệnh nhân đến đúng giờ', N'Huyết áp cao nhẹ', N'Huyết áp 140/90', N'Uống thuốc đều đặn, tái khám sau 1 tháng'),
(2, 2, '2024-01-16', '09:00:00', 'COMPLETED', N'Đau đầu thường xuyên', N'Triệu chứng kéo dài 2 tuần', N'Đau nửa đầu Migraine', N'Đau đầu bên trái, buồn nôn', N'Nghỉ ngơi đầy đủ, tránh stress'),
(3, 3, '2024-01-17', '10:00:00', 'COMPLETED', N'Đau lưng', N'Đau sau khi làm việc nặng', N'Thoát vị đĩa đệm L4-L5', N'Đau lưng dưới, tê chân', N'Vật lý trị liệu, không mang vác nặng'),
(4, 4, '2024-01-18', '08:30:00', 'COMPLETED', N'Sốt cao ở trẻ', N'Sốt 39 độ kéo dài 2 ngày', N'Viêm họng cấp', N'Sốt 39°C, họng đỏ', N'Uống thuốc hạ sốt, nghỉ học 3 ngày'),
(5, 5, '2024-01-19', '14:00:00', 'COMPLETED', N'Khám thai định kỳ', N'Thai 20 tuần', N'Thai phát triển bình thường', N'Thai 20 tuần, cân nặng tốt', N'Bổ sung vitamin, tái khám sau 4 tuần'),
(6, 6, '2024-01-20', '09:30:00', 'COMPLETED', N'Đau bụng', N'Đau vùng thượng vị', N'Viêm dạ dày cấp', N'Đau thượng vị, ợ nóng', N'Ăn uống điều độ, tránh cay nóng'),
(7, 7, '2024-01-22', '10:30:00', 'COMPLETED', N'Kiểm tra đường huyết', N'Tiểu đường type 2', N'Đái tháo đường type 2 kiểm soát tốt', N'Đường huyết 130 mg/dL', N'Tiếp tục điều trị, kiểm soát chế độ ăn'),
(8, 8, '2024-01-23', '11:00:00', 'COMPLETED', N'Nổi mẩn ngứa', N'Ngứa toàn thân', N'Dị ứng thực phẩm', N'Mẩn đỏ toàn thân, ngứa', N'Tránh thực phẩm gây dị ứng'),
(9, 9, '2024-01-24', '08:00:00', 'COMPLETED', N'Đau tai', N'Đau tai phải', N'Viêm tai giữa cấp', N'Tai đỏ, sưng, đau', N'Nhỏ thuốc tai, tránh nước'),
(10, 10, '2024-01-25', '09:00:00', 'COMPLETED', N'Mờ mắt', N'Nhìn mờ dần', N'Cận thị tăng', N'Thị lực giảm -2.5D', N'Đeo kính, khám lại sau 6 tháng');
GO

-- Lịch hẹn đã xác nhận (CONFIRMED) - sắp tới
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason, notes) VALUES 
(11, 1, '2024-02-01', '08:00:00', 'CONFIRMED', N'Khám tim định kỳ', N'Bệnh nhân có tiền sử bệnh tim'),
(12, 2, '2024-02-01', '09:00:00', 'CONFIRMED', N'Tê tay chân', N'Triệu chứng xuất hiện 1 tuần'),
(13, 3, '2024-02-02', '10:00:00', 'CONFIRMED', N'Đau khớp gối', N'Đau khi đi lại'),
(14, 4, '2024-02-02', '14:00:00', 'CONFIRMED', N'Tiêm chủng cho trẻ', N'Tiêm vắc xin 18 tháng tuổi'),
(15, 5, '2024-02-03', '08:30:00', 'CONFIRMED', N'Khám thai lần đầu', N'Thai 8 tuần'),
(16, 6, '2024-02-03', '09:30:00', 'CONFIRMED', N'Khó tiêu', N'Ăn không tiêu'),
(17, 7, '2024-02-04', '10:00:00', 'CONFIRMED', N'Tư vấn dinh dưỡng', N'Bệnh nhân tiểu đường'),
(18, 8, '2024-02-04', '11:00:00', 'CONFIRMED', N'Mụn trứng cá', N'Mụn nhiều ở mặt'),
(19, 9, '2024-02-05', '08:00:00', 'CONFIRMED', N'Viêm mũi dị ứng', N'Hắt hơi, sổ mũi'),
(20, 10, '2024-02-05', '09:00:00', 'CONFIRMED', N'Khám mắt định kỳ', N'Kiểm tra thị lực');
GO

-- Lịch hẹn chờ xác nhận (PENDING)
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason, notes) VALUES 
(21, 1, '2024-02-06', '08:00:00', 'PENDING', N'Đau ngực', N'Đau ngực khi gắng sức'),
(22, 2, '2024-02-06', '09:00:00', 'PENDING', N'Chóng mặt', N'Chóng mặt thường xuyên'),
(1, 3, '2024-02-07', '10:00:00', 'PENDING', N'Tái khám lưng', N'Kiểm tra sau điều trị'),
(2, 4, '2024-02-07', '14:00:00', 'PENDING', N'Ho kéo dài', N'Ho hơn 2 tuần'),
(3, 5, '2024-02-08', '08:30:00', 'PENDING', N'Tư vấn kế hoạch hóa gia đình', NULL),
(4, 6, '2024-02-08', '09:30:00', 'PENDING', N'Đau bụng dưới', N'Đau âm ỉ'),
(5, 7, '2024-02-09', '10:00:00', 'PENDING', N'Tái khám đường huyết', N'Kiểm tra sau 1 tháng'),
(6, 8, '2024-02-09', '11:00:00', 'PENDING', N'Nám da', N'Nám nhiều ở má'),
(7, 9, '2024-02-10', '08:00:00', 'PENDING', N'Ngạt mũi', N'Khó thở qua mũi'),
(8, 10, '2024-02-10', '09:00:00', 'PENDING', N'Khô mắt', N'Mắt khô, cộm');
GO

-- Lịch hẹn đã hủy (CANCELLED)
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, reason, notes) VALUES 
(9, 1, '2024-01-28', '08:00:00', 'CANCELLED', N'Khám sức khỏe tổng quát', N'Bệnh nhân hủy vì bận việc'),
(10, 5, '2024-01-29', '14:00:00', 'CANCELLED', N'Khám phụ khoa', N'Bệnh nhân đổi lịch'),
(11, 7, '2024-01-30', '10:00:00', 'CANCELLED', N'Tư vấn dinh dưỡng', N'Bác sĩ có việc đột xuất');
GO

PRINT N'✓ Đã tạo 33 lịch hẹn thành công!';
GO

-----------------------------------------------------
-- DỮ LIỆU HỒ SƠ BỆNH ÁN (MEDICAL RECORDS)
-----------------------------------------------------
-- Tạo 10 hồ sơ bệnh án cho 10 lịch hẹn đã hoàn thành

INSERT INTO medical_records (patient_id, doctor_id, appointment_id, visit_date, diagnosis, treatment_plan, notes, blood_pressure, heart_rate, temperature, weight, height) VALUES 
(1, 1, 1, '2024-01-15', N'Huyết áp cao nhẹ (Stage 1 Hypertension)', N'Kê đơn thuốc hạ huyết áp, theo dõi huyết áp hàng ngày', N'Bệnh nhân cần giảm muối trong chế độ ăn', '140/90', 78, 36.5, 72.5, 168.0),
(2, 2, 2, '2024-01-16', N'Đau nửa đầu Migraine', N'Kê đơn thuốc giảm đau, thuốc chống buồn nôn', N'Tránh ánh sáng mạnh, tiếng ồn', '120/80', 72, 36.8, 58.0, 162.0),
(3, 3, 3, '2024-01-17', N'Thoát vị đĩa đệm L4-L5', N'Vật lý trị liệu, thuốc giảm đau, chống viêm', N'Cần MRI để đánh giá mức độ thoát vị', '130/85', 75, 36.6, 78.0, 172.0),
(4, 4, 4, '2024-01-18', N'Viêm họng cấp do virus', N'Thuốc hạ sốt, thuốc xịt họng, nghỉ ngơi', N'Không cần kháng sinh', '110/70', 95, 39.0, 18.5, 105.0),
(5, 5, 5, '2024-01-19', N'Thai 20 tuần phát triển bình thường', N'Bổ sung sắt, acid folic, vitamin tổng hợp', N'Siêu âm thai nhi bình thường', '115/75', 80, 36.7, 62.0, 160.0),
(6, 6, 6, '2024-01-20', N'Viêm dạ dày cấp', N'Thuốc kháng acid, thuốc bảo vệ niêm mạc dạ dày', N'Nên nội soi dạ dày nếu không đỡ sau 2 tuần', '125/80', 76, 36.9, 65.0, 165.0),
(7, 7, 7, '2024-01-22', N'Đái tháo đường type 2 kiểm soát tốt', N'Tiếp tục Metformin, kiểm soát chế độ ăn', N'HbA1c: 6.8%, đường huyết đói: 130 mg/dL', '135/88', 74, 36.5, 82.0, 170.0),
(8, 8, 8, '2024-01-23', N'Dị ứng thực phẩm (nghi ngờ hải sản)', N'Thuốc kháng histamine, corticoid bôi', N'Tránh hải sản, có thể test dị ứng', '118/78', 70, 36.6, 55.0, 158.0),
(9, 9, 9, '2024-01-24', N'Viêm tai giữa cấp bên phải', N'Kháng sinh, thuốc giảm đau, thuốc nhỏ tai', N'Tái khám sau 1 tuần', '122/82', 73, 37.2, 68.0, 166.0),
(10, 10, 10, '2024-01-25', N'Cận thị tăng -2.5D', N'Kê đơn kính cận, khuyên đeo kính thường xuyên', N'Hạn chế sử dụng điện thoại, máy tính', '120/80', 71, 36.5, 52.0, 155.0);
GO

PRINT N'✓ Đã tạo 10 hồ sơ bệnh án thành công!';
GO

-----------------------------------------------------
-- DỮ LIỆU ĐơN THUỐC (PRESCRIPTIONS)
-----------------------------------------------------
-- Tạo đơn thuốc chi tiết cho từng hồ sơ bệnh án

-- Đơn thuốc cho bệnh án 1 (Huyết áp cao)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(1, N'Amlodipine', N'5mg', N'1 viên/ngày', 30, N'Uống vào buổi sáng sau ăn'),
(1, N'Losartan', N'50mg', N'1 viên/ngày', 30, N'Uống vào buổi tối trước khi ngủ');
GO

-- Đơn thuốc cho bệnh án 2 (Migraine)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(2, N'Sumatriptan', N'50mg', N'1 viên khi đau', 10, N'Uống ngay khi có triệu chứng đau đầu'),
(2, N'Domperidone', N'10mg', N'1 viên khi buồn nôn', 10, N'Uống trước bữa ăn 30 phút');
GO

-- Đơn thuốc cho bệnh án 3 (Thoát vị đĩa đệm)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(3, N'Ibuprofen', N'400mg', N'2 viên/lần, 3 lần/ngày', 14, N'Uống sau ăn'),
(3, N'Methocarbamol', N'500mg', N'2 viên/lần, 3 lần/ngày', 14, N'Thuốc giãn cơ, có thể gây buồn ngủ'),
(3, N'Vitamin B1-B6-B12', N'1 viên', N'1 viên/ngày', 30, N'Bổ sung vitamin nhóm B cho thần kinh');
GO

-- Đơn thuốc cho bệnh án 4 (Viêm họng ở trẻ)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(4, N'Paracetamol (siro)', N'5ml', N'Mỗi 6 giờ khi sốt', 5, N'Uống khi sốt trên 38.5°C'),
(4, N'Hexoral (xịt họng)', N'2 nhát', N'3 lần/ngày', 7, N'Xịt sau khi ăn, không ăn uống trong 30 phút');
GO

-- Đơn thuốc cho bệnh án 5 (Thai 20 tuần)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(5, N'Acid Folic', N'5mg', N'1 viên/ngày', 90, N'Uống vào buổi sáng'),
(5, N'Sắt Sulfat', N'200mg', N'1 viên/ngày', 90, N'Uống vào buổi tối, có thể gây táo bón'),
(5, N'Vitamin tổng hợp bà bầu', N'1 viên', N'1 viên/ngày', 90, N'Uống sau bữa ăn chính');
GO

-- Đơn thuốc cho bệnh án 6 (Viêm dạ dày)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(6, N'Omeprazole', N'20mg', N'1 viên/ngày', 14, N'Uống vào buổi sáng trước ăn 30 phút'),
(6, N'Sucralfate', N'1g', N'1 gói/lần, 3 lần/ngày', 14, N'Uống trước bữa ăn 1 giờ'),
(6, N'Domperidone', N'10mg', N'1 viên/lần, 3 lần/ngày', 7, N'Uống trước bữa ăn 30 phút');
GO

-- Đơn thuốc cho bệnh án 7 (Tiểu đường)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(7, N'Metformin', N'500mg', N'2 viên/lần, 2 lần/ngày', 30, N'Uống sau bữa ăn sáng và tối'),
(7, N'Glimepiride', N'2mg', N'1 viên/ngày', 30, N'Uống trước bữa ăn sáng 30 phút');
GO

-- Đơn thuốc cho bệnh án 8 (Dị ứng)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(8, N'Cetirizine', N'10mg', N'1 viên/ngày', 7, N'Uống vào buổi tối trước khi ngủ'),
(8, N'Hydrocortisone cream 1%', N'Bôi mỏng', N'2 lần/ngày', 7, N'Bôi lên vùng da bị dị ứng'),
(8, N'Prednisolone', N'5mg', N'2 viên/lần, 2 lần/ngày', 5, N'Uống sau ăn, giảm liều dần');
GO

-- Đơn thuốc cho bệnh án 9 (Viêm tai giữa)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(9, N'Amoxicillin', N'500mg', N'1 viên/lần, 3 lần/ngày', 7, N'Uống sau ăn, uống đủ liệu trình'),
(9, N'Ibuprofen', N'400mg', N'1 viên khi đau', 7, N'Uống sau ăn khi đau'),
(9, N'Ofloxacin (nhỏ tai)', N'3 giọt', N'2 lần/ngày', 7, N'Nhỏ vào tai bị viêm, nằm nghiêng 5 phút');
GO

-- Đơn thuốc cho bệnh án 10 (Cận thị)
INSERT INTO prescriptions (record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES 
(10, N'Kính cận -2.5D', N'Đeo thường xuyên', N'Cả ngày', 365, N'Đeo kính khi nhìn xa, học tập, làm việc'),
(10, N'Thuốc nhỏ mắt Vitamin A', N'1-2 giọt', N'2 lần/ngày', 30, N'Nhỏ vào mắt sáng và tối');
GO

PRINT N'✓ Đã tạo đơn thuốc chi tiết thành công!';
GO

-----------------------------------------------------
-- TỔNG KẾT DỮ LIỆU ĐÃ TẠO
-----------------------------------------------------
PRINT N'';
PRINT N'========================================';
PRINT N'TỔNG KẾT DỮ LIỆU ĐÃ KHỞI TẠO';
PRINT N'========================================';
PRINT N'✓ 15 Khoa (Departments)';
PRINT N'✓ 9 Vai trò nhân viên (Employee Roles)';
PRINT N'✓ 1 Admin';
PRINT N'✓ 10 Bác sĩ (Doctors)';
PRINT N'✓ 5 Lễ tân (Receptionists)';
PRINT N'✓ 8 Nhân viên vệ sinh (Cleaners)';
PRINT N'✓ 7 Nhân viên bảo trì (Maintenance)';
PRINT N'✓ 5 Nhân viên bảo vệ (Security)';
PRINT N'✓ 6 Điều dưỡng (Nurses)';
PRINT N'✓ 4 Dược sĩ (Pharmacists)';
PRINT N'✓ 3 Kỹ thuật viên xét nghiệm (Lab Technicians)';
PRINT N'✓ 2 Kế toán (Accountants)';
PRINT N'✓ 2 Nhân sự (HR)';
PRINT N'✓ 22 Bệnh nhân (10 có tài khoản, 12 walk-in)';
PRINT N'✓ 33 Lịch hẹn (10 hoàn thành, 10 đã xác nhận, 10 chờ xác nhận, 3 đã hủy)';
PRINT N'✓ 10 Hồ sơ bệnh án với đầy đủ chỉ số sinh tồn';
PRINT N'✓ 28 Đơn thuốc chi tiết';
PRINT N'========================================';
PRINT N'Database JVCare_MVC đã sẵn sàng sử dụng!';
PRINT N'========================================';
GO
