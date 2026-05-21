package com.jvcare.dao;

import com.jvcare.model.Department;
import com.jvcare.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {
    
    /**
     * Lấy tất cả departments đang ACTIVE
     */
    public List<Department> getAllActiveDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments WHERE status = 'ACTIVE' ORDER BY department_name";
        
        System.out.println("DepartmentDAO.getAllActiveDepartments: Executing query...");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Department dept = mapResultSetToDepartment(rs);
                list.add(dept);
                System.out.println("DepartmentDAO: Added department - " + dept.getDepartmentName());
            }
        } catch (SQLException e) {
            System.err.println("DepartmentDAO SQL Error: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("DepartmentDAO ClassNotFound Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DepartmentDAO.getAllActiveDepartments: Returned " + list.size() + " departments");
        return list;
    }
    
    /**
     * Lấy tất cả departments
     */
    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY department_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToDepartment(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return list;
    }
    
    /**
     * Lấy department theo ID
     */
    public Department getDepartmentById(int departmentId) {
        String sql = "SELECT * FROM departments WHERE department_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDepartment(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Tạo department mới
     */
    public boolean createDepartment(Department dept) {
        String sql = "INSERT INTO departments (department_code, department_name, description, phone, location, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, dept.getDepartmentCode());
            ps.setString(2, dept.getDepartmentName());
            ps.setString(3, dept.getDescription());
            ps.setString(4, dept.getPhone());
            ps.setString(5, dept.getLocation());
            ps.setString(6, dept.getStatus() != null ? dept.getStatus() : "ACTIVE");
            
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Cập nhật department
     */
    public boolean updateDepartment(Department dept) {
        String sql = "UPDATE departments SET department_name = ?, description = ?, phone = ?, " +
                     "location = ?, status = ?, head_doctor_id = ? WHERE department_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, dept.getDepartmentName());
            ps.setString(2, dept.getDescription());
            ps.setString(3, dept.getPhone());
            ps.setString(4, dept.getLocation());
            ps.setString(5, dept.getStatus());
            
            if (dept.getHeadDoctorId() != null) {
                ps.setInt(6, dept.getHeadDoctorId());
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            
            ps.setInt(7, dept.getDepartmentId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Xóa department
     */
    public boolean deleteDepartment(int departmentId) {
        String sql = "DELETE FROM departments WHERE department_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Map ResultSet to Department object
     */
    private Department mapResultSetToDepartment(ResultSet rs) throws SQLException {
        Department dept = new Department();
        dept.setDepartmentId(rs.getInt("department_id"));
        dept.setDepartmentCode(rs.getString("department_code"));
        dept.setDepartmentName(rs.getString("department_name"));
        dept.setDescription(rs.getString("description"));
        
        int headDoctorId = rs.getInt("head_doctor_id");
        if (!rs.wasNull()) {
            dept.setHeadDoctorId(headDoctorId);
        }
        
        dept.setPhone(rs.getString("phone"));
        dept.setLocation(rs.getString("location"));
        dept.setStatus(rs.getString("status"));
        dept.setCreatedAt(rs.getTimestamp("created_at"));
        dept.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return dept;
    }
}
