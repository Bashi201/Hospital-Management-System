<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Doctor Portal</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/doctor/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #4c1d95, #7c3aed);
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
            background: linear-gradient(90deg, #7c3aed, #a78bfa);
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
            background: url('${pageContext.request.contextPath}/doctor/assets/DoctorBG.png') no-repeat center center/cover;
        }

        /* Color Picker Styling */
        .color-picker-container {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .color-picker-container input[type="color"] {
            width: 40px;
            height: 40px;
            border: none;
            cursor: pointer;
            border-radius: 50%;
            padding: 0;
        }
        .color-picker-container input[type="color"]::-webkit-color-swatch-wrapper {
            padding: 0;
        }
        .color-picker-container input[type="color"]::-webkit-color-swatch {
            border: none;
            border-radius: 50%;
        }
        .color-picker-container label {
            font-weight: 500;
            color: #374151;
        }

        /* Card Styling */
        .settings-card {
            transition: all 0.3s ease;
        }
        .settings-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
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
                        <a href="${pageContext.request.contextPath}/doctor" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-purple-400"></i> Dashboard
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
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/doctor?action=salary" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-money-bill-wave mr-3 text-purple-400"></i> Salary
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor?action=settings" class="sidebar-link flex items-center p-3 bg-purple-600 rounded text-white">
                            <i class="fas fa-cog mr-3 text-purple-200"></i> Settings
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

            <!-- Settings Section -->
            <div class="container mx-auto p-8 pt-20 flex-1">
                <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">Settings</h1>
                <div class="max-w-lg mx-auto">
                    <div class="bg-white p-6 rounded-xl shadow-md settings-card">
                        <h2 class="text-xl font-semibold text-gray-800 mb-6">Customize Theme Colors</h2>
                        <div class="space-y-6">
                            <!-- Header Gradient Colors -->
                            <div>
                                <h3 class="text-lg font-medium text-gray-700 mb-2">Header Gradient</h3>
                                <div class="flex space-x-4">
                                    <div class="color-picker-container">
                                        <label>Start Color:</label>
                                        <input type="color" id="header-gradient-start" value="#4c1d95">
                                    </div>
                                    <div class="color-picker-container">
                                        <label>End Color:</label>
                                        <input type="color" id="header-gradient-end" value="#7c3aed">
                                    </div>
                                </div>
                            </div>

                            <!-- Sidebar Background Color -->
                            <div>
                                <h3 class="text-lg font-medium text-gray-700 mb-2">Sidebar Background</h3>
                                <div class="color-picker-container">
                                    <label>Color:</label>
                                    <input type="color" id="sidebar-bg" value="#1f2937">
                                </div>
                            </div>

                            <!-- Dashboard Card Gradient Colors -->
                            <div>
                                <h3 class="text-lg font-medium text-gray-700 mb-2">Dashboard Cards Gradient</h3>
                                <div class="flex space-x-4">
                                    <div class="color-picker-container">
                                        <label>Start Color:</label>
                                        <input type="color" id="card-gradient-start" value="#7c3aed">
                                    </div>
                                    <div class="color-picker-container">
                                        <label>End Color:</label>
                                        <input type="color" id="card-gradient-end" value="#a78bfa">
                                    </div>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="flex space-x-4 mt-6">
                                <button id="save-theme-btn" class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-colors">
                                    Save Theme
                                </button>
                                <button id="reset-theme-btn" class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors">
                                    Reset to Default
                                </button>
                            </div>
                        </div>
                    </div>
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

        // Function to apply theme colors
        function applyTheme() {
            const headerGradientStart = document.getElementById('header-gradient-start').value;
            const headerGradientEnd = document.getElementById('header-gradient-end').value;
            const sidebarBg = document.getElementById('sidebar-bg').value;
            const cardGradientStart = document.getElementById('card-gradient-start').value;
            const cardGradientEnd = document.getElementById('card-gradient-end').value;

            // Apply Header Gradient
            document.querySelector('.header-gradient').style.background = `linear-gradient(90deg, ${headerGradientStart}, ${headerGradientEnd})`;

            // Apply Sidebar Background
            document.querySelector('.sidebar').style.backgroundColor = sidebarBg;

            // Apply Dashboard Card Gradient (for sidebar hover effect)
            document.querySelectorAll('.sidebar-link').forEach(link => {
                link.addEventListener('mouseover', () => {
                    link.style.background = `linear-gradient(90deg, ${cardGradientStart}, ${cardGradientEnd})`;
                });
                link.addEventListener('mouseout', () => {
                    if (!link.classList.contains('bg-purple-600')) {
                        link.style.background = 'none';
                    }
                });
            });

            // Update CSS variables for dashboard cards (if present)
            document.documentElement.style.setProperty('--card-gradient-start', cardGradientStart);
            document.documentElement.style.setProperty('--card-gradient-end', cardGradientEnd);
        }

        // Function to save theme to localStorage
        function saveTheme() {
            const theme = {
                headerGradientStart: document.getElementById('header-gradient-start').value,
                headerGradientEnd: document.getElementById('header-gradient-end').value,
                sidebarBg: document.getElementById('sidebar-bg').value,
                cardGradientStart: document.getElementById('card-gradient-start').value,
                cardGradientEnd: document.getElementById('card-gradient-end').value
            };
            localStorage.setItem('doctorTheme', JSON.stringify(theme));
            alert('Theme saved successfully!');
        }

        // Function to load theme from localStorage
        function loadTheme() {
            const savedTheme = localStorage.getItem('doctorTheme');
            if (savedTheme) {
                const theme = JSON.parse(savedTheme);
                document.getElementById('header-gradient-start').value = theme.headerGradientStart;
                document.getElementById('header-gradient-end').value = theme.headerGradientEnd;
                document.getElementById('sidebar-bg').value = theme.sidebarBg;
                document.getElementById('card-gradient-start').value = theme.cardGradientStart;
                document.getElementById('card-gradient-end').value = theme.cardGradientEnd;
                applyTheme();
            }
        }

        // Function to reset theme to default
        function resetTheme() {
            localStorage.removeItem('doctorTheme');
            document.getElementById('header-gradient-start').value = '#4c1d95';
            document.getElementById('header-gradient-end').value = '#7c3aed';
            document.getElementById('sidebar-bg').value = '#1f2937';
            document.getElementById('card-gradient-start').value = '#7c3aed';
            document.getElementById('card-gradient-end').value = '#a78bfa';
            applyTheme();
            alert('Theme reset to default!');
        }

        // Event listeners for color inputs
        document.querySelectorAll('input[type="color"]').forEach(input => {
            input.addEventListener('input', applyTheme);
        });

        // Event listener for save button
        document.getElementById('save-theme-btn').addEventListener('click', saveTheme);

        // Event listener for reset button
        document.getElementById('reset-theme-btn').addEventListener('click', resetTheme);

        // Load theme on page load
        window.addEventListener('load', loadTheme);
    </script>
</body>
</html>