<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Patients</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/admin/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
            position: fixed;
            top: 0;
            left: 256px;
            right: 0;
            z-index: 900;
        }

        /* Sidebar Hover Effect */
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #3b82f6, #60a5fa);
        }

        /* Card Hover Effect */
        .patient-card {
            transition: all 0.3s ease;
        }
        .patient-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
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
            background: #3b82f6;
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
            background: url('${pageContext.request.contextPath}/admin/assets/AdminDashBG.png') no-repeat center center/cover;
            z-index: -1;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-blue-50 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen sidebar overflow-y-auto">
            <div class="p-6 text-xl font-bold border-b border-gray-800 flex items-center space-x-3">
                <i class="fas fa-hospital text-blue-400"></i>
                <span>Admin Panel</span>
            </div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-blue-400"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=patients" class="sidebar-link flex items-center p-3 bg-blue-600 rounded text-white">
                            <i class="fas fa-users mr-3 text-blue-200"></i> Manage Patients
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=doctors" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-user-md mr-3 text-blue-400"></i> Manage Doctors
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin?action=settings" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-cog mr-3 text-blue-400"></i> Settings
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
                        <img src="${pageContext.request.contextPath}/admin_dp.jpeg" alt="Admin Profile" class="w-10 h-10 rounded-full border-2 border-blue-200 shadow-sm cursor-pointer object-cover profile-img">
                        <div class="absolute left-1/2 transform -translate-x-1/2 -top-48 hidden group-hover:flex 
                                    w-40 h-40 border-2 border-blue-300 rounded-full overflow-hidden shadow-xl bg-white p-1 z-50">
                            <img src="${pageContext.request.contextPath}/admin_dp.jpeg" alt="Admin Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    <span class="text-white font-medium">Welcome, ${name}</span>
                    <a href="${pageContext.request.contextPath}/admin?action=logout" 
                       class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Patient Management Tiles -->
            <div class="container mx-auto p-8 pt-20 flex-1">
                <h1 class="text-4xl font-bold text-gray-800 mb-8 text-center">Patient Management</h1>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
                    <a href="${pageContext.request.contextPath}/admin?action=createPatient" 
                       class="patient-card bg-gradient-to-br from-blue-600 to-blue-400 p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-72">
                        <i class="fas fa-user-plus text-6xl text-white mb-4"></i>
                        <h2 class="text-2xl font-semibold text-white">Create Patient</h2>
                        <p class="text-gray-100 mt-2 text-center">Add a new patient to the system</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin?action=viewPatients" 
                       class="patient-card bg-gradient-to-br from-blue-600 to-blue-400 p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-72">
                        <i class="fas fa-list text-6xl text-white mb-4"></i>
                        <h2 class="text-2xl font-semibold text-white">View Patients</h2>
                        <p class="text-gray-100 mt-2 text-center">Browse and search all patients</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin?action=viewAppointments" 
                       class="patient-card bg-gradient-to-br from-blue-600 to-blue-400 p-8 rounded-xl shadow-md flex flex-col items-center justify-center h-72">
                        <i class="fas fa-calendar-check text-6xl text-white mb-4"></i>
                        <h2 class="text-2xl font-semibold text-white">View Appointments</h2>
                        <p class="text-gray-100 mt-2 text-center">View all appointments by day</p>
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