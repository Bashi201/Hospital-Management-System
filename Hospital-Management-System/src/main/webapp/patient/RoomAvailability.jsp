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
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #134e4a, #2dd4bf);
        }

        /* Sidebar Hover Effect */
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #2dd4bf, #5eead4);
        }

        /* Room Card Hover Effect */
        .room-card {
            transition: all 0.3s ease;
        }
        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #f0fdfa, #ccfbf1);
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
            background: #2dd4bf;
            border-radius: 4px;
        }
        .sidebar::-webkit-scrollbar-track {
            background: #1f2937;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-teal-100 font-sans h-full">
    <div class="flex h-full">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white fixed top-0 left-0 h-screen flex flex-col flex-shrink-0 sidebar">
            <div class="p-6 text-xl font-bold border-b border-gray-800 flex items-center space-x-3">
                <i class="fas fa-hospital text-teal-400"></i>
                <span>Patient Portal</span>
            </div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-teal-400"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient?action=channeling" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-calendar-check mr-3 text-teal-400"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient?action=doctors" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-user-md mr-3 text-teal-400"></i> Doctors
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient?action=rooms" class="sidebar-link flex items-center p-3 bg-teal-600 rounded text-white">
                            <i class="fas fa-bed mr-3 text-teal-200"></i> Rooms
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient?action=settings" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-cog mr-3 text-teal-400"></i> Settings
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col ml-64" style="background-image: url('${pageContext.request.contextPath}/patient/assets/RoomAvailablitiyBG.jpg'); background-size: cover; background-position: center; background-repeat: no-repeat;">
            <!-- Top Navbar -->
            <header class="header-gradient text-white p-4 flex justify-between items-center shadow-lg">
                <span id="datetime" class="text-lg font-medium"></span>
                <div class="flex items-center space-x-4">
                    <div class="relative group">
                        <img src="${pageContext.request.contextPath}/patient_dp.jpeg" alt="Patient Profile" class="w-10 h-10 rounded-full border-2 border-teal-200 shadow-sm cursor-pointer object-cover profile-img">
                        <div class="absolute left-1/2 transform -translate-x-1/2 -top-48 hidden group-hover:flex 
                                    w-40 h-40 border-2 border-teal-300 rounded-full overflow-hidden shadow-xl bg-white p-1 z-50">
                            <img src="${pageContext.request.contextPath}/patient_dp.jpeg" alt="Patient Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    <span class="text-white font-medium">${name != null ? name : "Patient"}</span>
                    <form action="${pageContext.request.contextPath}/patient" method="post">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                            Logout
                        </button>
                    </form>
                </div>
            </header>

            <!-- Room Availability Content -->
            <div class="container mx-auto p-8 flex-1">
                <h2 class="text-3xl font-bold text-gray-800 mb-8 text-center">Check Room Availability</h2>

                <c:if test="${not empty errorMessage}">
                    <div class="text-red-500 text-center mb-6 font-medium bg-red-50 p-3 rounded-md">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="text-green-500 text-center mb-6 font-medium bg-green-50 p-3 rounded-md">${successMessage}</div>
                </c:if>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:choose>
                        <c:when test="${empty availableRooms}">
                            <div class="col-span-full text-center text-gray-500 bg-white p-8 rounded-xl shadow-md">
                                <i class="fas fa-bed text-5xl text-teal-500 mb-4"></i>
                                <p class="text-lg">No rooms are currently available.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="room" items="${availableRooms}">
                                <div class="room-card bg-white p-6 rounded-xl shadow-md">
                                    <div class="flex items-center space-x-4 mb-4">
                                        <i class="fas fa-bed text-3xl text-teal-500"></i>
                                        <div>
                                            <h3 class="text-xl font-semibold text-gray-800">Room ${room.id}</h3>
                                            <p class="text-lg text-gray-600">${room.type}</p>
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <h4 class="text-md font-semibold text-gray-800">Details</h4>
                                        <p class="text-gray-600">${room.description != null ? room.description : 'Standard room with essential amenities'}</p>
                                    </div>
                                    <div class="mb-4">
                                        <h4 class="text-md font-semibold text-gray-800">Price</h4>
                                        <p class="text-gray-600">${room.price != null ? room.price : 'N/A'} per night</p>
                                    </div>
                                    <div class="text-right">
                                        <a href="${pageContext.request.contextPath}/patient?action=bookRoomForm&roomId=${room.id}" 
                                           class="bg-teal-500 text-white px-4 py-2 rounded-md hover:bg-teal-600 transition-colors">
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