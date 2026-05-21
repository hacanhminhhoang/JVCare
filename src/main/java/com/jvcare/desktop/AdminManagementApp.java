package com.jvcare.desktop;

import com.jvcare.desktop.view.AdminManagementFrame;
import javax.swing.*;

/**
 * Main class cho Desktop Application quản lý Admin
 * Sử dụng kiến trúc 3 Layer:
 * - Presentation Layer: Swing GUI (desktop.view)
 * - Business Layer: Service classes (service)
 * - Data Layer: DAO classes (dao)
 */
public class AdminManagementApp {
    
    public static void main(String[] args) {
        // Set Look and Feel cho Windows
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Chạy GUI trên Event Dispatch Thread
        SwingUtilities.invokeLater(() -> {
            AdminManagementFrame frame = new AdminManagementFrame();
            frame.setVisible(true);
        });
    }
}
