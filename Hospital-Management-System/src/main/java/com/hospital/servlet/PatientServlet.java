package com.hospital.servlet;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.model.Room;
import com.hospital.model.Ambulance;
import com.hospital.service.DoctorService;
import com.hospital.service.PatientService;
import com.hospital.service.RoomService;
import com.hospital.service.BillService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
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

        if (action != null && action.equals("logout")) {
            LOGGER.info("Patient logging out: " + loggedInPatient.getGmail());
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/patient/login");
            return;
        }

        if (action == null || action.isEmpty()) {
            request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
        } else if (action.equals("channeling")) {
            try {
                List<Doctor> doctors = doctorService.getAllDoctors();
                request.setAttribute("doctors", doctors);
                request.getRequestDispatcher("/patient/ChannelingForm.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching doctors", e);
                request.setAttribute("errorMessage", "Error loading doctors: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("doctors")) {
            try {
                List<Doctor> doctors = doctorService.getAllDoctors();
                request.setAttribute("doctors", doctors);
                request.getRequestDispatcher("/patient/DoctorProfile.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching doctors", e);
                request.setAttribute("errorMessage", "Error loading doctors: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("rooms")) {
            try {
                List<Room> rooms = roomService.getAvailableRooms();
                request.setAttribute("availableRooms", rooms);
                request.getRequestDispatcher("/patient/RoomAvailability.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching rooms", e);
                request.setAttribute("errorMessage", "Error loading rooms: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("bookRoomForm")) {
            try {
                String roomId = request.getParameter("roomId");
                List<Room> rooms = roomService.getAvailableRooms();
                request.setAttribute("availableRooms", rooms);
                request.setAttribute("selectedRoomId", roomId);
                request.getRequestDispatcher("/patient/RoomBookingForm.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching rooms for booking form", e);
                request.setAttribute("errorMessage", "Error loading room booking form: " + e.getMessage());
                request.getRequestDispatcher("/patient/RoomAvailability.jsp").forward(request, response);
            }
        } else if (action.equals("bookAmbulanceForm")) {
            request.getRequestDispatcher("/patient/AmbulanceBookingForm.jsp").forward(request, response);
        } else if (action.equals("viewBookedAmbulances")) {
            try {
                List<Ambulance> bookedAmbulances = patientService.getBookedAmbulances(loggedInPatient.getId());
                request.setAttribute("bookedAmbulances", bookedAmbulances);
                request.getRequestDispatcher("/patient/BookedAmbulances.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching booked ambulances", e);
                request.setAttribute("errorMessage", "Error loading booked ambulances: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("ambulanceDashboard")) {
            request.getRequestDispatcher("/patient/AmbulanceDashboard.jsp").forward(request, response);
        } else if (action.equals("payBill")) {
            try {
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
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching bill for roomId: " + request.getParameter("roomId"), e);
                request.setAttribute("errorMessage", "Error loading bill: " + e.getMessage());
                request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
            }
        } else if (action.equals("viewBills")) {
            try {
                List<BillService.Bill> bills = billService.getPendingBillsByPatient(loggedInPatient.getId());
                request.setAttribute("bills", bills);
                request.getRequestDispatcher("/patient/ViewBills.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching pending bills for patientId: " + loggedInPatient.getId(), e);
                request.setAttribute("errorMessage", "Error loading bills: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Unexpected error fetching pending bills for patientId: " + loggedInPatient.getId(), e);
                request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            }
        } else {
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

        if (action != null) {
            if (action.equals("logout")) {
                LOGGER.info("Patient logging out: " + loggedInPatient.getGmail());
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/patient/login");
            } else if (action.equals("bookChanneling")) {
                String doctor = request.getParameter("doctor");
                String appointmentDate = request.getParameter("appointmentDate");
                String appointmentTime = request.getParameter("appointmentTime");

                if (doctor != null && !doctor.trim().isEmpty() && 
                    appointmentDate != null && !appointmentDate.trim().isEmpty() && 
                    appointmentTime != null && !appointmentTime.trim().isEmpty()) {
                    try {
                        boolean booked = patientService.bookAppointment(
                            loggedInPatient.getId(),
                            doctor,
                            appointmentDate,
                            appointmentTime
                        );
                        if (booked) {
                            request.setAttribute("successMessage", 
                                "Appointment booked successfully with Doctor ID: " + doctor + 
                                " on " + appointmentDate + " at " + appointmentTime);
                        } else {
                            request.setAttribute("errorMessage", "Failed to book appointment.");
                        }
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Error booking appointment", e);
                        request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("errorMessage", "Please fill all fields correctly.");
                }
                try {
                    List<Doctor> doctors = doctorService.getAllDoctors();
                    request.setAttribute("doctors", doctors);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error fetching doctors for channeling form after booking", e);
                    request.setAttribute("errorMessage", "Error loading doctors: " + e.getMessage());
                }
                request.getRequestDispatcher("/patient/ChannelingForm.jsp").forward(request, response);
            } else if (action.equals("bookRoom")) {
                String roomId = request.getParameter("roomType");
                String checkInDate = request.getParameter("checkInDate");

                if (roomId != null && !roomId.trim().isEmpty() && 
                    checkInDate != null && !checkInDate.trim().isEmpty()) {
                    try {
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
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Error booking room", e);
                        request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("errorMessage", "Please fill all fields correctly.");
                }
                request.getRequestDispatcher("/patient/RoomBookingForm.jsp").forward(request, response);
            } else if (action.equals("bookAmbulance")) {
                String pickupLocation = request.getParameter("pickupLocation");
                String destination = request.getParameter("destination");
                String requestDate = request.getParameter("requestDate");
                String requestTime = request.getParameter("requestTime");

                if (pickupLocation != null && !pickupLocation.trim().isEmpty() &&
                    destination != null && !destination.trim().isEmpty() &&
                    requestDate != null && !requestDate.trim().isEmpty() &&
                    requestTime != null && !requestTime.trim().isEmpty()) {
                    try {
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
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Error booking ambulance", e);
                        request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("errorMessage", "Please fill all fields correctly.");
                }
                request.getRequestDispatcher("/patient/AmbulanceBookingForm.jsp").forward(request, response);
            } else if (action.equals("processPayment")) {
                String billId = request.getParameter("billId");
                String roomId = request.getParameter("roomId");
                String cardNumber = request.getParameter("cardNumber");
                String expiry = request.getParameter("expiry");
                String cvv = request.getParameter("cvv");

                if (billId != null && !billId.trim().isEmpty() &&
                    cardNumber != null && !cardNumber.trim().isEmpty() &&
                    expiry != null && !expiry.trim().isEmpty() &&
                    cvv != null && !cvv.trim().isEmpty()) {
                    try {
                        boolean paid = billService.processPayment(Integer.parseInt(billId), cardNumber, expiry, cvv);
                        if (paid) {
                            request.setAttribute("successMessage", "Payment processed successfully.");
                        } else {
                            request.setAttribute("errorMessage", "Payment failed. Please check card details.");
                        }
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Error processing payment for billId: " + billId, e);
                        request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                    }
                } else {
                    request.setAttribute("errorMessage", "Please fill all payment fields correctly.");
                }
                try {
                    BillService.Bill bill = billService.getBillByPatientAndRoom(loggedInPatient.getId(), roomId);
                    request.setAttribute("bill", bill);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error fetching bill after payment for roomId: " + roomId, e);
                    request.setAttribute("errorMessage", "Error loading bill: " + e.getMessage());
                }
                request.getRequestDispatcher("/patient/PayBill.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/login");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/login");
        }
    }
}