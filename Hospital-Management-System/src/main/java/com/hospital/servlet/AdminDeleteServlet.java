package com.hospital.servlet;

import com.hospital.service.AdminService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/delete")
public class AdminDeleteServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        adminService = new AdminService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String adminId = request.getParameter("id");
        System.out.println("Received DELETE request for Admin ID: " + adminId);

        if (adminId != null && !adminId.trim().isEmpty()) {
            boolean isDeleted = adminService.deleteAdmin(adminId);
            System.out.println("Deletion status: " + isDeleted);

            if (isDeleted) {
                System.out.println("Admin deleted successfully.");
                response.sendRedirect(request.getContextPath() + "/admin?deleteSuccess=true");
            } else {
                System.out.println("Failed to delete admin with ID: " + adminId);
                response.sendRedirect(request.getContextPath() + "/admin?deleteError=Failed to delete admin ID: " + adminId);
            }
        } else {
            System.out.println("Admin ID is missing in request.");
            response.sendRedirect(request.getContextPath() + "/admin?deleteError=Admin ID is required");
        }
    }
}
