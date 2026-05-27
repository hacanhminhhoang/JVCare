package com.jvcare.desktop;

import com.jvcare.dao.DoctorDAO;
import com.jvcare.dao.UserDAO;
import com.jvcare.desktop.view.AdminManagementFrame;
import com.jvcare.model.Doctor;
import com.jvcare.model.User;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;

public class MainDesktopApp {

    private static final UserDAO userDAO = new UserDAO();
    private static final DoctorDAO doctorDAO = new DoctorDAO();

    public static void main(String[] args) {
        // Cài đặt Look and Feel hệ thống
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Hiện dialog đăng nhập
        SwingUtilities.invokeLater(() -> {
            boolean loggedIn = showLoginDialog();
            if (!loggedIn) {
                System.exit(0);
            }
        });
    }

    private static boolean showLoginDialog() {
        JDialog loginDialog = new JDialog((Frame) null, "JVCare Desktop - Đăng nhập", true);
        loginDialog.setSize(380, 260);
        loginDialog.setLocationRelativeTo(null);
        loginDialog.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
        loginDialog.setLayout(new BorderLayout());

        JPanel headerPanel = new JPanel();
        headerPanel.setBackground(new Color(43, 108, 176));
        headerPanel.setPreferredSize(new Dimension(380, 60));
        headerPanel.setLayout(new GridBagLayout());
        JLabel lblTitle = new JLabel("JVCARE PORTAL - ĐĂNG NHẬP");
        lblTitle.setFont(new Font("Sora", Font.BOLD, 16));
        lblTitle.setForeground(Color.WHITE);
        headerPanel.add(lblTitle);

        JPanel centerPanel = new JPanel(new GridBagLayout());
        centerPanel.setBorder(new EmptyBorder(15, 20, 15, 20));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(8, 8, 8, 8);

        // Email
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.weightx = 0.3;
        centerPanel.add(new JLabel("Email đăng nhập:"), gbc);
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        JTextField txtEmail = new JTextField(20);
        centerPanel.add(txtEmail, gbc);

        // Password
        gbc.gridx = 0;
        gbc.gridy = 1;
        gbc.weightx = 0.3;
        centerPanel.add(new JLabel("Mật khẩu:"), gbc);
        gbc.gridx = 1;
        gbc.weightx = 0.7;
        JPasswordField txtPassword = new JPasswordField(20);
        centerPanel.add(txtPassword, gbc);

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 5));
        JButton btnLogin = new JButton("Đăng nhập");
        btnLogin.setPreferredSize(new Dimension(100, 30));
        JButton btnCancel = new JButton("Thoát");
        btnCancel.setPreferredSize(new Dimension(80, 30));
        buttonPanel.add(btnLogin);
        buttonPanel.add(btnCancel);

        loginDialog.add(headerPanel, BorderLayout.NORTH);
        loginDialog.add(centerPanel, BorderLayout.CENTER);
        loginDialog.add(buttonPanel, BorderLayout.SOUTH);

        final boolean[] loginSuccess = { false };

        btnLogin.addActionListener((ActionEvent e) -> {
            String email = txtEmail.getText().trim();
            String password = new String(txtPassword.getPassword());

            if (email.isEmpty() || password.isEmpty()) {
                JOptionPane.showMessageDialog(loginDialog, "Vui lòng nhập đầy đủ email và mật khẩu", "Cảnh báo",
                        JOptionPane.WARNING_MESSAGE);
                return;
            }

            // Gọi UserDAO xác thực
            User user = userDAO.authenticate(email, password);
            if (user == null) {
                JOptionPane.showMessageDialog(loginDialog, "Tài khoản hoặc mật khẩu không chính xác!", "Lỗi",
                        JOptionPane.ERROR_MESSAGE);
                return;
            }

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                loginSuccess[0] = true;
                loginDialog.dispose();
                launchAdminApp();
            } else if ("DOCTOR".equalsIgnoreCase(user.getRole())) {
                Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
                if (doctor == null) {
                    JOptionPane.showMessageDialog(loginDialog,
                            "Không tìm thấy thông tin Bác sĩ ứng với tài khoản này trong hệ thống!", "Lỗi",
                            JOptionPane.ERROR_MESSAGE);
                    return;
                }
                loginSuccess[0] = true;
                loginDialog.dispose();
                launchDoctorApp(user, doctor.getDoctorId());
            } else {
                JOptionPane.showMessageDialog(loginDialog, "Phiên bản Desktop chỉ hỗ trợ Admin và Bác sĩ!",
                        "Lỗi quyền truy cập", JOptionPane.ERROR_MESSAGE);
            }
        });

        btnCancel.addActionListener(e -> loginDialog.dispose());

        // Cho phép nhấn Enter để đăng nhập
        loginDialog.getRootPane().setDefaultButton(btnLogin);

        loginDialog.setVisible(true);
        return loginSuccess[0];
    }

    private static void launchAdminApp() {
        AdminManagementFrame frame = new AdminManagementFrame();
        frame.setVisible(true);
    }

    private static void launchDoctorApp(User user, int doctorId) {
        DoctorWinFormApp app = new DoctorWinFormApp(user, doctorId);
        app.setVisible(true);
    }
}
