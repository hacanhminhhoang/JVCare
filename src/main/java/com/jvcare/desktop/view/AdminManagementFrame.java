package com.jvcare.desktop.view;

import com.jvcare.dao.UserDAO;
import com.jvcare.model.User;
import com.jvcare.service.UserService;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

/**
 * PRESENTATION LAYER - GUI Frame chính cho quản lý Admin
 * Hiển thị danh sách users và các chức năng CRUD
 */
public class AdminManagementFrame extends JFrame {
    
    // Business Layer
    private UserService userService;
    
    // GUI Components
    private JTable userTable;
    private DefaultTableModel tableModel;
    private JButton btnAdd, btnEdit, btnDelete, btnRefresh;
    private JTextField txtSearch;
    
    public AdminManagementFrame() {
        // Khởi tạo Business Layer
        UserDAO userDAO = new UserDAO();
        this.userService = new UserService(userDAO);
        
        // Cấu hình Frame
        setTitle("JVCare - Quản lý Nhân viên Admin");
        setSize(1000, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        
        // Tạo GUI
        initComponents();
        loadUsers();
    }
    
    private void initComponents() {
        // Main Panel
        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        
        // Header Panel
        JPanel headerPanel = createHeaderPanel();
        mainPanel.add(headerPanel, BorderLayout.NORTH);
        
        // Table Panel
        JPanel tablePanel = createTablePanel();
        mainPanel.add(tablePanel, BorderLayout.CENTER);
        
        // Button Panel
        JPanel buttonPanel = createButtonPanel();
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);
        
        add(mainPanel);
    }
    
    private JPanel createHeaderPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        
        // Title
        JLabel lblTitle = new JLabel("QUẢN LÝ NHÂN VIÊN ADMIN");
        lblTitle.setFont(new Font("Arial", Font.BOLD, 24));
        lblTitle.setForeground(new Color(0, 102, 204));
        panel.add(lblTitle, BorderLayout.NORTH);
        
        // Search Panel
        JPanel searchPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JLabel lblSearch = new JLabel("Tìm kiếm:");
        txtSearch = new JTextField(30);
        JButton btnSearch = new JButton("Tìm");
        btnSearch.addActionListener(e -> searchUsers());
        
        searchPanel.add(lblSearch);
        searchPanel.add(txtSearch);
        searchPanel.add(btnSearch);
        panel.add(searchPanel, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel createTablePanel() {
        JPanel panel = new JPanel(new BorderLayout());
        
        // Table Model
        String[] columns = {"ID", "Username", "Họ tên", "Email", "SĐT", "Role", "Trạng thái"};
        tableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false; // Không cho edit trực tiếp
            }
        };
        
        // Table
        userTable = new JTable(tableModel);
        userTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        userTable.setRowHeight(25);
        userTable.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
        
        // Thêm border cho các cột của table header
        javax.swing.table.TableCellRenderer defaultRenderer = userTable.getTableHeader().getDefaultRenderer();
        userTable.getTableHeader().setDefaultRenderer((table, value, isSelected, hasFocus, row, column) -> {
            JComponent comp = (JComponent) defaultRenderer.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
            comp.setBorder(BorderFactory.createLineBorder(Color.GRAY));
            return comp;
        });
        
        // Scroll Pane
        JScrollPane scrollPane = new JScrollPane(userTable);
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
        
        // Add Action Listeners
        btnAdd.addActionListener(e -> addUser());
        btnEdit.addActionListener(e -> editUser());
        btnDelete.addActionListener(e -> deleteUser());
        btnRefresh.addActionListener(e -> loadUsers());
        
        panel.add(btnAdd);
        panel.add(btnEdit);
        panel.add(btnDelete);
        panel.add(btnRefresh);
        
        return panel;
    }
    
    /**
     * BUSINESS LAYER CALL - Load danh sách users
     */
    private void loadUsers() {
        try {
            List<User> users = userService.getAllUsers(1, 1000); // Load tất cả
            updateTable(users);
        } catch (Exception e) {
            showError("Lỗi khi tải danh sách: " + e.getMessage());
        }
    }
    
    /**
     * BUSINESS LAYER CALL - Tìm kiếm users
     */
    private void searchUsers() {
        String keyword = txtSearch.getText().trim();
        if (keyword.isEmpty()) {
            loadUsers();
            return;
        }
        
        try {
            List<User> users = userService.searchUsers(keyword, 1, 1000);
            updateTable(users);
        } catch (Exception e) {
            showError("Lỗi khi tìm kiếm: " + e.getMessage());
        }
    }
    
    /**
     * Update table với danh sách users
     */
    private void updateTable(List<User> users) {
        tableModel.setRowCount(0); // Clear table
        
        for (User user : users) {
            Object[] row = {
                user.getUserId(),
                user.getUsername(),
                user.getFullName(),
                user.getEmail(),
                user.getPhone(),
                user.getRole(),
                user.getStatus()
            };
            tableModel.addRow(row);
        }
    }
    
    /**
     * PRESENTATION LAYER - Thêm user mới
     */
    private void addUser() {
        UserFormDialog dialog = new UserFormDialog(this, userService, null);
        dialog.setVisible(true);
        
        if (dialog.isSuccess()) {
            loadUsers();
            showSuccess("Thêm nhân viên thành công!");
        }
    }
    
    /**
     * PRESENTATION LAYER - Sửa user
     */
    private void editUser() {
        int selectedRow = userTable.getSelectedRow();
        if (selectedRow == -1) {
            showWarning("Vui lòng chọn nhân viên cần sửa!");
            return;
        }
        
        try {
            int userId = (int) tableModel.getValueAt(selectedRow, 0);
            User user = userService.getUserById(userId);
            
            UserFormDialog dialog = new UserFormDialog(this, userService, user);
            dialog.setVisible(true);
            
            if (dialog.isSuccess()) {
                loadUsers();
                showSuccess("Cập nhật nhân viên thành công!");
            }
        } catch (Exception e) {
            showError("Lỗi khi sửa: " + e.getMessage());
        }
    }
    
    /**
     * BUSINESS LAYER CALL - Xóa user
     */
    private void deleteUser() {
        int selectedRow = userTable.getSelectedRow();
        if (selectedRow == -1) {
            showWarning("Vui lòng chọn nhân viên cần xóa!");
            return;
        }
        
        int userId = (int) tableModel.getValueAt(selectedRow, 0);
        String username = (String) tableModel.getValueAt(selectedRow, 1);
        
        int confirm = JOptionPane.showConfirmDialog(
            this,
            "Bạn có chắc muốn xóa nhân viên: " + username + "?",
            "Xác nhận xóa",
            JOptionPane.YES_NO_OPTION
        );
        
        if (confirm == JOptionPane.YES_OPTION) {
            try {
                userService.deleteUser(userId);
                loadUsers();
                showSuccess("Xóa nhân viên thành công!");
            } catch (Exception e) {
                showError("Lỗi khi xóa: " + e.getMessage());
            }
        }
    }
    
    // Utility methods
    private void showSuccess(String message) {
        JOptionPane.showMessageDialog(this, message, "Thành công", JOptionPane.INFORMATION_MESSAGE);
    }
    
    private void showError(String message) {
        JOptionPane.showMessageDialog(this, message, "Lỗi", JOptionPane.ERROR_MESSAGE);
    }
    
    private void showWarning(String message) {
        JOptionPane.showMessageDialog(this, message, "Cảnh báo", JOptionPane.WARNING_MESSAGE);
    }
}
