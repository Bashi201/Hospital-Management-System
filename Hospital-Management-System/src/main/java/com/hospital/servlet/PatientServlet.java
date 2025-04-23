package com.hospital.servlet;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.model.Room;
import com.hospital.service.DoctorService;
import com.hospital.service.PatientService;
import com.hospital.service.RoomService;

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
    private static final Logger LOGGER = Logger.getLogger(PatientServlet.class.getName());

    @Override
    public void init() throws ServletException {
        super.init();
        patientService = new PatientService();
        doctorService = new DoctorService();
        roomService = new RoomService();
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

        if (action == null) {
            request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
        } else if (action.equals("channeling")) {
            String doctorId = request.getParameter("doctorId");
            if (doctorId != null) {
                request.setAttribute("selectedDoctorId", doctorId);
            }
            try {
                List<Doctor> doctors = doctorService.getAllDoctors();
                request.setAttribute("doctors", doctors);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching doctors for channeling form", e);
                request.setAttribute("errorMessage", "Error loading doctors: " + e.getMessage());
            }
            request.getRequestDispatcher("/patient/ChannelingForm.jsp").forward(request, response);
        } else if (action.equals("doctors")) {
            try {
                List<Doctor> doctors = doctorService.getAllDoctors();
                request.setAttribute("doctors", doctors);
                LOGGER.info("Fetched " + doctors.size() + " doctors for DoctorProfile.jsp");
                request.getRequestDispatcher("/patient/DoctorProfile.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching doctors for profile", e);
                request.setAttribute("errorMessage", "Error fetching doctors: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("rooms")) {
            try {
                List<Room> availableRooms = roomService.getAvailableRooms();
                request.setAttribute("availableRooms", availableRooms);
                request.getRequestDispatcher("/patient/RoomAvailability.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching rooms", e);
                request.setAttribute("errorMessage", "Error fetching rooms: " + e.getMessage());
                request.getRequestDispatcher("/patient/PatientDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("bookRoomForm")) { // New action for booking form
            String roomId = request.getParameter("roomId");
            if (roomId != null) {
                request.setAttribute("selectedRoomId", roomId);
            }
            try {
                List<Room> availableRooms = roomService.getAvailableRooms();
                request.setAttribute("availableRooms", availableRooms);
                LOGGER.info("Forwarding to RoomBookingForm.jsp with selectedRoomId: " + roomId);
                request.getRequestDispatcher("/patient/RoomBookingForm.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching rooms for booking form", e);
                request.setAttribute("errorMessage", "Error loading rooms: " + e.getMessage());
                request.getRequestDispatcher("/patient/RoomAvailability.jsp").forward(request, response);
            }
        } else if (action.equals("logout")) {
            LOGGER.info("Patient logging out: " + loggedInPatient.getGmail());
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/patient/login");
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
                String checkOutDate = request.getParameter("checkOutDate");

                if (roomId != null && !roomId.trim().isEmpty() && 
                    checkInDate != null && !checkInDate.trim().isEmpty() && 
                    checkOutDate != null && !checkOutDate.trim().isEmpty()) {
                    try {
                        boolean booked = patientService.bookRoom(
                            loggedInPatient.getId(),
                            roomId,
                            checkInDate,
                            checkOutDate
                        );
                        if (booked) {
                            request.setAttribute("successMessage", 
                                "Room booked successfully: Room ID " + roomId + 
                                " from " + checkInDate + " to " + checkOutDate);
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
            } else {
                response.sendRedirect(request.getContextPath() + "/patient");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/patient");
        }
    }
}