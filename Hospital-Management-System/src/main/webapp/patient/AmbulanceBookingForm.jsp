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
         <!-- Main Content Area -->
        <div class="container mx-auto p-6 flex-1">
            <div class="bg-white p-8 rounded-lg shadow-md max-w-lg mx-auto">
                <h2 class="text-2xl font-semibold text-gray-800 mb-6">Ambulance Booking Form</h2>

                <!-- Success/Error Messages: Unchanged -->
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 text-green-700 p-4 rounded mb-4">
                        ${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 text-red-700 p-4 rounded mb-4">
                        ${errorMessage}
                    </div>
                </c:if>

                <!-- Form: Updated pickup location to manual input -->
                <form action="${pageContext.request.contextPath}/patient" method="post">
                    <input type="hidden" name="action" value="bookAmbulance">

                    <!-- Pickup Location: Now a manual text input -->
                    <div class="mb-4">
                        <label for="pickupLocation" class="block text-gray-700 font-medium mb-2">
                            Pickup Location
                        </label>
                        <!-- Changed to editable text input; removed readonly and map -->
                        <input type="text" id="pickupLocation" name="pickupLocation" 
                               placeholder="Enter your pickup address"
                               class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-600" 
                               required>
                    </div>

                    <!-- Destination: Default hospital address (customize here) -->
                    <div class="mb-4">
                        <label for="destination" class="block text-gray-700 font-medium mb-2">
                            Destination
                        </label>
                        <!-- Customize the value attribute with your hospital address -->
                        <input type="text" id="destination" name="destination" 
                               value="123 Hospital Road, City, Country" 
                               class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-600" 
                               required>
                    </div>

                    <!-- Request Date: Unchanged -->
                    <div class="mb-4">
                        <label for="requestDate" class="block text-gray-700 font-medium mb-2">
                            Request Date
                        </label>
                        <input type="date" id="requestDate" name="requestDate" 
                               class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-600" 
                               required>
                    </div>

                    <!-- Request Time: Unchanged -->
                    <div class="mb-4">
                        <label for="requestTime" class="block text-gray-700 font-medium mb-2">
                            Request Time
                        </label>
                        <input type="time" id="requestTime" name="requestTime" 
                               class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-600" 
                               required>
                    </div>

                    <!-- Submit Button: Unchanged -->
                    <button type="submit" 
                            class="w-full bg-blue-600 text-white p-2 rounded hover:bg-blue-700">
                        Book Ambulance
                    </button>
                </form>

                <!-- Back Link: Unchanged -->
                <a href="${pageContext.request.contextPath}/patient" 
                   class="block text-center text-blue-600 mt-4 hover:underline">
                    Back to Dashboard
                </a>
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