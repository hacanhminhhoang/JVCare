package com.jvcare.desktop.view;

import com.jvcare.model.User;
import com.jvcare.service.UserService;

import javax.swing.*;
import java.awt.*;

/**
 * PRESENTATION LAYER - Dialog form để thêm/sửa User
 */
public class UserFormDialog extends JDialog {
    
    private UserService userService;
    private User user; // null nếu thêm mới
    private boolean success = false;
    
    // Form fields
    private JTextField txtUsername;
    private JPasswordField txtPassword;
    private JTextField txtFullName;
    private JTextField txtEmail;
    private JTextField txtPhone;
    private JComboBox<String> cboRole;
    private JComboBox<String> cboStatus;
    
    private JButton btnSave, btnCancel;
    
    public UserFormDialog(Frame parent, UserService userService, User user) {
        super(parent, user == null ? "Thêm nhân viên mới" : "Sửa thông tin nhân viên", true);
        this.userService = userService;
        this.user = user;
        
        setSize(500, 450);
        setLocationRelativeTo(parent);
        setResizable(false);
        
        initComponents();
        
        if (user != null) {
            fillData();
        }
    }
    
    private void initComponents() {
        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        
        // Form Panel
        JPanel formPanel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(5, 5, 5, 5);
        
        // Username
        gbc.gridx = 0; gbc.gridy = 0;
        formPanel.add(new JLabel("Username:"), gbc);
        gbc.gridx = 1;
        txtUsername = new JTextField(20);
        txtUsername.setEnabled(user == null); // Chỉ cho nhập khi thêm mới
        formPanel.add(txtUsername, gbc);
        
        // Password
        gbc.gridx = 0; gbc.gridy = 1;
        formPanel.add(new JLabel("Password:"), gbc);
        gbc.gridx = 1;
        txtPassword = new JPasswordField(20);
        formPanel.add(txtPassword, gbc);
        
        if (user != null) {
            gbc.gridx = 1; gbc.gridy = 2;
            JLabel lblNote = new JLabel("(Để trống nếu không đổi mật khẩu)");
            lblNote.setFont(new Font("Arial", Font.ITALIC, 10));
            lblNote.setForeground(Color.GRAY);
            formPanel.add(lblNote, gbc);
        }
        
        // Full Name
        gbc.gridx = 0; gbc.gridy = 3;
        formPanel.add(new JLabel("Họ tên:"), gbc);
        gbc.gridx = 1;
        txtFullName = new JTextField(20);
        formPanel.add(txtFullName, gbc);
        
        // Email
        gbc.gridx = 0; gbc.gridy = 4;
        formPanel.add(new JLabel("Email:"), gbc);
        gbc.gridx = 1;
        txtEmail = new JTextField(20);
        formPanel.add(txtEmail, gbc);
        
        // Phone
        gbc.gridx = 0; gbc.gridy = 5;
        formPanel.add(new JLabel("Số điện thoại:"), gbc);
        gbc.gridx = 1;
        txtPhone = new JTextField(20);
        formPanel.add(txtPhone, gbc);
        
        // Role
        gbc.gridx = 0; gbc.gridy = 6;
        formPanel.add(new JLabel("Vai trò:"), gbc);
        gbc.gridx = 1;
        cboRole = new JComboBox<>(new String[]{"ADMIN", "RECEPTIONIST"});
        formPanel.add(cboRole, gbc);
        
        // Status
        gbc.gridx = 0; gbc.gridy = 7;
        formPanel.add(new JLabel("Trạng thái:"), gbc);
        gbc.gridx = 1;
        cboStatus = new JComboBox<>(new String[]{"ACTIVE", "INACTIVE"});
        formPanel.add(cboStatus, gbc);
        
        mainPanel.add(formPanel, BorderLayout.CENTER);
        
        // Button Panel
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 10));
        
        btnSave = new JButton("Lưu");
        btnCancel = new JButton("Hủy");
        
        btnSave.setPreferredSize(new Dimension(100, 35));
        btnCancel.setPreferredSize(new Dimension(100, 35));
        
        btnSave.setBackground(new Color(0, 102, 204));
        btnSave.setForeground(Color.WHITE);
        btnSave.setFocusPainted(false);
        
        btnCancel.setBackground(new Color(108, 117, 125));
        btnCancel.setForeground(Color.WHITE);
        btnCancel.setFocusPainted(false);
        
        btnSave.addActionListener(e -> saveUser());
        btnCancel.addActionListener(e -> dispose());
        
        buttonPanel.add(btnSave);
        buttonPanel.add(btnCancel);
        
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);
        
        add(mainPanel);
    }
    
    private void fillData() {
        txtUsername.setText(user.getUsername());
        txtFullName.setText(user.getFullName());
        txtEmail.setText(user.getEmail());
        txtPhone.setText(user.getPhone());
        cboRole.setSelectedItem(user.getRole());
        cboStatus.setSelectedItem(user.getStatus());
    }
    
    /**
     * BUSINESS LAYER CALL - Lưu user (thêm mới hoặc cập nhật)
     */
    private void saveUser() {
        // Validate
        if (!validateInput()) {
            return;
        }
        
        try {
            if (user == null) {
                // Thêm mới
                User newUser = new User();
                newUser.setUsername(txtUsername.getText().trim());
                newUser.setPassword(new String(txtPassword.getPassword()));
                newUser.setFullName(txtFullName.getText().trim());
                newUser.setEmail(txtEmail.getText().trim());
                newUser.setPhone(txtPhone.getText().trim());
                newUser.setRole((String) cboRole.getSelectedItem());
                newUser.setStatus((String) cboStatus.getSelectedItem());
                
                userService.createUser(newUser);
            } else {
                // Cập nhật
                user.setFullName(txtFullName.getText().trim());
                user.setEmail(txtEmail.getText().trim());
                user.setPhone(txtPhone.getText().trim());
                user.setRole((String) cboRole.getSelectedItem());
                user.setStatus((String) cboStatus.getSelectedItem());
                
                String newPassword = new String(txtPassword.getPassword()).trim();
                if (!newPassword.isEmpty()) {
                    user.setPassword(newPassword);
                }
                
                userService.updateUser(user);
            }
            
            success = true;
            dispose();
            
        } catch (Exception e) {
            JOptionPane.showMessageDialog(
                this,
                "Lỗi: " + e.getMessage(),
                "Lỗi",
                JOptionPane.ERROR_MESSAGE
            );
        }
    }
    
    private boolean validateInput() {
        if (user == null && txtUsername.getText().trim().isEmpty()) {
            showError("Username không được để trống!");
            return false;
        }
        
        if (user == null && new String(txtPassword.getPassword()).trim().isEmpty()) {
            showError("Password không được để trống!");
            return false;
        }
        
        if (txtFullName.getText().trim().isEmpty()) {
            showError("Họ tên không được để trống!");
            return false;
        }
        
        if (txtEmail.getText().trim().isEmpty()) {
            showError("Email không được để trống!");
            return false;
        }
        
        return true;
    }
    
    private void showError(String message) {
        JOptionPane.showMessageDialog(this, message, "Lỗi", JOptionPane.ERROR_MESSAGE);
    }
    
    public boolean isSuccess() {
        return success;
    }
}
