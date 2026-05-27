package com.jvcare.desktop.view;

import com.jvcare.dao.PatientDAO;
import com.jvcare.model.Patient;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class PatientManagementPanel extends JPanel {
    
    private JFrame parentFrame;
    private PatientDAO patientDAO;
    
    // GUI Components
    private JTable patientTable;
    private DefaultTableModel tableModel;
    private JButton btnRefresh;
    private JTextField txtSearch;
    
    public PatientManagementPanel(JFrame parentFrame) {
        this.parentFrame = parentFrame;
        this.patientDAO = new PatientDAO();
        
        // Cấu hình Panel
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        
        initComponents();
        loadPatients();
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
        JLabel lblTitle = new JLabel("QUẢN LÝ BỆNH NHÂN");
        lblTitle.setFont(new Font("Arial", Font.BOLD, 24));
        lblTitle.setForeground(new Color(0, 102, 204));
        panel.add(lblTitle, BorderLayout.NORTH);
        
        // Search Panel
        JPanel searchPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JLabel lblSearch = new JLabel("Tìm kiếm:");
        txtSearch = new JTextField(30);
        JButton btnSearch = new JButton("Tìm");
        btnSearch.addActionListener(e -> searchPatients());
        
        searchPanel.add(lblSearch);
        searchPanel.add(txtSearch);
        searchPanel.add(btnSearch);
        panel.add(searchPanel, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel createTablePanel() {
        JPanel panel = new JPanel(new BorderLayout());
        
        // Table Model
        String[] columns = {"ID", "Mã BN", "Họ tên", "Ngày sinh", "Giới tính", "SĐT", "Email"};
        tableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false; // Không cho edit trực tiếp
            }
        };
        
        // Table
        patientTable = new JTable(tableModel);
        patientTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        patientTable.setRowHeight(25);
        patientTable.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
        
        // Thêm border cho các cột của table header
        javax.swing.table.TableCellRenderer defaultRenderer = patientTable.getTableHeader().getDefaultRenderer();
        patientTable.getTableHeader().setDefaultRenderer((table, value, isSelected, hasFocus, row, column) -> {
            JComponent comp = (JComponent) defaultRenderer.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
            comp.setBorder(BorderFactory.createLineBorder(Color.GRAY));
            return comp;
        });
        
        // Scroll Pane
        JScrollPane scrollPane = new JScrollPane(patientTable);
        panel.add(scrollPane, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel createButtonPanel() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 10));
        
        btnRefresh = new JButton("Làm mới");
        
        // Style buttons
        Color btnColor = new Color(0, 102, 204);
        Font btnFont = new Font("Arial", Font.BOLD, 12);
        
        btnRefresh.setFont(btnFont);
        btnRefresh.setBackground(btnColor);
        btnRefresh.setForeground(Color.BLACK);
        btnRefresh.setFocusPainted(false);
        btnRefresh.setPreferredSize(new Dimension(120, 35));
        
        btnRefresh.addActionListener(e -> loadPatients());
        
        panel.add(btnRefresh);
        
        return panel;
    }
    
    private void loadPatients() {
        try {
            List<Patient> patients = patientDAO.getAllPatients();
            updateTable(patients);
        } catch (Exception e) {
            showError("Lỗi khi tải danh sách: " + e.getMessage());
        }
    }
    
    private void searchPatients() {
        String keyword = txtSearch.getText().trim();
        if (keyword.isEmpty()) {
            loadPatients();
            return;
        }
        
        try {
            List<Patient> patients = patientDAO.searchPatients(keyword);
            updateTable(patients);
        } catch (Exception e) {
            showError("Lỗi khi tìm kiếm: " + e.getMessage());
        }
    }
    
    private void updateTable(List<Patient> patients) {
        tableModel.setRowCount(0); // Clear table
        
        for (Patient patient : patients) {
            Object[] row = {
                patient.getPatientId(),
                patient.getPatientCode(),
                patient.getFullName(),
                patient.getDateOfBirth() != null ? patient.getDateOfBirth().toString() : "",
                patient.getGender(),
                patient.getPhone(),
                patient.getEmail()
            };
            tableModel.addRow(row);
        }
    }
    
    // Utility methods
    private void showError(String message) {
        JOptionPane.showMessageDialog(this, message, "Lỗi", JOptionPane.ERROR_MESSAGE);
    }
}
