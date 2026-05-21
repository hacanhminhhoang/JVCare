-- Kiểm tra database JVCare_MVC
USE JVCare_MVC;
GO

-- 1. Kiểm tra bảng departments có tồn tại không
SELECT COUNT(*) AS departments_table_exists 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'departments';
GO

-- 2. Kiểm tra dữ liệu trong bảng users với role DOCTOR
SELECT user_id, username, email, full_name, role, status 
FROM users 
WHERE role = 'DOCTOR';
GO

-- 3. Kiểm tra dữ liệu trong bảng doctors
SELECT * FROM doctors;
GO

-- 4. Kiểm tra dữ liệu trong bảng departments (nếu tồn tại)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'departments')
BEGIN
    SELECT * FROM departments;
END
ELSE
BEGIN
    PRINT 'Bảng departments không tồn tại!';
END
GO

-- 5. Test query giống như trong DoctorDAO.getAllDoctors()
SELECT d.doctor_id, d.user_id, d.specialization, d.department_id,
       u.full_name, u.email, u.phone, u.status,
       dept.department_name
FROM doctors d
JOIN users u ON d.user_id = u.user_id
LEFT JOIN departments dept ON d.department_id = dept.department_id
ORDER BY u.full_name;
GO
