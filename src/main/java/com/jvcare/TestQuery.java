package com.jvcare;

import com.jvcare.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestQuery {
    public static void main(String[] args) {
        System.out.println("=== Testing Query ===");
        String sql = "SELECT * FROM medical_records";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    System.out.println("MR_ID: " + rs.getInt("record_id") + 
                                       ", App_ID: " + rs.getInt("appointment_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
