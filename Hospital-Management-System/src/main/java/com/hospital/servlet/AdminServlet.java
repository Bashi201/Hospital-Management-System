package com.hospital.servlet;

import com.hospital.model.Admin;
import com.hospital.model.Doctor;
import com.hospital.model.Patient;
import com.hospital.model.Room;
import com.hospital.service.AdminService;
import com.hospital.service.DoctorService;
import com.hospital.service.PatientService;
import com.hospital.service.RoomService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    @Override
    public void init() throws ServletException {
        super.init();
        adminService = new AdminService();
        patientService = new PatientService();
        doctorService = new DoctorService();
        roomService = new RoomService();
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
}