<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Availability</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans h-full">
    <div class="flex h-full">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white fixed top-0 left-0 h-screen flex flex-col flex-shrink-0">
            <div class="p-5 text-lg font-bold border-b border-gray-800">Patient Portal</div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/patient" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/patient?action=channeling" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-calendar-check mr-3"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/patient?action=doctors" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-user-md mr-3"></i> Doctors
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/patient?action=rooms" class="flex items-center p-2 bg-gray-700 rounded">
                            <i class="fas fa-bed mr-3"></i> Rooms
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
        <div class="flex-1 flex flex-col ml-64" style="background-image: url('${pageContext.request.contextPath}/patient/assets/RoomAvailablitiyBG.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
        
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

            <!-- Room Availability Content -->
            <div class="container mx-auto p-6 flex-1">
                <h2 class="text-2xl font-semibold text-gray-800 mb-6 text-center">Check Room Availability</h2>

                <c:if test="${not empty errorMessage}">
                    <div class="text-red-500 text-center mb-4">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="text-green-500 text-center mb-4">${successMessage}</div>
                </c:if>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:choose>
                        <c:when test="${empty availableRooms}">
                            <div class="col-span-full text-center text-gray-600">
                                <i class="fas fa-bed text-4xl mb-2"></i>
                                <p>No rooms are currently available.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="room" items="${availableRooms}">
                                <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
                                    <div class="flex items-center space-x-4">
                                        <div>
                                            <h3 class="text-xl font-semibold text-gray-800">Room ${room.id}</h3>
                                            <p class="text-lg text-gray-600">${room.type}</p>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <h4 class="text-md font-semibold text-gray-800">Details</h4>
                                        <p class="text-gray-600">${room.description != null ? room.description : 'Standard room with essential amenities'}</p>
                                    </div>
                                    <div class="mt-4">
                                        <h4 class="text-md font-semibold text-gray-800">Price</h4>
                                        <p class="text-gray-600">${room.price != null ? room.price : 'N/A'} per night</p>
                                    </div>
                                    <div class="mt-4">
                                        <a href="${pageContext.request.contextPath}/patient?action=bookRoomForm&roomId=${room.id}" 
                                           class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">
                                            Book Room
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
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