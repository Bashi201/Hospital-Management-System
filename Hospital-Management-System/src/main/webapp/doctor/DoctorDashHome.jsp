<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen">
            <div class="p-5 text-lg font-bold border-b border-gray-800">Doctor Portal</div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="#" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor?action=appointments" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-calendar-check mr-3"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor?action=patients" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-users mr-3"></i> Patients
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor?action=rooms" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-bed mr-3"></i> Room Assignments
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
       <div class="flex-1 flex flex-col" style="background-image: url('${pageContext.request.contextPath}/doctor/assets/DoctorBG.png'); background-size: cover; background-position: center; background-repeat: no-repeat;">
            <!-- Top Navbar -->
            <header class="bg-white shadow p-4 flex justify-between items-center">
                <!-- Date and Time Display -->
                <span id="datetime" class="text-xl font-semibold text-gray-800"></span>
                
                <div class="flex items-center space-x-4 relative">
                    <!-- Profile Picture Container -->
                    <div class="relative group">
                        <img src="doctor_dp.jpeg" alt="Doctor Profile" class="w-12 h-12 rounded-full border-2 border-gray-300 shadow-sm cursor-pointer object-cover">
                        <div class="absolute left-1/2 transform -translate-x-1/2 hidden group-hover:flex 
                                    w-44 h-44 border-2 border-gray-400 rounded-full overflow-hidden shadow-lg bg-white p-1 z-10">
                            <img src="doctor_dp.jpeg" alt="Doctor Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    
                    <!-- Doctor Name -->
                    <span class="text-gray-700 font-medium">Welcome, ${name}</span>
                    
                    <!-- Logout Button -->
                    <a href="${pageContext.request.contextPath}/doctor?action=logout" 
                       class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Main Content with Vertical Tiles -->
            <div class="container mx-auto p-6 flex-1 flex items-center justify-center">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 w-full max-w-4xl">
                    <!-- Appointments Tile -->
                    <a href="${pageContext.request.contextPath}/doctor?action=appointments" 
                       class="bg-white p-8 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer flex flex-col items-center justify-center h-64">
                        <i class="fas fa-calendar-alt text-6xl text-blue-600 mb-4"></i>
                        <h2 class="text-2xl font-semibold text-gray-800">Appointments</h2>
                        <p class="text-gray-600 mt-2">View your schedule</p>
                    </a>

                    <!-- Patients Tile -->
                    <a href="${pageContext.request.contextPath}/doctor?action=patients" 
                       class="bg-white p-8 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer flex flex-col items-center justify-center h-64">
                        <i class="fas fa-users text-6xl text-blue-600 mb-4"></i>
                        <h2 class="text-2xl font-semibold text-gray-800">Patients</h2>
                        <p class="text-gray-600 mt-2">Manage patient records</p>
                    </a>

                    <!-- Rooms Tile -->
                    <a href="${pageContext.request.contextPath}/doctor?action=rooms" 
                       class="bg-white p-8 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer flex flex-col items-center justify-center h-64">
                        <i class="fas fa-bed text-6xl text-blue-600 mb-4"></i>
                        <h2 class="text-2xl font-semibold text-gray-800">Room Assignments</h2>
                        <p class="text-gray-600 mt-2">Check assigned rooms</p>
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
    
        // Update immediately and then every second
        updateDateTime();
        setInterval(updateDateTime, 1000);
    </script>
</body>
</html>