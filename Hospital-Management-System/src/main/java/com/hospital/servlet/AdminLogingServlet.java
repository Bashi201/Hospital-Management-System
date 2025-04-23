package com.hospital.servlet;

import com.hospital.model.Admin;

import com.hospital.service.AdminService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLogingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        adminService = new AdminService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Check if session already exists
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin") != null) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        // Authenticate admin
        Admin admin = authenticateAdmin(email, password);

        if (admin != null) {
            // Create a new session for the authenticated admin
            session = request.getSession(true);
            session.setAttribute("admin", admin);
            session.setAttribute("name", admin.getName()); // Using 'name' from your Admin model
            session.setAttribute("picture", admin.getFilename()); // Using 'filename' as picture
            session.setMaxInactiveInterval(30 * 60); // Session expires after 30 minutes

            // Redirect to the admin dashboard
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            // Authentication failed, redirect back to login page with error
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("/admin/AdminLoging.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin") != null) {
            // Redirect authenticated user to the dashboard
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            // Show the login page
            request.getRequestDispatcher("/admin/AdminLoging.jsp").forward(request, response);
        }
    }

    private Admin authenticateAdmin(String email, String password) {
        for (Admin admin : adminService.getAllAdmins()) {
            if (admin.getEmail().equalsIgnoreCase(email) && admin.getPassword().equals(password)) {
                return admin;
            }
        }
        return null;
    }
}
