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

    // New method to fetch all doctors for the channeling form
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
}