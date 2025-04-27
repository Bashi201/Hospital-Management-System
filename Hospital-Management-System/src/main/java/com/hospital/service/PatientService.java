package com.hospital.service;

import com.hospital.model.Patient;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientService {

    public List<Patient> getAllPatients() throws SQLException {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                Patient patient = new Patient();
                patient.setId(resultSet.getString("id"));
                patient.setPhoneNumber(resultSet.getString("phone_number"));
                patient.setName(resultSet.getString("name"));
                patient.setGender(resultSet.getString("gender"));
                patient.setAdmittedTime(resultSet.getString("admitted_time"));
                patient.setGmail(resultSet.getString("gmail"));
                patient.setPassword(resultSet.getString("password"));
                patients.add(patient);
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getAllPatients: " + e.getMessage());
            throw e;
        }
        return patients;
    }

    public boolean createPatient(Patient patient) throws SQLException {
        String sql = "INSERT INTO patients (id, phone_number, name, gender, admitted_time, gmail, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
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
            System.out.println("SQL Error in createPatient: " + e.getMessage());
            throw e;
        }
    }

    public boolean deletePatient(String id) throws SQLException {
        String sql = "DELETE FROM patients WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, id);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error in deletePatient: " + e.getMessage());
            throw e;
        }
    }

    public int getAvailableAmbulanceCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ambulances WHERE availability = 'available'";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1); // Get the count from the first column
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getAvailableAmbulanceCount: " + e.getMessage());
            throw e;
        }
        return 0;
    }

    public boolean sendAmbulance(String patientId, String pickupLocation, String destination, String requestDate, String requestTime) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false); // Start transaction

            // Check available ambulances
            int availableAmbulances = getAvailableAmbulanceCount();
            if (availableAmbulances <= 0) {
                connection.rollback();
                return false; // No ambulances available
            }

            // Insert booking
            String sql = "INSERT INTO ambulance_bookings (patient_id, pickup_location, destination, request_date, request_time, status) VALUES (?, ?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, patientId);
            statement.setString(2, pickupLocation);
            statement.setString(3, destination);
            statement.setString(4, requestDate);
            statement.setString(5, requestTime);
            statement.setString(6, "Dispatched");
            int rowsAffected = statement.executeUpdate();
            statement.close();

            // Update the available ambulances count
            String updateSql = "UPDATE ambulances SET availability = 'unavailable' WHERE availability = 'available' LIMIT 1";
            statement = connection.prepareStatement(updateSql);
            int updatedRows = statement.executeUpdate();

            if (updatedRows == 0) {
                connection.rollback();
                return false; // No ambulances were available to update
            }

            connection.commit();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException re) {
                    System.out.println("Rollback failed in sendAmbulance: " + re.getMessage());
                }
            }
            System.out.println("SQL Error in sendAmbulance: " + e.getMessage());
            throw e;
        } finally {
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException e) {
                    System.out.println("Error closing statement in sendAmbulance: " + e.getMessage());
                }
            }
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection in sendAmbulance: " + e.getMessage());
                }
            }
        }
    }
}