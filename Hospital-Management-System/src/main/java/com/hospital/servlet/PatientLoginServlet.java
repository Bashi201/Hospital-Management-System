package com.hospital.servlet;

import com.hospital.model.Patient;
import com.hospital.service.PatientService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/patient/login") // Lowercase for consistency
public class PatientLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        super.init();
        patientService = new PatientService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String gmail = request.getParameter("gmail");
        String password = request.getParameter("password");

        // Check if session already exists
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("patient") != null) {
            response.sendRedirect(request.getContextPath() + "/patient");
            return;
        }

        // Authenticate patient
        Patient patient = authenticatePatient(gmail, password);

        if (patient != null) {
            // Create a new session for the authenticated patient
            session = request.getSession(true);
            session.setAttribute("patient", patient);
            session.setAttribute("name", patient.getName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Redirect to the patient dashboard
            response.sendRedirect(request.getContextPath() + "/patient");
        } else {
            // Authentication failed, forward back to login page with error
            request.setAttribute("errorMessage", "Invalid Gmail or password");
            request.getRequestDispatcher("/patient/PatientLoging.jsp").forward(request, response); // Corrected JSP name
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("patient") != null) {
            response.sendRedirect(request.getContextPath() + "/patient");
        } else {
            // Show the login page
            request.getRequestDispatcher("/patient/PatientLoging.jsp").forward(request, response); // Corrected JSP name
        }
    }

    private Patient authenticatePatient(String gmail, String password) {
        for (Patient patient : patientService.getAllPatients()) {
            if (patient.getGmail().equalsIgnoreCase(gmail) && patient.getPassword().equals(password)) {
                return patient;
            }
        }
        return null;
    }
}