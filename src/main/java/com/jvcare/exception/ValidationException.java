package com.jvcare.exception;

/**
 * Ngoại lệ dùng khi dữ liệu đầu vào không hợp lệ (Validation Layer).
 * Ném ra khi dữ liệu từ người dùng vi phạm ràng buộc: để trống, sai định dạng,
 * ngoài phạm vi hợp lệ (huyết áp, nhịp tim, nhiệt độ, v.v.).
 */
public class ValidationException extends BusinessException {

    private String fieldName;

    public ValidationException(String message) {
        super(message);
    }

    public ValidationException(String fieldName, String message) {
        super(message);
        this.fieldName = fieldName;
    }

    public String getFieldName() {
        return fieldName;
    }
}
