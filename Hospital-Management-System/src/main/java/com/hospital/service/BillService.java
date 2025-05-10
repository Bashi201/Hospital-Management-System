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

    public boolean createRoomBill(String patientId, String roomId, String checkInDate, String checkOutDate, int daysStayed, double totalAmount) throws SQLException {
        if (patientId == null || patientId.trim().isEmpty() || 
            roomId == null || roomId.trim().isEmpty() || 
            checkInDate == null || checkInDate.trim().isEmpty() || 
            checkOutDate == null || checkOutDate.trim().isEmpty() || 
            daysStayed < 0 || totalAmount < 0) {
            LOGGER.warning("Invalid parameters for createRoomBill: patientId=" + patientId + ", roomId=" + roomId + 
                           ", checkInDate=" + checkInDate + ", checkOutDate=" + checkOutDate + 
                           ", daysStayed=" + daysStayed + ", totalAmount=" + totalAmount);
            throw new IllegalArgumentException("Invalid parameters for room bill creation");
        }
        LOGGER.info("Attempting to create room bill for patientId: " + patientId + ", roomId: " + roomId);
        boolean result = createBill(patientId, roomId, null, checkInDate, checkOutDate, daysStayed, totalAmount, "Room");
        if (result) {
            LOGGER.info("Successfully created room bill for patientId: " + patientId + ", roomId: " + roomId);
        } else {
            LOGGER.warning("Failed to create room bill for patientId: " + patientId + ", roomId: " + roomId);
        }
        return result;
    }

    public boolean createAppointmentBill(String patientId, int appointmentId, String appointmentDate, double totalAmount) throws SQLException {
        if (patientId == null || patientId.trim().isEmpty() || 
            appointmentDate == null || appointmentDate.trim().isEmpty() || 
            totalAmount < 0) {
            LOGGER.warning("Invalid parameters for createAppointmentBill: patientId=" + patientId + 
                           ", appointmentId=" + appointmentId + ", appointmentDate=" + appointmentDate + 
                           ", totalAmount=" + totalAmount);
            throw new IllegalArgumentException("Invalid parameters for appointment bill creation");
        }
        try {
            LocalDate.parse(appointmentDate);
        } catch (Exception e) {
            LOGGER.warning("Invalid appointmentDate format: " + appointmentDate);
            throw new IllegalArgumentException("Appointment date must be in YYYY-MM-DD format");
        }
        LOGGER.info("Attempting to create appointment bill for patientId: " + patientId + ", appointmentId: " + appointmentId);
        boolean result = createBill(patientId, null, appointmentId, appointmentDate, appointmentDate, 1, totalAmount, "Appointment");
        if (result) {
            LOGGER.info("Successfully created appointment bill for patientId: " + patientId + ", appointmentId: " + appointmentId);
        } else {
            LOGGER.warning("Failed to create appointment bill for patientId: " + patientId + ", appointmentId: " + appointmentId);
        }
        return result;
    }

    private boolean createBill(String patientId, String roomId, Integer appointmentId, String checkInDate, 
                              String checkOutDate, int daysStayed, double totalAmount, String billType) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "INSERT INTO bills (patient_id, room_id, appointment_id, check_in_date, check_out_date, " +
                        "days_stayed, total_amount, payment_status, bill_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, patientId);
            if (roomId != null) {
                stmt.setString(2, roomId);
                LOGGER.fine("Setting room_id to: " + roomId + " for billType: " + billType);
            } else {
                stmt.setNull(2, Types.VARCHAR);
                LOGGER.fine("Setting room_id to NULL for billType: " + billType);
            }
            if (appointmentId != null) {
                stmt.setInt(3, appointmentId);
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setDate(4, Date.valueOf(checkInDate));
            stmt.setDate(5, Date.valueOf(checkOutDate));
            stmt.setInt(6, daysStayed);
            stmt.setDouble(7, totalAmount);
            stmt.setString(8, "Pending");
            stmt.setString(9, billType);
            int rowsAffected = stmt.executeUpdate();
            LOGGER.info("Created bill for patientId: " + patientId + ", type: " + billType + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating bill for patientId: " + patientId + ", billType: " + billType + 
                      ", roomId=" + roomId + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw new SQLException("Failed to create bill: " + e.getMessage(), e);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Invalid date format for checkInDate: " + checkInDate + 
                      " or checkOutDate: " + checkOutDate, e);
            throw new SQLException("Invalid date format: " + e.getMessage(), e);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in createBill", e);
            }
        }
    }

    public Bill getBillByPatientAndRoom(String patientId, String roomId) throws SQLException {
        if (patientId == null || patientId.trim().isEmpty() || roomId == null || roomId.trim().isEmpty()) {
            LOGGER.warning("Invalid parameters for getBillByPatientAndRoom: patientId=" + patientId + ", roomId=" + roomId);
            throw new IllegalArgumentException("Patient ID and Room ID cannot be null or empty");
        }
        return getBill(patientId, roomId, null);
    }

    public Bill getBillByPatientAndAppointment(String patientId, int appointmentId) throws SQLException {
        if (patientId == null || patientId.trim().isEmpty()) {
            LOGGER.warning("Invalid patientId for getBillByPatientAndAppointment: " + patientId);
            throw new IllegalArgumentException("Patient ID cannot be null or empty");
        }
        return getBill(patientId, null, appointmentId);
    }

    private Bill getBill(String patientId, String roomId, Integer appointmentId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql;
            if (roomId != null) {
                sql = "SELECT * FROM bills WHERE patient_id = ? AND room_id = ? AND payment_status = 'Pending'";
            } else {
                sql = "SELECT * FROM bills WHERE patient_id = ? AND appointment_id = ? AND payment_status = 'Pending'";
            }
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, patientId);
            if (roomId != null) {
                stmt.setString(2, roomId);
            } else {
                stmt.setInt(2, appointmentId);
            }
            rs = stmt.executeQuery();
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setPatientId(rs.getString("patient_id"));
                bill.setRoomId(rs.getString("room_id"));
                bill.setAppointmentId(rs.getInt("appointment_id") != 0 ? rs.getInt("appointment_id") : null);
                bill.setCheckInDate(rs.getDate("check_in_date").toString());
                bill.setCheckOutDate(rs.getDate("check_out_date").toString());
                bill.setDaysStayed(rs.getInt("days_stayed"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaymentStatus(rs.getString("payment_status"));
                bill.setPaymentDate(rs.getDate("payment_date") != null ? rs.getDate("payment_date").toString() : null);
                bill.setBillType(rs.getString("bill_type"));
                return bill;
            }
            LOGGER.fine("No bill found for patientId: " + patientId + ", roomId: " + roomId + ", appointmentId: " + appointmentId);
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching bill for patientId: " + patientId + ", roomId: " + roomId + 
                      ", appointmentId: " + appointmentId + ", SQLState: " + e.getSQLState() + 
                      ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in getBill", e);
            }
        }
    }

    public List<Bill> getPendingRoomBillsByPatient(String patientId) throws SQLException {
        return getBillsByPatientAndType(patientId, "Pending", "Room");
    }

    public List<Bill> getPaidRoomBillsByPatient(String patientId) throws SQLException {
        return getBillsByPatientAndType(patientId, "Paid", "Room");
    }

    public List<Bill> getPendingAppointmentBillsByPatient(String patientId) throws SQLException {
        return getBillsByPatientAndType(patientId, "Pending", "Appointment");
    }

    public List<Bill> getPaidAppointmentBillsByPatient(String patientId) throws SQLException {
        return getBillsByPatientAndType(patientId, "Paid", "Appointment");
    }

    private List<Bill> getBillsByPatientAndType(String patientId, String paymentStatus, String billType) throws SQLException {
        if (patientId == null || patientId.trim().isEmpty()) {
            LOGGER.warning("Invalid patientId provided: " + patientId + " for paymentStatus: " + paymentStatus + 
                           ", billType: " + billType);
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
            String sql = "SELECT * FROM bills WHERE patient_id = ? AND payment_status = ? AND bill_type = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, patientId);
            stmt.setString(2, paymentStatus);
            stmt.setString(3, billType);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setPatientId(rs.getString("patient_id"));
                bill.setRoomId(rs.getString("room_id"));
                bill.setAppointmentId(rs.getInt("appointment_id") != 0 ? rs.getInt("appointment_id") : null);
                bill.setCheckInDate(rs.getDate("check_in_date").toString());
                bill.setCheckOutDate(rs.getDate("check_out_date").toString());
                bill.setDaysStayed(rs.getInt("days_stayed"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaymentStatus(rs.getString("payment_status"));
                bill.setPaymentDate(rs.getDate("payment_date") != null ? rs.getDate("payment_date").toString() : null);
                bill.setBillType(rs.getString("bill_type"));
                bills.add(bill);
            }
            LOGGER.info("Retrieved " + bills.size() + " " + paymentStatus.toLowerCase() + " " + billType.toLowerCase() + 
                        " bills for patientId: " + patientId);
            return bills;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching " + paymentStatus.toLowerCase() + " " + billType.toLowerCase() + 
                      " bills for patientId: " + patientId + ", SQLState: " + e.getSQLState() + 
                      ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in getBillsByPatientAndType", e);
            }
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
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            String sql = "UPDATE bills SET payment_status = 'Paid', payment_date = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, Date.valueOf(LocalDate.now()));
            stmt.setInt(2, billId);
            int rowsAffected = stmt.executeUpdate();
            LOGGER.info("Payment processed for billId: " + billId + ", rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error processing payment for billId: " + billId + 
                      ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            throw e;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in processPayment", e);
            }
        }
    }

    public static class Bill {
        private Integer id;
        private String patientId;
        private String roomId;
        private Integer appointmentId;
        private String checkInDate;
        private String checkOutDate;
        private Integer daysStayed;
        private Double totalAmount;
        private String paymentStatus;
        private String paymentDate;
        private String billType;

        public Integer getId() { return id; }
        public void setId(Integer id) { this.id = id; }
        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }
        public String getRoomId() { return roomId; }
        public void setRoomId(String roomId) { this.roomId = roomId; }
        public Integer getAppointmentId() { return appointmentId; }
        public void setAppointmentId(Integer appointmentId) { this.appointmentId = appointmentId; }
        public String getCheckInDate() { return checkInDate; }
        public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }
        public String getCheckOutDate() { return checkOutDate; }
        public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }
        public Integer getDaysStayed() { return daysStayed; }
        public void setDaysStayed(Integer daysStayed) { this.daysStayed = daysStayed; }
        public Double getTotalAmount() { return totalAmount; }
        public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }
        public String getPaymentStatus() { return paymentStatus; }
        public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
        public String getPaymentDate() { return paymentDate; }
        public void setPaymentDate(String paymentDate) { this.paymentDate = paymentDate; }
        public String getBillType() { return billType; }
        public void setBillType(String billType) { this.billType = billType; }
    }
}