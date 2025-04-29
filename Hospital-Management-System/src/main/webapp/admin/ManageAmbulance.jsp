<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Ambulance</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/admin/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen">
            <div class="p-5 text-lg font-bold border-b border-gray-800">Admin Panel</div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin?action=dashboard" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin?action=patients" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-users mr-3"></i> Manage Patients
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin?action=doctors" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-user-md mr-3"></i> Manage Doctors
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
        <div class="flex-1 flex flex-col">
            <!-- Top Navbar -->
            <header class="bg-white shadow p-4 flex justify-between items-center">
                <span id="datetime" class="text-xl font-semibold text-gray-800"></span>

                <div class="flex items-center space-x-4 relative">
                    <div class="relative group">
                        <img src="admin_dp.jpeg" alt="Admin Profile" class="w-12 h-12 rounded-full border-2 border-gray-300 shadow-sm cursor-pointer object-cover">
                        <div class="absolute left-1/2 transform -translate-x-1/2 hidden group-hover:flex 
                                    w-44 h-44 border-2 border-gray-400 rounded-full overflow-hidden shadow-lg bg-white p-1 z-10">
                            <img src="admin_dp.jpeg" alt="Admin Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>

                    <span class="text-gray-700 font-medium">Welcome, Admin ${name}</span>

                    <a href="${pageContext.request.contextPath}/admin?action=logout" 
                       class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Ambulance Management Section -->
            <div class="container mx-auto p-6 flex-1">
                <div class="max-w-4xl mx-auto">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
                        <i class="fas fa-ambulance text-blue-600 mr-3"></i> Manage Ambulance
                    </h2>

                    <!-- Success/Error Messages -->
                    <% if (request.getAttribute("successMessage") != null) { %>
                        <p class="text-green-600 mb-4">${successMessage}</p>
                    <% } %>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                        <p class="text-red-600 mb-4">${errorMessage}</p>
                    <% } %>

                    <!-- Two-Column Layout for Check and Send -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                        <!-- Option 1: Check Current Ambulances -->
                        <div class="bg-white p-6 rounded-lg shadow-md">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4">Check Current Ambulances</h3>
                            <p class="text-gray-600">
                                Available Ambulances: 
                                <span class="font-semibold">${availableAmbulances != null ? availableAmbulances : '0'}</span>
                            </p>
                        </div>

                        <!-- Option 2: Send Ambulance -->
                        <div class="bg-white p-6 rounded-lg shadow-md">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4">Send Ambulance</h3>
                            <form action="${pageContext.request.contextPath}/admin" method="POST" class="space-y-4">
                                <input type="hidden" name="action" value="sendAmbulance">
                                <div>
                                    <label for="patientId" class="block text-gray-700 text-sm">Patient ID:</label>
                                    <input type="text" id="patientId" name="patientId" class="border rounded px-2 py-1 w-full" required>
                                </div>
                                <div>
                                    <label for="pickupLocation" class="block text-gray-700 text-sm">Pickup Location:</label>
                                    <input type="text" id="pickupLocation" name="pickupLocation" class="border rounded px-2 py-1 w-full" required>
                                </div>
                                <div>
                                    <label for="destination" class="block text-gray-700 text-sm">Destination:</label>
                                    <input type="text" id="destination" name="destination" class="border rounded px-2 py-1 w-full" required>
                                </div>
                                <div>
                                    <label for="requestDate" class="block text-gray-700 text-sm">Date:</label>
                                    <input type="date" id="requestDate" name="requestDate" class="border rounded px-2 py-1 w-full" required>
                                </div>
                                <div>
                                    <label for="requestTime" class="block text-gray-700 text-sm">Time:</label>
                                    <input type="time" id="requestTime" name="requestTime" class="border rounded px-2 py-1 w-full" required>
                                </div>
                                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 w-full">Send Ambulance</button>
                            </form>
                        </div>
                    </div>

                    <!-- Ambulance Actions Icon List -->
                    <div class="bg-white p-6 rounded-lg shadow-md mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">Ambulance Actions</h3>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <!-- Icon 1: View History -->
                            <div class="flex flex-col items-center p-4 rounded-lg hover:bg-gray-50 transition-colors">
                                <i class="fas fa-history text-3xl text-blue-600 mb-2"></i>
                                <span class="text-gray-700 text-sm font-medium">View History</span>
                            </div>
                            <!-- Icon 2: Track Location -->
                            <div class="flex flex-col items-center p-4 rounded-lg hover:bg-gray-50 transition-colors">
                                <i class="fas fa-map-marker-alt text-3xl text-blue-600 mb-2"></i>
                                <span class="text-gray-700 text-sm font-medium">Track Location</span>
                            </div>
                            <!-- Icon 3: Schedule Maintenance -->
                            <div class="flex flex-col items-center p-4 rounded-lg hover:bg-gray-50 transition-colors">
                                <i class="fas fa-tools text-3xl text-blue-600 mb-2"></i>
                                <span class="text-gray-700 text-sm font-medium">Schedule Maintenance</span>
                            </div>
                            <!-- Icon 4: Emergency Alert -->
                            <div class="flex flex-col items-center p-4 rounded-lg hover:bg-gray-50 transition-colors">
                                <i class="fas fa-exclamation-triangle text-3xl text-red-600 mb-2"></i>
                                <span class="text-gray-700 text-sm font-medium">Emergency Alert</span>
                            </div>
                        </div>
                    </div>

                    <!-- Back to Dashboard Link -->
                    <div class="mt-6">
                        <a href="${pageContext.request.contextPath}/admin?action=dashboard" 
                           class="text-blue-600 hover:underline flex items-center">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                        </a>
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
    </script>
</body>
</html>