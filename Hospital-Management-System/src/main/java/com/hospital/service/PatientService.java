package com.hospital.service;

import com.hospital.model.Ambulance;
import com.hospital.model.Patient;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientService {

    // Create Patient
    public boolean createPatient(Patient patient) {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            String sql = "INSERT INTO patients (id, phone_number, name, gender, admitted_time, gmail, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, patient.getId());
            statement.setString(2, patient.getPhoneNumber());
            statement.setString(3, patient.getName());
            statement.setString(4, patient.getGender());
            statement.setString(5, patient.getAdmittedTime());
            statement.setString(6, patient.getGmail());
            statement.setString(7, patient.getPassword());

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

    // Get Patient by ID
    public Patient getPatient(String id) {
        String query = "SELECT * FROM patients WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Patient patient = new Patient();
                patient.setId(rs.getString("id"));
                patient.setPhoneNumber(rs.getString("phone_number"));
                patient.setName(rs.getString("name"));
                patient.setGender(rs.getString("gender"));
                patient.setAdmittedTime(rs.getString("admitted_time"));
                patient.setGmail(rs.getString("gmail"));
                patient.setPassword(rs.getString("password"));
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get All Patients
    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String query = "SELECT * FROM patients";
        try (Connection connection = DBConnection.getConnection();
             Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setId(rs.getString("id"));
                patient.setPhoneNumber(rs.getString("phone_number"));
                patient.setName(rs.getString("name"));
                patient.setGender(rs.getString("gender"));
                patient.setAdmittedTime(rs.getString("admitted_time"));
                patient.setGmail(rs.getString("gmail"));
                patient.setPassword(rs.getString("password"));
                patients.add(patient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    // Update Patient
    public boolean updatePatient(Patient patient) {
        String query = "UPDATE patients SET phone_number = ?, name = ?, gender = ?, admitted_time = ?, gmail = ?, password = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, patient.getPhoneNumber());
            stmt.setString(2, patient.getName());
            stmt.setString(3, patient.getGender());
            stmt.setString(4, patient.getAdmittedTime());
            stmt.setString(5, patient.getGmail());
            stmt.setString(6, patient.getPassword());
            stmt.setString(7, patient.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete Patient
    public boolean deletePatient(String patientId) {
        String deleteSQL = "DELETE FROM patients WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(deleteSQL)) {

            if (connection == null) {
                System.err.println("Error: Database connection is null!");
                return false;
            }

            statement.setString(1, patientId.trim());

            System.out.println("Executing query: " + deleteSQL + " with id = '" + patientId + "'");
            int rowsAffected = statement.executeUpdate();
            
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected == 0) {
                System.err.println("No patient found with id: '" + patientId + "'");
            }

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Book Room
    public boolean bookRoom(String patientId, String roomId, String checkInDate, String checkOutDate) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();

            // Check if the room is available
            String checkSql = "SELECT availability FROM rooms WHERE id = ?";
            statement = connection.prepareStatement(checkSql);
            statement.setString(1, roomId);
            ResultSet rs = statement.executeQuery();
            if (!rs.next() || !"Available".equals(rs.getString("availability"))) {
                rs.close();
                statement.close();
                return false; // Room not available or doesn’t exist
            }
            rs.close();
            statement.close();

            // Update the room with booking details
            String sql = "UPDATE rooms SET patient_id = ?, check_in_date = ?, check_out_date = ?, status = 'Pending', availability = 'Booked' " +
                        "WHERE id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, patientId);
            statement.setDate(2, Date.valueOf(checkInDate));
            statement.setDate(3, Date.valueOf(checkOutDate));
            statement.setString(4, roomId);
            int rowsAffected = statement.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error in bookRoom: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Book Appointment
    public boolean bookAppointment(String patientId, String doctorId, String appointmentDate, String appointmentTime) throws SQLException {
        String sql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, patientId);
            stmt.setString(2, doctorId);
            stmt.setString(3, appointmentDate);
            stmt.setString(4, appointmentTime);
            return stmt.executeUpdate() > 0;
        }
    }

    // Book Ambulance
    public boolean bookAmbulance(String patientId, String pickupLocation, String destination, String requestDate, String requestTime) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false); // Start transaction

            // Check for available ambulance
            String checkSql = "SELECT id FROM ambulances WHERE availability = 'Available' LIMIT 1";
            statement = connection.prepareStatement(checkSql);
            ResultSet rs = statement.executeQuery();
            if (!rs.next()) {
                rs.close();
                statement.close();
                connection.rollback();
                return false; // No available ambulance
            }
            int ambulanceId = rs.getInt("id");
            rs.close();
            statement.close();

            // Insert booking
            String sql = "INSERT INTO ambulance_bookings (patient_id, pickup_location, destination, request_date, request_time, status, ambulance_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, patientId);
            statement.setString(2, pickupLocation);
            statement.setString(3, destination);
            statement.setString(4, requestDate);
            statement.setString(5, requestTime);
            statement.setString(6, "Pending");
            statement.setInt(7, ambulanceId);
            int rowsAffected = statement.executeUpdate();
            statement.close();

            // Note: Availability update will be handled when dispatching the ambulance

            connection.commit();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (connection != null) try { connection.rollback(); } catch (SQLException re) { re.printStackTrace(); }
            System.out.println("SQL Error in bookAmbulance: " + e.getMessage());
            throw e;
        } finally {
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.setAutoCommit(true); connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Get Booked Ambulances for a Patient
    public List<Ambulance> getBookedAmbulances(String patientId) throws SQLException {
        List<Ambulance> bookings = new ArrayList<>();
        String query = "SELECT ab.*, a.vehicle_number FROM ambulance_bookings ab " +
                      "JOIN ambulances a ON ab.ambulance_id = a.id WHERE ab.patient_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, patientId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Ambulance booking = new Ambulance();
                booking.setId(rs.getInt("id"));
                booking.setPatientId(rs.getString("patient_id"));
                booking.setPickupLocation(rs.getString("pickup_location"));
                booking.setDestination(rs.getString("destination"));
                booking.setRequestDate(rs.getString("request_date"));
                booking.setRequestTime(rs.getString("request_time"));
                booking.setStatus(rs.getString("status"));
                // Optionally, you could add vehicle_number to the Ambulance model if needed
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getBookedAmbulances: " + e.getMessage());
            throw e;
        }
        return bookings;
    }

    // Get Latest Pending Ambulance Request
    public Ambulance getLatestPendingAmbulanceRequest() throws SQLException {
        String query = "SELECT ab.*, a.vehicle_number FROM ambulance_bookings ab " +
                      "JOIN ambulances a ON ab.ambulance_id = a.id " +
                      "WHERE ab.status = 'Pending' ORDER BY ab.request_date DESC, ab.request_time DESC LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Ambulance booking = new Ambulance();
                booking.setId(rs.getInt("id"));
                booking.setPatientId(rs.getString("patient_id"));
                booking.setPickupLocation(rs.getString("pickup_location"));
                booking.setDestination(rs.getString("destination"));
                booking.setRequestDate(rs.getString("request_date"));
                booking.setRequestTime(rs.getString("request_time"));
                booking.setStatus(rs.getString("status"));
                return booking;
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in getLatestPendingAmbulanceRequest: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // Dispatch Ambulance (update status and log to history)
    public boolean dispatchAmbulance(int bookingId, String driverId, String vehicleNumber) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        try {
            connection = DBConnection.getConnection();
            connection.setAutoCommit(false);

            // Update booking status
            String updateBookingSql = "UPDATE ambulance_bookings SET status = 'Dispatched' WHERE id = ?";
            statement = connection.prepareStatement(updateBookingSql);
            statement.setInt(1, bookingId);
            statement.executeUpdate();
            statement.close();

            // Update ambulance availability
            String updateAmbulanceSql = "UPDATE ambulances SET availability = 'Booked' WHERE vehicle_number = ?";
            statement = connection.prepareStatement(updateAmbulanceSql);
            statement.setString(1, vehicleNumber);
            statement.executeUpdate();
            statement.close();

            // Fetch booking details for history
            String fetchBookingSql = "SELECT * FROM ambulance_bookings WHERE id = ?";
            statement = connection.prepareStatement(fetchBookingSql);
            statement.setInt(1, bookingId);
            ResultSet rs = statement.executeQuery();
            if (!rs.next()) {
                connection.rollback();
                return false;
            }
            String patientId = rs.getString("patient_id");
            String pickupLocation = rs.getString("pickup_location");
            String destination = rs.getString("destination");
            String requestDate = rs.getString("request_date");
            String requestTime = rs.getString("request_time");
            rs.close();
            statement.close();

            // Insert into history
            String historySql = "INSERT INTO ambulance_history (patient_id, pickup_location, destination, request_date, request_time, driver_id, vehicle_number, dispatch_time) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
            statement = connection.prepareStatement(historySql);
            statement.setString(1, patientId);
            statement.setString(2, pickupLocation);
            statement.setString(3, destination);
            statement.setString(4, requestDate);
            statement.setString(5, requestTime);
            statement.setString(6, driverId);
            statement.setString(7, vehicleNumber);
            statement.executeUpdate();

            connection.commit();
            return true;
        } catch (SQLException e) {
            if (connection != null) try { connection.rollback(); } catch (SQLException re) { re.printStackTrace(); }
            throw e;
        } finally {
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.setAutoCommit(true); connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Get Ambulance History
    public List<AmbulanceHistory> getAmbulanceHistory() throws SQLException {
        List<AmbulanceHistory> history = new ArrayList<>();
        String query = "SELECT * FROM ambulance_history ORDER BY dispatch_time DESC";
        try (Connection connection = DBConnection.getConnection();
             Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                AmbulanceHistory entry = new AmbulanceHistory();
                entry.setId(rs.getInt("id"));
                entry.setPatientId(rs.getString("patient_id"));
                entry.setPickupLocation(rs.getString("pickup_location"));
                entry.setDestination(rs.getString("destination"));
                entry.setRequestDate(rs.getString("request_date"));
                entry.setRequestTime(rs.getString("request_time"));
                entry.setDriverId(rs.getString("driver_id"));
                entry.setVehicleNumber(rs.getString("vehicle_number"));
                entry.setDispatchTime(rs.getString("dispatch_time"));
                entry.setReturnTime(rs.getString("return_time"));
                history.add(entry);
            }
        } catch (SQLException e) {
            throw e;
        }
        return history;
    }

    // Model class for AmbulanceHistory
    public static class AmbulanceHistory {
        private int id;
        private String patientId;
        private String pickupLocation;
        private String destination;
        private String requestDate;
        private String requestTime;
        private String driverId;
        private String vehicleNumber;
        private String dispatchTime;
        private String returnTime;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }
        public String getPickupLocation() { return pickupLocation; }
        public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }
        public String getDestination() { return destination; }
        public void setDestination(String destination) { this.destination = destination; }
        public String getRequestDate() { return requestDate; }
        public void setRequestDate(String requestDate) { this.requestDate = requestDate; }
        public String getRequestTime() { return requestTime; }
        public void setRequestTime(String requestTime) { this.requestTime = requestTime; }
        public String getDriverId() { return driverId; }
        public void setDriverId(String driverId) { this.driverId = driverId; }
        public String getVehicleNumber() { return vehicleNumber; }
        public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }
        public String getDispatchTime() { return dispatchTime; }
        public void setDispatchTime(String dispatchTime) { this.dispatchTime = dispatchTime; }
        public String getReturnTime() { return returnTime; }
        public void setReturnTime(String returnTime) { this.returnTime = returnTime; }
    }

    public boolean hasPatient() {
        // TODO: Implement logic to check if any patients exist
        return false;
    }
}