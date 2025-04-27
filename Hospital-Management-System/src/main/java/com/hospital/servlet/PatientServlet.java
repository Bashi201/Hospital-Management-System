package com.hospital.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/patient")
public class PatientServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hospitalmanagementsystem";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");
        if (action == null) action = "";

        if ("login".equals(action)) {
            showPatientLogin(request, response);
            return;
        }

        if (session == null || (session.getAttribute("patientId") == null && session.getAttribute("dispatcherId") == null)) {
            if (action.contains("Dispatcher")) {
                response.sendRedirect(request.getContextPath() + "/dispatcherLogin");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/login");
            }
            return;
        }

        if (session.getAttribute("patientId") != null) {
            switch (action) {
                case "ambulance":
                    showAmbulanceBookingForm(request, response);
                    break;
                case "ambulanceBookings":
                    showAmbulanceBookings(request, response);
                    break;
                case "appointments":
                    showAppointments(request, response);
                    break;
                case "logout":
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/patient/login");
                    break;
                default:
                    showPatientDashboard(request, response);
            }
        } else if (session.getAttribute("dispatcherId") != null) {
            switch (action) {
                case "logoutDispatcher":
                    session.invalidate();
                    response.sendRedirect(request.getContextPath() + "/dispatcherLogin");
                    break;
                default:
                    showDispatcherDashboard(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else {
            HttpSession session = request.getSession(false);
            if (session == null || (session.getAttribute("patientId") == null && session.getAttribute("dispatcherId") == null)) {
                if (action != null && action.contains("Dispatcher")) {
                    response.sendRedirect(request.getContextPath() + "/dispatcherLogin");
                } else {
                    response.sendRedirect(request.getContextPath() + "/patient/login");
                }
                return;
            }

            if ("bookAmbulance".equals(action) && session.getAttribute("patientId") != null) {
                bookAmbulance(request, response);
            } else if ("dispatchAmbulance".equals(action) && session.getAttribute("dispatcherId") != null) {
                dispatchAmbulance(request, response);
            }
        }
    }

    private void showPatientLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Patient Login</title></head>");
        out.println("<body>");
        out.println("<h1>Patient Login</h1>");
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
            out.println("<p style=\"color: red;\">" + errorMessage + "</p>");
        }
        out.println("<form action=\"" + request.getContextPath() + "/patient\" method=\"POST\">");
        out.println("<input type=\"hidden\" name=\"action\" value=\"login\">");
        out.println("Email: <input type=\"email\" name=\"gmail\" required><br>");
        out.println("Password: <input type=\"password\" name=\"password\" required><br>");
        out.println("<button type=\"submit\">Login</button>");
        out.println("</form>");
        out.println("</body>");
        out.println("</html>");

        out.close();
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String gmail = request.getParameter("gmail");
        String password = request.getParameter("password");

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement("SELECT id FROM patients WHERE gmail = ? AND password = ?")) {
            pstmt.setString(1, gmail);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("patientId", rs.getString("id"));
                response.sendRedirect(request.getContextPath() + "/patient");
            } else {
                request.setAttribute("errorMessage", "Invalid email or password");
                showPatientLogin(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during login: " + e.getMessage(), e);
        }
    }

    private void showPatientDashboard(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Patient Dashboard</title></head>");
        out.println("<body>");
        out.println("<h1>Patient Dashboard</h1>");
        out.println("<p>Welcome, Patient!</p>");
        out.println("<a href=\"" + request.getContextPath() + "/patient?action=ambulance\">Book Ambulance</a><br>");
        out.println("<a href=\"" + request.getContextPath() + "/patient?action=ambulanceBookings\">View Ambulance Bookings</a><br>");
        out.println("<a href=\"" + request.getContextPath() + "/patient?action=appointments\">View Appointments</a><br>");
        out.println("<a href=\"" + request.getContextPath() + "/patient?action=logout\">Logout</a>");
        out.println("</body>");
        out.println("</html>");

        out.close();
    }

    private void showAmbulanceBookingForm(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Book Ambulance</title></head>");
        out.println("<body>");
        out.println("<h1>Book Ambulance</h1>");
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (successMessage != null) {
            out.println("<p style=\"color: green;\">" + successMessage + "</p>");
        }
        if (errorMessage != null) {
            out.println("<p style=\"color: red;\">" + errorMessage + "</p>");
        }
        out.println("<form action=\"" + request.getContextPath() + "/patient\" method=\"POST\">");
        out.println("<input type=\"hidden\" name=\"action\" value=\"bookAmbulance\">");
        out.println("Pickup Location: <input type=\"text\" name=\"pickupLocation\" required><br>");
        out.println("Drop-off Location: <input type=\"text\" name=\"dropLocation\" required><br>");
        out.println("Date: <input type=\"date\" name=\"bookingDate\" required><br>");
        out.println("Time: <input type=\"time\" name=\"bookingTime\" required><br>");
        out.println("<button type=\"submit\">Book Ambulance</button>");
        out.println("</form>");
        out.println("<a href=\"" + request.getContextPath() + "/patient\">Back to Dashboard</a>");
        out.println("</body>");
        out.println("</html>");

        out.close();
    }

    private void bookAmbulance(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String patientId = (String) session.getAttribute("patientId");

        String pickupLocation = request.getParameter("pickupLocation");
        String dropLocation = request.getParameter("dropLocation");
        String bookingDate = request.getParameter("bookingDate");
        String bookingTime = request.getParameter("bookingTime");

        String bookingId = "B" + UUID.randomUUID().toString().substring(0, 8);

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            conn.setAutoCommit(false);

            String sql = "INSERT INTO ambulance_bookings (booking_id, patient_id, pickup_location, drop_location, booking_date, booking_time, status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookingId);
            pstmt.setString(2, patientId);
            pstmt.setString(3, pickupLocation);
            pstmt.setString(4, dropLocation);
            pstmt.setString(5, bookingDate);
            pstmt.setString(6, bookingTime);
            pstmt.executeUpdate();

            conn.commit();
            request.setAttribute("successMessage", "Booking request submitted successfully! Awaiting dispatch.");
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    throw new ServletException("Rollback failed: " + ex.getMessage(), ex);
                }
            }
            request.setAttribute("errorMessage", "Failed to submit booking request: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new ServletException("Database connection error: " + e.getMessage(), e);
            }
        }
        showAmbulanceBookingForm(request, response);
    }

    private void showAmbulanceBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String patientId = (String) session.getAttribute("patientId");

        List<AmbulanceBooking> bookings = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT ab.booking_id, ab.ambulance_id, a.type AS ambulance_type, ab.pickup_location, ab.drop_location, ab.booking_date, ab.booking_time, ab.status " +
                             "FROM ambulance_bookings ab " +
                             "LEFT JOIN ambulance a ON ab.ambulance_id = a.id " +
                             "WHERE ab.patient_id = ?")) {
            pstmt.setString(1, patientId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                AmbulanceBooking booking = new AmbulanceBooking();
                booking.setBookingId(rs.getString("booking_id"));
                booking.setAmbulanceId(rs.getString("ambulance_id"));
                booking.setAmbulanceType(rs.getString("ambulance_type"));
                booking.setPickupLocation(rs.getString("pickup_location"));
                booking.setDropLocation(rs.getString("drop_location"));
                booking.setBookingDate(rs.getString("booking_date"));
                booking.setBookingTime(rs.getString("booking_time"));
                booking.setStatus(rs.getString("status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching bookings: " + e.getMessage(), e);
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Ambulance Bookings</title></head>");
        out.println("<body>");
        out.println("<h1>Ambulance Bookings</h1>");
        if (bookings.isEmpty()) {
            out.println("<p>No bookings found.</p>");
        } else {
            out.println("<table border=\"1\">");
            out.println("<tr><th>Booking ID</th><th>Ambulance ID</th><th>Ambulance Type</th><th>Pickup Location</th><th>Drop-off Location</th><th>Date</th><th>Time</th><th>Status</th></tr>");
            for (AmbulanceBooking booking : bookings) {
                out.println("<tr>");
                out.println("<td>" + (booking.getBookingId() != null ? booking.getBookingId() : "") + "</td>");
                out.println("<td>" + (booking.getAmbulanceId() != null ? booking.getAmbulanceId() : "") + "</td>");
                out.println("<td>" + (booking.getAmbulanceType() != null ? booking.getAmbulanceType() : "") + "</td>");
                out.println("<td>" + (booking.getPickupLocation() != null ? booking.getPickupLocation() : "") + "</td>");
                out.println("<td>" + (booking.getDropLocation() != null ? booking.getDropLocation() : "") + "</td>");
                out.println("<td>" + (booking.getBookingDate() != null ? booking.getBookingDate() : "") + "</td>");
                out.println("<td>" + (booking.getBookingTime() != null ? booking.getBookingTime() : "") + "</td>");
                out.println("<td>" + (booking.getStatus() != null ? booking.getStatus() : "") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        out.println("<a href=\"" + request.getContextPath() + "/patient\">Back to Dashboard</a>");
        out.println("</body>");
        out.println("</html>");

        out.close();
    }

    private void showDispatcherDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Booking> pendingBookings = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT booking_id, patient_id, pickup_location, drop_location, booking_date, booking_time " +
                             "FROM ambulance_bookings WHERE status = 'Pending'")) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getString("booking_id"));
                booking.setPatientId(rs.getString("patient_id"));
                booking.setPickupLocation(rs.getString("pickup_location"));
                booking.setDropLocation(rs.getString("drop_location"));
                booking.setBookingDate(rs.getString("booking_date"));
                booking.setBookingTime(rs.getString("booking_time"));
                pendingBookings.add(booking);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching bookings: " + e.getMessage(), e);
        }

        List<Ambulance> availableAmbulances = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT id, type, driver_name, driver_contact, status " +
                             "FROM ambulance WHERE status = 'Available'")) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Ambulance ambulance = new Ambulance();
                ambulance.setId(rs.getString("id"));
                ambulance.setType(rs.getString("type"));
                ambulance.setDriverName(rs.getString("driver_name"));
                ambulance.setDriverContact(rs.getString("driver_contact"));
                ambulance.setStatus(rs.getString("status"));
                availableAmbulances.add(ambulance);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching ambulances: " + e.getMessage(), e);
        }

        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("availableAmbulances", availableAmbulances);
        request.getRequestDispatcher("/DispatcherDashHome.jsp").forward(request, response);
    }

    private void dispatchAmbulance(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String dispatcherId = (String) session.getAttribute("dispatcherId");
        String bookingId = request.getParameter("bookingId");
        String ambulanceId = request.getParameter("ambulanceId");

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            conn.setAutoCommit(false);

            String updateBookingSql = "UPDATE ambulance_bookings SET ambulance_id = ?, status = 'Dispatched' WHERE booking_id = ?";
            pstmt = conn.prepareStatement(updateBookingSql);
            pstmt.setString(1, ambulanceId);
            pstmt.setString(2, bookingId);
            pstmt.executeUpdate();

            String updateAmbulanceSql = "UPDATE ambulance SET status = 'Assigned' WHERE id = ?";
            pstmt = conn.prepareStatement(updateAmbulanceSql);
            pstmt.setString(1, ambulanceId);
            pstmt.executeUpdate();

            String insertDispatchSql = "INSERT INTO dispatch_records (booking_id, vehicle_id, dispatcher_id, status) VALUES (?, ?, ?, 'Dispatched')";
            pstmt = conn.prepareStatement(insertDispatchSql);
            pstmt.setString(1, bookingId);
            pstmt.setString(2, ambulanceId);
            pstmt.setInt(3, Integer.parseInt(dispatcherId));
            pstmt.setString(4, "Dispatched");
            pstmt.executeUpdate();

            conn.commit();
            request.setAttribute("successMessage", "Ambulance dispatched successfully!");
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    throw new ServletException("Rollback failed: " + ex.getMessage(), ex);
                }
            }
            request.setAttribute("errorMessage", "Failed to dispatch ambulance: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                throw new ServletException("Database connection error: " + e.getMessage(), e);
            }
        }
        showDispatcherDashboard(request, response);
    }

    private void showAppointments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String patientId = (String) session.getAttribute("patientId");

        List<Appointment> appointments = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT id, doctor_id, doctor_name, specialization, appointment_date, appointment_time, status " +
                             "FROM appointments WHERE patient_id = ?")) {
            pstmt.setString(1, patientId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setSpecialization(rs.getString("specialization"));
                appointment.setAppointmentDate(rs.getString("appointment_date"));
                appointment.setAppointmentTime(rs.getString("appointment_time"));
                appointment.setStatus(rs.getString("status"));
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching appointments: " + e.getMessage(), e);
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Appointments</title></head>");
        out.println("<body>");
        out.println("<h1>Appointments</h1>");
        if (appointments.isEmpty()) {
            out.println("<p>No appointments found.</p>");
        } else {
            out.println("<table border=\"1\">");
            out.println("<tr><th>ID</th><th>Doctor ID</th><th>Doctor Name</th><th>Specialization</th><th>Date</th><th>Time</th><th>Status</th></tr>");
            for (Appointment appointment : appointments) {
                out.println("<tr>");
                out.println("<td>" + appointment.getId() + "</td>");
                out.println("<td>" + appointment.getDoctorId() + "</td>");
                out.println("<td>" + (appointment.getDoctorName() != null ? appointment.getDoctorName() : "") + "</td>");
                out.println("<td>" + (appointment.getSpecialization() != null ? appointment.getSpecialization() : "") + "</td>");
                out.println("<td>" + (appointment.getAppointmentDate() != null ? appointment.getAppointmentDate() : "") + "</td>");
                out.println("<td>" + (appointment.getAppointmentTime() != null ? appointment.getAppointmentTime() : "") + "</td>");
                out.println("<td>" + (appointment.getStatus() != null ? appointment.getStatus() : "") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        out.println("<a href=\"" + request.getContextPath() + "/patient\">Back to Dashboard</a>");
        out.println("</body>");
        out.println("</html>");

        out.close();
    }

    static class AmbulanceBooking {
        private String bookingId;
        private String ambulanceId;
        private String ambulanceType;
        private String pickupLocation;
        private String dropLocation;
        private String bookingDate;
        private String bookingTime;
        private String status;

        public String getBookingId() { return bookingId; }
        public void setBookingId(String bookingId) { this.bookingId = bookingId; }
        public String getAmbulanceId() { return ambulanceId; }
        public void setAmbulanceId(String ambulanceId) { this.ambulanceId = ambulanceId; }
        public String getAmbulanceType() { return ambulanceType; }
        public void setAmbulanceType(String ambulanceType) { this.ambulanceType = ambulanceType; }
        public String getPickupLocation() { return pickupLocation; }
        public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }
        public String getDropLocation() { return dropLocation; }
        public void setDropLocation(String dropLocation) { this.dropLocation = dropLocation; }
        public String getBookingDate() { return bookingDate; }
        public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
        public String getBookingTime() { return bookingTime; }
        public void setBookingTime(String bookingTime) { this.bookingTime = bookingTime; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    static class Appointment {
        private int id;
        private int doctorId;
        private String doctorName;
        private String specialization;
        private String appointmentDate;
        private String appointmentTime;
        private String status;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public int getDoctorId() { return doctorId; }
        public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
        public String getDoctorName() { return doctorName; }
        public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
        public String getSpecialization() { return specialization; }
        public void setSpecialization(String specialization) { this.specialization = specialization; }
        public String getAppointmentDate() { return appointmentDate; }
        public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }
        public String getAppointmentTime() { return appointmentTime; }
        public void setAppointmentTime(String appointmentTime) { this.appointmentTime = appointmentTime; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    static class Booking {
        private String bookingId;
        private String patientId;
        private String pickupLocation;
        private String dropLocation;
        private String bookingDate;
        private String bookingTime;

        public String getBookingId() { return bookingId; }
        public void setBookingId(String bookingId) { this.bookingId = bookingId; }
        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }
        public String getPickupLocation() { return pickupLocation; }
        public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }
        public String getDropLocation() { return dropLocation; }
        public void setDropLocation(String dropLocation) { this.dropLocation = dropLocation; }
        public String getBookingDate() { return bookingDate; }
        public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
        public String getBookingTime() { return bookingTime; }
        public void setBookingTime(String bookingTime) { this.bookingTime = bookingTime; }
    }

    static class Ambulance {
        private String id;
        private String type;
        private String driverName;
        private String driverContact;
        private String status;

        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public String getDriverName() { return driverName; }
        public void setDriverName(String driverName) { this.driverName = driverName; }
        public String getDriverContact() { return driverContact; }
        public void setDriverContact(String driverContact) { this.driverContact = driverContact; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
}