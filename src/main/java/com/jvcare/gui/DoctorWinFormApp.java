package com.jvcare.gui;

import com.jvcare.dao.UserDAO;
import com.jvcare.dto.MedicalRecordDTO;
import com.jvcare.dto.PrescriptionDTO;
import com.jvcare.exception.BusinessException;
import com.jvcare.exception.ValidationException;
import com.jvcare.model.Appointment;
import com.jvcare.model.User;
import com.jvcare.service.MedicalRecordService;
import com.jvcare.service.PrescriptionService;
import com.jvcare.util.DBConnection;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.border.TitledBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableRowSorter;
import java.awt.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Ứng dụng Desktop Bác sĩ (WinForm Style) chạy trên kiến trúc 3 lớp của JVCare.
 * Kết nối trực tiếp đến Service Layer (MedicalRecordService & PrescriptionService) để
 * xử lý nghiệp vụ, kiểm tra ràng buộc (Validation) và quản lý cơ sở dữ liệu.
 */
public class DoctorWinFormApp extends JFrame {

    private final MedicalRecordService recordService = new MedicalRecordService();
    private final PrescriptionService prescriptionService = new PrescriptionService();
    private final UserDAO userDAO = new UserDAO();

    private User currentDoctorUser;
    private int currentDoctorId = -1;
    private List<MedicalRecordDTO> allRecords = new ArrayList<>();
    private MedicalRecordDTO selectedRecord = null;

    // Component giao diện chính
    private DefaultTableModel recordTableModel;
    private JTable recordTable;
    private TableRowSorter<DefaultTableModel> rowSorter;
    private JTextField txtSearch;

    // Panel chi tiết bệnh án
    private JLabel lblPatientName;
    private JLabel lblPatientCode;
    private JLabel lblVisitDate;
    private JLabel lblBP;
    private JLabel lblHeartRate;
    private JLabel lblTemp;
    private JLabel lblWeight;
    private JLabel lblHeight;
    private JLabel lblBMI;
    private JTextArea txtDiagnosis;
    private JTextArea txtTreatmentPlan;
    private JTextArea txtNotes;

    // Bảng đơn thuốc
    private DefaultTableModel prescriptionTableModel;
    private JTable prescriptionTable;
    private JButton btnAddPrescription;
    private JButton btnDeletePrescription;
    private JButton btnPrintPrescription;

    public DoctorWinFormApp() {
        // Thiết lập Look & Feel hệ thống
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Hiện hộp thoại đăng nhập trước khi vào app chính
        if (!showLoginDialog()) {
            System.exit(0);
        }

        initializeUI();
        loadMedicalRecords();
    }

    /**
     * Hộp thoại Đăng nhập (Login Dialog)
     */
    private boolean showLoginDialog() {
        JDialog loginDialog = new JDialog((Frame) null, "JVCare Desktop - Đăng nhập", true);
        loginDialog.setSize(380, 260);
        loginDialog.setLocationRelativeTo(null);
        loginDialog.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
        loginDialog.setLayout(new BorderLayout());

        JPanel headerPanel = new JPanel();
        headerPanel.setBackground(new Color(43, 108, 176));
        headerPanel.setPreferredSize(new Dimension(380, 60));
        headerPanel.setLayout(new GridBagLayout());
        JLabel lblTitle = new JLabel("JVCARE PORTAL - BÁC SĨ");
        lblTitle.setFont(new Font("Sora", Font.BOLD, 16));
        lblTitle.setForeground(Color.WHITE);
        headerPanel.add(lblTitle);

        JPanel centerPanel = new JPanel(new GridBagLayout());
        centerPanel.setBorder(new EmptyBorder(15, 20, 15, 20));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(8, 8, 8, 8);

        // Email
        gbc.gridx = 0; gbc.gridy = 0; gbc.weightx = 0.3;
        centerPanel.add(new JLabel("Email đăng nhập:"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        JTextField txtEmail = new JTextField("doctor@jvcare.com", 20);
        centerPanel.add(txtEmail, gbc);

        // Password
        gbc.gridx = 0; gbc.gridy = 1; gbc.weightx = 0.3;
        centerPanel.add(new JLabel("Mật khẩu:"), gbc);
        gbc.gridx = 1; gbc.weightx = 0.7;
        JPasswordField txtPassword = new JPasswordField("123456", 20);
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

        final boolean[] loginSuccess = {false};

        btnLogin.addActionListener(e -> {
            String email = txtEmail.getText().trim();
            String password = new String(txtPassword.getPassword());

            if (email.isEmpty() || password.isEmpty()) {
                JOptionPane.showMessageDialog(loginDialog, "Vui lòng nhập đầy đủ email và mật khẩu", "Cảnh báo", JOptionPane.WARNING_MESSAGE);
                return;
            }

            // Gọi UserDAO xác thực
            User user = userDAO.authenticate(email, password);
            if (user == null) {
                JOptionPane.showMessageDialog(loginDialog, "Tài khoản hoặc mật khẩu không chính xác!", "Lỗi", JOptionPane.ERROR_MESSAGE);
                return;
            }

            if (!"DOCTOR".equalsIgnoreCase(user.getRole())) {
                JOptionPane.showMessageDialog(loginDialog, "Chỉ tài khoản Bác sĩ mới được đăng nhập vào ứng dụng này!", "Lỗi quyền truy cập", JOptionPane.ERROR_MESSAGE);
                return;
            }

            // Truy vấn lấy doctorId
            int docId = queryDoctorId(user.getUserId());
            if (docId == -1) {
                JOptionPane.showMessageDialog(loginDialog, "Không tìm thấy thông tin Bác sĩ ứng với tài khoản này trong hệ thống!", "Lỗi", JOptionPane.ERROR_MESSAGE);
                return;
            }

            currentDoctorUser = user;
            currentDoctorId = docId;
            loginSuccess[0] = true;
            loginDialog.dispose();
        });

        btnCancel.addActionListener(e -> loginDialog.dispose());

        // Cho phép nhấn Enter để đăng nhập
        loginDialog.getRootPane().setDefaultButton(btnLogin);

        loginDialog.setVisible(true);
        return loginSuccess[0];
    }

    /**
     * Lấy doctor_id từ database
     */
    private int queryDoctorId(int userId) {
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("doctor_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Dựng giao diện chính
     */
    private void initializeUI() {
        setTitle("JVCare Desktop - Quản lý Bệnh án Bác sĩ (Kiến trúc 3 Lớp)");
        setSize(1200, 750);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        // Bảng màu giao diện
        Color primaryColor = new Color(43, 108, 176);
        Color sidebarBg = new Color(26, 32, 44);

        // ==================== SIDEBAR TRÁI ====================
        JPanel sidebarPanel = new JPanel();
        sidebarPanel.setBackground(sidebarBg);
        sidebarPanel.setPreferredSize(new Dimension(240, 750));
        sidebarPanel.setLayout(new BorderLayout());

        JPanel brandPanel = new JPanel(new GridBagLayout());
        brandPanel.setBackground(sidebarBg);
        brandPanel.setPreferredSize(new Dimension(240, 80));
        JLabel lblLogo = new JLabel("JVCare Desktop");
        lblLogo.setFont(new Font("Sora", Font.BOLD, 18));
        lblLogo.setForeground(Color.WHITE);
        brandPanel.add(lblLogo);

        JPanel doctorInfoPanel = new JPanel(new GridBagLayout());
        doctorInfoPanel.setBackground(new Color(45, 55, 72));
        doctorInfoPanel.setBorder(new EmptyBorder(10, 15, 10, 15));
        GridBagConstraints gbcInfo = new GridBagConstraints();
        gbcInfo.fill = GridBagConstraints.HORIZONTAL;
        gbcInfo.gridx = 0; gbcInfo.gridy = 0; gbcInfo.weightx = 1.0;
        
        JLabel lblDocName = new JLabel(currentDoctorUser.getFullName());
        lblDocName.setFont(new Font("Segoe UI", Font.BOLD, 13));
        lblDocName.setForeground(Color.WHITE);
        doctorInfoPanel.add(lblDocName, gbcInfo);

        gbcInfo.gridy = 1;
        JLabel lblRole = new JLabel("Vai trò: Bác sĩ điều trị");
        lblRole.setFont(new Font("Segoe UI", Font.ITALIC, 11));
        lblRole.setForeground(new Color(160, 174, 192));
        doctorInfoPanel.add(lblRole, gbcInfo);

        JPanel menuPanel = new JPanel(new GridLayout(6, 1, 0, 5));
        menuPanel.setBackground(sidebarBg);
        menuPanel.setBorder(new EmptyBorder(20, 10, 20, 10));

        JButton btnMenuRecords = new JButton(" Danh sách Bệnh án");
        btnMenuRecords.setFont(new Font("Segoe UI", Font.BOLD, 13));
        btnMenuRecords.setForeground(Color.WHITE);
        btnMenuRecords.setBackground(primaryColor);
        btnMenuRecords.setBorderPainted(false);
        btnMenuRecords.setFocusPainted(false);
        btnMenuRecords.setHorizontalAlignment(SwingConstants.LEFT);
        menuPanel.add(btnMenuRecords);

        JButton btnLogout = new JButton(" Đăng xuất");
        btnLogout.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        btnLogout.setForeground(new Color(226, 232, 240));
        btnLogout.setBackground(sidebarBg);
        btnLogout.setBorderPainted(false);
        btnLogout.setFocusPainted(false);
        btnLogout.setHorizontalAlignment(SwingConstants.LEFT);
        btnLogout.addActionListener(e -> {
            dispose();
            DoctorWinFormApp app = new DoctorWinFormApp();
            app.setVisible(true);
        });
        menuPanel.add(btnLogout);

        sidebarPanel.add(brandPanel, BorderLayout.NORTH);
        sidebarPanel.add(doctorInfoPanel, BorderLayout.CENTER);
        sidebarPanel.add(menuPanel, BorderLayout.SOUTH);

        // ==================== CỘT NỘI DUNG CHÍNH (BÊN PHẢI) ====================
        JPanel mainContentPanel = new JPanel(new BorderLayout());
        mainContentPanel.setBorder(new EmptyBorder(10, 15, 10, 15));

        // Header
        JPanel headerPanel = new JPanel(new BorderLayout());
        headerPanel.setBorder(new EmptyBorder(0, 0, 10, 0));
        JLabel lblHeaderTitle = new JLabel("QUẢN LÝ BỆNH ÁN & KÊ ĐƠN THUỐC");
        lblHeaderTitle.setFont(new Font("Sora", Font.BOLD, 18));
        lblHeaderTitle.setForeground(new Color(45, 55, 72));
        headerPanel.add(lblHeaderTitle, BorderLayout.WEST);
        mainContentPanel.add(headerPanel, BorderLayout.NORTH);

        // Split Pane chia đôi: Trái là Bảng danh sách, Phải là Chi tiết bệnh án
        JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        splitPane.setDividerLocation(480);
        splitPane.setResizeWeight(0.4);

        // ----------------- PANEL TRÁI: DANH SÁCH BỆNH ÁN -----------------
        JPanel listPanel = new JPanel(new BorderLayout());
        listPanel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Danh sách bệnh án của tôi",
                TitledBorder.LEFT, TitledBorder.TOP,
                new Font("Segoe UI", Font.BOLD, 12), primaryColor));

        // Thanh tìm kiếm nhanh
        JPanel searchPanel = new JPanel(new BorderLayout(5, 0));
        searchPanel.setBorder(new EmptyBorder(5, 5, 8, 5));
        searchPanel.add(new JLabel("Tìm bệnh nhân: "), BorderLayout.WEST);
        txtSearch = new JTextField();
        searchPanel.add(txtSearch, BorderLayout.CENTER);
        listPanel.add(searchPanel, BorderLayout.NORTH);

        // Bảng dữ liệu
        String[] columns = {"Mã BA", "Mã BN", "Tên bệnh nhân", "Ngày khám", "Chẩn đoán"};
        recordTableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        recordTable = new JTable(recordTableModel);
        recordTable.setRowHeight(28);
        recordTable.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        recordTable.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));
        recordTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

        // Bộ lọc tìm kiếm nhanh thời gian thực
        rowSorter = new TableRowSorter<>(recordTableModel);
        recordTable.setRowSorter(rowSorter);
        txtSearch.getDocument().addDocumentListener(new DocumentListener() {
            public void insertUpdate(DocumentEvent e) { filterTable(); }
            public void removeUpdate(DocumentEvent e) { filterTable(); }
            public void changedUpdate(DocumentEvent e) { filterTable(); }
        });

        JScrollPane scrollTable = new JScrollPane(recordTable);
        listPanel.add(scrollTable, BorderLayout.CENTER);

        // Thanh điều khiển danh sách
        JPanel listControlPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 5));
        JButton btnAddRecord = new JButton("Tạo Bệnh Án Mới");
        btnAddRecord.setBackground(primaryColor);
        btnAddRecord.setForeground(Color.BLACK);
        btnAddRecord.setFont(new Font("Segoe UI", Font.BOLD, 11));
        
        JButton btnEditRecord = new JButton("Sửa Bệnh Án");
        btnEditRecord.setFont(new Font("Segoe UI", Font.BOLD, 11));

        listControlPanel.add(btnAddRecord);
        listControlPanel.add(btnEditRecord);
        listPanel.add(listControlPanel, BorderLayout.SOUTH);

        // ----------------- PANEL PHẢI: CHI TIẾT BỆNH ÁN & ĐƠN THUỐC -----------------
        JPanel detailContainer = new JPanel(new BorderLayout());
        detailContainer.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Thông tin chi tiết bệnh án",
                TitledBorder.LEFT, TitledBorder.TOP,
                new Font("Segoe UI", Font.BOLD, 12), primaryColor));

        JPanel detailScrollable = new JPanel();
        detailScrollable.setLayout(new BoxLayout(detailScrollable, BoxLayout.Y_AXIS));
        detailScrollable.setBorder(new EmptyBorder(8, 8, 8, 8));

        // 1. Khung hành chính
        JPanel patientCard = new JPanel(new GridLayout(2, 2, 10, 5));
        patientCard.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createTitledBorder("Bệnh nhân"),
                new EmptyBorder(5, 8, 5, 8)));
        lblPatientName = new JLabel("Họ tên: --");
        lblPatientName.setFont(new Font("Segoe UI", Font.BOLD, 12));
        lblPatientCode = new JLabel("Mã BN: --");
        lblVisitDate = new JLabel("Ngày khám: --");
        lblBMI = new JLabel("Chỉ số BMI: --");
        lblBMI.setFont(new Font("Segoe UI", Font.BOLD, 12));
        patientCard.add(lblPatientName);
        patientCard.add(lblPatientCode);
        patientCard.add(lblVisitDate);
        patientCard.add(lblBMI);

        // 2. Khung sinh hiệu
        JPanel vitalsCard = new JPanel(new GridLayout(2, 3, 10, 5));
        vitalsCard.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createTitledBorder("Chỉ số Sinh hiệu"),
                new EmptyBorder(5, 8, 5, 8)));
        lblBP = new JLabel("Huyết áp: --");
        lblHeartRate = new JLabel("Nhịp tim: --");
        lblTemp = new JLabel("Nhiệt độ: --");
        lblWeight = new JLabel("Cân nặng: --");
        lblHeight = new JLabel("Chiều cao: --");
        vitalsCard.add(lblBP);
        vitalsCard.add(lblHeartRate);
        vitalsCard.add(lblTemp);
        vitalsCard.add(lblWeight);
        vitalsCard.add(lblHeight);

        // 3. Chẩn đoán & Điều trị
        JPanel textFieldsCard = new JPanel(new GridBagLayout());
        textFieldsCard.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createTitledBorder("Nội dung Bệnh lý"),
                new EmptyBorder(5, 8, 5, 8)));
        GridBagConstraints gbcText = new GridBagConstraints();
        gbcText.fill = GridBagConstraints.BOTH;
        gbcText.insets = new Insets(4, 4, 4, 4);
        gbcText.weightx = 1.0;

        gbcText.gridx = 0; gbcText.gridy = 0;
        textFieldsCard.add(new JLabel("Chẩn đoán lâm sàng:"), gbcText);
        gbcText.gridy = 1;
        txtDiagnosis = new JTextArea(3, 20);
        txtDiagnosis.setLineWrap(true);
        txtDiagnosis.setWrapStyleWord(true);
        txtDiagnosis.setEditable(false);
        textFieldsCard.add(new JScrollPane(txtDiagnosis), gbcText);

        gbcText.gridy = 2;
        textFieldsCard.add(new JLabel("Phương án điều trị:"), gbcText);
        gbcText.gridy = 3;
        txtTreatmentPlan = new JTextArea(3, 20);
        txtTreatmentPlan.setLineWrap(true);
        txtTreatmentPlan.setWrapStyleWord(true);
        txtTreatmentPlan.setEditable(false);
        textFieldsCard.add(new JScrollPane(txtTreatmentPlan), gbcText);

        gbcText.gridy = 4;
        textFieldsCard.add(new JLabel("Ghi chú bổ sung:"), gbcText);
        gbcText.gridy = 5;
        txtNotes = new JTextArea(2, 20);
        txtNotes.setLineWrap(true);
        txtNotes.setWrapStyleWord(true);
        txtNotes.setEditable(false);
        textFieldsCard.add(new JScrollPane(txtNotes), gbcText);

        // 4. Khung đơn thuốc
        JPanel prescriptionCard = new JPanel(new BorderLayout());
        prescriptionCard.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createTitledBorder("Đơn thuốc đã kê"),
                new EmptyBorder(5, 5, 5, 5)));
        prescriptionCard.setPreferredSize(new Dimension(300, 160));

        String[] presCols = {"ID", "Tên thuốc", "Liều lượng", "Tần suất", "Ngày dùng", "Cách dùng"};
        prescriptionTableModel = new DefaultTableModel(presCols, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        prescriptionTable = new JTable(prescriptionTableModel);
        prescriptionTable.setRowHeight(24);
        prescriptionTable.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        
        prescriptionCard.add(new JScrollPane(prescriptionTable), BorderLayout.CENTER);

        JPanel presBtnBar = new JPanel(new FlowLayout(FlowLayout.RIGHT, 5, 2));
        btnAddPrescription = new JButton("+ Kê thêm thuốc");
        btnAddPrescription.setFont(new Font("Segoe UI", Font.BOLD, 10));
        btnAddPrescription.setEnabled(false);

        btnDeletePrescription = new JButton("Xóa thuốc");
        btnDeletePrescription.setFont(new Font("Segoe UI", Font.PLAIN, 10));
        btnDeletePrescription.setEnabled(false);

        btnPrintPrescription = new JButton("In Đơn Thuốc");
        btnPrintPrescription.setFont(new Font("Segoe UI", Font.BOLD, 10));
        btnPrintPrescription.setBackground(new Color(56, 161, 105));
        btnPrintPrescription.setForeground(Color.BLACK);
        btnPrintPrescription.setEnabled(false);

        presBtnBar.add(btnAddPrescription);
        presBtnBar.add(btnDeletePrescription);
        presBtnBar.add(btnPrintPrescription);
        prescriptionCard.add(presBtnBar, BorderLayout.SOUTH);

        detailScrollable.add(patientCard);
        detailScrollable.add(Box.createVerticalStrut(8));
        detailScrollable.add(vitalsCard);
        detailScrollable.add(Box.createVerticalStrut(8));
        detailScrollable.add(textFieldsCard);
        detailScrollable.add(Box.createVerticalStrut(8));
        detailScrollable.add(prescriptionCard);

        JScrollPane scrollDetail = new JScrollPane(detailScrollable);
        scrollDetail.getVerticalScrollBar().setUnitIncrement(16);
        detailContainer.add(scrollDetail, BorderLayout.CENTER);

        splitPane.setLeftComponent(listPanel);
        splitPane.setRightComponent(detailContainer);
        mainContentPanel.add(splitPane, BorderLayout.CENTER);
        add(sidebarPanel, BorderLayout.WEST);
        add(mainContentPanel, BorderLayout.CENTER);

        // ==================== CÁC SỰ KIỆN XỬ LÝ GIAO DIỆN ====================
        
        // Sự kiện click chọn dòng trên Table bệnh án
        recordTable.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting()) {
                int selectedRow = recordTable.getSelectedRow();
                if (selectedRow != -1) {
                    int modelRow = recordTable.convertRowIndexToModel(selectedRow);
                    int recordId = (int) recordTableModel.getValueAt(modelRow, 0);
                    showRecordDetails(recordId);
                } else {
                    clearRecordDetails();
                }
            }
        });

        // Click Tạo bệnh án mới
        btnAddRecord.addActionListener(e -> showAddRecordDialog());

        // Click Sửa bệnh án
        btnEditRecord.addActionListener(e -> {
            if (selectedRecord == null) {
                JOptionPane.showMessageDialog(this, "Vui lòng chọn một bệnh án để sửa!", "Thông báo", JOptionPane.WARNING_MESSAGE);
                return;
            }
            showEditRecordDialog();
        });

        // Click Kê thêm thuốc
        btnAddPrescription.addActionListener(e -> showAddPrescriptionDialog());

        // Click Xóa đơn thuốc
        btnDeletePrescription.addActionListener(e -> {
            int selectedRow = prescriptionTable.getSelectedRow();
            if (selectedRow == -1) {
                JOptionPane.showMessageDialog(this, "Vui lòng chọn thuốc cần xóa trong đơn!", "Thông báo", JOptionPane.WARNING_MESSAGE);
                return;
            }
            int presId = (int) prescriptionTableModel.getValueAt(selectedRow, 0);
            int confirm = JOptionPane.showConfirmDialog(this, "Bạn có chắc chắn muốn xóa loại thuốc này khỏi đơn?", "Xác nhận", JOptionPane.YES_NO_OPTION);
            if (confirm == JOptionPane.YES_OPTION) {
                try {
                    // Gọi Service Layer xóa
                    boolean success = prescriptionService.deletePrescription(presId, currentDoctorId);
                    if (success) {
                        JOptionPane.showMessageDialog(this, "Xóa thuốc thành công!");
                        showRecordDetails(selectedRecord.getRecordId()); // reload chi tiet
                    }
                } catch (BusinessException ex) {
                    JOptionPane.showMessageDialog(this, ex.getMessage(), "Lỗi nghiệp vụ", JOptionPane.ERROR_MESSAGE);
                }
            }
        });

        // Click In đơn thuốc
        btnPrintPrescription.addActionListener(e -> showPrintPrescriptionDialog());
    }

    /**
     * Tải dữ liệu bệnh án thông qua Service Layer
     */
    private void loadMedicalRecords() {
        try {
            allRecords = recordService.getRecordsByDoctor(currentDoctorId);
            recordTableModel.setRowCount(0);
            for (MedicalRecordDTO r : allRecords) {
                recordTableModel.addRow(new Object[]{
                        r.getRecordId(),
                        r.getPatientCode(),
                        r.getPatientName(),
                        r.getVisitDate() != null ? r.getVisitDate().toString() : "Chưa có ngày",
                        r.getDiagnosis()
                });
            }
            clearRecordDetails();
        } catch (BusinessException e) {
            JOptionPane.showMessageDialog(this, "Lỗi khi lấy danh sách bệnh án: " + e.getMessage(), "Lỗi hệ thống", JOptionPane.ERROR_MESSAGE);
        }
    }

    /**
     * Tìm kiếm cục bộ thời gian thực
     */
    private void filterTable() {
        String keyword = txtSearch.getText().trim();
        if (keyword.isEmpty()) {
            rowSorter.setRowFilter(null);
        } else {
            rowSorter.setRowFilter(RowFilter.regexFilter("(?i)" + keyword, 2, 1)); // Lọc theo Tên bệnh nhân hoặc Mã bệnh nhân
        }
    }

    /**
     * Đưa thông tin bệnh án được chọn lên giao diện chi tiết
     */
    private void showRecordDetails(int recordId) {
        try {
            // Gọi Service lấy thông tin đầy đủ kèm đơn thuốc
            selectedRecord = recordService.getRecordWithPrescriptions(recordId);

            lblPatientName.setText("Họ tên: " + selectedRecord.getPatientName());
            lblPatientCode.setText("Mã BN: " + selectedRecord.getPatientCode());
            lblVisitDate.setText("Ngày khám: " + (selectedRecord.getVisitDate() != null ? selectedRecord.getVisitDate().toString() : ""));
            
            // Tính toán hiển thị BMI
            if (selectedRecord.getBmi() > 0) {
                String bmiClass = "Bình thường";
                Color bmiColor = new Color(56, 161, 105);
                if (selectedRecord.getBmi() < 18.5) {
                    bmiClass = "Gầy";
                    bmiColor = new Color(49, 130, 206);
                } else if (selectedRecord.getBmi() >= 23 && selectedRecord.getBmi() < 25) {
                    bmiClass = "Tiền béo phì";
                    bmiColor = new Color(221, 107, 32);
                } else if (selectedRecord.getBmi() >= 25) {
                    bmiClass = "Béo phì";
                    bmiColor = new Color(229, 62, 62);
                }
                lblBMI.setText("<html>Chỉ số BMI: <font color='rgb(" + bmiColor.getRed() + "," + bmiColor.getGreen() + "," + bmiColor.getBlue() + ")'>" + selectedRecord.getBmi() + " (" + bmiClass + ")</font></html>");
            } else {
                lblBMI.setText("Chỉ số BMI: --");
            }

            lblBP.setText("Huyết áp: " + (selectedRecord.getBloodPressure() != null ? selectedRecord.getBloodPressure() + " mmHg" : "--"));
            lblHeartRate.setText("Nhịp tim: " + (selectedRecord.getHeartRate() > 0 ? selectedRecord.getHeartRate() + " bpm" : "--"));
            lblTemp.setText("Nhiệt độ: " + (selectedRecord.getTemperature() > 0 ? selectedRecord.getTemperature() + " °C" : "--"));
            lblWeight.setText("Cân nặng: " + (selectedRecord.getWeight() > 0 ? selectedRecord.getWeight() + " kg" : "--"));
            lblHeight.setText("Chiều cao: " + (selectedRecord.getHeight() > 0 ? selectedRecord.getHeight() + " cm" : "--"));

            txtDiagnosis.setText(selectedRecord.getDiagnosis());
            txtTreatmentPlan.setText(selectedRecord.getTreatmentPlan());
            txtNotes.setText(selectedRecord.getNotes());

            // Đưa đơn thuốc lên bảng
            prescriptionTableModel.setRowCount(0);
            List<PrescriptionDTO> prescriptions = selectedRecord.getPrescriptions();
            if (prescriptions != null) {
                for (PrescriptionDTO p : prescriptions) {
                    prescriptionTableModel.addRow(new Object[]{
                            p.getPrescriptionId(),
                            p.getMedicationName(),
                            p.getDosage(),
                            p.getFrequency(),
                            p.getDurationDays(),
                            p.getInstructions()
                    });
                }
            }

            // Mở khóa các nút đơn thuốc
            btnAddPrescription.setEnabled(true);
            btnDeletePrescription.setEnabled(true);
            btnPrintPrescription.setEnabled(true);

        } catch (BusinessException e) {
            JOptionPane.showMessageDialog(this, "Không thể lấy chi tiết bệnh án: " + e.getMessage(), "Lỗi", JOptionPane.ERROR_MESSAGE);
        }
    }

    /**
     * Clear panel chi tiết
     */
    private void clearRecordDetails() {
        selectedRecord = null;
        lblPatientName.setText("Họ tên: --");
        lblPatientCode.setText("Mã BN: --");
        lblVisitDate.setText("Ngày khám: --");
        lblBMI.setText("Chỉ số BMI: --");

        lblBP.setText("Huyết áp: --");
        lblHeartRate.setText("Nhịp tim: --");
        lblTemp.setText("Nhiệt độ: --");
        lblWeight.setText("Cân nặng: --");
        lblHeight.setText("Chiều cao: --");

        txtDiagnosis.setText("");
        txtTreatmentPlan.setText("");
        txtNotes.setText("");

        prescriptionTableModel.setRowCount(0);

        btnAddPrescription.setEnabled(false);
        btnDeletePrescription.setEnabled(false);
        btnPrintPrescription.setEnabled(false);
    }

    /**
     * Truy vấn tìm các lịch hẹn của bác sĩ đã COMPLETED nhưng CHƯA lập bệnh án
     */
    private List<Appointment> fetchPendingAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.patient_id, a.appointment_date, a.reason, p.full_name, p.patient_code " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "WHERE a.doctor_id = ? AND a.status = 'COMPLETED' " +
                     "AND a.appointment_id NOT IN (SELECT appointment_id FROM medical_records) " +
                     "ORDER BY a.appointment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentDoctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setPatientId(rs.getInt("patient_id"));
                    a.setReason(rs.getString("reason"));
                    
                    // Gán ảo để hiển thị
                    a.setPatientCondition(rs.getString("full_name")); 
                    a.setNotes(rs.getString("patient_code"));
                    
                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hộp thoại Tạo bệnh án mới (Add Record JDialog)
     */
    private void showAddRecordDialog() {
        List<Appointment> appointments = fetchPendingAppointments();
        if (appointments.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Không có lịch hẹn đã hoàn thành (COMPLETED) nào chưa được tạo bệnh án!", "Thông báo", JOptionPane.INFORMATION_MESSAGE);
            return;
        }

        JDialog addDialog = new JDialog(this, "Tạo Bệnh Án Mới", true);
        addDialog.setSize(520, 600);
        addDialog.setLocationRelativeTo(this);
        addDialog.setLayout(new BorderLayout());

        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(new EmptyBorder(15, 15, 15, 15));
        GridBagConstraints g = new GridBagConstraints();
        g.fill = GridBagConstraints.HORIZONTAL;
        g.insets = new Insets(6, 6, 6, 6);

        // Combobox Chọn lịch hẹn
        g.gridx = 0; g.gridy = 0; g.weightx = 0.3;
        formPanel.add(new JLabel("Lịch hẹn chờ lập BA:"), g);
        g.gridx = 1; g.weightx = 0.7;
        JComboBox<String> cbApp = new JComboBox<>();
        for (Appointment a : appointments) {
            cbApp.addItem("#" + a.getAppointmentId() + " - " + a.getPatientCondition() + " (" + a.getNotes() + ")");
        }
        formPanel.add(cbApp, g);

        // Sinh hiệu
        g.gridx = 0; g.gridy = 1;
        formPanel.add(new JLabel("Huyết áp (VD: 120/80):"), g);
        g.gridx = 1;
        JTextField txtBP = new JTextField();
        formPanel.add(txtBP, g);

        g.gridx = 0; g.gridy = 2;
        formPanel.add(new JLabel("Nhịp tim (bpm):"), g);
        g.gridx = 1;
        JSpinner spnHeartRate = new JSpinner(new SpinnerNumberModel(0, 0, 220, 1));
        formPanel.add(spnHeartRate, g);

        g.gridx = 0; g.gridy = 3;
        formPanel.add(new JLabel("Nhiệt độ (°C):"), g);
        g.gridx = 1;
        JSpinner spnTemp = new JSpinner(new SpinnerNumberModel(0.0, 0.0, 45.0, 0.1));
        formPanel.add(spnTemp, g);

        g.gridx = 0; g.gridy = 4;
        formPanel.add(new JLabel("Cân nặng (kg):"), g);
        g.gridx = 1;
        JSpinner spnWeight = new JSpinner(new SpinnerNumberModel(0.0, 0.0, 300.0, 0.5));
        formPanel.add(spnWeight, g);

        g.gridx = 0; g.gridy = 5;
        formPanel.add(new JLabel("Chiều cao (cm):"), g);
        g.gridx = 1;
        JSpinner spnHeight = new JSpinner(new SpinnerNumberModel(0, 0, 250, 1));
        formPanel.add(spnHeight, g);

        // Nội dung bệnh án
        g.gridx = 0; g.gridy = 6; g.fill = GridBagConstraints.BOTH;
        formPanel.add(new JLabel("Chẩn đoán (*):"), g);
        g.gridx = 1;
        JTextArea areaDiagnosis = new JTextArea(3, 20);
        areaDiagnosis.setLineWrap(true);
        areaDiagnosis.setWrapStyleWord(true);
        formPanel.add(new JScrollPane(areaDiagnosis), g);

        g.gridx = 0; g.gridy = 7;
        formPanel.add(new JLabel("Phương án ĐT (*):"), g);
        g.gridx = 1;
        JTextArea areaTreatment = new JTextArea(4, 20);
        areaTreatment.setLineWrap(true);
        areaTreatment.setWrapStyleWord(true);
        formPanel.add(new JScrollPane(areaTreatment), g);

        g.gridx = 0; g.gridy = 8;
        formPanel.add(new JLabel("Ghi chú bổ sung:"), g);
        g.gridx = 1;
        JTextArea areaNotes = new JTextArea(2, 20);
        areaNotes.setLineWrap(true);
        areaNotes.setWrapStyleWord(true);
        formPanel.add(new JScrollPane(areaNotes), g);

        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 5));
        JButton btnSave = new JButton("Lưu Bệnh Án");
        btnSave.setBackground(new Color(43, 108, 176));
        btnSave.setForeground(Color.WHITE);
        JButton btnClose = new JButton("Đóng");
        btnPanel.add(btnSave);
        btnPanel.add(btnClose);

        addDialog.add(formPanel, BorderLayout.CENTER);
        addDialog.add(btnPanel, BorderLayout.SOUTH);

        btnSave.addActionListener(ev -> {
            try {
                int selectedIndex = cbApp.getSelectedIndex();
                if (selectedIndex == -1) return;
                Appointment selectedApp = appointments.get(selectedIndex);

                // Gom thông số DTO
                MedicalRecordDTO recordDTO = new MedicalRecordDTO();
                recordDTO.setAppointmentId(selectedApp.getAppointmentId());
                recordDTO.setBloodPressure(txtBP.getText().trim());
                recordDTO.setHeartRate((int) spnHeartRate.getValue());
                recordDTO.setTemperature((double) spnTemp.getValue());
                recordDTO.setWeight((double) spnWeight.getValue());
                recordDTO.setHeight((int) spnHeight.getValue());
                recordDTO.setDiagnosis(areaDiagnosis.getText().trim());
                recordDTO.setTreatmentPlan(areaTreatment.getText().trim());
                recordDTO.setNotes(areaNotes.getText().trim());

                // Gọi Service Layer thực hiện tạo bệnh án.
                // Service layer tự kiểm tra validation và ném ngoại lệ nếu dữ liệu sai chuẩn!
                int recordId = recordService.createRecordFromAppointment(
                        selectedApp.getAppointmentId(), currentDoctorId, recordDTO);

                if (recordId > 0) {
                    JOptionPane.showMessageDialog(addDialog, "Tạo bệnh án thành công!", "Thành công", JOptionPane.INFORMATION_MESSAGE);
                    addDialog.dispose();
                    loadMedicalRecords(); // reload
                }
            } catch (BusinessException ex) {
                // Hiển thị trực tiếp lỗi được bắt từ Business Logic Layer
                JOptionPane.showMessageDialog(addDialog, ex.getMessage(), "Lỗi xác thực dữ liệu", JOptionPane.ERROR_MESSAGE);
            }
        });

        btnClose.addActionListener(ev -> addDialog.dispose());

        addDialog.setVisible(true);
    }

    /**
     * Hộp thoại Chỉnh sửa bệnh án (Edit Record JDialog)
     */
    private void showEditRecordDialog() {
        if (selectedRecord == null) return;

        JDialog editDialog = new JDialog(this, "Sửa Bệnh Án - " + selectedRecord.getPatientName(), true);
        editDialog.setSize(520, 600);
        editDialog.setLocationRelativeTo(this);
        editDialog.setLayout(new BorderLayout());

        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(new EmptyBorder(15, 15, 15, 15));
        GridBagConstraints g = new GridBagConstraints();
        g.fill = GridBagConstraints.HORIZONTAL;
        g.insets = new Insets(6, 6, 6, 6);

        // Hiển thị thông tin hành chính
        g.gridx = 0; g.gridy = 0; g.weightx = 0.3;
        formPanel.add(new JLabel("Tên bệnh nhân:"), g);
        g.gridx = 1; g.weightx = 0.7;
        JLabel lblName = new JLabel(selectedRecord.getPatientName() + " (" + selectedRecord.getPatientCode() + ")");
        lblName.setFont(new Font("Segoe UI", Font.BOLD, 12));
        formPanel.add(lblName, g);

        // Sinh hiệu
        g.gridx = 0; g.gridy = 1;
        formPanel.add(new JLabel("Huyết áp (VD: 120/80):"), g);
        g.gridx = 1;
        JTextField txtBP = new JTextField(selectedRecord.getBloodPressure());
        formPanel.add(txtBP, g);

        g.gridx = 0; g.gridy = 2;
        formPanel.add(new JLabel("Nhịp tim (bpm):"), g);
        g.gridx = 1;
        JSpinner spnHeartRate = new JSpinner(new SpinnerNumberModel(selectedRecord.getHeartRate(), 0, 220, 1));
        formPanel.add(spnHeartRate, g);

        g.gridx = 0; g.gridy = 3;
        formPanel.add(new JLabel("Nhiệt độ (°C):"), g);
        g.gridx = 1;
        JSpinner spnTemp = new JSpinner(new SpinnerNumberModel(selectedRecord.getTemperature(), 0.0, 45.0, 0.1));
        formPanel.add(spnTemp, g);

        g.gridx = 0; g.gridy = 4;
        formPanel.add(new JLabel("Cân nặng (kg):"), g);
        g.gridx = 1;
        JSpinner spnWeight = new JSpinner(new SpinnerNumberModel(selectedRecord.getWeight(), 0.0, 300.0, 0.5));
        formPanel.add(spnWeight, g);

        g.gridx = 0; g.gridy = 5;
        formPanel.add(new JLabel("Chiều cao (cm):"), g);
        g.gridx = 1;
        JSpinner spnHeight = new JSpinner(new SpinnerNumberModel(selectedRecord.getHeight(), 0, 250, 1));
        formPanel.add(spnHeight, g);

        // Nội dung bệnh án
        g.gridx = 0; g.gridy = 6; g.fill = GridBagConstraints.BOTH;
        formPanel.add(new JLabel("Chẩn đoán (*):"), g);
        g.gridx = 1;
        JTextArea areaDiagnosis = new JTextArea(3, 20);
        areaDiagnosis.setLineWrap(true);
        areaDiagnosis.setWrapStyleWord(true);
        areaDiagnosis.setText(selectedRecord.getDiagnosis());
        formPanel.add(new JScrollPane(areaDiagnosis), g);

        g.gridx = 0; g.gridy = 7;
        formPanel.add(new JLabel("Phương án ĐT (*):"), g);
        g.gridx = 1;
        JTextArea areaTreatment = new JTextArea(4, 20);
        areaTreatment.setLineWrap(true);
        areaTreatment.setWrapStyleWord(true);
        areaTreatment.setText(selectedRecord.getTreatmentPlan());
        formPanel.add(new JScrollPane(areaTreatment), g);

        g.gridx = 0; g.gridy = 8;
        formPanel.add(new JLabel("Ghi chú bổ sung:"), g);
        g.gridx = 1;
        JTextArea areaNotes = new JTextArea(2, 20);
        areaNotes.setLineWrap(true);
        areaNotes.setWrapStyleWord(true);
        areaNotes.setText(selectedRecord.getNotes());
        formPanel.add(new JScrollPane(areaNotes), g);

        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 5));
        JButton btnSave = new JButton("Cập Nhật");
        btnSave.setBackground(new Color(43, 108, 176));
        btnSave.setForeground(Color.WHITE);
        JButton btnClose = new JButton("Đóng");
        btnPanel.add(btnSave);
        btnPanel.add(btnClose);

        editDialog.add(formPanel, BorderLayout.CENTER);
        editDialog.add(btnPanel, BorderLayout.SOUTH);

        btnSave.addActionListener(ev -> {
            try {
                // Gom thông số DTO
                MedicalRecordDTO recordDTO = new MedicalRecordDTO();
                recordDTO.setRecordId(selectedRecord.getRecordId());
                recordDTO.setAppointmentId(selectedRecord.getAppointmentId());
                recordDTO.setBloodPressure(txtBP.getText().trim());
                recordDTO.setHeartRate((int) spnHeartRate.getValue());
                recordDTO.setTemperature((double) spnTemp.getValue());
                recordDTO.setWeight((double) spnWeight.getValue());
                recordDTO.setHeight((int) spnHeight.getValue());
                recordDTO.setDiagnosis(areaDiagnosis.getText().trim());
                recordDTO.setTreatmentPlan(areaTreatment.getText().trim());
                recordDTO.setNotes(areaNotes.getText().trim());

                // Gọi Service Layer thực hiện sửa
                boolean success = recordService.updateRecord(recordDTO, currentDoctorId);

                if (success) {
                    JOptionPane.showMessageDialog(editDialog, "Cập nhật bệnh án thành công!", "Thành công", JOptionPane.INFORMATION_MESSAGE);
                    editDialog.dispose();
                    loadMedicalRecords(); // reload list
                }
            } catch (BusinessException ex) {
                // Bắt lỗi nghiệp vụ từ Service
                JOptionPane.showMessageDialog(editDialog, ex.getMessage(), "Lỗi nghiệp vụ", JOptionPane.ERROR_MESSAGE);
            }
        });

        btnClose.addActionListener(ev -> editDialog.dispose());

        editDialog.setVisible(true);
    }

    /**
     * Hộp thoại kê đơn thuốc mới (Add Prescription JDialog)
     */
    private void showAddPrescriptionDialog() {
        if (selectedRecord == null) return;

        JDialog presDialog = new JDialog(this, "Kê đơn thuốc mới", true);
        presDialog.setSize(420, 360);
        presDialog.setLocationRelativeTo(this);
        presDialog.setLayout(new BorderLayout());

        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(new EmptyBorder(15, 15, 15, 15));
        GridBagConstraints g = new GridBagConstraints();
        g.fill = GridBagConstraints.HORIZONTAL;
        g.insets = new Insets(6, 6, 6, 6);

        // Tên thuốc
        g.gridx = 0; g.gridy = 0; g.weightx = 0.3;
        formPanel.add(new JLabel("Tên thuốc (*):"), g);
        g.gridx = 1; g.weightx = 0.7;
        JTextField txtMedName = new JTextField();
        formPanel.add(txtMedName, g);

        // Liều lượng
        g.gridx = 0; g.gridy = 1;
        formPanel.add(new JLabel("Liều dùng (dosage):"), g);
        g.gridx = 1;
        JTextField txtDosage = new JTextField("Ngày 2 viên, sáng 1 chiều 1");
        formPanel.add(txtDosage, g);

        // Tần suất
        g.gridx = 0; g.gridy = 2;
        formPanel.add(new JLabel("Tần suất (frequency):"), g);
        g.gridx = 1;
        JTextField txtFrequency = new JTextField("Sau khi ăn");
        formPanel.add(txtFrequency, g);

        // Số ngày dùng
        g.gridx = 0; g.gridy = 3;
        formPanel.add(new JLabel("Số ngày kê đơn:"), g);
        g.gridx = 1;
        JSpinner spnDays = new JSpinner(new SpinnerNumberModel(7, 1, 365, 1));
        formPanel.add(spnDays, g);

        // Chỉ dẫn sử dụng
        g.gridx = 0; g.gridy = 4; g.fill = GridBagConstraints.BOTH;
        formPanel.add(new JLabel("Hướng dẫn chi tiết:"), g);
        g.gridx = 1;
        JTextArea areaInstructions = new JTextArea(3, 20);
        areaInstructions.setLineWrap(true);
        areaInstructions.setWrapStyleWord(true);
        formPanel.add(new JScrollPane(areaInstructions), g);

        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 5));
        JButton btnSave = new JButton("Kê Thuốc");
        btnSave.setBackground(new Color(56, 161, 105));
        btnSave.setForeground(Color.BLACK);
        JButton btnClose = new JButton("Hủy");
        btnPanel.add(btnSave);
        btnPanel.add(btnClose);

        presDialog.add(formPanel, BorderLayout.CENTER);
        presDialog.add(btnPanel, BorderLayout.SOUTH);

        btnSave.addActionListener(ev -> {
            try {
                PrescriptionDTO dto = new PrescriptionDTO();
                dto.setRecordId(selectedRecord.getRecordId());
                dto.setMedicationName(txtMedName.getText().trim());
                dto.setDosage(txtDosage.getText().trim());
                dto.setFrequency(txtFrequency.getText().trim());
                dto.setDurationDays((int) spnDays.getValue());
                dto.setInstructions(areaInstructions.getText().trim());

                // Gọi PrescriptionService để validate nghiệp vụ
                boolean success = prescriptionService.createPrescription(dto, currentDoctorId);
                if (success) {
                    JOptionPane.showMessageDialog(presDialog, "Thêm thuốc thành công!");
                    presDialog.dispose();
                    showRecordDetails(selectedRecord.getRecordId()); // reload chi tiet
                }
            } catch (BusinessException ex) {
                // Bắt lỗi nghiệp vụ từ Service
                JOptionPane.showMessageDialog(presDialog, ex.getMessage(), "Lỗi nghiệp vụ", JOptionPane.ERROR_MESSAGE);
            }
        });

        btnClose.addActionListener(ev -> presDialog.dispose());

        presDialog.setVisible(true);
    }

    /**
     * Hộp thoại hiển thị bản in đơn thuốc (Print JDialog) cực đẹp
     */
    private void showPrintPrescriptionDialog() {
        if (selectedRecord == null) return;

        JDialog printDialog = new JDialog(this, "In Đơn Thuốc", true);
        printDialog.setSize(550, 650);
        printDialog.setLocationRelativeTo(this);
        printDialog.setLayout(new BorderLayout());

        JTextArea paper = new JTextArea();
        paper.setFont(new Font("Courier New", Font.PLAIN, 12));
        paper.setEditable(false);
        paper.setBorder(new EmptyBorder(25, 25, 25, 25));

        // Dựng bản in dạng văn bản chuyên nghiệp
        StringBuilder sb = new StringBuilder();
        sb.append("      HỆ THỐNG Y TẾ QUỐC TẾ JVCARE\n");
        sb.append("      Địa chỉ: 123 Nguyễn Trãi, Thanh Xuân, Hà Nội\n");
        sb.append("      Điện thoại: 1900-JVCARE (1900-5822)\n");
        sb.append("====================================================\n");
        sb.append("                 ĐƠN THUỐC BỆNH NHÂN\n");
        sb.append("----------------------------------------------------\n");
        sb.append("Họ tên bệnh nhân: ").append(selectedRecord.getPatientName()).append("\n");
        sb.append("Mã số bệnh nhân:  ").append(selectedRecord.getPatientCode()).append("\n");
        sb.append("Ngày kê đơn:      ").append(selectedRecord.getVisitDate() != null ? selectedRecord.getVisitDate().toString() : "Hôm nay").append("\n");
        sb.append("Chẩn đoán:        ").append(selectedRecord.getDiagnosis()).append("\n");
        sb.append("----------------------------------------------------\n");
        sb.append("DANH SÁCH THUỐC KÊ ĐƠN:\n\n");

        List<PrescriptionDTO> list = selectedRecord.getPrescriptions();
        if (list == null || list.isEmpty()) {
            sb.append("  (Chưa kê loại thuốc nào trong đơn thuốc này)\n");
        } else {
            int count = 1;
            for (PrescriptionDTO p : list) {
                sb.append(count).append(". ").append(p.getMedicationName().toUpperCase())
                  .append("  - Ngày uống: ").append(p.getDurationDays()).append(" ngày\n");
                sb.append("   * Liều dùng:   ").append(p.getDosage()).append("\n");
                sb.append("   * Tần suất:    ").append(p.getFrequency()).append("\n");
                if (p.getInstructions() != null && !p.getInstructions().trim().isEmpty()) {
                    sb.append("   * Chỉ dẫn:     ").append(p.getInstructions()).append("\n");
                }
                sb.append("\n");
                count++;
            }
        }
        sb.append("----------------------------------------------------\n");
        sb.append("Lưu ý: Bệnh nhân uống thuốc đúng theo chỉ dẫn.\n");
        sb.append("Tái khám đúng hẹn khi có dấu hiệu bất thường.\n\n");
        sb.append("                      BÁC SĨ ĐIỀU TRỊ\n");
        sb.append("                      (Ký tên và đóng dấu)\n\n\n");
        sb.append("                      ").append(currentDoctorUser.getFullName()).append("\n");

        paper.setText(sb.toString());
        printDialog.add(new JScrollPane(paper), BorderLayout.CENTER);

        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 5));
        JButton btnPrint = new JButton("In Ngay");
        btnPrint.setBackground(new Color(43, 108, 176));
        btnPrint.setForeground(Color.WHITE);
        JButton btnClose = new JButton("Đóng");
        btnPanel.add(btnPrint);
        btnPanel.add(btnClose);
        printDialog.add(btnPanel, BorderLayout.SOUTH);

        btnPrint.addActionListener(e -> {
            try {
                paper.print();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(printDialog, "Lỗi in ấn: " + ex.getMessage(), "Lỗi", JOptionPane.ERROR_MESSAGE);
            }
        });

        btnClose.addActionListener(e -> printDialog.dispose());
        printDialog.setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            DoctorWinFormApp app = new DoctorWinFormApp();
            app.setVisible(true);
        });
    }
}
