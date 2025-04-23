package com.hospital.service;

import com.hospital.model.Room;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomService {

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
}
