package com.hospital.servlet;

import com.hospital.model.Admin;

import com.hospital.service.AdminService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/admin/ManageAdminCreate") // This makes the servlet respond to the correct URL
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class AdminCreateServlet extends HttpServlet {

    // This method handles GET requests to show the admin creation form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward the request to the form JSP page
        request.getRequestDispatcher("/admin/ManageAdminCreate.jsp").forward(request, response);
    }

    // This method handles POST requests to submit the form and create the admin
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Get the uploaded picture part (if any)
        Part picturePart = request.getPart("profilePic");

        // Process the uploaded picture (if exists)
        String filename = handlePhotoUpload(picturePart, "uploads");

        // Create an Admin object and set its properties
        Admin admin = new Admin();
        admin.setId(id);
        admin.setName(name);
        admin.setEmail(email);
        admin.setPassword(password);
        admin.setFilename(filename);

        // Call the AdminService to create the admin in the database
        AdminService adminService = new AdminService();
        boolean isCreated = adminService.createAdmin(admin);

        // Check if the admin was successfully created
        if (isCreated) {
            // Redirect to the admin list or a success page
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            // If there is an error, show an error message
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating admin.");
        }
    }

    // Helper method to handle photo upload
    private String handlePhotoUpload(Part filePart, String uploadDirectory) throws IOException {
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + uploadDirectory;

            // Create the upload directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Save the file to the server
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            return fileName;
        }
        return null;
    }
}
