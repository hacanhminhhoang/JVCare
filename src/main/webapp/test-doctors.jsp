<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.jvcare.dao.DoctorDAO" %>
<%@ page import="com.jvcare.model.Doctor" %>
<%@ page import="com.jvcare.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Doctors</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; }
        h2 { color: #666; margin-top: 30px; }
        table { border-collapse: collapse; width: 100%; margin: 10px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .error { color: red; background: #fee; padding: 10px; margin: 10px 0; border: 1px solid red; }
        .success { color: green; background: #efe; padding: 10px; margin: 10px 0; border: 1px solid green; }
        .info { color: blue; background: #eef; padding: 10px; margin: 10px 0; border: 1px solid blue; }
        pre { background: #f5f5f5; padding: 10px; overflow-x: auto; }
    </style>
</head>
<body>
    <h1>🔍 Test Doctor DAO - Debug Page</h1>
    
    <h2>1. Database Connection Test</h2>
    <%
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                out.println("<p class='success'>✅ Database connection successful!</p>");
                out.println("<p class='info'>Database: " + conn.getCatalog() + "</p>");
                conn.close();
            } else {
                out.println("<p class='error'>❌ Database connection failed!</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>❌ Database connection error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
    
    <h2>2. Check Tables Existence</h2>
    <%
        try (Connection conn = DBConnection.getConnection()) {
            // Check users table
            String checkUsers = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users'";
            PreparedStatement ps = conn.prepareStatement(checkUsers);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                out.println("<p class='success'>✅ Table 'users' exists</p>");
            } else {
                out.println("<p class='error'>❌ Table 'users' does NOT exist</p>");
            }
            
            // Check doctors table
            String checkDoctors = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'doctors'";
            ps = conn.prepareStatement(checkDoctors);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                out.println("<p class='success'>✅ Table 'doctors' exists</p>");
            } else {
                out.println("<p class='error'>❌ Table 'doctors' does NOT exist</p>");
            }
            
            // Check departments table
            String checkDepts = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'departments'";
            ps = conn.prepareStatement(checkDepts);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                out.println("<p class='success'>✅ Table 'departments' exists</p>");
            } else {
                out.println("<p class='error'>❌ Table 'departments' does NOT exist</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>Error checking tables: " + e.getMessage() + "</p>");
        }
    %>
    
    <h2>3. Check Users with DOCTOR Role</h2>
    <%
        try (Connection conn2 = DBConnection.getConnection()) {
            String sql2 = "SELECT * FROM users WHERE role = 'DOCTOR'";
            PreparedStatement ps2 = conn2.prepareStatement(sql2);
            ResultSet rs2 = ps2.executeQuery();
            
            int userCount = 0;
            out.println("<table>");
            out.println("<tr><th>User ID</th><th>Username</th><th>Full Name</th><th>Email</th><th>Status</th></tr>");
            
            while (rs2.next()) {
                userCount++;
                out.println("<tr>");
                out.println("<td>" + rs2.getInt("user_id") + "</td>");
                out.println("<td>" + rs2.getString("username") + "</td>");
                out.println("<td>" + rs2.getString("full_name") + "</td>");
                out.println("<td>" + rs2.getString("email") + "</td>");
                out.println("<td>" + rs2.getString("status") + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            out.println("<p class='info'>Found " + userCount + " users with DOCTOR role</p>");
        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
    
    <h2>4. Check Doctors Table Records</h2>
    <%
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM doctors";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            out.println("<table>");
            out.println("<tr><th>Doctor ID</th><th>User ID</th><th>Specialization</th><th>Department ID</th></tr>");
            
            while (rs.next()) {
                count++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("doctor_id") + "</td>");
                out.println("<td>" + rs.getInt("user_id") + "</td>");
                out.println("<td>" + rs.getString("specialization") + "</td>");
                
                int deptId = rs.getInt("department_id");
                if (rs.wasNull()) {
                    out.println("<td>NULL</td>");
                } else {
                    out.println("<td>" + deptId + "</td>");
                }
                
                out.println("</tr>");
            }
            
            out.println("</table>");
            out.println("<p class='info'>Total records in doctors table: " + count + "</p>");
        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
    
    <h2>5. Testing DoctorDAO.getTotalDoctors()</h2>
    <%
        try {
            DoctorDAO doctorDAO = new DoctorDAO();
            int total = doctorDAO.getTotalDoctors();
            out.println("<p class='info'>Total count from getTotalDoctors(): <strong>" + total + "</strong></p>");
        } catch (Exception e) {
            out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
        }
    %>
    
    <h2>6. Testing DoctorDAO.getAllDoctors()</h2>
    <%
        out.println("<p class='info'>Check console logs for detailed debug output...</p>");
        
        try {
            DoctorDAO doctorDAO = new DoctorDAO();
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            out.println("<p class='info'>Total doctors found from getAllDoctors(): <strong>" + doctors.size() + "</strong></p>");
            
            if (doctors.isEmpty()) {
                out.println("<p class='error'>❌ No doctors found! Check console logs for SQL errors.</p>");
            } else {
                out.println("<p class='success'>✅ Found " + doctors.size() + " doctors</p>");
                out.println("<table>");
                out.println("<tr><th>ID</th><th>User ID</th><th>Full Name</th><th>Email</th><th>Phone</th><th>Specialization</th><th>Department</th><th>Status</th></tr>");
                
                for (Doctor doctor : doctors) {
                    out.println("<tr>");
                    out.println("<td>" + doctor.getDoctorId() + "</td>");
                    out.println("<td>" + doctor.getUserId() + "</td>");
                    out.println("<td>" + doctor.getFullName() + "</td>");
                    out.println("<td>" + doctor.getEmail() + "</td>");
                    out.println("<td>" + doctor.getPhone() + "</td>");
                    out.println("<td>" + doctor.getSpecialization() + "</td>");
                    out.println("<td>" + (doctor.getDepartmentName() != null ? doctor.getDepartmentName() : "N/A") + "</td>");
                    out.println("<td>" + doctor.getStatus() + "</td>");
                    out.println("</tr>");
                }
                
                out.println("</table>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>❌ Error: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        }
    %>
    
    <hr>
    <p><a href="admin/doctors" style="color: blue; text-decoration: underline;">→ Go to Admin Doctors Page</a></p>
    <p><a href="javascript:location.reload()" style="color: green; text-decoration: underline;">🔄 Refresh Page</a></p>
</body>
</html>
