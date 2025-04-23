package com.hospital.util;

public class ConnectionData {
    // Database connection details
    public static final String DATABASE = "hospitalmanagementsystem";
    public static final String URL = "jdbc:mysql://localhost:3306/" + DATABASE + "?useSSL=false&serverTimezone=UTC";
    public static final String USERNAME = "root";
    public static final String PASSWORD = ""; // Ensure this matches your MySQL password

    // For debugging: Log the connection details (remove in production)
    static {
        System.out.println("Connection URL: " + URL);
        System.out.println("Username: " + USERNAME);
        System.out.println("Password: " + PASSWORD);
    }
}