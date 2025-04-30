<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/doctor/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #4c1d95, #7c3aed);
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
            background: linear-gradient(90deg, #7c3aed, #a78bfa);
        }

        /* Card Hover Effect */
        .dashboard-card {
            transition: all 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #f5f3ff, #ede9fe);
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
            background: #7c3aed;
            border-radius: 4px;
        }
        .sidebar::-webkit-scrollbar-track {
            background: #1f2937;
        }

        /* Background Overlay for Readability */
        .main-content {
            background:  
                        url('${pageContext.request.contextPath}/doctor/assets/DoctorBG.png') no-repeat center center/cover;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-purple-50 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen sidebar overflow-y-auto">
            <div class="p-6 text-xl font-bold border-b border-gray-800 flex items-center space-x-3">
                <i class="fas fa-hospital text-purple-400"></i>
                <span>Doctor Portal</span>
            </div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/doctor" class="sidebar-link flex items-center p-3 bg-purple-600 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-purple-200"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/doctor?action=appointments" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-calendar-check mr-3 text-purple-400"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/doctor?action=patients" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-users mr-3 text-purple-400"></i> Patients
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor?action=salary" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-money-bill-wave mr-3 text-purple-400"></i> Salary
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col main-content">
            <!-- Top Navbar -->
            <header class="header-gradient text-white p-4 flex justify-between items-center shadow-lg">
                <span id="datetime" class="text-lg font-medium"></span>
                <div class="flex items-center space-x-4">
                    <div class="relative group">
                        <img src="doctor_dp.jpeg" alt="Doctor Profile" class="w-10 h-10 rounded-full border-2 border-purple-200 shadow-sm cursor-pointer object-cover profile-img">
                        <div class="absolute left-1/2 transform -translate-x-1/2 -top-48 hidden group-hover:flex 
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

            <!-- Main Dashboard Tiles -->
            <div class="container mx-auto p-8 pt-20 flex-1">
                <h1 class="text-4xl font-bold text-gray-800 mb-8 text-center">Doctor Dashboard</h1>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
                    <!-- Appointments Tile -->
                    <a href="${pageContext.request.contextPath}/doctor?action=appointments" 
                       class="dashboard-card bg-gradient-to-br from-purple-600 to-purple-400 p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-72">
                        <i class="fas fa-calendar-alt text-6xl text-white mb-4"></i>
                        <h2 class="text-2xl font-semibold text-white">Appointments</h2>
                        <p class="text-gray-100 mt-2 text-center">View your schedule</p>
                    </a>

                    <!-- Patients Tile -->
                    <a href="${pageContext.request.contextPath}/doctor?action=patients" 
                       class="dashboard-card bg-gradient-to-br from-purple-600 to-purple-400 p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-72">
                        <i class="fas fa-users text-6xl text-white mb-4"></i>
                        <h2 class="text-2xl font-semibold text-white">Patients</h2>
                        <p class="text-gray-100 mt-2 text-center">Manage patient records</p>
                    </a>

                    <!-- Salary Tile -->
                    <a href="${pageContext.request.contextPath}/doctor?action=salary" 
                       class="dashboard-card bg-gradient-to-br from-purple-600 to-purple-400 p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-72">
                        <i class="fas fa-money-bill-wave text-6xl text-white mb-4"></i>
                        <h2 class="text-2xl font-semibold text-white">Salary</h2>
                        <p class="text-gray-100 mt-2 text-center">View your payments</p>
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