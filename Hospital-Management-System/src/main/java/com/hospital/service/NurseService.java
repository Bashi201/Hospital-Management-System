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
        String query = "SELECT n.*, nra.room_id AS assigned_room_id FROM nurses n " +
                      "LEFT JOIN nurse_room_assignments nra ON n.id = nra.nurse_id WHERE n.id = ?";
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
                nurse.setAssignedRoomId(rs.getString("assigned_room_id"));
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
        String query = "SELECT n.*, nra.room_id AS assigned_room_id FROM nurses n " +
                      "LEFT JOIN nurse_room_assignments nra ON n.id = nra.nurse_id";
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
                nurse.setAssignedRoomId(rs.getString("assigned_room_id"));
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
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // Delete nurse-room assignments first
            String deleteAssignmentsSQL = "DELETE FROM nurse_room_assignments WHERE nurse_id = ?";
            statement = connection.prepareStatement(deleteAssignmentsSQL);
            statement.setString(1, nurseId.trim());
            statement.executeUpdate();
            statement.close();

            // Delete nurse
            String deleteNurseSQL = "DELETE FROM nurses WHERE id = ?";
            statement = connection.prepareStatement(deleteNurseSQL);
            statement.setString(1, nurseId.trim());
            int rowsAffected = statement.executeUpdate();

            connection.commit();
            return rowsAffected > 0;
        } catch (SQLException e) {
            try {
                if (connection != null) connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Assign Nurse to Room
    public boolean assignNurseToRoom(String nurseId, String roomId) {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            // Validate that the room is booked
            String checkRoomSQL = "SELECT availability FROM rooms WHERE id = ?";
            statement = connection.prepareStatement(checkRoomSQL);
            statement.setString(1, roomId.trim());
            ResultSet rs = statement.executeQuery();
            if (!rs.next() || !rs.getString("availability").equals("Booked")) {
                rs.close();
                statement.close();
                return false; // Room is not booked or does not exist
            }
            rs.close();
            statement.close();

            // Remove any existing assignment for this nurse
            String deleteSQL = "DELETE FROM nurse_room_assignments WHERE nurse_id = ?";
            statement = connection.prepareStatement(deleteSQL);
            statement.setString(1, nurseId.trim());
            statement.executeUpdate();
            statement.close();

            // Insert new assignment
            String insertSQL = "INSERT INTO nurse_room_assignments (nurse_id, room_id) VALUES (?, ?)";
            statement = connection.prepareStatement(insertSQL);
            statement.setString(1, nurseId.trim());
            statement.setString(2, roomId.trim());
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

    // Remove Nurse from Room
    public boolean removeNurseFromRoom(String nurseId) {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            String deleteSQL = "DELETE FROM nurse_room_assignments WHERE nurse_id = ?";
            statement = connection.prepareStatement(deleteSQL);
            statement.setString(1, nurseId.trim());
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
}