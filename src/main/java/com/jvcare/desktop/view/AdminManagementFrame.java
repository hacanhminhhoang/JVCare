package com.jvcare.desktop.view;

import com.jvcare.desktop.MainDesktopApp;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

/**
 * PRESENTATION LAYER - GUI Frame chính cho quản lý Admin
 * Hiển thị thanh sidebar và các view quản lý khác nhau
 */
public class AdminManagementFrame extends JFrame {
    
    // Panels
    private JPanel mainContentPanel;
    private CardLayout cardLayout;
    
    // View Panels
    private EmployeeManagementPanel employeePanel;
    private DoctorManagementPanel doctorPanel;
    private PatientManagementPanel patientPanel;
    
    public AdminManagementFrame() {
        // Cấu hình Frame
        setTitle("JVCare - Bảng điều khiển Admin");
        setSize(1200, 750);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());
        
        // Màu sắc giao diện
        Color sidebarBg = new Color(26, 32, 44);
        Color primaryColor = new Color(43, 108, 176);
        
        // Khởi tạo các View Panels
        employeePanel = new EmployeeManagementPanel(this);
        doctorPanel = new DoctorManagementPanel(this);
        patientPanel = new PatientManagementPanel(this);
        
        // Khởi tạo CardLayout cho phần nội dung chính
        cardLayout = new CardLayout();
        mainContentPanel = new JPanel(cardLayout);
        mainContentPanel.setBorder(new EmptyBorder(10, 15, 10, 15));
        
        mainContentPanel.add(employeePanel, "EMPLOYEES");
        mainContentPanel.add(doctorPanel, "DOCTORS");
        mainContentPanel.add(patientPanel, "PATIENTS");
        
        // ==================== SIDEBAR TRÁI ====================
        JPanel sidebarPanel = new JPanel();
        sidebarPanel.setBackground(sidebarBg);
        sidebarPanel.setPreferredSize(new Dimension(240, 750));
        sidebarPanel.setLayout(new BorderLayout());

        JPanel brandPanel = new JPanel(new GridBagLayout());
        brandPanel.setBackground(sidebarBg);
        brandPanel.setPreferredSize(new Dimension(240, 80));
        JLabel lblLogo = new JLabel("JVCare Admin");
        lblLogo.setFont(new Font("Sora", Font.BOLD, 20));
        lblLogo.setForeground(Color.WHITE);
        brandPanel.add(lblLogo);

        JPanel menuPanel = new JPanel(new GridLayout(6, 1, 0, 5));
        menuPanel.setBackground(sidebarBg);
        menuPanel.setBorder(new EmptyBorder(20, 10, 20, 10));

        // Nút Quản lý Nhân viên
        JButton btnMenuEmployees = createSidebarButton("Quản lý Nhân viên", primaryColor, true);
        
        // Nút Quản lý Bác sĩ
        JButton btnMenuDoctors = createSidebarButton("Quản lý Bác sĩ", sidebarBg, false);
        
        // Nút Quản lý Bệnh nhân
        JButton btnMenuPatients = createSidebarButton("Quản lý Bệnh nhân", sidebarBg, false);

        // Nút Đăng xuất
        JButton btnLogout = createSidebarButton("Đăng xuất", sidebarBg, false);

        // Thêm vào menu
        menuPanel.add(btnMenuEmployees);
        menuPanel.add(btnMenuDoctors);
        menuPanel.add(btnMenuPatients);
        menuPanel.add(btnLogout);

        sidebarPanel.add(brandPanel, BorderLayout.NORTH);
        sidebarPanel.add(menuPanel, BorderLayout.CENTER);

        // ==================== XỬ LÝ SỰ KIỆN MENU ====================
        
        btnMenuEmployees.addActionListener(e -> {
            setActiveButton(btnMenuEmployees, btnMenuDoctors, btnMenuPatients, primaryColor, sidebarBg);
            cardLayout.show(mainContentPanel, "EMPLOYEES");
        });
        
        btnMenuDoctors.addActionListener(e -> {
            setActiveButton(btnMenuDoctors, btnMenuEmployees, btnMenuPatients, primaryColor, sidebarBg);
            cardLayout.show(mainContentPanel, "DOCTORS");
        });
        
        btnMenuPatients.addActionListener(e -> {
            setActiveButton(btnMenuPatients, btnMenuEmployees, btnMenuDoctors, primaryColor, sidebarBg);
            cardLayout.show(mainContentPanel, "PATIENTS");
        });

        btnLogout.addActionListener(e -> {
            dispose();
            MainDesktopApp.main(null);
        });

        // Thêm vào Frame
        add(sidebarPanel, BorderLayout.WEST);
        add(mainContentPanel, BorderLayout.CENTER);
        
        // Hiển thị tab đầu tiên mặc định
        cardLayout.show(mainContentPanel, "EMPLOYEES");
    }
    
    private JButton createSidebarButton(String text, Color bg, boolean isActive) {
        JButton btn = new JButton(text);
        btn.setFont(new Font("Segoe UI", isActive ? Font.BOLD : Font.PLAIN, 14));
        btn.setForeground(Color.WHITE);
        btn.setBackground(bg);
        btn.setBorderPainted(false);
        btn.setFocusPainted(false);
        btn.setHorizontalAlignment(SwingConstants.LEFT);
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        return btn;
    }
    
    private void setActiveButton(JButton activeBtn, JButton otherBtn1, JButton otherBtn2, Color activeColor, Color defaultColor) {
        activeBtn.setBackground(activeColor);
        activeBtn.setFont(new Font("Segoe UI", Font.BOLD, 14));
        
        otherBtn1.setBackground(defaultColor);
        otherBtn1.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        
        otherBtn2.setBackground(defaultColor);
        otherBtn2.setFont(new Font("Segoe UI", Font.PLAIN, 14));
    }
}
