package com.hospital.servlet;

import com.hospital.model.Patient;
import com.hospital.service.PatientService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/patientLogin")
public class PatientLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        super.init();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("patient") != null) {
            response.sendRedirect(request.getContextPath() + "/patientDashboard");
        } else {
            request.getRequestDispatcher("/patient/PatientLogin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String gmail = request.getParameter("gmail");
        String password = request.getParameter("password");

        try {
            List<Patient> patients = patientService.getAllPatients(); // This call throws SQLException
            Patient authenticatedPatient = null;

            for (Patient patient : patients) {
                if (patient.getGmail().equals(gmail) && patient.getPassword().equals(password)) {
                    authenticatedPatient = patient;
                    break;
                }
            }

            if (authenticatedPatient != null) {
                HttpSession session = request.getSession();
                session.setAttribute("patient", authenticatedPatient);
                response.sendRedirect(request.getContextPath() + "/patientDashboard");
            } else {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("/patient/PatientLogin.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientLogin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientLogin.jsp").forward(request, response);
        }
    }
}