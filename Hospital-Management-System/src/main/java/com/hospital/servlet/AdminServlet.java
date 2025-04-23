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

@WebServlet("/admin")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        super.init();
        adminService = new AdminService();
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

        if (action == null) {
            try {
                request.setAttribute("admins", adminService.getAllAdmins());
                request.getRequestDispatcher("/admin/ManageAllAdmin.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching admin list");
            }
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
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else if (action.equals("delete")) {
            String id = request.getParameter("id");
            if (adminService.deleteAdmin(id)) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}