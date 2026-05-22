package com.jvcare.dto;

import java.util.Map;

public class StatisticsDTO {
    // User statistics
    private int totalUsers;
    private int totalAdmins;
    private int totalDoctors;
    private int totalPatients;
    
    // Appointment statistics
    private int totalAppointments;
    private int pendingAppointments;
    private int confirmedAppointments;
    private int completedAppointments;
    private int cancelledAppointments;
    
    // Medical record statistics
    private int totalRecords;
    private int totalPrescriptions;
    
    // Chart data
    private Map<Integer, Integer> appointmentsByMonth;
    private Map<String, Integer> appointmentsByStatus;
    private Map<String, Integer> usersByRole;

    public StatisticsDTO() {}

    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }

    public int getTotalAdmins() { return totalAdmins; }
    public void setTotalAdmins(int totalAdmins) { this.totalAdmins = totalAdmins; }

    public int getTotalDoctors() { return totalDoctors; }
    public void setTotalDoctors(int totalDoctors) { this.totalDoctors = totalDoctors; }

    public int getTotalPatients() { return totalPatients; }
    public void setTotalPatients(int totalPatients) { this.totalPatients = totalPatients; }

    public int getTotalAppointments() { return totalAppointments; }
    public void setTotalAppointments(int totalAppointments) { this.totalAppointments = totalAppointments; }

    public int getPendingAppointments() { return pendingAppointments; }
    public void setPendingAppointments(int pendingAppointments) { this.pendingAppointments = pendingAppointments; }

    public int getConfirmedAppointments() { return confirmedAppointments; }
    public void setConfirmedAppointments(int confirmedAppointments) { this.confirmedAppointments = confirmedAppointments; }

    public int getCompletedAppointments() { return completedAppointments; }
    public void setCompletedAppointments(int completedAppointments) { this.completedAppointments = completedAppointments; }

    public int getCancelledAppointments() { return cancelledAppointments; }
    public void setCancelledAppointments(int cancelledAppointments) { this.cancelledAppointments = cancelledAppointments; }

    public int getTotalRecords() { return totalRecords; }
    public void setTotalRecords(int totalRecords) { this.totalRecords = totalRecords; }

    public int getTotalPrescriptions() { return totalPrescriptions; }
    public void setTotalPrescriptions(int totalPrescriptions) { this.totalPrescriptions = totalPrescriptions; }

    public Map<Integer, Integer> getAppointmentsByMonth() { return appointmentsByMonth; }
    public void setAppointmentsByMonth(Map<Integer, Integer> appointmentsByMonth) { this.appointmentsByMonth = appointmentsByMonth; }

    public Map<String, Integer> getAppointmentsByStatus() { return appointmentsByStatus; }
    public void setAppointmentsByStatus(Map<String, Integer> appointmentsByStatus) { this.appointmentsByStatus = appointmentsByStatus; }

    public Map<String, Integer> getUsersByRole() { return usersByRole; }
    public void setUsersByRole(Map<String, Integer> usersByRole) { this.usersByRole = usersByRole; }
}
