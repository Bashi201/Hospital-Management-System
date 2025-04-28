<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.UUID" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Doctor</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
        }

        /* Sidebar Hover Effect */
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #3b82f6, #60a5fa);
        }

        /* Form Container Hover Effect */
        .form-container {
            transition: all 0.3s ease;
        }
        .form-container:hover {
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
        }

        /* Profile Image Animation */
        .profile-img {
            transition: transform 0.3s ease;
        }
        .profile-img:hover {
            transform: scale(1.1);
        }

        /* Custom Scrollbar for Sidebar */
        .sidebar::-webkit-scrollbar {
            width: 8px;
        }
        .sidebar::-webkit-scrollbar-thumb {
            background: #3b82f6;
            border-radius: 4px;
        }
        .sidebar::-webkit-scrollbar-track {
            background: #1f2937;
        }

        /* Input Group Styling */
        .input-group {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .input-group i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #3b82f6;
            font-size: 16px;
        }
        .input-group input,
        .input-group textarea {
            padding-left: 40px;
            width: 100%;
            background: #f9fafb;
            transition: all 0.3s ease;
        }
        .input-group input[type="file"] {
            padding: 12px 12px 12px 40px;
            line-height: 1.5;
        }
        .input-group input:focus,
        .input-group textarea:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 4px rgba(59, 130, 246, 0.3);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-blue-50 font-sans h-full">
    <div class="flex h-full">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white fixed top-0 left-0 h-screen flex flex-col flex-shrink-0 sidebar">
            <div class="p-6 text-xl font-bold border-b border-gray-800 flex items-center space-x-3">
                <i class="fas fa-hospital text-blue-400"></i>
                <span>Admin Panel</span>
            </div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-blue-400"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=patients" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-users mr-3 text-blue-400"></i> Manage Patients
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=doctors" class="sidebar-link flex items-center p-3 bg-blue-600 rounded text-white">
                            <i class="fas fa-user-md mr-3 text-blue-200"></i> Manage Doctors
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin?action=settings" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-cog mr-3 text-blue-400"></i> Settings
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col ml-64" style="background-image: url('${pageContext.request.contextPath}/admin/assets/CreateDoctorBG.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
            <!-- Top Navbar -->
            <header class="header-gradient text-white p-4 flex justify-between items-center shadow-lg">
                <span id="datetime" class="text-lg font-medium"></span>
                <div class="flex items-center space-x-4">
                    <div class="relative group">
                        <img src="${pageContext.request.contextPath}/admin_dp.jpeg" alt="Admin Profile" class="w-10 h-10 rounded-full border-2 border-blue-200 shadow-sm cursor-pointer object-cover profile-img">
                        <div class="absolute left-1/2 transform -translate-x-1/2 -top-48 hidden group-hover:flex 
                                    w-40 h-40 border-2 border-blue-300 rounded-full overflow-hidden shadow-xl bg-white p-1 z-50">
                            <img src="${pageContext.request.contextPath}/admin_dp.jpeg" alt="Admin Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    <span class="text-white font-medium">Welcome, ${name != null ? name : "Admin"}</span>
                    <a href="${pageContext.request.contextPath}/admin?action=logout" 
                       class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Create Doctor Form -->
            <div class="container mx-auto p-8 flex-1 flex items-center justify-center">
                <div class="form-container bg-white p-8 rounded-xl shadow-md max-w-2xl w-full">
                    <div class="text-center mb-6">
                        <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z'/></svg>" alt="Doctor Icon" class="w-12 h-12 mx-auto mb-2">
                        <h2 class="text-2xl font-semibold text-gray-800">Create Doctor</h2>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="text-red-500 text-center mb-6 font-medium bg-red-50 p-3 rounded-md">${errorMessage}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin" method="post" enctype="multipart/form-data" class="space-y-6">
                        <input type="hidden" name="action" value="createDoctor">
                        <div class="input-group">
                            <i class="fas fa-id-badge"></i>
                            <input type="text" id="id" name="id" value="D<%= UUID.randomUUID().toString().substring(0, 8).toUpperCase() %>" readonly
                                   class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" required>
                        </div>
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input type="text" id="name" name="name" placeholder="Full Name" required
                                   class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                        <div class="input-group">
                            <i class="fas fa-stethoscope"></i>
                            <input type="text" id="specialty" name="specialty" placeholder="Specialty" required
                                   class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                        <div class="input-group">
                            <i class="fas fa-graduation-cap"></i>
                            <textarea id="qualifications" name="qualifications" placeholder="Qualifications" required
                                      class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 min-h-[100px]"></textarea>
                        </div>
                        <div class="input-group">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" placeholder="Email" required
                                   class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                        <div class="input-group">
                            <i class="fas fa-phone"></i>
                            <input type="text" id="phone" name="phone" placeholder="Phone" required
                                   class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Password" required
                                   class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                        <div class="input-group">
                            <i class="fas fa-image"></i>
                            <input type="file" id="picture" name="picture" accept="image/*"
                                   class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                        <div class="text-center">
                            <button type="submit" class="w-full bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition-colors">
                                Create Doctor
                            </button>
                        </div>
                    </form>
                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/admin?action=doctors" 
                           class="text-blue-600 hover:underline">Back to Doctor Management</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function updateDateTime() {
            const now = new Date();
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            };
            const formattedDateTime = now.toLocaleString('en-US', options);
            document.getElementById('datetime').textContent = formattedDateTime;
        }
        updateDateTime();
        setInterval(updateDateTime, 1000);
    </script>
</body>
</html>