package com.jvcare.controller;

import com.jvcare.dao.PatientDAO;
import com.jvcare.dao.AppointmentDAO;
import com.jvcare.model.Patient;
import com.jvcare.model.Appointment;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    
    private PatientDAO patientDAO = new PatientDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String query = request.getParameter("q");
        String type = request.getParameter("type"); // patient, doctor, appointment
        
        if (query == null || query.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        Map<String, Object> results = new HashMap<>();
        
        if ("patient".equals(type)) {
            results.put("patients", searchPatients(query));
        } else if ("appointment".equals(type)) {
            results.put("appointments", searchAppointments(query));
        } else {
            // Search all
            results.put("patients", searchPatients(query));
            results.put("appointments", searchAppointments(query));
        }
        
        // Return JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Gson gson = new Gson();
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(results));
        out.flush();
    }
    
    private List<Map<String, String>> searchPatients(String query) {
        List<Map<String, String>> results = new ArrayList<>();
        List<Patient> patients = patientDAO.getAllPatients();
        
        for (Patient p : patients) {
            if (matchesQuery(p, query)) {
                Map<String, String> item = new HashMap<>();
                item.put("id", String.valueOf(p.getPatientId()));
                item.put("name", p.getFullName());
                item.put("code", p.getPatientCode());
                item.put("phone", p.getPhone());
                results.add(item);
                
                if (results.size() >= 10) break; // Limit results
            }
        }
        return results;
    }
    
    private List<Map<String, String>> searchAppointments(String query) {
        List<Map<String, String>> results = new ArrayList<>();
        List<Appointment> appointments = appointmentDAO.searchAppointments(query);
        
        for (Appointment a : appointments) {
            Map<String, String> item = new HashMap<>();
            item.put("id", String.valueOf(a.getAppointmentId()));
            item.put("patientName", a.getPatientName());
            item.put("date", a.getAppointmentDate().toString());
            item.put("time", a.getAppointmentTime().toString());
            item.put("status", a.getStatus());
            item.put("reason", a.getReason());
            results.add(item);
            
            if (results.size() >= 10) break; // Limit results
        }
        return results;
    }
    
    private boolean matchesQuery(Patient p, String query) {
        String q = query.toLowerCase();
        return (p.getFullName() != null && p.getFullName().toLowerCase().contains(q)) ||
               (p.getPatientCode() != null && p.getPatientCode().toLowerCase().contains(q)) ||
               (p.getPhone() != null && p.getPhone().contains(q));
    }
}
