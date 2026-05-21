-- =============================================
-- Script: Tạo bảng Departments (Khoa) cho SQL Server
-- =============================================

-- Kiểm tra và tạo bảng departments nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'departments')
BEGIN
    CREATE TABLE departments (
        department_id INT PRIMARY KEY IDENTITY(1,1),
        department_code VARCHAR(20) UNIQUE NOT NULL,
        department_name NVARCHAR(100) NOT NULL,
        description NVARCHAR(MAX),
        head_doctor_id INT,
        phone VARCHAR(20),
        location NVARCHAR(200),
        status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_departments_doctors FOREIGN KEY (head_doctor_id) 
            REFERENCES doctors(doctor_id) ON DELETE SET NULL
    );
    PRINT 'Bảng departments đã được tạo thành công.';
END
ELSE
BEGIN
    PRINT 'Bảng departments đã tồn tại.';
END
GO

-- Thêm cột department_id vào bảng doctors nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID('doctors') 
               AND name = 'department_id')
BEGIN
    ALTER TABLE doctors 
    ADD department_id INT;
    
    ALTER TABLE doctors
    ADD CONSTRAINT FK_doctors_departments FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) ON DELETE SET NULL;
    
    PRINT 'Đã thêm cột department_id vào bảng doctors.';
END
ELSE
BEGIN
    PRINT 'Cột department_id đã tồn tại trong bảng doctors.';
END
GO

-- Thêm dữ liệu mẫu cho departments
IF NOT EXISTS (SELECT * FROM departments)
BEGIN
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
    
    PRINT 'Đã thêm 15 khoa mẫu vào bảng departments.';
END
ELSE
BEGIN
    PRINT 'Bảng departments đã có dữ liệu.';
END
GO

-- Hiển thị kết quả
SELECT * FROM departments;
GO
