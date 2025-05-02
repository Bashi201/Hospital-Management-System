package com.hospital.servlet;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.service.DoctorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet for handling doctor dashboard and related actions.
 * Maps to "/doctor" and manages dashboard, appointments, patients, rooms, salary, settings, meal orders, and logout.
 */
@WebServlet("/doctor")
public class DoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    private static final Logger LOGGER = Logger.getLogger(DoctorServlet.class.getName());

    /**
     * Initializes the servlet and creates an instance of DoctorService.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        doctorService = new DoctorService();
        LOGGER.info("DoctorServlet initialized");
    }

    /**
     * Handles GET requests for the doctor dashboard and actions.
     * Requires a valid session; redirects to login if not authenticated.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check for a valid session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("doctor") == null) {
            LOGGER.info("No valid session found, redirecting to /doctor/login");
            response.sendRedirect(request.getContextPath() + "/doctor/login");
            return;
        }

        // Get the logged-in doctor and set name attribute
        Doctor loggedInDoctor = (Doctor) session.getAttribute("doctor");
        request.setAttribute("name", loggedInDoctor.getName());

        // Determine the action requested
        String action = request.getParameter("action");

        if (action == null) {
            // Default action: show the dashboard
            LOGGER.info("Displaying doctor dashboard for: " + loggedInDoctor.getEmail());
            request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
        } else if (action.equals("appointments")) {
            try {
                // Fetch appointments for the logged-in doctor
                LOGGER.info("Fetching appointments for doctor: " + loggedInDoctor.getId());
                var appointments = doctorService.getAppointmentsForDoctor(loggedInDoctor.getId());
                request.setAttribute("appointments", appointments);
                request.getRequestDispatcher("/doctor/Appointments.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching appointments", e);
                request.setAttribute("errorMessage", "Unable to fetch appointments. Please try again later.");
                request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("patients")) {
            try {
                // Fetch confirmed patients for the logged-in doctor
                LOGGER.info("Fetching confirmed patients for doctor: " + loggedInDoctor.getId());
                var patients = doctorService.getConfirmedPatientsForDoctor(loggedInDoctor.getId());
                request.setAttribute("patients", patients);
                request.getRequestDispatcher("/doctor/Patients.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching patients", e);
                request.setAttribute("errorMessage", "Unable to fetch patients. Please try again later.");
                request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("patientDetails")) {
            try {
                String patientId = request.getParameter("id");
                if (patientId == null || patientId.trim().isEmpty()) {
                    LOGGER.warning("Invalid patient ID in patientDetails action");
                    request.setAttribute("errorMessage", "Invalid patient ID.");
                    response.sendRedirect(request.getContextPath() + "/doctor?action=patients");
                    return;
                }
                LOGGER.info("Fetching details for patient ID: " + patientId);
                Patient patient = doctorService.getPatientById(patientId);
                if (patient == null) {
                    request.setAttribute("errorMessage", "Patient not found.");
                    response.sendRedirect(request.getContextPath() + "/doctor?action=patients");
                    return;
                }
                var notes = doctorService.getPatientNotes(patientId, loggedInDoctor.getId());
                request.setAttribute("patient", patient);
                request.setAttribute("notes", notes);
                request.getRequestDispatcher("/doctor/PatientDetails.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching patient details", e);
                request.setAttribute("errorMessage", "Unable to fetch patient details. Please try again later.");
                response.sendRedirect(request.getContextPath() + "/doctor?action=patients");
            }
        } else if (action.equals("rooms")) {
            // Placeholder for rooms page (to be implemented)
            LOGGER.info("Rooms action requested (not implemented yet)");
            request.setAttribute("errorMessage", "Rooms page not implemented yet.");
            request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
        } else if (action.equals("salary")) {
            try {
                // Fetch paysheets for the logged-in doctor
                LOGGER.info("Fetching salary details for doctor: " + loggedInDoctor.getId());
                var paysheets = doctorService.getPaysheetsForDoctor(loggedInDoctor.getId());
                request.setAttribute("paysheets", paysheets);
                request.getRequestDispatcher("/doctor/Salary.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching salary details", e);
                request.setAttribute("errorMessage", "Unable to fetch salary details. Please try again later.");
                request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
            }
        } else if (action.equals("settings")) {
            // Show settings page
            LOGGER.info("Displaying settings page for doctor: " + loggedInDoctor.getEmail());
            request.getRequestDispatcher("/doctor/Settings.jsp").forward(request, response);
        } else if (action.equals("mealOrder")) {
            java.util.List<DoctorService.MealOrder> mealOrders = new java.util.ArrayList<>();
            try {
                // Fetch meal orders for the logged-in doctor
                LOGGER.info("Fetching meal orders for doctor: " + loggedInDoctor.getId());
                mealOrders = doctorService.getMealOrdersForDoctor(loggedInDoctor.getId());
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching meal orders", e);
                request.setAttribute("errorMessage", "Unable to fetch meal orders. Please try again later.");
            }
            request.setAttribute("mealOrders", mealOrders);
            request.getRequestDispatcher("/doctor/MealOrder.jsp").forward(request, response);
        } else if (action.equals("logout")) {
            // Invalidate session and redirect to login
            LOGGER.info("Doctor logging out: " + loggedInDoctor.getEmail());
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/doctor/login");
        } else {
            // Unknown action, redirect to dashboard
            LOGGER.warning("Unknown action requested: " + action);
            response.sendRedirect(request.getContextPath() + "/doctor");
        }
    }

    /**
     * Handles POST requests (e.g., logout form submission, confirm/delete appointment, place meal order).
     * Requires a valid session; redirects to login if not authenticated.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check for a valid session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("doctor") == null) {
            LOGGER.info("No valid session found, redirecting to /doctor/login");
            response.sendRedirect(request.getContextPath() + "/doctor/login");
            return;
        }

        // Get the action from the request
        String action = request.getParameter("action");
        Doctor loggedInDoctor = (Doctor) session.getAttribute("doctor");
        request.setAttribute("name", loggedInDoctor.getName());

        if (action != null) {
            if (action.equals("logout")) {
                // Handle logout via POST (e.g., from dashboard form)
                LOGGER.info("Doctor logging out via POST: " + loggedInDoctor.getEmail());
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/doctor/login");
            } else if (action.equals("confirmAppointment")) {
                try {
                    int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                    LOGGER.info("Confirming appointment ID: " + appointmentId);
                    boolean confirmed = doctorService.confirmAppointment(appointmentId);
                    if (confirmed) {
                        request.setAttribute("successMessage", "Appointment confirmed successfully.");
                    } else {
                        request.setAttribute("errorMessage", "Failed to confirm appointment. It may already be confirmed or does not exist.");
                    }
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error confirming appointment", e);
                    request.setAttribute("errorMessage", "Error confirming appointment. Please try again.");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid appointment ID format", e);
                    request.setAttribute("errorMessage", "Invalid appointment ID.");
                }
                // Refresh appointments list
                try {
                    var appointments = doctorService.getAppointmentsForDoctor(loggedInDoctor.getId());
                    request.setAttribute("appointments", appointments);
                    request.getRequestDispatcher("/doctor/Appointments.jsp").forward(request, response);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error fetching appointments after confirm", e);
                    request.setAttribute("errorMessage", "Unable to fetch appointments. Please try again later.");
                    request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
                }
            } else if (action.equals("deleteAppointment")) {
                try {
                    int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                    LOGGER.info("Deleting appointment ID: " + appointmentId);
                    boolean deleted = doctorService.deleteAppointment(appointmentId);
                    if (deleted) {
                        request.setAttribute("successMessage", "Appointment deleted successfully.");
                    } else {
                        request.setAttribute("errorMessage", "Failed to delete appointment.");
                    }
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error deleting appointment", e);
                    request.setAttribute("errorMessage", "Error deleting appointment. Please try again.");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid appointment ID format", e);
                    request.setAttribute("errorMessage", "Invalid appointment ID.");
                }
                // Refresh appointments list
                try {
                    var appointments = doctorService.getAppointmentsForDoctor(loggedInDoctor.getId());
                    request.setAttribute("appointments", appointments);
                    request.getRequestDispatcher("/doctor/Appointments.jsp").forward(request, response);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error fetching appointments after delete", e);
                    request.setAttribute("errorMessage", "Unable to fetch appointments. Please try again later.");
                    request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
                }
            } else if (action.equals("addNote")) {
                try {
                    String patientId = request.getParameter("patientId");
                    String noteText = request.getParameter("noteText");
                    if (noteText == null || noteText.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Note cannot be empty.");
                    } else {
                        boolean added = doctorService.addPatientNote(patientId, loggedInDoctor.getId(), noteText);
                        if (added) {
                            request.setAttribute("successMessage", "Note added successfully.");
                        } else {
                            request.setAttribute("errorMessage", "Failed to add note.");
                        }
                    }
                    // Refresh patient details
                    Patient patient = doctorService.getPatientById(patientId);
                    var notes = doctorService.getPatientNotes(patientId, loggedInDoctor.getId());
                    request.setAttribute("patient", patient);
                    request.setAttribute("notes", notes);
                    request.getRequestDispatcher("/doctor/PatientDetails.jsp").forward(request, response);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error adding note", e);
                    request.setAttribute("errorMessage", "Error adding note. Please try again.");
                    response.sendRedirect(request.getContextPath() + "/doctor?action=patients");
                }
            } else if (action.equals("updateNote")) {
                try {
                    int noteId = Integer.parseInt(request.getParameter("noteId"));
                    String patientId = request.getParameter("patientId");
                    String noteText = request.getParameter("noteText");
                    if (noteText == null || noteText.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Note cannot be empty.");
                    } else {
                        boolean updated = doctorService.updatePatientNote(noteId, noteText);
                        if (updated) {
                            request.setAttribute("successMessage", "Note updated successfully.");
                        } else {
                            request.setAttribute("errorMessage", "Failed to update note.");
                        }
                    }
                    // Refresh patient details
                    Patient patient = doctorService.getPatientById(patientId);
                    var notes = doctorService.getPatientNotes(patientId, loggedInDoctor.getId());
                    request.setAttribute("patient", patient);
                    request.setAttribute("notes", notes);
                    request.getRequestDispatcher("/doctor/PatientDetails.jsp").forward(request, response);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error updating note", e);
                    request.setAttribute("errorMessage", "Error updating note. Please try again.");
                    response.sendRedirect(request.getContextPath() + "/doctor?action=patients");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid note ID format", e);
                    request.setAttribute("errorMessage", "Invalid note ID.");
                    response.sendRedirect(request.getContextPath() + "/doctor?action=patients");
                }
            } else if (action.equals("placeMealOrder")) {
                try {
                    // Process meal order
                    int chickenSalad = Integer.parseInt(request.getParameter("chickenSalad") != null ? request.getParameter("chickenSalad") : "0");
                    int vegPasta = Integer.parseInt(request.getParameter("vegPasta") != null ? request.getParameter("vegPasta") : "0");
                    int beefStirFry = Integer.parseInt(request.getParameter("beefStirFry") != null ? request.getParameter("beefStirFry") : "0");

                    if (chickenSalad == 0 && vegPasta == 0 && beefStirFry == 0) {
                        request.setAttribute("errorMessage", "Please select at least one meal item.");
                    } else {
                        // Calculate total cost and build items string
                        double totalCost = (chickenSalad * 10.00) + (vegPasta * 8.50) + (beefStirFry * 12.00);
                        StringBuilder items = new StringBuilder();
                        if (chickenSalad > 0) items.append("Grilled Chicken Salad x").append(chickenSalad).append(", ");
                        if (vegPasta > 0) items.append("Vegetarian Pasta x").append(vegPasta).append(", ");
                        if (beefStirFry > 0) items.append("Beef Stir-Fry x").append(beefStirFry).append(", ");
                        if (items.length() > 0) items.setLength(items.length() - 2); // Remove trailing comma and space

                        boolean ordered = doctorService.placeMealOrder(loggedInDoctor.getId(), items.toString(), totalCost);
                        if (ordered) {
                            request.setAttribute("successMessage", "Meal order placed successfully.");
                        } else {
                            request.setAttribute("errorMessage", "Failed to place meal order.");
                        }
                    }
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error placing meal order", e);
                    request.setAttribute("errorMessage", "Error placing meal order. Please try again.");
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid quantity format", e);
                    request.setAttribute("errorMessage", "Invalid quantity specified.");
                }
                // Refresh meal orders
                try {
                    var mealOrders = doctorService.getMealOrdersForDoctor(loggedInDoctor.getId());
                    request.setAttribute("mealOrders", mealOrders);
                    request.getRequestDispatcher("/doctor/MealOrder.jsp").forward(request, response);
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error fetching meal orders after placing order", e);
                    request.setAttribute("errorMessage", "Unable to fetch meal orders. Please try again later.");
                    request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
                }
            } else {
                // Unknown or no action, redirect to dashboard
                LOGGER.warning("Unknown POST action: " + action);
                response.sendRedirect(request.getContextPath() + "/doctor");
            }
        } else {
            LOGGER.warning("No action specified in POST request");
            response.sendRedirect(request.getContextPath() + "/doctor");
        }
    }
}