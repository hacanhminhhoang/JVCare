
const I18N = (function () {
    const STORAGE_KEY = 'hospital_lang';

    const dict = {
        vi: {
            // Navigation
            nav_dashboard:    'Bảng điều khiển',
            nav_doctors:      'Bác sĩ',
            nav_patients:     'Bệnh nhân',
            nav_appointments: 'Lịch hẹn',
            nav_revenue:      'Doanh thu',
            nav_reports:      'Báo cáo',
            nav_partners:     'Đối tác',
            nav_department:   'Khoa & Phòng',
            nav_settings:     'Cài đặt',
            nav_logout:       'Đăng xuất',
            // Dashboard
            total_doctors:    'Tổng bác sĩ',
            total_patients:   'Tổng bệnh nhân',
            total_revenue:    'Tổng doanh thu',
            total_appointments: 'Lịch hẹn',
            appointments:     'Lịch hẹn',
            view_all:         'Xem tất cả',
            reports:          'Báo cáo',
            doctors_list:     'Danh sách bác sĩ',
            // Table headers
            th_id:            'Mã',
            th_name:          'Họ tên',
            th_specialty:     'Chuyên khoa',
            th_status:        'Trạng thái',
            th_phone:         'Số điện thoại',
            th_actions:       'Thao tác',
            th_diagnosis:     'Chuẩn đoán',
            th_time:          'Giờ',
            th_date:          'Ngày',
            th_type:          'Loại',
            th_doctor:        'Bác sĩ',
            th_patient:       'Bệnh nhân',
            th_amount:        'Số tiền',
            th_description:   'Mô tả',
            th_category:      'Danh mục',
            th_partner_name:  'Tên đối tác',
            th_partner_type:  'Loại',
            th_email:         'Email',
            th_contract:      'Hợp đồng',
            // Actions
            btn_add:          'Thêm mới',
            btn_edit:         'Sửa',
            btn_delete:       'Xóa',
            btn_save:         'Lưu',
            btn_cancel:       'Hủy',
            btn_confirm:      'Xác nhận',
            // Status
            status_active:    'Đang làm việc',
            status_leave:     'Nghỉ phép',
            status_waiting:   'Chờ khám',
            status_treating:  'Đang điều trị',
            status_done:      'Hoàn thành',
            status_confirmed: 'Đã xác nhận',
            status_pending:   'Chờ xác nhận',
            // Revenue
            page_revenue:     'Doanh thu',
            revenue_total:    'Tổng doanh thu',
            revenue_today:    'Doanh thu hôm nay',
            // Misc
            welcome_back:     'Chào mừng trở lại',
            admin_role:       'Quản trị viên',
            search:           'Tìm kiếm...',
            no_data:          'Không có dữ liệu',
            lang_label:       'Tiếng Việt',
        },
        en: {
            // Navigation
            nav_dashboard:    'Dashboard',
            nav_doctors:      'Doctors',
            nav_patients:     'Patients',
            nav_appointments: 'Appointments',
            nav_revenue:      'Revenue',
            nav_reports:      'Reports',
            nav_partners:     'Partners',
            nav_department:   'Departments',
            nav_settings:     'Settings',
            nav_logout:       'Log out',
            // Dashboard
            total_doctors:    'Total Doctors',
            total_patients:   'Total Patients',
            total_revenue:    'Total Revenue',
            total_appointments: 'Appointments',
            appointments:     'Appointments',
            view_all:         'View all',
            reports:          'Reports',
            doctors_list:     'Doctors List',
            // Table headers
            th_id:            'ID',
            th_name:          'Full Name',
            th_specialty:     'Specialty',
            th_status:        'Status',
            th_phone:         'Phone',
            th_actions:       'Actions',
            th_diagnosis:     'Diagnosis',
            th_time:          'Time',
            th_date:          'Date',
            th_type:          'Type',
            th_doctor:        'Doctor',
            th_patient:       'Patient',
            th_amount:        'Amount',
            th_description:   'Description',
            th_category:      'Category',
            th_partner_name:  'Partner Name',
            th_partner_type:  'Type',
            th_email:         'Email',
            th_contract:      'Contract',
            // Actions
            btn_add:          'Add New',
            btn_edit:         'Edit',
            btn_delete:       'Delete',
            btn_save:         'Save',
            btn_cancel:       'Cancel',
            btn_confirm:      'Confirm',
            // Status
            status_active:    'Active',
            status_leave:     'On Leave',
            status_waiting:   'Waiting',
            status_treating:  'In Treatment',
            status_done:      'Completed',
            status_confirmed: 'Confirmed',
            status_pending:   'Pending',
            // Revenue
            page_revenue:     'Revenue',
            revenue_total:    'Total Revenue',
            revenue_today:    'Today\'s Revenue',
            // Misc
            welcome_back:     'Welcome back',
            admin_role:       'Administrator',
            search:           'Search...',
            no_data:          'No data available',
            lang_label:       'English',
        }
    };

    let currentLang = localStorage.getItem(STORAGE_KEY) || 'vi';

    /** Get translation by key */
    function t(key) {
        return (dict[currentLang] && dict[currentLang][key]) ||
               (dict['vi'][key]) || key;
    }

    /** Toggle between vi and en */
    function toggle() {
        currentLang = currentLang === 'vi' ? 'en' : 'vi';
        localStorage.setItem(STORAGE_KEY, currentLang);
        applyAll();
        updateToggleButton();
    }

    /** Apply translations to all [data-i18n] elements */
    function applyAll() {
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            el.textContent = t(key);
        });
        document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
            const key = el.getAttribute('data-i18n-placeholder');
            el.placeholder = t(key);
        });
    }

    /** Update the toggle button UI */
    function updateToggleButton() {
        const btn = document.getElementById('langToggleBtn');
        if (!btn) return;
        if (currentLang === 'en') {
            btn.innerHTML = '<span class="lang-flag">🇬🇧</span><span class="lang-text">English</span>';
        } else {
            btn.innerHTML = '<span class="lang-flag">🇻🇳</span><span class="lang-text">Tiếng Việt</span>';
        }
    }

    /** Initialize on page load */
    function init() {
        applyAll();
        updateToggleButton();
    }

    return { t, toggle, init, currentLang: () => currentLang };
})();

// Auto-init when DOM is ready
document.addEventListener('DOMContentLoaded', function () {
    I18N.init();
    const btn = document.getElementById('langToggleBtn');
    if (btn) btn.addEventListener('click', I18N.toggle);
});
