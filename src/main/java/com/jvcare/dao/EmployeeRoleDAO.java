package com.jvcare.dao;

import com.jvcare.model.EmployeeRole;
import com.jvcare.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmployeeRoleDAO {

    public List<EmployeeRole> getAllActiveRoles() {
        List<EmployeeRole> list = new ArrayList<>();
        String sql = "SELECT * FROM employee_roles WHERE status = 'ACTIVE' ORDER BY role_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EmployeeRole role = new EmployeeRole();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleCode(rs.getString("role_code"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                role.setStatus(rs.getString("status"));
                list.add(role);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
}
