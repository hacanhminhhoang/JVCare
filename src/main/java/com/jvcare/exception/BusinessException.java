package com.jvcare.exception;

/**
 * Ngoại lệ dùng cho lớp Business Logic (Service Layer).
 * Ném ra khi vi phạm quy tắc nghiệp vụ, ví dụ: lịch hẹn chưa hoàn thành,
 * bác sĩ không có quyền sửa bệnh án của người khác, v.v.
 */
public class BusinessException extends Exception {

    public BusinessException(String message) {
        super(message);
    }

    public BusinessException(String message, Throwable cause) {
        super(message, cause);
    }
}
