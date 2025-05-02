package com.hospital.service;

import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorService {

    // Fetch a single doctor by ID
    public Doctor getDoctor(String doctorId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            rs.close();
            stmt.close();
            conn.close();
            return doctor;
        }
        rs.close();
        stmt.close();
        conn.close();
        return null;
    }

    // Fetch multiple doctors (e.g., for DoctorProfile.jsp, limited to 2)
    public List<Doctor> getMultipleDoctors() throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors LIMIT 2"; // Fetch 2 doctors for now
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            doctors.add(doctor);
        }
        rs.close();
        stmt.close();
        conn.close();
        return doctors;
    }

    // Authenticate doctor by email and password
    public Doctor authenticateDoctor(String email, String password) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors WHERE email = ? AND password = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            rs.close();
            stmt.close();
            conn.close();
            return doctor;
        }
        rs.close();
        stmt.close();
        conn.close();
        return null;
    }

    // Fetch all doctors
    public List<Doctor> getAllDoctors() throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM doctors";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Doctor doctor = new Doctor();
            doctor.setId(rs.getString("id"));
            doctor.setName(rs.getString("name"));
            doctor.setSpecialty(rs.getString("specialty"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setEmail(rs.getString("email"));
            doctor.setPhone(rs.getString("phone"));
            doctor.setPicture(rs.getString("picture"));
            doctor.setPassword(rs.getString("password"));
            doctors.add(doctor);
        }
        rs.close();
        stmt.close();
        conn.close();
        return doctors;
    }

    // Create a new doctor
    public boolean createDoctor(Doctor doctor) {
        String sql = "INSERT INTO doctors (id, name, specialty, qualifications, email, phone, picture, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, doctor.getId());
            stmt.setString(2, doctor.getName());
            stmt.setString(3, doctor.getSpecialty());
            stmt.setString(4, doctor.getQualifications());
            stmt.setString(5, doctor.getEmail());
            stmt.setString(6, doctor.getPhone());
            stmt.setString(7, doctor.getPicture());
            stmt.setString(8, doctor.getPassword());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update an existing doctor
    public boolean updateDoctor(Doctor doctor) {
        String sql = "UPDATE doctors SET name = ?, specialty = ?, qualifications = ?, email = ?, phone = ?, picture = ?, password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, doctor.getName());
            stmt.setString(2, doctor.getSpecialty());
            stmt.setString(3, doctor.getQualifications());
            stmt.setString(4, doctor.getEmail());
            stmt.setString(5, doctor.getPhone());
            stmt.setString(6, doctor.getPicture());
            stmt.setString(7, doctor.getPassword());
            stmt.setString(8, doctor.getId());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete a doctor by ID
    public boolean deleteDoctor(String doctorId) {
        String sql = "DELETE FROM doctors WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, doctorId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Fetch all appointments for a specific doctor
    public List<Appointment> getAppointmentsForDoctor(String doctorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT a.id, a.patient_id, a.appointment_date, a.appointment_time, a.status, p.name AS patient_name " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.id " +
                    "WHERE a.doctor_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Appointment appointment = new Appointment();
            appointment.setId(rs.getInt("id"));
            appointment.setPatientId(rs.getString("patient_id"));
            appointment.setPatientName(rs.getString("patient_name"));
            appointment.setDate(rs.getString("appointment_date"));
            appointment.setTime(rs.getString("appointment_time"));
            appointment.setStatus(rs.getString("status"));
            appointments.add(appointment);
        }
        rs.close();
        stmt.close();
        conn.close();
        return appointments;
    }

    // Fetch confirmed patients for a specific doctor
    public List<Patient> getConfirmedPatientsForDoctor(String doctorId) throws SQLException {
        List<Patient> patients = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT DISTINCT p.* " +
                    "FROM patients p " +
                    "JOIN appointments a ON p.id = a.patient_id " +
                    "WHERE a.doctor_id = ? AND a.status = 'Confirmed'";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Patient patient = new Patient();
            patient.setId(rs.getString("id"));
            patient.setPhoneNumber(rs.getString("phone_number"));
            patient.setName(rs.getString("name"));
            patient.setGender(rs.getString("gender"));
            patient.setAdmittedTime(rs.getString("admitted_time"));
            patient.setGmail(rs.getString("gmail"));
            patient.setPassword(rs.getString("password"));
            patients.add(patient);
        }
        rs.close();
        stmt.close();
        conn.close();
        return patients;
    }

    // Fetch a single patient by ID
    public Patient getPatientById(String patientId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM patients WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, patientId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Patient patient = new Patient();
            patient.setId(rs.getString("id"));
            patient.setPhoneNumber(rs.getString("phone_number"));
            patient.setName(rs.getString("name"));
            patient.setGender(rs.getString("gender"));
            patient.setAdmittedTime(rs.getString("admitted_time"));
            patient.setGmail(rs.getString("gmail"));
            patient.setPassword(rs.getString("password"));
            rs.close();
            stmt.close();
            conn.close();
            return patient;
        }
        rs.close();
        stmt.close();
        conn.close();
        return null;
    }

    // Fetch notes for a specific patient and doctor
    public List<PatientNote> getPatientNotes(String patientId, String doctorId) throws SQLException {
        List<PatientNote> notes = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM patient_notes WHERE patient_id = ? AND doctor_id = ? ORDER BY updated_at DESC";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, patientId);
        stmt.setString(2, doctorId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            PatientNote note = new PatientNote();
            note.setId(rs.getInt("id"));
            note.setPatientId(rs.getString("patient_id"));
            note.setDoctorId(rs.getString("doctor_id"));
            note.setNoteText(rs.getString("note_text"));
            note.setCreatedAt(rs.getString("created_at"));
            note.setUpdatedAt(rs.getString("updated_at"));
            notes.add(note);
        }
        rs.close();
        stmt.close();
        conn.close();
        return notes;
    }

    // Add a new note for a patient
    public boolean addPatientNote(String patientId, String doctorId, String noteText) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "INSERT INTO patient_notes (patient_id, doctor_id, note_text) VALUES (?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, patientId);
        stmt.setString(2, doctorId);
        stmt.setString(3, noteText);
        int rowsAffected = stmt.executeUpdate();
        stmt.close();
        conn.close();
        return rowsAffected > 0;
    }

    // Update an existing note
    public boolean updatePatientNote(int noteId, String noteText) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE patient_notes SET note_text = ? WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, noteText);
        stmt.setInt(2, noteId);
        int rowsAffected = stmt.executeUpdate();
        stmt.close();
        conn.close();
        return rowsAffected > 0;
    }

    // Delete an appointment by ID
    public boolean deleteAppointment(int appointmentId) throws SQLException {
        String sql = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Confirm an appointment by updating its status to "Confirmed"
    public boolean confirmAppointment(int appointmentId) throws SQLException {
        String sql = "UPDATE appointments SET status = 'Confirmed' WHERE id = ? AND status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Fetch paysheets for a specific doctor based on their ID
    public List<Paysheet> getPaysheetsForDoctor(String doctorId) throws SQLException {
        List<Paysheet> paysheets = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM paysheets WHERE employee_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Paysheet paysheet = new Paysheet();
            paysheet.setPaysheetId(rs.getInt("paysheet_id"));
            paysheet.setEmployeeId(rs.getString("employee_id"));
            paysheet.setEmployeeName(rs.getString("employee_name"));
            paysheet.setPosition(rs.getString("position"));
            String fullMonth = rs.getString("month");
            if (fullMonth != null && fullMonth.matches("\\d{4}-\\d{2}")) {
                String[] parts = fullMonth.split("-");
                paysheet.setYear(parts[0]);
                paysheet.setMonth(parts[1]);
            } else {
                paysheet.setYear("");
                paysheet.setMonth(fullMonth != null ? fullMonth : "");
            }
            paysheet.setGrossSalary(rs.getDouble("gross_salary"));
            paysheet.setDeductions(rs.getDouble("deductions"));
            paysheet.setOvertime(rs.getDouble("overtime"));
            paysheet.setBonus(rs.getDouble("bonus"));
            paysheet.setNetPay(rs.getDouble("net_pay"));
            paysheet.setCreatedAt(rs.getString("created_at"));
            paysheets.add(paysheet);
        }

        rs.close();
        stmt.close();
        conn.close();
        return paysheets;
    }

    // Place a meal order for a doctor
    public boolean placeMealOrder(String doctorId, String items, double totalCost) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "INSERT INTO meal_orders (doctor_id, items, total_cost) VALUES (?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        stmt.setString(2, items);
        stmt.setDouble(3, totalCost);
        int rowsAffected = stmt.executeUpdate();
        stmt.close();
        conn.close();
        return rowsAffected > 0;
    }

    // Fetch meal orders for a specific doctor
    public List<MealOrder> getMealOrdersForDoctor(String doctorId) throws SQLException {
        List<MealOrder> mealOrders = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM meal_orders WHERE doctor_id = ? ORDER BY created_at DESC";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, doctorId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            MealOrder order = new MealOrder();
            order.setId(rs.getInt("id"));
            order.setDoctorId(rs.getString("doctor_id"));
            order.setItems(rs.getString("items"));
            order.setTotalCost(rs.getDouble("total_cost"));
            order.setCreatedAt(rs.getString("created_at"));
            mealOrders.add(order);
        }
        rs.close();
        stmt.close();
        conn.close();
        return mealOrders;
    }

    // Inner class to represent an appointment
    public static class Appointment {
        private int id;
        private String patientId;
        private String patientName;
        private String date;
        private String time;
        private String status;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }
        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public String getTime() { return time; }
        public void setTime(String time) { this.time = time; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    // Inner class to represent a patient note
    public static class PatientNote {
        private int id;
        private String patientId;
        private String doctorId;
        private String noteText;
        private String createdAt;
        private String updatedAt;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getPatientId() { return patientId; }
        public void setPatientId(String patientId) { this.patientId = patientId; }
        public String getDoctorId() { return doctorId; }
        public void setDoctorId(String doctorId) { this.doctorId = doctorId; }
        public String getNoteText() { return noteText; }
        public void setNoteText(String noteText) { this.noteText = noteText; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        public String getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
    }

    // Inner class to represent a paysheet
    public static class Paysheet {
        private int paysheetId;
        private String employeeId;
        private String employeeName;
        private String position;
        private String month;
        private String year;
        private double grossSalary;
        private double deductions;
        private double overtime;
        private double bonus;
        private double netPay;
        private String createdAt;

        public int getPaysheetId() { return paysheetId; }
        public void setPaysheetId(int paysheetId) { this.paysheetId = paysheetId; }
        public String getEmployeeId() { return employeeId; }
        public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
        public String getEmployeeName() { return employeeName; }
        public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
        public String getPosition() { return position; }
        public void setPosition(String position) { this.position = position; }
        public String getMonth() { return month; }
        public void setMonth(String month) { this.month = month; }
        public String getYear() { return year; }
        public void setYear(String year) { this.year = year; }
        public double getGrossSalary() { return grossSalary; }
        public void setGrossSalary(double grossSalary) { this.grossSalary = grossSalary; }
        public double getDeductions() { return deductions; }
        public void setDeductions(double deductions) { this.deductions = deductions; }
        public double getOvertime() { return overtime; }
        public void setOvertime(double overtime) { this.overtime = overtime; }
        public double getBonus() { return bonus; }
        public void setBonus(double bonus) { this.bonus = bonus; }
        public double getNetPay() { return netPay; }
        public void setNetPay(double netPay) { this.netPay = netPay; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }

    // Inner class to represent a meal order
    public static class MealOrder {
        private int id;
        private String doctorId;
        private String items;
        private double totalCost;
        private String createdAt;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getDoctorId() { return doctorId; }
        public void setDoctorId(String doctorId) { this.doctorId = doctorId; }
        public String getItems() { return items; }
        public void setItems(String items) { this.items = items; }
        public double getTotalCost() { return totalCost; }
        public void setTotalCost(double totalCost) { this.totalCost = totalCost; }
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}