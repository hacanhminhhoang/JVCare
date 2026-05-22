<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${prescription != null ? 'Sửa' : 'Thêm'} Thuốc - JVCare</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Manrope:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: oklch(0.55 0.22 260);
            --primary-dark: oklch(0.42 0.22 260);
            --accent: oklch(0.65 0.20 195);
            --surface: oklch(0.10 0.02 260);
            --surface-card: oklch(0.13 0.02 260);
            --border: oklch(0.20 0.02 260);
            --text: oklch(0.95 0.01 260);
            --text-muted: oklch(0.65 0.02 260);
            --success: oklch(0.65 0.18 145);
            --danger: oklch(0.60 0.22 25);
            --warning: oklch(0.75 0.18 85);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Manrope', sans-serif;
            background: var(--surface);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .card {
            background: var(--surface-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2.5rem;
            width: 100%;
            max-width: 560px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
        }
        .card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .card-header .icon {
            width: 48px; height: 48px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
        }
        h2 {
            font-family: 'Sora', sans-serif;
            font-size: 1.4rem;
            font-weight: 700;
        }
        .subtitle { color: var(--text-muted); font-size: 0.85rem; margin-top: 2px; }
        .form-group { margin-bottom: 1.25rem; }
        label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        input, textarea, select {
            width: 100%;
            padding: 0.75rem 1rem;
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            font-family: 'Manrope', sans-serif;
            font-size: 0.95rem;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        input:focus, textarea:focus, select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px oklch(0.55 0.22 260 / 0.15);
        }
        textarea { resize: vertical; min-height: 90px; }
        .row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .required::after { content: ' *'; color: var(--danger); }
        .error-banner {
            background: oklch(0.60 0.22 25 / 0.15);
            border: 1px solid var(--danger);
            border-radius: 10px;
            padding: 0.85rem 1rem;
            margin-bottom: 1.5rem;
            color: oklch(0.80 0.15 25);
            font-size: 0.9rem;
        }
        .btn-group { display: flex; gap: 1rem; margin-top: 2rem; }
        .btn {
            flex: 1;
            padding: 0.85rem 1.5rem;
            border: none;
            border-radius: 10px;
            font-family: 'Manrope', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px oklch(0.55 0.22 260 / 0.4); }
        .btn-secondary {
            background: var(--surface);
            color: var(--text-muted);
            border: 1.5px solid var(--border);
        }
        .btn-secondary:hover { color: var(--text); border-color: var(--text-muted); }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <div class="icon">💊</div>
            <div>
                <h2>${prescription != null ? 'Sửa' : 'Thêm'} thuốc</h2>
                <div class="subtitle">
                    ${prescription != null ? 'Cập nhật thông tin thuốc trong đơn' : 'Thêm thuốc mới vào đơn bệnh án'}
                </div>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="error-banner">⚠️ ${errorMessage}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/doctor/prescriptions">
            <input type="hidden" name="action"         value="${prescription != null ? 'update' : 'create'}">
            <input type="hidden" name="recordId"       value="${param.recordId != null ? param.recordId : prescription.recordId}">
            <c:if test="${prescription != null}">
                <input type="hidden" name="prescriptionId" value="${prescription.prescriptionId}">
            </c:if>

            <div class="form-group">
                <label class="required" for="medicationName">Tên thuốc</label>
                <input type="text" id="medicationName" name="medicationName" list="medication-list" autocomplete="off"
                       value="${prescription.medicationName}"
                       placeholder="VD: Paracetamol, Amoxicillin..."
                       required maxlength="150">
                <datalist id="medication-list">
                    <option value="Paracetamol">Giảm đau, hạ sốt</option>
                    <option value="Amoxicillin">Kháng sinh</option>
                    <option value="Ibuprofen">Kháng viêm, giảm đau</option>
                    <option value="Vitamin C">Bổ sung vitamin</option>
                    <option value="Loratadine">Dị ứng</option>
                    <option value="Cetirizine">Dị ứng</option>
                    <option value="Omeprazole">Dạ dày</option>
                    <option value="Pantoprazole">Dạ dày</option>
                    <option value="Amlodipine">Huyết áp</option>
                    <option value="Aspirin">Huyết áp, tim mạch</option>
                    <option value="Hydrocortisone cream 1%">Bôi da</option>
                    <option value="Erythromycin">Kháng sinh</option>
                    <option value="Alpha Choay">Kháng viêm dạng men</option>
                    <option value="Oresol">Bù nước</option>
                </datalist>
            </div>

            <div class="row">
                <div class="form-group">
                    <label class="required" for="dosage">Liều lượng</label>
                    <input type="text" id="dosage" name="dosage"
                           value="${prescription.dosage}"
                           placeholder="VD: 500mg, 1 viên..."
                           required>
                </div>
                <div class="form-group">
                    <label class="required" for="frequency">Tần suất dùng</label>
                    <input type="text" id="frequency" name="frequency"
                           value="${prescription.frequency}"
                           placeholder="VD: 3 lần/ngày, Sáng - Tối..."
                           required>
                </div>
            </div>

            <div class="form-group">
                <label class="required" for="durationDays">Số ngày dùng thuốc</label>
                <input type="number" id="durationDays" name="durationDays"
                       value="${prescription.durationDays > 0 ? prescription.durationDays : ''}"
                       placeholder="VD: 7"
                       min="1" max="365" required>
            </div>

            <div class="form-group">
                <label for="instructions">Hướng dẫn sử dụng</label>
                <textarea id="instructions" name="instructions"
                          placeholder="VD: Uống sau ăn, không dùng cùng sữa...">${prescription.instructions}</textarea>
            </div>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/doctor/medical-records?action=detail&id=${param.recordId != null ? param.recordId : prescription.recordId}"
                   class="btn btn-secondary">← Quay lại</a>
                <button type="submit" class="btn btn-primary">
                    ${prescription != null ? '💾 Lưu thay đổi' : '➕ Thêm thuốc'}
                </button>
            </div>
        </form>
    </div>
</body>
</html>
