<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ambulance Services</title>
     <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/doctor/assets/favicon.png">
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

        /* Tile Hover Effect */
        .dashboard-tile {
            transition: all 0.3s ease;
        }
        .dashboard-tile:hover {
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

        /* Background for Main Content */
        .main-content {
            position: relative;
        }
        .main-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('${pageContext.request.contextPath}/patient/assets/AmbulanceDashBG.png') no-repeat center center/cover;
            z-index: -1;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-teal-100 font-sans h-full">
    <div class="flex h-full">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white fixed top-0 left-0 h-screen flex flex-col flex-shrink-0 sidebar">
            <div class="p-6 text-xl font-bold border-b border-gray-800 flex items-center space-x- regul3">
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
                    <li>
                        <a href="${pageContext.request.contextPath}/patient?action=settings" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-cog mr-3 text-teal-400"></i> Settings
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col ml-64 main-content">
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
                    <span class="text-white font-medium">Welcome, ${name}</span>
                    <a href="${pageContext.request.contextPath}/patient?action=logout" 
                       class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Main Content with Tiles -->
            <div class="container mx-auto p-8 flex-1 flex items-center justify-center">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 w-full max-w-4xl">
                    <!-- Book an Ambulance Tile -->
                    <a href="${pageContext.request.contextPath}/patient?action=bookAmbulanceForm" 
                       class="dashboard-tile bg-white p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-64">
                        <i class="fas fa-ambulance text-5xl text-teal-500 mb-4"></i>
                        <h2 class="text-xl font-semibold text-gray-800">Book an Ambulance</h2>
                        <p class="text-gray-600 text-sm mt-2">Request a new ambulance service</p>
                    </a>

                    <!-- View Booked Ambulances Tile -->
                    <a href="${pageContext.request.contextPath}/patient?action=viewBookedAmbulances" 
                       class="dashboard-tile bg-white p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-64">
                        <i class="fas fa-list-alt text-5xl text-teal-500 mb-4"></i>
                        <h2 class="text-xl font-semibold text-gray-800">Booked Ambulances</h2>
                        <p class="text-gray-600 text-sm mt-2">View your ambulance bookings</p>
                    </a>
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