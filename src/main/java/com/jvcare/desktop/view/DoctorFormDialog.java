package com.jvcare.desktop.view;

import com.jvcare.dto.DoctorDTO;
import com.jvcare.model.Doctor;
import com.jvcare.service.DoctorService;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

public class DoctorFormDialog extends JDialog {
    
    private DoctorService doctorService;
    private DoctorDTO currentDoctor;
    private boolean success = false;
    
    // GUI Components
    private JTextField txtFullName, txtEmail, txtPhone, txtSpecialization;
    private JPasswordField txtPassword;
    private JComboBox<String> cboStatus;
    private JButton btnSave, btnCancel;
    
    public DoctorFormDialog(JFrame parent, DoctorService doctorService, DoctorDTO doctor) {
        super(parent, doctor == null ? "Thêm Bác sĩ mới" : "Sửa thông tin Bác sĩ", true);
        this.doctorService = doctorService;
        this.currentDoctor = doctor;
        
        initComponents();
        if (doctor != null) {
            loadDoctorData();
        }
    }
    
    private void initComponents() {
        setSize(450, 400);
        setLocationRelativeTo(getParent());
        setLayout(new BorderLayout(10, 10));
        
        // Form Panel
        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(new EmptyBorder(20, 20, 20, 20));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(8, 8, 8, 8);
        
        int row = 0;
        
        // Họ tên
        gbc.gridx = 0; gbc.gridy = row; gbc.weightx = 0.3;
        formPanel.add(new JLabel("Họ tên (*):"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        txtFullName = new JTextField(20);
        formPanel.add(txtFullName, gbc);
        row++;
        
        // Email (Username)
        gbc.gridx = 0; gbc.gridy = row; gbc.weightx = 0.3;
        formPanel.add(new JLabel("Email (*):"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        txtEmail = new JTextField(20);
        txtEmail.setEnabled(currentDoctor == null); // Không cho sửa email nếu đang edit
        formPanel.add(txtEmail, gbc);
        row++;
        
        // Mật khẩu
        gbc.gridx = 0; gbc.gridy = row; gbc.weightx = 0.3;
        formPanel.add(new JLabel(currentDoctor == null ? "Mật khẩu (*):" : "Mật khẩu mới:"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        txtPassword = new JPasswordField(20);
        formPanel.add(txtPassword, gbc);
        row++;
        
        // SĐT
        gbc.gridx = 0; gbc.gridy = row; gbc.weightx = 0.3;
        formPanel.add(new JLabel("Số điện thoại:"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        txtPhone = new JTextField(20);
        formPanel.add(txtPhone, gbc);
        row++;
        
        // Chuyên khoa
        gbc.gridx = 0; gbc.gridy = row; gbc.weightx = 0.3;
        formPanel.add(new JLabel("Chuyên khoa:"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        txtSpecialization = new JTextField(20);
        formPanel.add(txtSpecialization, gbc);
        row++;
        
        // Status
        gbc.gridx = 0; gbc.gridy = row; gbc.weightx = 0.3;
        formPanel.add(new JLabel("Trạng thái:"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        cboStatus = new JComboBox<>(new String[]{"ACTIVE", "INACTIVE"});
        formPanel.add(cboStatus, gbc);
        row++;
        
        add(formPanel, BorderLayout.CENTER);
        
        // Button Panel
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 10));
        btnSave = new JButton("Lưu");
        btnCancel = new JButton("Hủy");
        
        btnSave.setBackground(new Color(0, 102, 204));
        btnSave.setForeground(Color.WHITE);
        btnSave.setFocusPainted(false);
        
        btnSave.addActionListener(e -> saveDoctor());
        btnCancel.addActionListener(e -> dispose());
        
        buttonPanel.add(btnSave);
        buttonPanel.add(btnCancel);
        add(buttonPanel, BorderLayout.SOUTH);
        
        getRootPane().setDefaultButton(btnSave);
    }
    
    private void loadDoctorData() {
        txtFullName.setText(currentDoctor.getFullName());
        txtEmail.setText(currentDoctor.getEmail());
        txtPhone.setText(currentDoctor.getPhone());
        txtSpecialization.setText(currentDoctor.getSpecialization());
        cboStatus.setSelectedItem(currentDoctor.getStatus());
    }
    
    private void saveDoctor() {
        try {
            String fullName = txtFullName.getText().trim();
            String email = txtEmail.getText().trim();
            String phone = txtPhone.getText().trim();
            String specialization = txtSpecialization.getText().trim();
            String password = new String(txtPassword.getPassword()).trim();
            String status = (String) cboStatus.getSelectedItem();
            
            if (fullName.isEmpty() || email.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Vui lòng nhập đầy đủ thông tin bắt buộc!", "Lỗi", JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            Doctor doctor = new Doctor();
            doctor.setFullName(fullName);
            doctor.setEmail(email);
            doctor.setPhone(phone);
            doctor.setSpecialization(specialization);
            doctor.setStatus(status);
            
            if (currentDoctor == null) {
                // Thêm mới
                if (password.isEmpty()) {
                    JOptionPane.showMessageDialog(this, "Vui lòng nhập mật khẩu cho tài khoản mới!", "Lỗi", JOptionPane.ERROR_MESSAGE);
                    return;
                }
                doctorService.addDoctor(doctor, password);
            } else {
                // Sửa
                doctor.setDoctorId(currentDoctor.getDoctorId());
                doctor.setUserId(currentDoctor.getUserId());
                doctorService.updateDoctor(doctor, password.isEmpty() ? null : password);
            }
            
            success = true;
            dispose();
            
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Lỗi: " + e.getMessage(), "Lỗi", JOptionPane.ERROR_MESSAGE);
        }
    }
    
    public boolean isSuccess() {
        return success;
    }
}
