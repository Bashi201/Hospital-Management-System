package com.hospital.servlet;

import com.hospital.model.Patient;
import com.hospital.service.PatientService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/patientCreate")
public class PatientCreateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        super.init();
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/patient/PatientCreate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String phoneNumber = request.getParameter("phoneNumber");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String admittedTime = request.getParameter("admittedTime");
        String gmail = request.getParameter("gmail");
        String password = request.getParameter("password");

        Patient patient = new Patient();
        patient.setId(id);
        patient.setPhoneNumber(phoneNumber);
        patient.setName(name);
        patient.setGender(gender);
        patient.setAdmittedTime(admittedTime);
        patient.setGmail(gmail);
        patient.setPassword(password);

        try {
            if (patientService.createPatient(patient)) { // This call throws SQLException
                response.sendRedirect(request.getContextPath() + "/patientLogin");
            } else {
                request.setAttribute("errorMessage", "Error creating patient. Email might already exist or invalid data provided.");
                request.getRequestDispatcher("/patient/PatientCreate.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred while creating patient: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientCreate.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unexpected error occurred while creating patient: " + e.getMessage());
            request.getRequestDispatcher("/patient/PatientCreate.jsp").forward(request, response);
        }
    }
}