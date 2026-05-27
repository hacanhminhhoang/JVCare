package com.jvcare.desktop.view;

import com.jvcare.dao.DoctorDAO;
import com.jvcare.model.Doctor;

import com.jvcare.service.DoctorService;
import com.jvcare.dto.DoctorDTO;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class DoctorManagementPanel extends JPanel {
    
    private JFrame parentFrame;
    private DoctorDAO doctorDAO;
    private DoctorService doctorService;
    
    // GUI Components
    private JTable doctorTable;
    private DefaultTableModel tableModel;
    private JButton btnAdd, btnEdit, btnDelete, btnRefresh;
    private JTextField txtSearch;
    
    public DoctorManagementPanel(JFrame parentFrame) {
        this.parentFrame = parentFrame;
        this.doctorDAO = new DoctorDAO();
        this.doctorService = new DoctorService();
        
        // Cấu hình Panel
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        
        initComponents();
        loadDoctors();
    }
    
    private void initComponents() {
        // Header Panel
        JPanel headerPanel = createHeaderPanel();
        add(headerPanel, BorderLayout.NORTH);
        
        // Table Panel
        JPanel tablePanel = createTablePanel();
        add(tablePanel, BorderLayout.CENTER);
        
        // Button Panel
        JPanel buttonPanel = createButtonPanel();
        add(buttonPanel, BorderLayout.SOUTH);
    }
    
    private JPanel createHeaderPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        
        // Title
        JLabel lblTitle = new JLabel("QUẢN LÝ BÁC SĨ");
        lblTitle.setFont(new Font("Arial", Font.BOLD, 24));
        lblTitle.setForeground(new Color(0, 102, 204));
        panel.add(lblTitle, BorderLayout.NORTH);
        
        // Search Panel
        JPanel searchPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JLabel lblSearch = new JLabel("Tìm kiếm:");
        txtSearch = new JTextField(30);
        JButton btnSearch = new JButton("Tìm");
        btnSearch.addActionListener(e -> searchDoctors());
        
        searchPanel.add(lblSearch);
        searchPanel.add(txtSearch);
        searchPanel.add(btnSearch);
        panel.add(searchPanel, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel createTablePanel() {
        JPanel panel = new JPanel(new BorderLayout());
        
        // Table Model
        String[] columns = {"ID", "User ID", "Họ tên", "Email", "SĐT", "Chuyên khoa", "Phòng ban", "Trạng thái"};
        tableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false; // Không cho edit trực tiếp
            }
        };
        
        // Table
        doctorTable = new JTable(tableModel);
        doctorTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        doctorTable.setRowHeight(25);
        doctorTable.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
        
        // Thêm border cho các cột của table header
        javax.swing.table.TableCellRenderer defaultRenderer = doctorTable.getTableHeader().getDefaultRenderer();
        doctorTable.getTableHeader().setDefaultRenderer((table, value, isSelected, hasFocus, row, column) -> {
            JComponent comp = (JComponent) defaultRenderer.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
            comp.setBorder(BorderFactory.createLineBorder(Color.GRAY));
            return comp;
        });
        
        // Scroll Pane
        JScrollPane scrollPane = new JScrollPane(doctorTable);
        panel.add(scrollPane, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel createButtonPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 10));
        
        btnAdd = new JButton("Thêm mới");
        btnEdit = new JButton("Sửa");
        btnDelete = new JButton("Xóa");
        btnRefresh = new JButton("Làm mới");
        
        // Style buttons
        Color btnColor = new Color(0, 102, 204);
        Font btnFont = new Font("Arial", Font.BOLD, 12);
        
        for (JButton btn : new JButton[]{btnAdd, btnEdit, btnDelete, btnRefresh}) {
            btn.setFont(btnFont);
            btn.setBackground(btnColor);
            btn.setForeground(Color.BLACK);
            btn.setFocusPainted(false);
            btn.setPreferredSize(new Dimension(120, 35));
        }
        
        btnDelete.setBackground(new Color(220, 53, 69));
        
        btnAdd.addActionListener(e -> addDoctor());
        btnEdit.addActionListener(e -> editDoctor());
        btnDelete.addActionListener(e -> deleteDoctor());
        btnRefresh.addActionListener(e -> loadDoctors());
        
        panel.add(btnAdd);
        panel.add(btnEdit);
        panel.add(btnDelete);
        panel.add(btnRefresh);
        
        return panel;
    }
    
    private void loadDoctors() {
        try {
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            updateTable(doctors);
        } catch (Exception e) {
            showError("Lỗi khi tải danh sách: " + e.getMessage());
        }
    }
    
    private void searchDoctors() {
        String keyword = txtSearch.getText().trim();
        if (keyword.isEmpty()) {
            loadDoctors();
            return;
        }
        
        try {
            List<Doctor> doctors = doctorDAO.searchDoctors(keyword);
            updateTable(doctors);
        } catch (Exception e) {
            showError("Lỗi khi tìm kiếm: " + e.getMessage());
        }
    }
    
    private void updateTable(List<Doctor> doctors) {
        tableModel.setRowCount(0); // Clear table
        
        for (Doctor doctor : doctors) {
            Object[] row = {
                doctor.getDoctorId(),
                doctor.getUserId(),
                doctor.getFullName(),
                doctor.getEmail(),
                doctor.getPhone(),
                doctor.getSpecialization(),
                doctor.getDepartmentName() != null ? doctor.getDepartmentName() : "N/A",
                doctor.getStatus()
            };
            tableModel.addRow(row);
        }
    }
    
    private void addDoctor() {
        DoctorFormDialog dialog = new DoctorFormDialog(parentFrame, doctorService, null);
        dialog.setVisible(true);
        
        if (dialog.isSuccess()) {
            loadDoctors();
            JOptionPane.showMessageDialog(this, "Thêm Bác sĩ thành công!", "Thành công", JOptionPane.INFORMATION_MESSAGE);
        }
    }
    
    private void editDoctor() {
        int selectedRow = doctorTable.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn Bác sĩ cần sửa!", "Cảnh báo", JOptionPane.WARNING_MESSAGE);
            return;
        }
        
        try {
            int doctorId = (int) tableModel.getValueAt(selectedRow, 0);
            // Lấy thông tin chi tiết qua DAO (vì service trả về DTO)
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            if (doctor == null) {
                showError("Không tìm thấy thông tin bác sĩ!");
                return;
            }
            
            // Convert to DTO
            DoctorDTO dto = new DoctorDTO();
            dto.setDoctorId(doctor.getDoctorId());
            dto.setUserId(doctor.getUserId());
            dto.setFullName(doctor.getFullName());
            dto.setEmail(doctor.getEmail());
            dto.setPhone(doctor.getPhone());
            dto.setSpecialization(doctor.getSpecialization());
            dto.setStatus(doctor.getStatus());
            
            DoctorFormDialog dialog = new DoctorFormDialog(parentFrame, doctorService, dto);
            dialog.setVisible(true);
            
            if (dialog.isSuccess()) {
                loadDoctors();
                JOptionPane.showMessageDialog(this, "Cập nhật thông tin thành công!", "Thành công", JOptionPane.INFORMATION_MESSAGE);
            }
        } catch (Exception e) {
            showError("Lỗi khi sửa: " + e.getMessage());
        }
    }
    
    private void deleteDoctor() {
        int selectedRow = doctorTable.getSelectedRow();
        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(this, "Vui lòng chọn Bác sĩ cần xóa!", "Cảnh báo", JOptionPane.WARNING_MESSAGE);
            return;
        }
        
        int doctorId = (int) tableModel.getValueAt(selectedRow, 0);
        int userId = (int) tableModel.getValueAt(selectedRow, 1);
        String name = (String) tableModel.getValueAt(selectedRow, 2);
        
        int confirm = JOptionPane.showConfirmDialog(
            this,
            "Bạn có chắc muốn xóa Bác sĩ: " + name + "?",
            "Xác nhận xóa",
            JOptionPane.YES_NO_OPTION
        );
        
        if (confirm == JOptionPane.YES_OPTION) {
            try {
                doctorService.deleteDoctor(doctorId, userId);
                loadDoctors();
                JOptionPane.showMessageDialog(this, "Xóa Bác sĩ thành công!", "Thành công", JOptionPane.INFORMATION_MESSAGE);
            } catch (Exception e) {
                showError("Lỗi khi xóa: " + e.getMessage());
            }
        }
    }
    
    // Utility methods
    private void showError(String message) {
        JOptionPane.showMessageDialog(this, message, "Lỗi", JOptionPane.ERROR_MESSAGE);
    }
}
