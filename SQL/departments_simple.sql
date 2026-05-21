-- Script đơn giản để tạo bảng departments và thêm dữ liệu
-- Chạy từng phần một trong SSMS

-- BƯỚC 1: Tạo bảng departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY IDENTITY(1,1),
    department_code VARCHAR(20) UNIQUE NOT NULL,
    department_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    head_doctor_id INT,
    phone VARCHAR(20),
    location NVARCHAR(200),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- BƯỚC 2: Thêm constraint cho status
ALTER TABLE departments
ADD CONSTRAINT CHK_departments_status CHECK (status IN ('ACTIVE', 'INACTIVE'));

-- BƯỚC 3: Thêm dữ liệu mẫu
INSERT INTO departments (department_code, department_name, description, phone, location, status) VALUES
(N'CARDIO', N'Khoa Tim Mạch', N'Chuyên khoa điều trị các bệnh về tim mạch, huyết áp, mạch máu', '0901234567', N'Tầng 3, Khu A', 'ACTIVE'),
(N'NEURO', N'Khoa Thần Kinh', N'Chuyên khoa điều trị các bệnh về thần kinh, não bộ', '0901234568', N'Tầng 4, Khu A', 'ACTIVE'),
(N'ORTHO', N'Khoa Chấn Thương Chỉnh Hình', N'Chuyên khoa điều trị các bệnh về xương khớp, chấn thương', '0901234569', N'Tầng 2, Khu B', 'ACTIVE'),
(N'PEDIA', N'Khoa Nhi', N'Chuyên khoa điều trị các bệnh về trẻ em', '0901234570', N'Tầng 1, Khu C', 'ACTIVE'),
(N'OBGYN', N'Khoa Sản Phụ Khoa', N'Chuyên khoa điều trị các bệnh về phụ nữ, thai sản', '0901234571', N'Tầng 2, Khu C', 'ACTIVE'),
(N'GASTRO', N'Khoa Tiêu Hóa', N'Chuyên khoa điều trị các bệnh về dạ dày, ruột, gan mật', '0901234572', N'Tầng 3, Khu B', 'ACTIVE'),
(N'ENDO', N'Khoa Nội Tiết', N'Chuyên khoa điều trị các bệnh về nội tiết, đái tháo đường', '0901234573', N'Tầng 4, Khu B', 'ACTIVE'),
(N'DERMA', N'Khoa Da Liễu', N'Chuyên khoa điều trị các bệnh về da', '0901234574', N'Tầng 1, Khu D', 'ACTIVE'),
(N'ENT', N'Khoa Tai Mũi Họng', N'Chuyên khoa điều trị các bệnh về tai mũi họng', '0901234575', N'Tầng 2, Khu D', 'ACTIVE'),
(N'OPHTHAL', N'Khoa Mắt', N'Chuyên khoa điều trị các bệnh về mắt', '0901234576', N'Tầng 3, Khu D', 'ACTIVE'),
(N'DENTAL', N'Khoa Răng Hàm Mặt', N'Chuyên khoa điều trị các bệnh về răng miệng', '0901234577', N'Tầng 1, Khu E', 'ACTIVE'),
(N'ONCO', N'Khoa Ung Bướu', N'Chuyên khoa điều trị các bệnh ung thư', '0901234578', N'Tầng 5, Khu A', 'ACTIVE'),
(N'NEPHRO', N'Khoa Thận - Tiết Niệu', N'Chuyên khoa điều trị các bệnh về thận, tiết niệu', '0901234579', N'Tầng 4, Khu C', 'ACTIVE'),
(N'PULMO', N'Khoa Hô Hấp', N'Chuyên khoa điều trị các bệnh về phổi, đường hô hấp', '0901234580', N'Tầng 5, Khu B', 'ACTIVE'),
(N'EMERGENCY', N'Khoa Cấp Cứu', N'Khoa cấp cứu và hồi sức tích cực', '0901234581', N'Tầng 1, Khu A', 'ACTIVE');

-- BƯỚC 4: Thêm cột department_id vào bảng doctors
ALTER TABLE doctors 
ADD department_id INT;

-- BƯỚC 5: Thêm foreign key
ALTER TABLE doctors
ADD CONSTRAINT FK_doctors_departments FOREIGN KEY (department_id) 
    REFERENCES departments(department_id) ON DELETE SET NULL;

-- BƯỚC 6: Kiểm tra kết quả
SELECT * FROM departments;
SELECT COUNT(*) AS total_departments FROM departments;
