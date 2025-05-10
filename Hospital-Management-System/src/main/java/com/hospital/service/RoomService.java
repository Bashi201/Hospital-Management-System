package com.hospital.service;

import com.hospital.model.Room;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class RoomService {

    private static final Logger LOGGER = Logger.getLogger(RoomService.class.getName());
    private final BillService billService;

    public RoomService() {
        this.billService = new BillService();
    }

    public Room getRoom(String roomId) throws SQLException {
        if (roomId == null || roomId.trim().isEmpty()) {
            LOGGER.warning("Invalid roomId provided: " + roomId);
            throw new IllegalArgumentException("Room ID cannot be null or empty");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "SELECT * FROM rooms WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, roomId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                Room room = new Room();
                room.setId(rs.getString("id"));
                room.setType(rs.getString("type"));
                room.setPrice(rs.getString("price"));
                room.setAvailability(rs.getString("availability"));
                room.setDescription(rs.getString("description"));
                LOGGER.info("Retrieved room with ID: " + roomId);
                return room;
            }
            LOGGER.info("No room found with ID: " + roomId);
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching room with ID: " + roomId + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in getRoom", e);
            }
        }
    }

    public List<Room> getAvailableRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "SELECT * FROM rooms WHERE availability = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "Available");
            rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getString("id"));
                room.setType(rs.getString("type"));
                room.setPrice(rs.getString("price"));
                room.setAvailability(rs.getString("availability"));
                room.setDescription(rs.getString("description"));
                rooms.add(room);
            }
            LOGGER.info("Retrieved " + rooms.size() + " available rooms");
            return rooms;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching available rooms, SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in getAvailableRooms", e);
            }
        }
    }

    public List<Room> getBookedRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "SELECT * FROM rooms WHERE availability = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "Booked");
            rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getString("id"));
                room.setType(rs.getString("type"));
                room.setPrice(rs.getString("price"));
                room.setAvailability(rs.getString("availability"));
                room.setDescription(rs.getString("description"));
                rooms.add(room);
            }
            LOGGER.info("Retrieved " + rooms.size() + " booked rooms");
            return rooms;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching booked rooms, SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in getBookedRooms", e);
            }
        }
    }

    public List<Room> getAllRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "SELECT * FROM rooms";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getString("id"));
                room.setType(rs.getString("type"));
                room.setPrice(rs.getString("price"));
                room.setAvailability(rs.getString("availability"));
                room.setDescription(rs.getString("description"));
                rooms.add(room);
            }
            LOGGER.info("Retrieved " + rooms.size() + " rooms");
            return rooms;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all rooms, SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in getAllRooms", e);
            }
        }
    }

    public boolean createRoom(Room room) throws SQLException {
        if (room == null || room.getId() == null || room.getId().trim().isEmpty() ||
            room.getType() == null || room.getPrice() == null || room.getAvailability() == null) {
            LOGGER.warning("Invalid room object provided: " + (room != null ? room.toString() : "null"));
            throw new IllegalArgumentException("Room and its required fields cannot be null or empty");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "INSERT INTO rooms (id, type, price, availability, description) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, room.getId());
            stmt.setString(2, room.getType());
            stmt.setString(3, room.getPrice());
            stmt.setString(4, room.getAvailability());
            stmt.setString(5, room.getDescription() != null ? room.getDescription() : "");
            int rowsAffected = stmt.executeUpdate();
            LOGGER.info("Created room with ID: " + room.getId() + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating room with ID: " + room.getId() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in createRoom", e);
            }
        }
    }

    public boolean deleteRoom(String roomId) throws SQLException {
        if (roomId == null || roomId.trim().isEmpty()) {
            LOGGER.warning("Invalid roomId provided: " + roomId);
            throw new IllegalArgumentException("Room ID cannot be null or empty");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "DELETE FROM rooms WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, roomId);
            int rowsAffected = stmt.executeUpdate();
            LOGGER.info("Deleted room with ID: " + roomId + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting room with ID: " + roomId + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in deleteRoom", e);
            }
        }
    }

    public boolean makeRoomAvailable(String roomId) throws SQLException {
        if (roomId == null || roomId.trim().isEmpty()) {
            LOGGER.warning("Invalid roomId provided: " + roomId);
            throw new IllegalArgumentException("Room ID cannot be null or empty");
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            conn.setAutoCommit(false);

            // Fetch room details
            String fetchSql = "SELECT patient_id, check_in_date, price FROM rooms WHERE id = ? AND availability = 'Booked'";
            stmt = conn.prepareStatement(fetchSql);
            stmt.setString(1, roomId);
            rs = stmt.executeQuery();
            if (!rs.next()) {
                LOGGER.info("Room with ID: " + roomId + " is not booked or does not exist");
                return false;
            }

            String patientId = rs.getString("patient_id");
            Date checkInDate = rs.getDate("check_in_date");
            String priceStr = rs.getString("price");
            rs.close();
            stmt.close();

            if (patientId == null || checkInDate == null) {
                LOGGER.warning("Room with ID: " + roomId + " has incomplete booking data: patientId=" + patientId + ", checkInDate=" + checkInDate);
                return false;
            }

            // Parse price (assuming price is stored as a numeric string, e.g., "300.00")
            double pricePerDay;
            try {
                pricePerDay = Double.parseDouble(priceStr.replaceAll("[^0-9.]", ""));
            } catch (NumberFormatException e) {
                LOGGER.log(Level.SEVERE, "Invalid price format for room ID: " + roomId + ", price: " + priceStr, e);
                throw new SQLException("Invalid price format: " + priceStr, e);
            }

            // Calculate days stayed
            LocalDate checkIn = checkInDate.toLocalDate();
            LocalDate checkOut = LocalDate.now();
            long daysStayed = ChronoUnit.DAYS.between(checkIn, checkOut);
            if (daysStayed < 1) daysStayed = 1; // Minimum 1 day charge

            // Calculate total amount
            double totalAmount = daysStayed * pricePerDay;

            // Generate bill using BillService.createRoomBill
            billService.createRoomBill(
                patientId,
                roomId,
                checkIn.toString(),
                checkOut.toString(),
                (int) daysStayed,
                totalAmount
            );

            // Update room to available
            String sql = "UPDATE rooms SET availability = 'Available', patient_id = NULL, check_in_date = NULL, check_out_date = ?, status = NULL WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, Date.valueOf(checkOut));
            stmt.setString(2, roomId);
            int rowsAffected = stmt.executeUpdate();

            conn.commit();
            LOGGER.info("Made room available with ID: " + roomId + ", bill created for patientId: " + patientId + ", totalAmount: " + totalAmount);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error making room available with ID: " + roomId + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException re) {
                    LOGGER.log(Level.WARNING, "Error rolling back transaction for room ID: " + roomId, re);
                }
            }
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in makeRoomAvailable", e);
            }
        }
    }
}