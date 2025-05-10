package com.hospital.service;

import com.hospital.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class BillService {
    private static final Logger LOGGER = Logger.getLogger(BillService.class.getName());

    public boolean createBill(String patientId, String roomId, String checkInDate, String checkOutDate, int daysStayed, double totalAmount) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO bills (patient_id, room_id, check_in_date, check_out_date, days_stayed, total_amount, payment_status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, patientId);
            stmt.setString(2, roomId);
            stmt.setDate(3, Date.valueOf(checkInDate));
            stmt.setDate(4, Date.valueOf(checkOutDate));
            stmt.setInt(5, daysStayed);
            stmt.setDouble(6, totalAmount);
            stmt.setString(7, "Pending");
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating bill for patientId: " + patientId + ", roomId: " + roomId, e);
            throw e;
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public Bill getBillByPatientAndRoom(String patientId, String roomId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM bills WHERE patient_id = ? AND room_id = ? AND payment_status = 'Pending'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, patientId);
            stmt.setString(2, roomId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setPatientId(rs.getString("patient_id"));
                bill.setRoomId(rs.getString("room_id"));
                bill.setCheckInDate(rs.getDate("check_in_date").toString());
                bill.setCheckOutDate(rs.getDate("check_out_date").toString());
                bill.setDaysStayed(rs.getInt("days_stayed"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaymentStatus(rs.getString("payment_status"));
                bill.setPaymentDate(rs.getDate("payment_date") != null ? rs.getDate("payment_date").toString() : null);
                return bill;
            }
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching bill for patientId: " + patientId + ", roomId: " + roomId, e);
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public List<Bill> getPendingBillsByPatient(String patientId) throws SQLException {
        if (patientId == null || patientId.trim().isEmpty()) {
            LOGGER.warning("Invalid patientId provided to getPendingBillsByPatient: " + patientId);
            throw new IllegalArgumentException("Patient ID cannot be null or empty");
        }

        List<Bill> bills = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "SELECT * FROM bills WHERE patient_id = ? AND payment_status = 'Pending'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, patientId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setPatientId(rs.getString("patient_id"));
                bill.setRoomId(rs.getString("room_id"));
                bill.setCheckInDate(rs.getDate("check_in_date").toString());
                bill.setCheckOutDate(rs.getDate("check_out_date").toString());
                bill.setDaysStayed(rs.getInt("days_stayed"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaymentStatus(rs.getString("payment_status"));
                bill.setPaymentDate(rs.getDate("payment_date") != null ? rs.getDate("payment_date").toString() : null);
                bills.add(bill);
            }
            LOGGER.info("Retrieved " + bills.size() + " pending bills for patientId: " + patientId);
            return bills;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching pending bills for patientId: " + patientId, e);
            throw new SQLException("Database error while fetching bills: " + e.getMessage(), e);
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public boolean processPayment(int billId, String cardNumber, String expiry, String cvv) throws SQLException {
        if (cardNumber == null || cardNumber.trim().isEmpty() ||
            expiry == null || expiry.trim().isEmpty() ||
            cvv == null || cvv.trim().isEmpty()) {
            LOGGER.warning("Invalid payment details for billId: " + billId);
            return false;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE bills SET payment_status = 'Paid', payment_date = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, Date.valueOf(LocalDate.now()));
            stmt.setInt(2, billId);
            int rowsAffected = stmt.executeUpdate();
            LOGGER.info("Payment processed for billId: " + billId + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error processing payment for billId: " + billId, e);
            throw e;
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public static class Bill {
        private int id;
        private String patientId;
        private String roomId;
        private String checkInDate;
        private String checkOutDate;
        private int daysStayed;
        private double totalAmount;
        private String paymentStatus;
        private String paymentDate;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }
        public String getRoomId() { return roomId; }
        public void setRoomId(String roomId) { this.roomId = roomId; }
        public String getCheckInDate() { return checkInDate; }
        public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }
        public String getCheckOutDate() { return checkOutDate; }
        public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }
        public int getDaysStayed() { return daysStayed; }
        public void setDaysStayed(int daysStayed) { this.daysStayed = daysStayed; }
        public double getTotalAmount() { return totalAmount; }
        public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
        public String getPaymentStatus() { return paymentStatus; }
        public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
        public String getPaymentDate() { return paymentDate; }
        public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }
    }
}