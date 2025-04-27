<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.UUID" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Doctor</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen">
            <div class="p-5 text-lg font-bold border-b border-gray-800">Admin Panel</div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin?action=patients" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-users mr-3"></i> Manage Patients
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin?action=doctors" class="flex items-center p-2 bg-gray-700 rounded">
                            <i class="fas fa-user-md mr-3"></i> Manage Doctors
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin?action=settings" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-cog mr-3"></i> Settings
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col">
            <!-- Top Navbar -->
            <header class="bg-white shadow p-4 flex justify-between items-center">
                <span id="datetime" class="text-xl font-semibold text-gray-800"></span>
                <div class="flex items-center space-x-4 relative">
                    <div class="relative group">
                        <img src="${pageContext.request.contextPath}/admin_dp.jpeg" alt="Admin Profile" class="w-12 h-12 rounded-full border-2 border-gray-300 shadow-sm cursor-pointer object-cover">
                        <div class="absolute left-1/2 transform -translate-x-1/2 hidden group-hover:flex 
                                    w-44 h-44 border-2 border-gray-400 rounded-full overflow-hidden shadow-lg bg-white p-1 z-10">
                            <img src="${pageContext.request.contextPath}/admin_dp.jpeg" alt="Admin Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    <span class="text-gray-700 font-medium">Welcome, Admin ${name}</span>
                    <a href="${pageContext.request.contextPath}/admin?action=logout" 
                       class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Create Doctor Form -->
            <div class="container mx-auto p-6">
                <div class="bg-white p-8 rounded-lg shadow-md max-w-lg mx-auto">
                    <h2 class="text-2xl font-semibold text-gray-800 text-center mb-6">Create Doctor</h2>
                    <c:if test="${not empty errorMessage}">
                        <p class="text-red-500 text-center mb-4">${errorMessage}</p>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/admin" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="createDoctor">
                        <div class="mb-4">
                            <label for="id" class="block text-gray-700 mb-2">Doctor ID</label>
                            <input type="text" id="id" name="id" value="D<%= UUID.randomUUID().toString().substring(0, 8).toUpperCase() %>" readonly
                                   class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600">
                        </div>
                        <div class="mb-4">
                            <label for="name" class="block text-gray-700 mb-2">Name</label>
                            <input type="text" id="name" name="name" required
                                   class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600">
                        </div>
                        <div class="mb-4">
                            <label for="specialty" class="block text-gray-700 mb-2">Specialty</label>
                            <input type="text" id="specialty" name="specialty" required
                                   class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600">
                        </div>
                        <div class="mb-4">
                            <label for="qualifications" class="block text-gray-700 mb-2">Qualifications</label>
                            <textarea id="qualifications" name="qualifications" required
                                      class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600"></textarea>
                        </div>
                        <div class="mb-4">
                            <label for="email" class="block text-gray-700 mb-2">Email</label>
                            <input type="email" id="email" name="email" required
                                   class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600">
                        </div>
                        <div class="mb-4">
                            <label for="phone" class="block text-gray-700 mb-2">Phone</label>
                            <input type="text" id="phone" name="phone" required
                                   class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600">
                        </div>
                        <div class="mb-4">
                            <label for="password" class="block text-gray-700 mb-2">Password</label>
                            <input type="password" id="password" name="password" required
                                   class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600">
                        </div>
                        <div class="mb-4">
                            <label for="picture" class="block text-gray-700 mb-2">Profile Picture</label>
                            <input type="file" id="picture" name="picture" accept="image/*"
                                   class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-600">
                        </div>
                        <button type="submit" class="w-full bg-blue-600 text-white p-2 rounded hover:bg-blue-700 transition">
                            Create Doctor
                        </button>
                    </form>
                    <div class="mt-4 text-center">
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