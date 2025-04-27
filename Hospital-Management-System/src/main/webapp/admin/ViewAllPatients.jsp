<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View All Patients</title>
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
                        <a href="${pageContext.request.contextPath}/admin?action=patients" class="flex items-center p-2 bg-gray-700 rounded">
                            <i class="fas fa-users mr-3"></i> Manage Patients
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin?action=doctors" class="flex items-center p-2 hover:bg-gray-700 rounded">
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

            <!-- Patient List -->
            <div class="container mx-auto p-6">
                <div class="bg-white p-6 rounded-lg shadow-md">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-2xl font-semibold text-gray-800">All Patients</h2>
                        <form action="${pageContext.request.contextPath}/admin" method="post" class="flex items-center">
                            <input type="hidden" name="action" value="searchPatients">
                            <input type="text" name="searchQuery" value="${searchQuery}" placeholder="Search by ID, Name, Gmail, or Phone" 
                                   class="p-2 border border-gray-300 rounded-l focus:outline-none focus:ring-2 focus:ring-blue-600">
                            <button type="submit" class="bg-blue-600 text-white p-2 rounded-r hover:bg-blue-700">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>
                    </div>
                    <c:if test="${not empty patients}">
                        <table class="w-full table-auto">
                            <thead>
                                <tr class="bg-gray-200">
                                    <th class="p-3 text-left">ID</th>
                                    <th class="p-3 text-left">Name</th>
                                    <th class="p-3 text-left">Gmail</th>
                                    <th class="p-3 text-left">Phone Number</th>
                                    <th class="p-3 text-left">Gender</th>
                                    <th class="p-3 text-left">Admitted Time</th>
                                    <th class="p-3 text-left">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="patient" items="${patients}">
                                    <tr class="border-b">
                                        <td class="p-3">${patient.id}</td>
                                        <td class="p-3">${patient.name}</td>
                                        <td class="p-3">${patient.gmail}</td>
                                        <td class="p-3">${patient.phoneNumber}</td>
                                        <td class="p-3">${patient.gender}</td>
                                        <td class="p-3">${patient.admittedTime}</td>
                                        <td class="p-3">
                                            <a href="${pageContext.request.contextPath}/admin?action=deletePatient&id=${patient.id}" 
                                               class="text-red-500 hover:text-red-700" 
                                               onclick="return confirm('Are you sure you want to delete this patient?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                    <c:if test="${empty patients}">
                        <p class="text-gray-600 text-center">No patients found.</p>
                    </c:if>
                    <div class="mt-6">
                        <a href="${pageContext.request.contextPath}/admin?action=patients" 
                           class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                            Back to Patient Management
                        </a>
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