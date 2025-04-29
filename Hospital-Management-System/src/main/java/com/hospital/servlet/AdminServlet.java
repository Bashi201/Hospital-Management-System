package com.hospital.servlet;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Nurse;
import com.hospital.model.Patient;
import com.hospital.model.Room;
import com.hospital.model.Ambulance;
import com.hospital.model.Driver;
import com.hospital.service.AdminService;
import com.hospital.service.DoctorService;
import com.hospital.service.NurseService;
import com.hospital.service.PatientService;
import com.hospital.service.RoomService;
import com.hospital.service.DriverService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.hospital.util.DBConnection;

@WebServlet("/admin")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminService adminService;
    private PatientService patientService;
    private DoctorService doctorService;
    private RoomService roomService;
    private NurseService nurseService;
    private DriverService driverService;

    @Override
    public void init() throws ServletException {
        super.init();
        adminService = new AdminService();
        patientService = new PatientService();
        doctorService = new DoctorService();
        roomService = new RoomService();
        nurseService = new NurseService();
        driverService = new DriverService();
    }

    private String handlePhotoUpload(Part filePart, String uploadDirectory) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + uploadDirectory;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
            return fileName;
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            System.out.println("No valid session found, redirecting to /admin/login");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");
        Admin loggedInAdmin = (Admin) session.getAttribute("admin");
        request.setAttribute("name", loggedInAdmin.getName());
        request.setAttribute("picture", loggedInAdmin.getFilename());

        try {
            if (action == null || action.equals("dashboard")) {
                request.getRequestDispatcher("/admin/AdminDashhome.jsp").forward(request, response);
            } else if (action.equals("create")) {
                request.getRequestDispatcher("/admin/ManageAdminsCreate.jsp").forward(request, response);
            } else if (action.equals("view")) {
                String id = request.getParameter("id");
                Admin admin = adminService.getAdmin(id);
                request.setAttribute("admin", admin);
                request.getRequestDispatcher("/admin/ManageAdminIndex.jsp").forward(request, response);
            } else if (action.equals("edit")) {
                String id = request.getParameter("id");
                Admin admin = adminService.getAdmin(id);
                request.setAttribute("admin", admin);
                request.getRequestDispatcher("/admin/ManageAdminEdit.jsp").forward(request, response);
            } else if (action.equals("delete")) {
                String id = request.getParameter("id");
                adminService.deleteAdmin(id);
                response.sendRedirect(request.getContextPath() + "/admin");
            } else if (action.equals("logout")) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/admin/login");
            } else if (action.equals("manageAdmins")) {
                request.setAttribute("admins", adminService.getAllAdmins());
                request.getRequestDispatcher("/admin/ManageAllAdmin.jsp").forward(request, response);
            } else if (action.equals("patients")) {
                request.getRequestDispatcher("/admin/ManagePatients.jsp").forward(request, response);
            } else if (action.equals("createPatient")) {
                request.getRequestDispatcher("/patient/ManagePatientCreate.jsp").forward(request, response);
            } else if (action.equals("viewPatients")) {
                List<Patient> patients = patientService.getAllPatients();
                request.setAttribute("patients", patients);
                request.getRequestDispatcher("/admin/ViewAllPatients.jsp").forward(request, response);
            } else if (action.equals("deletePatient")) {
                String id = request.getParameter("id");
                if (patientService.deletePatient(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=viewPatients");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete patient. The patient may be referenced in other records or does not exist.");
                    List<Patient> patients = patientService.getAllPatients();
                    request.setAttribute("patients", patients);
                    request.getRequestDispatcher("/admin/ViewAllPatients.jsp").forward(request, response);
                }
            } else if (action.equals("doctors")) {
                request.getRequestDispatcher("/admin/ManageDoctors.jsp").forward(request, response);
            } else if (action.equals("createDoctor")) {
                request.getRequestDispatcher("/admin/ManageDoctorCreate.jsp").forward(request, response);
            } else if (action.equals("viewDoctors")) {
                List<Doctor> doctors = doctorService.getAllDoctors();
                request.setAttribute("doctors", doctors);
                request.getRequestDispatcher("/admin/ViewAllDoctors.jsp").forward(request, response);
            } else if (action.equals("deleteDoctor")) {
                String id = request.getParameter("id");
                doctorService.deleteDoctor(id);
                response.sendRedirect(request.getContextPath() + "/admin?action=viewDoctors");
            } else if (action.equals("updateDoctor")) {
                String id = request.getParameter("id");
                Doctor doctor = doctorService.getDoctor(id);
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/admin/ManageDoctorUpdate.jsp").forward(request, response);
            } else if (action.equals("rooms")) {
                List<Room> rooms = roomService.getAllRooms();
                request.setAttribute("rooms", rooms);
                request.getRequestDispatcher("/admin/ManageRooms.jsp").forward(request, response);
            } else if (action.equals("deleteRoom")) {
                String id = request.getParameter("id");
                if (roomService.deleteRoom(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=rooms");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete room. It may be referenced or does not exist.");
                    List<Room> rooms = roomService.getAllRooms();
                    request.setAttribute("rooms", rooms);
                    request.getRequestDispatcher("/admin/ManageRooms.jsp").forward(request, response);
                }
            } else if (action.equals("nurses")) {
                List<Nurse> nurses = nurseService.getAllNurses();
                request.setAttribute("nurses", nurses);
                request.getRequestDispatcher("/admin/ManageNurses.jsp").forward(request, response);
            } else if (action.equals("deleteNurse")) {
                String id = request.getParameter("id");
                if (nurseService.deleteNurse(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=nurses");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete nurse. It may be referenced or does not exist.");
                    List<Nurse> nurses = nurseService.getAllNurses();
                    request.setAttribute("nurses", nurses);
                    request.getRequestDispatcher("/admin/ManageNurses.jsp").forward(request, response);
                }
            } else if (action.equals("salary")) {
                List<Admin> admins = adminService.getAllAdmins();
                List<Doctor> doctors = doctorService.getAllDoctors();
                List<Nurse> nurses = nurseService.getAllNurses();
                request.setAttribute("admins", admins);
                request.setAttribute("doctors", doctors);
                request.setAttribute("nurses", nurses);
                request.getRequestDispatcher("/admin/PayrollManagement.jsp").forward(request, response);
            } else if (action.equals("manageEmployees")) {
                List<Admin> admins = adminService.getAllAdmins();
                List<Doctor> doctors = doctorService.getAllDoctors();
                List<Nurse> nurses = nurseService.getAllNurses();
                request.setAttribute("admins", admins);
                request.setAttribute("doctors", doctors);
                request.setAttribute("nurses", nurses);
                request.getRequestDispatcher("/admin/ManageEmployees.jsp").forward(request, response);
            } else if (action.equals("manageDeductions")) {
                List<Paysheet> paysheets = getAllPaysheets();
                System.out.println("Fetched " + paysheets.size() + " paysheets for deductions");
                request.setAttribute("paysheets", paysheets);
                request.getRequestDispatcher("/admin/ManageDeductions.jsp").forward(request, response);
            } else if (action.equals("viewPaysheets")) {
                List<Paysheet> paysheets = getAllPaysheets();
                System.out.println("Fetched " + paysheets.size() + " paysheets");
                request.setAttribute("paysheets", paysheets);
                request.getRequestDispatcher("/admin/ViewPaysheets.jsp").forward(request, response);
            } else if (action.equals("ambulance")) {
                // Fetch available ambulances
                List<String> availableAmbulanceVehicleNumbers = new ArrayList<>();
                int availableAmbulancesCount = 0;
                String ambulanceSql = "SELECT vehicle_number FROM ambulances WHERE availability = 'Available'";
                try (Connection conn = DBConnection.getConnection();
                     Statement stmt = conn.createStatement()) {
                    ResultSet rs = stmt.executeQuery(ambulanceSql);
                    while (rs.next()) {
                        availableAmbulanceVehicleNumbers.add(rs.getString("vehicle_number"));
                        availableAmbulancesCount++;
                    }
                }

                // Fetch latest ambulance request
                Ambulance latestAmbulanceRequest = patientService.getLatestPendingAmbulanceRequest();

                // Fetch available drivers
                List<Driver> driversAtHospital = driverService.getAvailableDrivers();

                // Fetch unavailable ambulances
                List<String> unavailableAmbulances = new ArrayList<>();
                String unavailableSql = "SELECT vehicle_number FROM ambulances WHERE availability = 'Booked'";
                try (Connection conn = DBConnection.getConnection();
                     Statement stmt = conn.createStatement()) {
                    ResultSet rs = stmt.executeQuery(unavailableSql);
                    while (rs.next()) {
                        unavailableAmbulances.add(rs.getString("vehicle_number"));
                    }
                }

                // Fetch ambulance history
                List<PatientService.AmbulanceHistory> ambulanceHistory = patientService.getAmbulanceHistory();

                request.setAttribute("availableAmbulances", availableAmbulancesCount);
                request.setAttribute("availableAmbulanceVehicleNumbers", availableAmbulanceVehicleNumbers);
                request.setAttribute("latestAmbulanceRequest", latestAmbulanceRequest);
                request.setAttribute("driversAtHospital", driversAtHospital);
                request.setAttribute("unavailableAmbulances", unavailableAmbulances);
                request.setAttribute("ambulanceHistory", ambulanceHistory);
                request.getRequestDispatcher("/admin/ManageAmbulance.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error occurred: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            System.out.println("No valid session found, redirecting to /admin/login");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if (action.equals("create")) {
                String id = request.getParameter("id");
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                Part picturePart = request.getPart("filename");

                String filename = handlePhotoUpload(picturePart, "uploads");

                Admin admin = new Admin();
                admin.setId(id);
                admin.setName(name);
                admin.setEmail(email);
                admin.setPassword(password);
                admin.setFilename(filename);

                if (adminService.createAdmin(admin)) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating admin");
                }
            } else if (action.equals("update")) {
                String id = request.getParameter("id");
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                Part picturePart = request.getPart("filename");

                String filename = handlePhotoUpload(picturePart, "uploads");

                Admin admin = adminService.getAdmin(id);
                admin.setName(name);
                admin.setEmail(email);
                admin.setPassword(password);
                if (filename != null) {
                    admin.setFilename(filename);
                }

                if (adminService.updateAdmin(admin)) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating admin");
                }
            } else if (action.equals("delete")) {
                String id = request.getParameter("id");
                if (adminService.deleteAdmin(id)) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting admin");
                }
            } else if (action.equals("searchPatients")) {
                String searchQuery = request.getParameter("searchQuery");
                List<Patient> patients;
                if (searchQuery == null || searchQuery.trim().isEmpty()) {
                    patients = patientService.getAllPatients();
                } else {
                    patients = searchPatients(searchQuery);
                }
                request.setAttribute("patients", patients);
                request.setAttribute("searchQuery", searchQuery);
                request.getRequestDispatcher("/admin/ViewAllPatients.jsp").forward(request, response);
            } else if (action.equals("createDoctor")) {
                String id = request.getParameter("id");
                String name = request.getParameter("name");
                String specialty = request.getParameter("specialty");
                String qualifications = request.getParameter("qualifications");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String password = request.getParameter("password");
                Part picturePart = request.getPart("picture");

                String picture = handlePhotoUpload(picturePart, "uploads");

                Doctor doctor = new Doctor();
                doctor.setId(id);
                doctor.setName(name);
                doctor.setSpecialty(specialty);
                doctor.setQualifications(qualifications);
                doctor.setEmail(email);
                doctor.setPhone(phone);
                doctor.setPicture(picture);
                doctor.setPassword(password);

                if (doctorService.createDoctor(doctor)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=viewDoctors");
                } else {
                    request.setAttribute("errorMessage", "Error creating doctor. Email might already exist.");
                    request.getRequestDispatcher("/admin/ManageDoctorCreate.jsp").forward(request, response);
                }
            } else if (action.equals("updateDoctor")) {
                String id = request.getParameter("id");
                String name = request.getParameter("name");
                String specialty = request.getParameter("specialty");
                String qualifications = request.getParameter("qualifications");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String password = request.getParameter("password");
                Part picturePart = request.getPart("picture");

                String picture = handlePhotoUpload(picturePart, "Uploads");

                Doctor doctor = doctorService.getDoctor(id);
                doctor.setName(name);
                doctor.setSpecialty(specialty);
                doctor.setQualifications(qualifications);
                doctor.setEmail(email);
                doctor.setPhone(phone);
                doctor.setPassword(password);
                if (picture != null) {
                    doctor.setPicture(picture);
                }

                if (doctorService.updateDoctor(doctor)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=viewDoctors");
                } else {
                    request.setAttribute("errorMessage", "Error updating doctor.");
                    request.setAttribute("doctor", doctor);
                    request.getRequestDispatcher("/admin/ManageDoctorUpdate.jsp").forward(request, response);
                }
            } else if (action.equals("searchDoctors")) {
                String searchQuery = request.getParameter("searchQuery");
                List<Doctor> doctors;
                if (searchQuery == null || searchQuery.trim().isEmpty()) {
                    doctors = doctorService.getAllDoctors();
                } else {
                    doctors = searchDoctors(searchQuery);
                }
                request.setAttribute("doctors", doctors);
                request.setAttribute("searchQuery", searchQuery);
                request.getRequestDispatcher("/admin/ViewAllDoctors.jsp").forward(request, response);
            } else if (action.equals("createPatient")) {
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
                if (patientService.createPatient(patient)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=viewPatients");
                } else {
                    request.setAttribute("errorMessage", "Error creating patient. Email might already exist or invalid data provided.");
                    request.getRequestDispatcher("/patient/ManagePatientCreate.jsp").forward(request, response);
                }
            } else if (action.equals("createRoom")) {
                String id = request.getParameter("id");
                String type = request.getParameter("type");
                String price = request.getParameter("price");
                String availability = request.getParameter("availability");
                String description = request.getParameter("description");

                Room room = new Room();
                room.setId(id);
                room.setType(type);
                room.setPrice(price);
                room.setAvailability(availability);
                room.setDescription(description);

                if (roomService.createRoom(room)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=rooms");
                } else {
                    request.setAttribute("errorMessage", "Error creating room. ID might already exist.");
                    List<Room> rooms = roomService.getAllRooms();
                    request.setAttribute("rooms", rooms);
                    request.getRequestDispatcher("/admin/ManageRooms.jsp").forward(request, response);
                }
            } else if (action.equals("createNurse")) {
                String id = request.getParameter("id");
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String shift = request.getParameter("shift");
                Part picturePart = request.getPart("filename");

                String filename = handlePhotoUpload(picturePart, "uploads");

                Nurse nurse = new Nurse();
                nurse.setId(id);
                nurse.setName(name);
                nurse.setEmail(email);
                nurse.setPhone(phone);
                nurse.setShift(shift);
                nurse.setFilename(filename);

                if (nurseService.createNurse(nurse)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=nurses");
                } else {
                    request.setAttribute("errorMessage", "Error creating nurse. ID or email might already exist.");
                    List<Nurse> nurses = nurseService.getAllNurses();
                    request.setAttribute("nurses", nurses);
                    request.getRequestDispatcher("/admin/ManageNurses.jsp").forward(request, response);
                }
            } else if (action.equals("savePayroll")) {
                String month = request.getParameter("month");
                String[] employeeIds = request.getParameterValues("employeeIds");
                String[] employeeNames = request.getParameterValues("employeeNames");
                String[] positions = request.getParameterValues("positions");
                String[] grossSalaries = request.getParameterValues("grossSalaries");
                String[] deductions = request.getParameterValues("deductions");
                String[] overtimes = request.getParameterValues("overtimes");
                String[] bonuses = request.getParameterValues("bonuses");
                String[] netPays = request.getParameterValues("netPays");

                Connection conn = DBConnection.getConnection();
                String sql = "INSERT INTO paysheets (employee_id, employee_name, position, month, gross_salary, deductions, overtime, bonus, net_pay) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);

                for (int i = 0; i < employeeIds.length; i++) {
                    if (employeeIds[i] != null && !employeeIds[i].isEmpty()) {
                        stmt.setString(1, employeeIds[i]);
                        stmt.setString(2, employeeNames[i]);
                        stmt.setString(3, positions[i]);
                        stmt.setString(4, month);
                        stmt.setDouble(5, Double.parseDouble(grossSalaries[i] != null && !grossSalaries[i].isEmpty() ? grossSalaries[i] : "0"));
                        stmt.setDouble(6, Double.parseDouble(deductions[i] != null && !deductions[i].isEmpty() ? deductions[i] : "0"));
                        stmt.setDouble(7, Double.parseDouble(overtimes[i] != null && !overtimes[i].isEmpty() ? overtimes[i] : "0"));
                        stmt.setDouble(8, Double.parseDouble(bonuses[i] != null && !bonuses[i].isEmpty() ? bonuses[i] : "0"));
                        stmt.setDouble(9, Double.parseDouble(netPays[i] != null && !netPays[i].isEmpty() ? netPays[i] : "0"));
                        stmt.executeUpdate();
                    }
                }

                stmt.close();
                conn.close();
                response.sendRedirect(request.getContextPath() + "/admin?action=salary");
            } else if (action.equals("createDriver")) {
                String driverId = request.getParameter("driverId");
                String name = request.getParameter("name");

                Driver driver = new Driver();
                driver.setDriverId(driverId);
                driver.setName(name);
                driver.setAvailability("Available");

                if (driverService.createDriver(driver)) {
                    response.sendRedirect(request.getContextPath() + "/admin?action=ambulance");
                } else {
                    request.setAttribute("errorMessage", "Error creating driver. ID might already exist.");
                    response.sendRedirect(request.getContextPath() + "/admin?action=ambulance");
                }
            } else if (action.equals("dispatchAmbulance")) {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String driverId = request.getParameter("driverId");
                String vehicleNumber = request.getParameter("vehicleNumber");

                Connection conn = DBConnection.getConnection();
                conn.setAutoCommit(false);
                try {
                    // Dispatch ambulance
                    if (patientService.dispatchAmbulance(bookingId, driverId, vehicleNumber)) {
                        // Update driver availability
                        driverService.updateDriverAvailability(driverId, "Dispatched");
                        conn.commit();
                    } else {
                        conn.rollback();
                        request.setAttribute("errorMessage", "Failed to dispatch ambulance.");
                    }
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                    conn.close();
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=ambulance");
            } else if (action.equals("returnAmbulance")) {
                String vehicleNumber = request.getParameter("vehicleNumber");

                Connection conn = DBConnection.getConnection();
                conn.setAutoCommit(false);
                try {
                    // Update ambulance availability
                    String updateAmbulanceSql = "UPDATE ambulances SET availability = 'Available' WHERE vehicle_number = ?";
                    PreparedStatement stmt = conn.prepareStatement(updateAmbulanceSql);
                    stmt.setString(1, vehicleNumber);
                    stmt.executeUpdate();
                    stmt.close();

                    // Fetch driver from history
                    String fetchDriverSql = "SELECT driver_id FROM ambulance_history WHERE vehicle_number = ? AND return_time IS NULL ORDER BY dispatch_time DESC LIMIT 1";
                    stmt = conn.prepareStatement(fetchDriverSql);
                    stmt.setString(1, vehicleNumber);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        String driverId = rs.getString("driver_id");
                        // Update driver availability
                        driverService.updateDriverAvailability(driverId, "Available");
                    }
                    rs.close();
                    stmt.close();

                    // Update return time in history
                    String updateHistorySql = "UPDATE ambulance_history SET return_time = NOW() WHERE vehicle_number = ? AND return_time IS NULL";
                    stmt = conn.prepareStatement(updateHistorySql);
                    stmt.setString(1, vehicleNumber);
                    stmt.executeUpdate();
                    stmt.close();

                    conn.commit();
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                    conn.close();
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=ambulance");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error occurred: " + e.getMessage());
        }
    }

    private List<Patient> searchPatients(String searchQuery) {
        List<Patient> allPatients = patientService.getAllPatients();
        List<Patient> filteredPatients = new ArrayList<>();
        searchQuery = searchQuery.toLowerCase();
        for (Patient patient : allPatients) {
            if (patient.getId().toLowerCase().contains(searchQuery) ||
                patient.getName().toLowerCase().contains(searchQuery) ||
                patient.getGmail().toLowerCase().contains(searchQuery) ||
                patient.getPhoneNumber().toLowerCase().contains(searchQuery)) {
                filteredPatients.add(patient);
            }
        }
        return filteredPatients;
    }

    private List<Doctor> searchDoctors(String searchQuery) throws SQLException {
        List<Doctor> allDoctors = doctorService.getAllDoctors();
        List<Doctor> filteredDoctors = new ArrayList<>();
        searchQuery = searchQuery.toLowerCase();
        for (Doctor doctor : allDoctors) {
            if (doctor.getId().toLowerCase().contains(searchQuery) ||
                doctor.getName().toLowerCase().contains(searchQuery) ||
                doctor.getEmail().toLowerCase().contains(searchQuery) ||
                doctor.getPhone().toLowerCase().contains(searchQuery) ||
                doctor.getSpecialty().toLowerCase().contains(searchQuery)) {
                filteredDoctors.add(doctor);
            }
        }
        return filteredDoctors;
    }

    // Model class for Paysheet
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

    // Fetch all paysheets
    private List<Paysheet> getAllPaysheets() throws SQLException {
        List<Paysheet> paysheets = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM paysheets";
        PreparedStatement stmt = conn.prepareStatement(sql);
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
}