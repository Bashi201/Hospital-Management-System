package com.hospital.service;

import com.hospital.model.Admin;

import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminService {

    // Create Admin
	public boolean createAdmin(Admin admin) {
	    Connection connection = null;
	    PreparedStatement statement = null;
	    try {
	        connection = DBConnection.getConnection();  // Your DB connection method
	        String sql = "INSERT INTO admins (id, name, email, password, filename) VALUES (?, ?, ?, ?, ?)";
	        statement = connection.prepareStatement(sql);
	        statement.setString(1, admin.getId());
	        statement.setString(2, admin.getName());
	        statement.setString(3, admin.getEmail());
	        statement.setString(4, admin.getPassword());
	        statement.setString(5, admin.getFilename());

	        int rowsAffected = statement.executeUpdate();
	        return rowsAffected > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        // Close resources
	        if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
	        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
	}

    // Get Admin by ID
    public Admin getAdmin(String id) {
        String query = "SELECT * FROM admins WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getString("id"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                admin.setFilename(rs.getString("filename"));
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get All Admins
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        String query = "SELECT * FROM admins";
        try (Connection connection = DBConnection.getConnection();
             Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getString("id"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                admin.setFilename(rs.getString("filename"));
                admins.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admins;
    }

    // Update Admin
    public boolean updateAdmin(Admin admin) {
        String query = "UPDATE admins SET name = ?, email = ?, password = ?, filename = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, admin.getName());
            stmt.setString(2, admin.getEmail());
            stmt.setString(3, admin.getPassword());
            stmt.setString(4, admin.getFilename());
            stmt.setString(5, admin.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    // Delete Admin
    public boolean deleteAdmin(String adminId) {
        String deleteSQL = "DELETE FROM admins WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(deleteSQL)) {

            if (connection == null) {
                System.err.println("Error: Database connection is null!");
                return false;
            }

            statement.setString(1, adminId.trim()); // Trim to avoid whitespace issues

            System.out.println("Executing query: " + deleteSQL + " with id = '" + adminId + "'");
            int rowsAffected = statement.executeUpdate();
            
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected == 0) {
                System.err.println("No admin found with id: '" + adminId + "'");
            }

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }



	public boolean hasAdmin() {
		// TODO Auto-generated method stub
		return false;
	}
}