package com.jvcare.util;

import io.github.cdimascio.dotenv.Dotenv;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static Dotenv dotenv;
    static {
        try {
            // Load .env file from the root directory of the project
            dotenv = Dotenv.configure().ignoreIfMissing().load();
        } catch (Exception e) {
            System.err.println("Could not load .env file. Proceeding with system environment variables if available.");
            dotenv = null;
        }
    }

    private static String getEnv(String key) {
        if (dotenv != null) {
            return dotenv.get(key);
        }
        return System.getenv(key);
    }

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // SQL Server driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
        String dbUrl = getEnv("DB_URL");
        String dbUser = getEnv("DB_USER");
        String dbPass = getEnv("DB_PASS");
        if (dbPass == null || dbPass.isEmpty()) {
            dbPass = getEnv("DB_PASSWORD");
        }
        
        return DriverManager.getConnection(dbUrl, dbUser, dbPass);
    }
}
