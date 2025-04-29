package com.hospital.service;

import com.hospital.model.Nurse;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NurseService {

    // Create Nurse
    public boolean createNurse(Nurse nurse) {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            String sql = "INSERT INTO nurses (id, name, email, phone, shift, filename) VALUES (?, ?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, nurse.getId());
            statement.setString(2, nurse.getName());
            statement.setString(3, nurse.getEmail());
            statement.setString(4, nurse.getPhone());
            statement.setString(5, nurse.getShift());
            statement.setString(6, nurse.getFilename());

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

    // Get Nurse by ID
    public Nurse getNurse(String id) {
        String query = "SELECT * FROM nurses WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Nurse nurse = new Nurse();
                nurse.setId(rs.getString("id"));
                nurse.setName(rs.getString("name"));
                nurse.setEmail(rs.getString("email"));
                nurse.setPhone(rs.getString("phone"));
                nurse.setShift(rs.getString("shift"));
                nurse.setFilename(rs.getString("filename"));
                return nurse;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get All Nurses
    public List<Nurse> getAllNurses() {
        List<Nurse> nurses = new ArrayList<>();
        String query = "SELECT * FROM nurses";
        try (Connection connection = DBConnection.getConnection();
             Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Nurse nurse = new Nurse();
                nurse.setId(rs.getString("id"));
                nurse.setName(rs.getString("name"));
                nurse.setEmail(rs.getString("email"));
                nurse.setPhone(rs.getString("phone"));
                nurse.setShift(rs.getString("shift"));
                nurse.setFilename(rs.getString("filename"));
                nurses.add(nurse);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nurses;
    }

    // Update Nurse
    public boolean updateNurse(Nurse nurse) {
        String query = "UPDATE nurses SET name = ?, email = ?, phone = ?, shift = ?, filename = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, nurse.getName());
            stmt.setString(2, nurse.getEmail());
            stmt.setString(3, nurse.getPhone());
            stmt.setString(4, nurse.getShift());
            stmt.setString(5, nurse.getFilename());
            stmt.setString(6, nurse.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete Nurse
    public boolean deleteNurse(String nurseId) {
        String deleteSQL = "DELETE FROM nurses WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(deleteSQL)) {
            statement.setString(1, nurseId.trim());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}