package com.jvcare.util;

import io.github.cdimascio.dotenv.Dotenv;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static Dotenv dotenv;
    
    static {
        try {
            // Load .env file from project root (auto-detect)
            // Tự động tìm .env trong thư mục hiện tại
            dotenv = Dotenv.configure()
                           .ignoreIfMissing()
                           .load();
            System.out.println("✓ .env file loaded successfully");
        } catch (Exception e) {
            System.err.println("⚠ Could not load .env file: " + e.getMessage());
            System.err.println("⚠ Proceeding with system environment variables if available.");
            dotenv = null;
        }
    }

    /**
     * Get environment variable from .env file or system environment
     * @param key Environment variable key
     * @param defaultValue Default value if key not found
     * @return Environment variable value
     */
    private static String getEnv(String key, String defaultValue) {
        String value = null;
        
        // Try to get from .env file first
        if (dotenv != null) {
            value = dotenv.get(key);
        }
        
        // Fallback to system environment
        if (value == null) {
            value = System.getenv(key);
        }
        
        // Use default value if still null
        if (value == null) {
            value = defaultValue;
        }
        
        return value;
    }

    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     * @throws ClassNotFoundException if driver not found
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load SQL Server driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
        // Get connection info from .env
        String dbUrl = getEnv("DB_URL", 
            "jdbc:sqlserver://localhost:1433;databaseName=jvcare_db;encrypt=true;trustServerCertificate=true;");
        String dbUser = getEnv("DB_USER", "sa");
        String dbPass = getEnv("DB_PASS", "");
        
        System.out.println("Connecting to: " + dbUrl);
        
        return DriverManager.getConnection(dbUrl, dbUser, dbPass);
    }
    
    /**
     * Test database connection
     * @return true if connection successful, false otherwise
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            boolean isValid = conn != null && !conn.isClosed();
            if (isValid) {
                System.out.println("✓ Database connection test: SUCCESS");
            } else {
                System.out.println("✗ Database connection test: FAILED");
            }
            return isValid;
        } catch (Exception e) {
            System.err.println("✗ Database connection test: FAILED");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Main method for testing connection
     */
    public static void main(String[] args) {
        System.out.println("=== Testing Database Connection ===");
        testConnection();
    }
}
