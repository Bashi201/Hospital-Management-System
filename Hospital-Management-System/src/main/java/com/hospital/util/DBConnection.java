package com.hospital.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("JDBC Driver loaded successfully.");

            // Attempt to establish the connection
            System.out.println("Attempting to connect to the database...");
            conn = DriverManager.getConnection(
                ConnectionData.URL,
                ConnectionData.USERNAME,
                ConnectionData.PASSWORD
            );
            System.out.println("Database connection established successfully.");
            return conn;
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found.");
            e.printStackTrace();
            return null;
        } catch (SQLException e) {
            System.out.println("Connection failed! Error: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            // Optional: Close the connection if something goes wrong (for testing)
            if (conn == null) {
                System.out.println("Failed to establish a database connection.");
            }
        }
    }
}