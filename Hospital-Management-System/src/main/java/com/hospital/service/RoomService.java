package com.hospital.service;

import com.hospital.model.Room;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class RoomService {

    private BillService billService;

    public RoomService() {
        this.billService = new BillService();
    }

    public Room getRoom(String roomId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM rooms WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, roomId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Room room = new Room();
            room.setId(rs.getString("id"));
            room.setType(rs.getString("type"));
            room.setPrice(rs.getString("price"));
            room.setAvailability(rs.getString("availability"));
            room.setDescription(rs.getString("description"));
            rs.close();
            stmt.close();
            conn.close();
            return room;
        }
        rs.close();
        stmt.close();
        conn.close();
        return null;
    }

    public List<Room> getAvailableRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM rooms WHERE availability = 'Available'";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Room room = new Room();
            room.setId(rs.getString("id"));
            room.setType(rs.getString("type"));
            room.setPrice(rs.getString("price"));
            room.setAvailability(rs.getString("availability"));
            room.setDescription(rs.getString("description"));
            rooms.add(room);
        }
        rs.close();
        stmt.close();
        conn.close();
        return rooms;
    }
    
    public List<Room> getBookedRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM rooms WHERE availability = 'Booked'";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Room room = new Room();
            room.setId(rs.getString("id"));
            room.setType(rs.getString("type"));
            room.setPrice(rs.getString("price"));
            room.setAvailability(rs.getString("availability"));
            room.setDescription(rs.getString("description"));
            rooms.add(room);
        }
        rs.close();
        stmt.close();
        conn.close();
        return rooms;
    }
    
    public List<Room> getAllRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM rooms";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Room room = new Room();
            room.setId(rs.getString("id"));
            room.setType(rs.getString("type"));
            room.setPrice(rs.getString("price"));
            room.setAvailability(rs.getString("availability"));
            room.setDescription(rs.getString("description"));
            rooms.add(room);
        }
        rs.close();
        stmt.close();
        conn.close();
        return rooms;
    }

    public boolean createRoom(Room room) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "INSERT INTO rooms (id, type, price, availability, description) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, room.getId());
        stmt.setString(2, room.getType());
        stmt.setString(3, room.getPrice());
        stmt.setString(4, room.getAvailability());
        stmt.setString(5, room.getDescription());
        int rowsAffected = stmt.executeUpdate();
        stmt.close();
        conn.close();
        return rowsAffected > 0;
    }

    public boolean deleteRoom(String roomId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "DELETE FROM rooms WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, roomId);
        int rowsAffected = stmt.executeUpdate();
        stmt.close();
        conn.close();
        return rowsAffected > 0;
    }

    public boolean makeRoomAvailable(String roomId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Fetch room details before updating
            String fetchSql = "SELECT patient_id, check_in_date, price FROM rooms WHERE id = ? AND availability = 'Booked'";
            stmt = conn.prepareStatement(fetchSql);
            stmt.setString(1, roomId);
            rs = stmt.executeQuery();
            if (!rs.next()) {
                rs.close();
                stmt.close();
                return false; // Room not booked or doesn’t exist
            }

            String patientId = rs.getString("patient_id");
            Date checkInDate = rs.getDate("check_in_date");
            String priceStr = rs.getString("price");
            rs.close();
            stmt.close();

            // Clean price string (e.g., "$300/day" -> "300")
            String cleanedPrice = priceStr.replaceAll("[^0-9.]", "");
            double pricePerDay;
            try {
                pricePerDay = Double.parseDouble(cleanedPrice);
            } catch (NumberFormatException e) {
                throw new SQLException("Invalid price format: " + priceStr, e);
            }

            // Calculate days stayed
            LocalDate checkIn = checkInDate.toLocalDate();
            LocalDate checkOut = LocalDate.now();
            long daysStayed = ChronoUnit.DAYS.between(checkIn, checkOut);
            if (daysStayed < 1) daysStayed = 1; // Minimum 1 day charge

            // Calculate total
            double totalAmount = daysStayed * pricePerDay;

            // Generate bill
            billService.createBill(patientId, roomId, checkInDate.toString(), checkOut.toString(), (int) daysStayed, totalAmount);

            // Update room to available
            String sql = "UPDATE rooms SET availability = 'Available', patient_id = NULL, check_in_date = NULL, check_out_date = ?, status = NULL WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, Date.valueOf(checkOut));
            stmt.setString(2, roomId);
            int rowsAffected = stmt.executeUpdate();

            conn.commit();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException re) { re.printStackTrace(); }
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}