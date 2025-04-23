<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full"> <!-- Ensure HTML takes full height -->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book an Appointment</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans h-full"> <!-- Ensure body takes full height -->
    <div class="flex h-full"> <!-- Changed to h-full to match parent height -->
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col flex-shrink-0 h-full"> <!-- Added h-full -->
            <div class="p-5 text-lg font-bold border-b border-gray-800">Patient Portal</div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/patient" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/patient?action=channeling" class="flex items-center p-2 bg-gray-700 rounded">
                            <i class="fas fa-calendar-check mr-3"></i> Appointments
                        </a>
                    </li>
                    <li>
                        <a href="#" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-cog mr-3"></i> Settings
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col" style="background-image: url('${pageContext.request.contextPath}/patient/assets/PatientChannelingFormBG.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
            <!-- Top Navbar -->
            <header class="bg-white shadow p-4 flex justify-between items-center">
                <span id="datetime" class="text-xl font-semibold text-gray-800"></span>
                <div class="flex items-center space-x-4 relative">
                    <div class="relative group">
                        <img src="patient_dp.jpeg" alt="Patient Profile" class="w-12 h-12 rounded-full border-2 border-gray-300 shadow-sm cursor-pointer object-cover">
                        <div class="absolute left-1/2 transform -translate-x-1/2 hidden group-hover:flex 
                                    w-44 h-44 border-2 border-gray-400 rounded-full overflow-hidden shadow-lg bg-white p-1 z-10">
                            <img src="patient_dp.jpeg" alt="Patient Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    <span class="text-gray-700 font-medium">${name != null ? name : "Patient"}</span>
                    <form action="${pageContext.request.contextPath}/patient" method="post">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
                            Logout
                        </button>
                    </form>
                </div>
            </header>

            <!-- Channeling Form -->
            <div class="container mx-auto p-6 flex-1">
                <div class="bg-white p-8 rounded-lg shadow-md max-w-2xl mx-auto">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6 text-center">Book an Appointment</h2>

                    <c:if test="${not empty errorMessage}">
                        <div class="text-red-500 text-center mb-4">${errorMessage}</div>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <div class="text-green-500 text-center mb-4">${successMessage}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/patient" method="post" class="space-y-6">
                        <input type="hidden" name="action" value="bookChanneling">

                        <!-- Doctor Selection -->
                        <div class="flex items-center space-x-4">
                            <label for="doctor" class="w-1/3 text-gray-700 font-medium">
                                <i class="fas fa-user-md mr-2"></i> Doctor
                            </label>
                            <select id="doctor" name="doctor" class="w-2/3 p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" required>
                                <option value="" <c:if test="${selectedDoctorId == null}">selected</c:if> disabled>Select a Doctor</option>
                                <c:forEach var="doctor" items="${doctors}">
                                    <option value="${doctor.id}" <c:if test="${doctor.id == selectedDoctorId}">selected</c:if>>
                                        ${doctor.name} - ${doctor.specialty}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Date Selection -->
                        <div class="flex items-center space-x-4">
                            <label for="appointmentDate" class="w-1/3 text-gray-700 font-medium">
                                <i class="fas fa-calendar-alt mr-2"></i> Date
                            </label>
                            <input type="date" id="appointmentDate" name="appointmentDate" 
                                   class="w-2/3 p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" 
                                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" 
                                   required>
                        </div>

                        <!-- Time Selection -->
                        <div class="flex items-center space-x-4">
                            <label for="appointmentTime" class="w-1/3 text-gray-700 font-medium">
                                <i class="fas fa-clock mr-2"></i> Time
                            </label>
                            <select id="appointmentTime" name="appointmentTime" 
                                    class="w-2/3 p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" required>
                                <option value="" disabled selected>Select a Time</option>
                                <option value="09:00">09:00 AM</option>
                                <option value="11:00">11:00 AM</option>
                                <option value="14:00">02:00 PM</option>
                                <option value="16:00">04:00 PM</option>
                            </select>
                        </div>

                        <!-- Submit Button -->
                        <div class="text-center">
                            <button type="submit" class="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition">
                                Book Appointment
                            </button>
                        </div>
                    </form>
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