<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Profiles</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/doctor/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #134e4a, #2dd4bf);
            position: fixed; /* Make header fixed */
            top: 0;
            left: 256px; /* Offset to start after the sidebar */
            right: 0;
            z-index: 900; /* Ensure it stays above other content */
        }

        /* Sidebar Hover Effect */
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #2dd4bf, #5eead4);
        }

        /* Card Hover Effect */
        .doctor-card {
            transition: all 0.3s ease;
            border: 1px solid #ccfbf1; /* Subtle teal border */
        }
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #e6fffa, #b5f5ec);
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

        /* Background Overlay for Readability */
        .main-content {
            background: linear-gradient(rgba(255, 255, 255, 0.8), rgba(255, 255, 255, 0.8)), 
                        url('${pageContext.request.contextPath}/patient/assets/DoctorProfileBG.jpg') no-repeat center center/cover;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-teal-100 font-sans h-full">
    <div class="flex h-full">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white fixed top-0 left-0 h-screen flex flex-col flex-shrink-0">
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
                        <a href="${pageContext.request.contextPath}/patient?action=doctors" class="sidebar-link flex items-center p-3 bg-teal-600 rounded text-white">
                            <i class="fas fa-user-md mr-3 text-teal-200"></i> Doctors
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
                    <span class="text-white font-medium">${name != null ? name : "Patient"}</span>
                    <form action="${pageContext.request.contextPath}/patient" method="post">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                            Logout
                        </button>
                    </form>
                </div>
            </header>

            <!-- Doctor Profiles Content -->
            <div class="container mx-auto p-8 pt-20 flex-1">
                <h1 class="text-4xl font-bold text-gray-800 mb-8 text-center">Doctor Profiles</h1>
                <c:if test="${not empty errorMessage}">
                    <div class="text-red-500 text-center mb-6 font-medium bg-gradient-to-r from-red-50 to-red-100 p-3 rounded-lg">${errorMessage}</div>
                </c:if>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-6xl mx-auto">
                    <c:forEach var="doctor" items="${doctors}">
                        <div class="doctor-card bg-gradient-to-br from-teal-50 to-teal-100 p-8 rounded-xl shadow-md border border-teal-200">
                            <div class="flex items-center space-x-4 mb-4">
                                <div class="w-24 h-24 rounded-full overflow-hidden ring-2 ring-teal-400">
                                    <img src="${doctor.picture != null ? doctor.picture : '${pageContext.request.contextPath}/patient/assets/default_doctor.jpg'}" 
                                         alt="Doctor Profile" class="w-full h-full object-cover">
                                </div>
                                <div>
                                    <h2 class="text-2xl font-bold text-gray-800">${doctor.name}</h2>
                                    <p class="text-base text-gray-700">${doctor.specialty}</p>
                                    <p class="text-gray-600 text-sm">
                                        <i class="fas fa-id-card mr-2 text-teal-600"></i> ID: ${doctor.id}
                                    </p>
                                </div>
                            </div>
                            <div class="space-y-4">
                                <div>
                                    <h3 class="text-lg font-semibold text-gray-800">Qualifications</h3>
                                    <p class="text-gray-700 text-sm">${doctor.qualifications}</p>
                                </div>
                                <div>
                                    <h3 class="text-lg font-semibold text-gray-800">Contact</h3>
                                    <p class="text-gray-700 text-sm">
                                        <i class="fas fa-envelope mr-2 text-teal-600"></i> ${doctor.email}
                                    </p>
                                    <p class="text-gray-700 text-sm">
                                        <i class="fas fa-phone mr-2 text-teal-600"></i> ${doctor.phone}
                                    </p>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/patient?action=channeling&doctorId=${doctor.id}" 
                                       class="bg-gradient-to-r from-teal-500 to-teal-600 text-white px-6 py-3 rounded-lg hover:from-teal-600 hover:to-teal-700 transition-colors text-base">
                                        Book Appointment
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
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