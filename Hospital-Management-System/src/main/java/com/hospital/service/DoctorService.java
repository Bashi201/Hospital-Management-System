package com.hospital.service;

import com.hospital.model.Doctor;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorService {

    // Fetch a single doctor by ID
    public Doctor getDoctor(String doctorId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            rs.close();
            stmt.close();
            conn.close();
            return doctor;
        }
        rs.close();
        stmt.close();
        conn.close();
        return null;
    }

    // Fetch multiple doctors (e.g., for DoctorProfile.jsp, limited to 2)
    public List<Doctor> getMultipleDoctors() throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors LIMIT 2"; // Fetch 2 doctors for now
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            doctors.add(doctor);
        }
        rs.close();
        stmt.close();
        conn.close();
        return doctors;
    }

    // Authenticate doctor by email and password
    public Doctor authenticateDoctor(String email, String password) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors WHERE email = ? AND password = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            rs.close();
            stmt.close();
            conn.close();
            return doctor;
        }
        rs.close();
        stmt.close();
        conn.close();
        return null;
    }

    // Fetch all doctors
    public List<Doctor> getAllDoctors() throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            doctors.add(doctor);
        }
        rs.close();
        stmt.close();
        conn.close();
        return doctors;
    }

    // Create a new doctor
    public boolean createDoctor(Doctor doctor) {
        String sql = "INSERT INTO doctors (id, name, specialty, qualifications, email, phone, picture, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, doctor.getId());
            stmt.setString(2, doctor.getName());
            stmt.setString(3, doctor.getSpecialty());
            stmt.setString(4, doctor.getQualifications());
            stmt.setString(5, doctor.getEmail());
            stmt.setString(6, doctor.getPhone());
            stmt.setString(7, doctor.getPicture());
            stmt.setString(8, doctor.getPassword());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update an existing doctor
    public boolean updateDoctor(Doctor doctor) {
        String sql = "UPDATE doctors SET name = ?, specialty = ?, qualifications = ?, email = ?, phone = ?, picture = ?, password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, doctor.getName());
            stmt.setString(2, doctor.getSpecialty());
            stmt.setString(3, doctor.getQualifications());
            stmt.setString(4, doctor.getEmail());
            stmt.setString(5, doctor.getPhone());
            stmt.setString(6, doctor.getPicture());
            stmt.setString(7, doctor.getPassword());
            stmt.setString(8, doctor.getId());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a doctor by ID
    public boolean deleteDoctor(String doctorId) {
        String sql = "DELETE FROM doctors WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, doctorId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Fetch all appointments for a specific doctor
    public List<Appointment> getAppointmentsForDoctor(String doctorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT a.id, a.patient_id, a.appointment_date, a.appointment_time, a.status, p.name AS patient_name " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.id " +
                    "WHERE a.doctor_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Appointment appointment = new Appointment();
            appointment.setId(rs.getInt("id"));
            appointment.setPatientId(rs.getString("patient_id"));
            appointment.setPatientName(rs.getString("patient_name"));
            appointment.setDate(rs.getString("appointment_date"));
            appointment.setTime(rs.getString("appointment_time"));
            appointment.setStatus(rs.getString("status"));
            appointments.add(appointment);
        }
        rs.close();
        stmt.close();
        conn.close();
        return appointments;
    }

    // Delete an appointment by ID
    public boolean deleteAppointment(int appointmentId) throws SQLException {
        String sql = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Confirm an appointment by updating its status to "Confirmed"
    public boolean confirmAppointment(int appointmentId) throws SQLException {
        String sql = "UPDATE appointments SET status = 'Confirmed' WHERE id = ? AND status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Inner class to represent an appointment
    public static class Appointment {
        private int id;
        private String patientId;
        private String patientName;
        private String date;
        private String time;
        private String status;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }
        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public String getTime() { return time; }
        public void setTime(String time) { this.time = time; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
}