package com.jvcare.exception;

/**
 * Exception cho các lỗi validation
 */
public class ValidationException extends Exception {
    
    public ValidationException(String message) {
        super(message);
    }
}
