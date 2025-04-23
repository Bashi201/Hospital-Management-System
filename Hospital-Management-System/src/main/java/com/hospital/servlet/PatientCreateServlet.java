package com.hospital.servlet;

import com.hospital.model.Patient;
import com.hospital.service.PatientService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/patient/ManagePatientCreate")
public class PatientCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward the request to the form JSP page
        request.getRequestDispatcher("/patient/ManagePatientCreate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String id = request.getParameter("id");
        String phoneNumber = request.getParameter("phoneNumber");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String admittedTimeStr = request.getParameter("admittedTime");
        String gmail = request.getParameter("gmail");
        String password = request.getParameter("password");

        // Convert admittedTime from String to a suitable format (e.g., for database)
        String admittedTime = null;
        try {
            // Assuming admittedTime comes from datetime-local in format "yyyy-MM-dd'T'HH:mm"
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = inputFormat.parse(admittedTimeStr);
            admittedTime = outputFormat.format(date);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid admitted time format");
            request.getRequestDispatcher("/patient/ManagePatientCreate.jsp").forward(request, response);
            return;
        }

        // Create a Patient object and set its properties
        Patient patient = new Patient();
        patient.setId(id);
        patient.setPhoneNumber(phoneNumber);
        patient.setName(name);
        patient.setGender(gender);
        patient.setAdmittedTime(admittedTime);
        patient.setGmail(gmail);
        patient.setPassword(password);

        // Call the PatientService to create the patient in the database
        PatientService patientService = new PatientService();
        boolean isCreated = patientService.createPatient(patient);

        // Check if the patient was successfully created
        if (isCreated) {
            // Redirect to the login page after successful creation
            response.sendRedirect(request.getContextPath() + "/patient/login");
        } else {
            // If there is an error, show an error message on the create page
            request.setAttribute("errorMessage", "Error creating patient. Gmail might already exist.");
            request.getRequestDispatcher("/patient/ManagePatientCreate.jsp").forward(request, response);
        }
    }
}