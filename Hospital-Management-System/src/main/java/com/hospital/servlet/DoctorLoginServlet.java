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
 * Servlet for handling doctor login functionality.
 * Maps to "/doctor/login" and processes login requests.
 */
@WebServlet("/doctor/login")
public class DoctorLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DoctorService doctorService;
    private static final Logger LOGGER = Logger.getLogger(DoctorLoginServlet.class.getName());

    /**
     * Initializes the servlet and creates an instance of DoctorService.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        doctorService = new DoctorService();
        LOGGER.info("DoctorLoginServlet initialized");
    }

    /**
     * Handles GET requests by displaying the login page or redirecting to dashboard if already logged in.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if doctor is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("doctor") != null) {
            LOGGER.info("Doctor already logged in, redirecting to /doctor");
            response.sendRedirect(request.getContextPath() + "/doctor");
            return;
        }
        // Display the login page
        LOGGER.info("Displaying doctor login page");
        request.getRequestDispatcher("/doctor/DoctorLoging.jsp").forward(request, response);
    }

    /**
     * Handles POST requests for doctor login form submission.
     * Authenticates the doctor and redirects to dashboard on success, or back to login on failure.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve email and password from the form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Check if session already exists with a logged-in doctor
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("doctor") != null) {
            LOGGER.info("Doctor already logged in, redirecting to /doctor");
            response.sendRedirect(request.getContextPath() + "/doctor");
            return;
        }

        try {
            // Authenticate the doctor using DoctorService
            Doctor doctor = doctorService.authenticateDoctor(email, password);

            if (doctor != null) {
                // Create a new session and store doctor details
                session = request.getSession(true);
                session.setAttribute("doctor", doctor);
                session.setAttribute("name", doctor.getName());
                session.setMaxInactiveInterval(30 * 60); // Session timeout: 30 minutes
                LOGGER.info("Doctor logged in successfully: " + email);
                // Redirect to the doctor dashboard
                response.sendRedirect(request.getContextPath() + "/doctor");
            } else {
                // Authentication failed, set error message and forward back to login page
                LOGGER.warning("Login failed for email: " + email);
                request.setAttribute("errorMessage", "Invalid email or password");
                request.getRequestDispatcher("/doctor/DoctorLoging.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Handle database errors
            LOGGER.log(Level.SEVERE, "Database error during login for email: " + email, e);
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/doctor/DoctorLoging.jsp").forward(request, response);
        }
    }
}