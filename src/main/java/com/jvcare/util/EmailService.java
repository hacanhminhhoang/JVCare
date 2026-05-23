package com.jvcare.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import io.github.cdimascio.dotenv.Dotenv;

public class EmailService {
    
    private static final Dotenv dotenv = Dotenv.load();
    private static final String SMTP_HOST = dotenv.get("SMTP_HOST", "smtp.gmail.com");
    private static final String SMTP_PORT = dotenv.get("SMTP_PORT", "587");
    private static final String SMTP_USER = dotenv.get("SMTP_USER");
    private static final String SMTP_PASSWORD = dotenv.get("SMTP_PASSWORD");
    
    /**
     * Gửi email xác nhận lịch hẹn
     */
    public static boolean sendAppointmentConfirmation(String toEmail, String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        String subject = "Xác nhận lịch hẹn - JVCare";
        String body = buildAppointmentConfirmationEmail(patientName, appointmentDate, 
                                                        appointmentTime, doctorName);
        
        return sendEmail(toEmail, subject, body);
    }
    
    /**
     * Gửi email nhắc nhở lịch hẹn
     */
    public static boolean sendAppointmentReminder(String toEmail, String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        String subject = "Nhắc nhở lịch hẹn - JVCare";
        String body = buildAppointmentReminderEmail(patientName, appointmentDate, 
                                                     appointmentTime, doctorName);
        
        return sendEmail(toEmail, subject, body);
    }
    
    /**
     * Gửi email hủy lịch hẹn
     */
    public static boolean sendAppointmentCancellation(String toEmail, String patientName, 
            String appointmentDate, String appointmentTime) {
        
        String subject = "Thông báo hủy lịch hẹn - JVCare";
        String body = buildAppointmentCancellationEmail(patientName, appointmentDate, appointmentTime);
        
        return sendEmail(toEmail, subject, body);
    }
    
    /**
     * Core method để gửi email
     */
    private static boolean sendEmail(String toEmail, String subject, String body) {
        
        if (SMTP_USER == null || SMTP_PASSWORD == null) {
            System.err.println("SMTP credentials not configured in .env");
            return false;
        }
        
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, "JVCare System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            Transport.send(message);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Build HTML email template cho xác nhận lịch hẹn
     */
    private static String buildAppointmentConfirmationEmail(String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        return "<!DOCTYPE html>" +
               "<html><head><meta charset='UTF-8'></head><body>" +
               "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
               "<h2 style='color: #2c3e50;'>Xác nhận lịch hẹn</h2>" +
               "<p>Kính gửi <strong>" + patientName + "</strong>,</p>" +
               "<p>Lịch hẹn của bạn đã được xác nhận:</p>" +
               "<div style='background: #f8f9fa; padding: 15px; border-radius: 5px;'>" +
               "<p><strong>Ngày:</strong> " + appointmentDate + "</p>" +
               "<p><strong>Giờ:</strong> " + appointmentTime + "</p>" +
               "<p><strong>Bác sĩ:</strong> " + doctorName + "</p>" +
               "</div>" +
               "<p>Vui lòng đến đúng giờ. Xin cảm ơn!</p>" +
               "<hr style='border: 1px solid #eee;'>" +
               "<p style='color: #7f8c8d; font-size: 12px;'>JVCare - Hệ thống quản lý bệnh án</p>" +
               "</div></body></html>";
    }
    
    private static String buildAppointmentReminderEmail(String patientName, 
            String appointmentDate, String appointmentTime, String doctorName) {
        
        return "<!DOCTYPE html>" +
               "<html><head><meta charset='UTF-8'></head><body>" +
               "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
               "<h2 style='color: #e74c3c;'>Nhắc nhở lịch hẹn</h2>" +
               "<p>Kính gửi <strong>" + patientName + "</strong>,</p>" +
               "<p>Đây là lời nhắc về lịch hẹn của bạn vào ngày mai:</p>" +
               "<div style='background: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107;'>" +
               "<p><strong>Ngày:</strong> " + appointmentDate + "</p>" +
               "<p><strong>Giờ:</strong> " + appointmentTime + "</p>" +
               "<p><strong>Bác sĩ:</strong> " + doctorName + "</p>" +
               "</div>" +
               "<p>Vui lòng đến đúng giờ. Nếu không thể đến, vui lòng hủy lịch trước 24 giờ.</p>" +
               "<hr style='border: 1px solid #eee;'>" +
               "<p style='color: #7f8c8d; font-size: 12px;'>JVCare - Hệ thống quản lý bệnh án</p>" +
               "</div></body></html>";
    }
    
    private static String buildAppointmentCancellationEmail(String patientName, 
            String appointmentDate, String appointmentTime) {
        
        return "<!DOCTYPE html>" +
               "<html><head><meta charset='UTF-8'></head><body>" +
               "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
               "<h2 style='color: #e74c3c;'>Thông báo hủy lịch hẹn</h2>" +
               "<p>Kính gửi <strong>" + patientName + "</strong>,</p>" +
               "<p>Lịch hẹn của bạn đã được hủy:</p>" +
               "<div style='background: #f8d7da; padding: 15px; border-radius: 5px; border-left: 4px solid #dc3545;'>" +
               "<p><strong>Ngày:</strong> " + appointmentDate + "</p>" +
               "<p><strong>Giờ:</strong> " + appointmentTime + "</p>" +
               "</div>" +
               "<p>Nếu bạn muốn đặt lịch mới, vui lòng truy cập hệ thống.</p>" +
               "<hr style='border: 1px solid #eee;'>" +
               "<p style='color: #7f8c8d; font-size: 12px;'>JVCare - Hệ thống quản lý bệnh án</p>" +
               "</div></body></html>";
    }
}
