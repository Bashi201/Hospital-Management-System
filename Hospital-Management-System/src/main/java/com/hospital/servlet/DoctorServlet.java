package com.hospital.servlet;

import com.hospital.model.Doctor;
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
 * Maps to "/doctor" and manages dashboard, appointments, patients, rooms, and logout.
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
            // Placeholder for patients page (to be implemented)
            LOGGER.info("Patients action requested (not implemented yet)");
            request.setAttribute("errorMessage", "Patients page not implemented yet.");
            request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
        } else if (action.equals("rooms")) {
            // Placeholder for rooms page (to be implemented)
            LOGGER.info("Rooms action requested (not implemented yet)");
            request.setAttribute("errorMessage", "Rooms page not implemented yet.");
            request.getRequestDispatcher("/doctor/DoctorDashHome.jsp").forward(request, response);
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
     * Handles POST requests (e.g., logout form submission, confirm/delete appointment).
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
                String appointmentId = request.getParameter("appointmentId");
                // Placeholder for confirm action (not implemented as per requirement)
                LOGGER.info("Confirm appointment requested for ID: " + appointmentId + " (not implemented)");
                response.sendRedirect(request.getContextPath() + "/doctor?action=appointments");
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