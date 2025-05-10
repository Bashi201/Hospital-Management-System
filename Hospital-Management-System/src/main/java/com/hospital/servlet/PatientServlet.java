package com.hospital.servlet;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.model.Room;
import com.hospital.model.Ambulance;
import com.hospital.service.DoctorService;
import com.hospital.service.PatientService;
import com.hospital.service.RoomService;
import com.hospital.service.BillService;
import com.hospital.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/patient")
public class PatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;
    private DoctorService doctorService;
    private RoomService roomService;
    private BillService billService;
    private static final Logger LOGGER = Logger.getLogger(PatientServlet.class.getName());

    @Override
    public void init() throws ServletException {
        super.init();
        patientService = new PatientService();
        doctorService = new DoctorService();
        roomService = new RoomService();
        billService = new BillService();
        LOGGER.info("PatientServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            LOGGER.info("No valid session found, redirecting to /patient/login");
            response.sendRedirect(request.getContextPath() + "/patient/login");
            return;
        }

        String action = request.getParameter("action");
        Patient loggedInPatient = (Patient) session.getAttribute("patient");
        request.setAttribute("name", loggedInPatient.getName());

        LOGGER.info("Processing GET request with action: " + action + " for patientId: " + loggedInPatient.getId());

        try {
            if (action == null || action.isEmpty()) {
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            } else if (action.equals("logout")) {
                LOGGER.info("Patient logging out: " + loggedInPatient.getGmail());
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/patient/login");
            } else if (action.equals("channeling")) {
                List<Doctor> doctors = doctorService.getAllDoctors();
                request.setAttribute("doctors", doctors);
                request.getRequestDispatcher("/patient/ChannelingForm.jsp").forward(request, response);
            } else if (action.equals("doctors")) {
                List<Doctor> doctors = doctorService.getAllDoctors();
                request.setAttribute("doctors", doctors);
                request.getRequestDispatcher("/patient/DoctorProfile.jsp").forward(request, response);
            } else if (action.equals("rooms")) {
                List<Room> rooms = roomService.getAvailableRooms();
                request.setAttribute("availableRooms", rooms);
                request.getRequestDispatcher("/patient/RoomAvailability.jsp").forward(request, response);
            } else if (action.equals("bookRoomForm")) {
                String roomId = request.getParameter("roomId");
                List<Room> rooms = roomService.getAvailableRooms();
                request.setAttribute("availableRooms", rooms);
                request.setAttribute("selectedRoomId", roomId);
                request.getRequestDispatcher("/patient/RoomBookingForm.jsp").forward(request, response);
            } else if (action.equals("makeRoomAvailableForm")) {
                String roomId = request.getParameter("roomId");
                request.setAttribute("roomId", roomId);
                request.getRequestDispatcher("/patient/RoomCheckoutForm.jsp").forward(request, response);
            } else if (action.equals("bookAmbulanceForm")) {
                request.getRequestDispatcher("/patient/AmbulanceBookingForm.jsp").forward(request, response);
            } else if (action.equals("viewBookedAmbulances")) {
                List<Ambulance> bookedAmbulances = patientService.getBookedAmbulances(loggedInPatient.getId());
                request.setAttribute("bookedAmbulances", bookedAmbulances);
                request.getRequestDispatcher("/patient/BookedAmbulances.jsp").forward(request, response);
            } else if (action.equals("ambulanceDashboard")) {
                request.getRequestDispatcher("/patient/AmbulanceDashboard.jsp").forward(request, response);
            } else if (action.equals("payBill")) {
                String roomId = request.getParameter("roomId");
                if (roomId == null || roomId.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Room ID is required.");
                    request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
                    return;
                }
                BillService.Bill bill = billService.getBillByPatientAndRoom(loggedInPatient.getId(), roomId);
                if (bill != null) {
                    request.setAttribute("bill", bill);
                    request.getRequestDispatcher("/patient/PayBill.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "No pending bill found for this room.");
                    request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
                }
            } else if (action.equals("payAppointmentBill")) {
                String appointmentIdStr = request.getParameter("appointmentId");
                if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Appointment ID is required.");
                    request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
                    return;
                }
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    BillService.Bill bill = billService.getBillByPatientAndAppointment(loggedInPatient.getId(), appointmentId);
                    if (bill != null) {
                        request.setAttribute("bill", bill);
                        request.getRequestDispatcher("/patient/PayAppointmentBill.jsp").forward(request, response);
                    } else {
                        request.setAttribute("errorMessage", "No pending bill found for this appointment.");
                        request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid appointmentId format: " + appointmentIdStr, e);
                    request.setAttribute("errorMessage", "Invalid appointment ID.");
                    request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
                }
            } else if (action.equals("viewBills")) {
                List<BillService.Bill> pendingRoomBills = billService.getPendingRoomBillsByPatient(loggedInPatient.getId());
                List<BillService.Bill> paidRoomBills = billService.getPaidRoomBillsByPatient(loggedInPatient.getId());
                List<BillService.Bill> pendingAppointmentBills = billService.getPendingAppointmentBillsByPatient(loggedInPatient.getId());
                List<BillService.Bill> paidAppointmentBills = billService.getPaidAppointmentBillsByPatient(loggedInPatient.getId());
                request.setAttribute("pendingRoomBills", pendingRoomBills);
                request.setAttribute("paidRoomBills", paidRoomBills);
                request.setAttribute("pendingAppointmentBills", pendingAppointmentBills);
                request.setAttribute("paidAppointmentBills", paidAppointmentBills);
                request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
            } else {
                LOGGER.warning("Unsupported GET action: " + action + " for patientId: " + loggedInPatient.getId());
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method not supported for action: " + action);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error processing GET action: " + action + " for patientId: " + loggedInPatient.getId(), e);
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error processing GET action: " + action + " for patientId: " + loggedInPatient.getId(), e);
            request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            LOGGER.info("No valid session found, redirecting to /patient/login");
            response.sendRedirect(request.getContextPath() + "/patient/login");
            return;
        }

        String action = request.getParameter("action");
        Patient loggedInPatient = (Patient) session.getAttribute("patient");
        request.setAttribute("name", loggedInPatient.getName());

        LOGGER.info("Processing POST request with action: " + action + " for patientId: " + loggedInPatient.getId());

        try {
            if (action == null || action.trim().isEmpty()) {
                LOGGER.warning("No action specified for POST request by patientId: " + loggedInPatient.getId());
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No action specified");
                return;
            }

            if (action.equals("logout")) {
                LOGGER.info("Patient logging out: " + loggedInPatient.getGmail());
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/patient/login");
            } else if (action.equals("bookChanneling")) {
                String doctorId = request.getParameter("doctor");
                String appointmentDate = request.getParameter("appointmentDate");
                String appointmentTime = request.getParameter("appointmentTime");

                if (doctorId == null || doctorId.trim().isEmpty() || 
                    appointmentDate == null || appointmentDate.trim().isEmpty() || 
                    appointmentTime == null || appointmentTime.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Please fill all appointment fields correctly.");
                    forwardToChannelingForm(request, response, loggedInPatient);
                    return;
                }

                try {
                    java.time.LocalDate.parse(appointmentDate);
                } catch (Exception e) {
                    LOGGER.warning("Invalid appointmentDate format: " + appointmentDate + " for patientId: " + loggedInPatient.getId());
                    request.setAttribute("errorMessage", "Appointment date must be in YYYY-MM-DD format.");
                    forwardToChannelingForm(request, response, loggedInPatient);
                    return;
                }

                boolean booked = patientService.bookAppointment(
                    loggedInPatient.getId(),
                    doctorId,
                    appointmentDate,
                    appointmentTime
                );
                if (booked) {
                    int appointmentId = getLastInsertedAppointmentId(loggedInPatient.getId(), doctorId, appointmentDate, appointmentTime);
                    try {
                        billService.createAppointmentBill(loggedInPatient.getId(), appointmentId, appointmentDate, 100.00);
                        request.setAttribute("successMessage", 
                            "Appointment booked successfully with Doctor ID: " + doctorId + 
                            " on " + appointmentDate + " at " + appointmentTime);
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Failed to create appointment bill for patientId: " + loggedInPatient.getId() + 
                                  ", appointmentId: " + appointmentId + ", SQLState: " + e.getSQLState() + 
                                  ", ErrorCode: " + e.getErrorCode(), e);
                        request.setAttribute("errorMessage", "Appointment booked, but failed to generate bill: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("errorMessage", "Failed to book appointment. Please try again.");
                }
                forwardToChannelingForm(request, response, loggedInPatient);
            } else if (action.equals("bookRoom")) {
                String roomId = request.getParameter("roomType");
                String checkInDate = request.getParameter("checkInDate");

                if (roomId == null || roomId.trim().isEmpty() || 
                    checkInDate == null || checkInDate.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Please fill all room booking fields correctly.");
                    request.getRequestDispatcher("/patient/RoomBookingForm.jsp").forward(request, response);
                    return;
                }

                boolean booked = patientService.bookRoom(
                    loggedInPatient.getId(),
                    roomId,
                    checkInDate
                );
                if (booked) {
                    request.setAttribute("successMessage", 
                        "Room booked successfully: Room ID " + roomId + 
                        " from " + checkInDate);
                } else {
                    request.setAttribute("errorMessage", "Failed to book room. Room may not be available.");
                }
                request.getRequestDispatcher("/patient/RoomBookingForm.jsp").forward(request, response);
            } else if (action.equals("makeRoomAvailable")) {
                String roomId = request.getParameter("roomId");
                if (roomId == null || roomId.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Room ID is required for checkout.");
                    request.getRequestDispatcher("/patient/RoomCheckoutForm.jsp").forward(request, response);
                    return;
                }
                try {
                    boolean success = roomService.makeRoomAvailable(roomId);
                    if (success) {
                        request.setAttribute("successMessage", "Room " + roomId + " checked out successfully and bill generated.");
                    } else {
                        request.setAttribute("errorMessage", "Failed to check out room. Room may not be booked.");
                    }
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Failed to make room available for roomId: " + roomId + 
                              ", patientId: " + loggedInPatient.getId() + ", SQLState: " + e.getSQLState() + 
                              ", ErrorCode: " + e.getErrorCode(), e);
                    request.setAttribute("errorMessage", "Failed to check out room: " + e.getMessage());
                }
                request.getRequestDispatcher("/patient/RoomCheckoutForm.jsp").forward(request, response);
            } else if (action.equals("bookAmbulance")) {
                String pickupLocation = request.getParameter("pickupLocation");
                String destination = request.getParameter("destination");
                String requestDate = request.getParameter("requestDate");
                String requestTime = request.getParameter("requestTime");

                if (pickupLocation == null || pickupLocation.trim().isEmpty() ||
                    destination == null || destination.trim().isEmpty() ||
                    requestDate == null || requestDate.trim().isEmpty() ||
                    requestTime == null || requestTime.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Please fill all ambulance booking fields correctly.");
                    request.getRequestDispatcher("/patient/AmbulanceBookingForm.jsp").forward(request, response);
                    return;
                }

                boolean booked = patientService.bookAmbulance(
                    loggedInPatient.getId(),
                    pickupLocation,
                    destination,
                    requestDate,
                    requestTime
                );
                if (booked) {
                    request.setAttribute("successMessage",
                        "Ambulance booked successfully for " + pickupLocation +
                        " to " + destination + " on " + requestDate + " at " + requestTime);
                } else {
                    request.setAttribute("errorMessage", "Failed to book ambulance. No available ambulances.");
                }
                request.getRequestDispatcher("/patient/AmbulanceBookingForm.jsp").forward(request, response);
            } else if (action.equals("processPayment")) {
                String billIdStr = request.getParameter("billId");
                String roomId = request.getParameter("roomId");
                String appointmentIdStr = request.getParameter("appointmentId");
                String cardNumber = request.getParameter("cardNumber");
                String expiry = request.getParameter("expiry");
                String cvv = request.getParameter("cvv");

                if (billIdStr == null || billIdStr.trim().isEmpty() ||
                    cardNumber == null || cardNumber.trim().isEmpty() ||
                    expiry == null || expiry.trim().isEmpty() ||
                    cvv == null || cvv.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Please fill all payment fields correctly.");
                    forwardToPaymentPage(request, response, loggedInPatient, roomId, appointmentIdStr);
                    return;
                }

                try {
                    int billId = Integer.parseInt(billIdStr);
                    boolean paid = billService.processPayment(billId, cardNumber, expiry, cvv);
                    if (paid) {
                        request.setAttribute("successMessage", "Payment processed successfully.");
                    } else {
                        request.setAttribute("errorMessage", "Payment failed. Please check card details.");
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid billId format: " + billIdStr, e);
                    request.setAttribute("errorMessage", "Invalid bill ID.");
                }
                forwardToPaymentPage(request, response, loggedInPatient, roomId, appointmentIdStr);
            } else {
                LOGGER.warning("Unsupported POST action: " + action + " for patientId: " + loggedInPatient.getId());
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not supported for action: " + action);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error processing POST action: " + action + " for patientId: " + loggedInPatient.getId(), e);
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error processing POST action: " + action + " for patientId: " + loggedInPatient.getId(), e);
            request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
        }
    }

    private void forwardToChannelingForm(HttpServletRequest request, HttpServletResponse response, Patient loggedInPatient) 
            throws ServletException, IOException {
        try {
            List<Doctor> doctors = doctorService.getAllDoctors();
            request.setAttribute("doctors", doctors);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching doctors for channeling form after booking for patientId: " + 
                      loggedInPatient.getId(), e);
            request.setAttribute("errorMessage", "Error loading doctors: " + e.getMessage());
        }
        request.getRequestDispatcher("/patient/ChannelingForm.jsp").forward(request, response);
    }

    private void forwardToPaymentPage(HttpServletRequest request, HttpServletResponse response, Patient loggedInPatient, 
                                     String roomId, String appointmentIdStr) throws ServletException, IOException {
        try {
            BillService.Bill bill = null;
            if (roomId != null && !roomId.trim().isEmpty()) {
                bill = billService.getBillByPatientAndRoom(loggedInPatient.getId(), roomId);
                request.setAttribute("bill", bill);
                request.getRequestDispatcher("/patient/PayBill.jsp").forward(request, response);
            } else if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty()) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    bill = billService.getBillByPatientAndAppointment(loggedInPatient.getId(), appointmentId);
                    request.setAttribute("bill", bill);
                    request.getRequestDispatcher("/patient/PayAppointmentBill.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid appointmentId format: " + appointmentIdStr, e);
                    request.setAttribute("errorMessage", "Invalid appointment ID.");
                    request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Invalid bill type.");
                request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching bill after payment for patientId: " + loggedInPatient.getId(), e);
            request.setAttribute("errorMessage", "Error loading bill: " + e.getMessage());
            request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
        }
    }

    private int getLastInsertedAppointmentId(String patientId, String doctorId, String appointmentDate, String appointmentTime) 
            throws SQLException {
        String sql = "SELECT id FROM appointments WHERE patient_id = ? AND doctor_id = ? AND appointment_date = ? " +
                     "AND appointment_time = ? ORDER BY id DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.severe("Database connection is null");
                throw new SQLException("Failed to establish database connection");
            }
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, patientId);
            stmt.setString(2, doctorId);
            stmt.setString(3, appointmentDate);
            stmt.setString(4, appointmentTime);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
            LOGGER.warning("No appointment found for patientId: " + patientId + ", doctorId: " + doctorId + 
                           ", date: " + appointmentDate + ", time: " + appointmentTime);
            throw new SQLException("Failed to retrieve appointment ID");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing resources in getLastInsertedAppointmentId", e);
            }
        }
    }
}