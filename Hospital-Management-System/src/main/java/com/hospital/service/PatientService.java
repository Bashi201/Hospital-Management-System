package com.hospital.service;

import com.hospital.model.Patient;

import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientService {

    // Create Patient
    public boolean createPatient(Patient patient) {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            String sql = "INSERT INTO patients (id, phone_number, name, gender, admitted_time, gmail, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, patient.getId());
            statement.setString(2, patient.getPhoneNumber());
            statement.setString(3, patient.getName());
            statement.setString(4, patient.getGender());
            statement.setString(5, patient.getAdmittedTime());
            statement.setString(6, patient.getGmail());
            statement.setString(7, patient.getPassword());

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Get Patient by ID
    public Patient getPatient(String id) {
        String query = "SELECT * FROM patients WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Patient patient = new Patient();
                patient.setId(rs.getString("id"));
                patient.setPhoneNumber(rs.getString("phone_number"));
                patient.setName(rs.getString("name"));
                patient.setGender(rs.getString("gender"));
                patient.setAdmittedTime(rs.getString("admitted_time"));
                patient.setGmail(rs.getString("gmail"));
                patient.setPassword(rs.getString("password"));
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get All Patients
    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT * FROM patients";
        try (Connection connection = DBConnection.getConnection();
             Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setId(rs.getString("id"));
                patient.setPhoneNumber(rs.getString("phone_number"));
                patient.setName(rs.getString("name"));
                patient.setGender(rs.getString("gender"));
                patient.setAdmittedTime(rs.getString("admitted_time"));
                patient.setGmail(rs.getString("gmail"));
                patient.setPassword(rs.getString("password"));
                patients.add(patient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    // Update Patient
    public boolean updatePatient(Patient patient) {
        String query = "UPDATE patients SET phone_number = ?, name = ?, gender = ?, admitted_time = ?, gmail = ?, password = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, patient.getPhoneNumber());
            stmt.setString(2, patient.getName());
            stmt.setString(3, patient.getGender());
            stmt.setString(4, patient.getAdmittedTime());
            stmt.setString(5, patient.getGmail());
            stmt.setString(6, patient.getPassword());
            stmt.setString(7, patient.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete Patient
    public boolean deletePatient(String patientId) {
        String deleteSQL = "DELETE FROM patients WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(deleteSQL)) {

            if (connection == null) {
                System.err.println("Error: Database connection is null!");
                return false;
            }

            statement.setString(1, patientId.trim());

            System.out.println("Executing query: " + deleteSQL + " with id = '" + patientId + "'");
            int rowsAffected = statement.executeUpdate();
            
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected == 0) {
                System.err.println("No patient found with id: '" + patientId + "'");
            }

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    //Add a bookRoom method to save the room booking to the database:
    public boolean bookRoom(String patientId, String roomId, String checkInDate, String checkOutDate) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();

            // Check if the room is available
            String checkSql = "SELECT availability FROM rooms WHERE id = ?";
            statement = connection.prepareStatement(checkSql);
            statement.setString(1, roomId);
            ResultSet rs = statement.executeQuery();
            if (!rs.next() || !"Available".equals(rs.getString("availability"))) {
                rs.close();
                statement.close();
                return false; // Room not available or doesn’t exist
            }
            rs.close();
            statement.close();

            // Update the room with booking details
            String sql = "UPDATE rooms SET patient_id = ?, check_in_date = ?, check_out_date = ?, status = 'Pending', availability = 'Booked' " +
                        "WHERE id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, patientId);
            statement.setDate(2, Date.valueOf(checkInDate));
            statement.setDate(3, Date.valueOf(checkOutDate));
            statement.setString(4, roomId);
            int rowsAffected = statement.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error in bookRoom: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    
    public boolean bookAppointment(String patientId, String doctorId, String appointmentDate, String appointmentTime) throws SQLException {
        String sql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, patientId);
            stmt.setString(2, doctorId);
            stmt.setString(3, appointmentDate);
            stmt.setString(4, appointmentTime);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean hasPatient() {
        // TODO: Implement logic to check if any patients exist
        return false;
    }
}