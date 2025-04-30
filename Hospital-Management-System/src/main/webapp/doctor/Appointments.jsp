<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Appointments</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/doctor/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-gray-100 to-purple-50 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen">
            <div class="p-5 text-lg font-bold border-b border-gray-800 flex items-center space-x-3">
                <i class="fas fa-hospital text-purple-400"></i>
                <span>Doctor Portal</span>
            </div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor" class="flex items-center p-2 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-purple-400"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor?action=appointments" class="flex items-center p-2 bg-purple-600 rounded text-white">
                            <i class="fas fa-calendar-check mr-3 text-purple-200"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor?action=patients" class="flex items-center p-2 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-users mr-3 text-purple-400"></i> Patients
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor?action=rooms" class="flex items-center p-2 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-bed mr-3 text-purple-400"></i> Room Assignments
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col">
            <!-- Top Navbar -->
            <header class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white p-4 flex justify-between items-center shadow-lg">
                <span id="datetime" class="text-lg font-medium"></span>
                <div class="flex items-center space-x-4 relative">
                    <div class="relative group">
                        <img src="doctor_dp.jpeg" alt="Doctor Profile" class="w-10 h-10 rounded-full border-2 border-purple-200 shadow-sm cursor-pointer object-cover">
                        <div class="absolute left-1/2 transform -translate-x-1/2 -top-40 hidden group-hover:flex 
                                    w-40 h-40 border-2 border-purple-300 rounded-full overflow-hidden shadow-xl bg-white p-1 z-50">
                            <img src="doctor_dp.jpeg" alt="Doctor Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    <span class="text-white font-medium">Welcome, ${name}</span>
                    <a href="${pageContext.request.contextPath}/doctor?action=logout" 
                       class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Appointments Content -->
            <div class="container mx-auto p-6 flex-1">
                <h1 class="text-3xl font-bold text-gray-800 mb-6">Your Appointments</h1>

                <!-- Success/Error Message -->
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${successMessage}</p>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${errorMessage}</p>
                    </div>
                </c:if>

                <!-- Search Bar -->
                <div class="mb-6">
                    <div class="relative">
                        <input type="text" id="searchInput" placeholder="Search by patient name, date, or time..." 
                               class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                        <i class="fas fa-search absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                </div>

                <!-- Appointments Table -->
                <div class="bg-white p-6 rounded-xl shadow-md">
                    <table class="min-w-full divide-y divide-gray-200" id="appointmentsTable">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Patient Name</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Time</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200" id="appointmentsBody">
                            <c:forEach var="appointment" items="${appointments}">
                                <tr class="appointment-row">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${appointment.patientName}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${appointment.date}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${appointment.time}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                                            ${appointment.status == 'Confirmed' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}">
                                            ${appointment.status}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                                        <c:choose>
                                            <c:when test="${appointment.status == 'Pending'}">
                                                <form action="${pageContext.request.contextPath}/doctor?action=confirmAppointment" method="POST" class="inline">
                                                    <input type="hidden" name="appointmentId" value="${appointment.id}">
                                                    <button type="submit" class="text-purple-600 hover:text-purple-800 mr-3">
                                                        <i class="fas fa-check mr-1"></i> Confirm
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-500 mr-3">Confirmed</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <form action="${pageContext.request.contextPath}/doctor?action=deleteAppointment" method="POST" class="inline">
                                            <input type="hidden" name="appointmentId" value="${appointment.id}">
                                            <button type="submit" class="text-red-600 hover:text-red-800" 
                                                    onclick="return confirm('Are you sure you want to delete this appointment?');">
                                                <i class="fas fa-trash-alt mr-1"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty appointments}">
                                <tr>
                                    <td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">No appointments scheduled.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
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
    
        // Update immediately and then every second
        updateDateTime();
        setInterval(updateDateTime, 1000);

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchText = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.appointment-row');

            rows.forEach(row => {
                const patientName = row.cells[0].textContent.toLowerCase();
                const date = row.cells[1].textContent.toLowerCase();
                const time = row.cells[2].textContent.toLowerCase();

                if (patientName.includes(searchText) || date.includes(searchText) || time.includes(searchText)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>