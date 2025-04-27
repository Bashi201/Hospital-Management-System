<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin HomePage</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col fixed h-screen">
            <div class="p-5 text-lg font-bold border-b border-gray-800">All Employee Info</div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="#" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="#" class="flex items-center p-2 hover:bg-gray-700 rounded">
                            <i class="fas fa-users mr-3"></i> Users
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
        <div class="flex-1 ml-64 flex flex-col">
            <!-- Top Navbar -->
            <header class="bg-white shadow p-4 flex justify-between items-center">
                <!-- Date and Time Display -->
                <span id="datetime" class="text-xl font-semibold text-gray-800"></span>
                
                <div class="flex items-center space-x-4 relative">
                    <!-- Profile Picture Container -->
                    <div class="relative group">
                        <!-- Small Profile Picture -->
                        <img src="dp.jpeg" alt="Admin Profile" class="w-12 h-12 rounded-full border-2 border-gray-300 shadow-sm cursor-pointer object-cover">
                
                        <!-- Enlarged Image (Hidden by Default, Shown on Hover) -->
                        <div class="absolute left-1/2 transform -translate-x-1/2 hidden group-hover:flex 
                                    w-44 h-44 border-2 border-gray-400 rounded-full overflow-hidden shadow-lg bg-white p-1 z-10">
                            <img src="dp.jpeg" alt="Admin Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    
                    <!-- Admin Name -->
                    <span class="text-gray-700 font-medium">Admin Name</span>
                    
                    <!-- Logout Button -->
                    <button class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
                        Logout
                    </button>
                </div>
            </header>
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

            <!-- Main Content -->
            <div class="container mx-auto p-6 flex-1 overflow-y-auto">
                <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6">
                    <!-- New Patient Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-user-plus text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">New Patient</h2>
                        </div>
                    </div>

                    <!-- All Employee Info Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-users text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">All Employee Info</h2>
                        </div>
                    </div>

                    <!-- Search Room Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-search text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Search Room</h2>
                        </div>
                    </div>

                    <!-- Room Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-bed text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Room</h2>
                        </div>
                    </div>

                    <!-- Patient Info Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-address-card text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Patient Info</h2>
                        </div>
                    </div>

                    <!-- Update Patient Details Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-user-edit text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Update Patient Details</h2>
                        </div>
                    </div>

                    <!-- Department Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-building text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Department</h2>
                        </div>
                    </div>

                    <!-- Patient Discard Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-user-slash text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Patient Discard</h2>
                        </div>
                    </div>

                    <!-- Hospital Ambulance Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-ambulance text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Hospital Ambulance</h2>
                        </div>
                    </div>

                    <!-- Nurses Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-user-nurse text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Nurses</h2>
                            <p class="text-gray-600">Manage nursing staff</p>
                        </div>
                    </div>

                    <!-- Ambulance Services Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-ambulance text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Ambulance</h2>
                            <p class="text-gray-600">Manage services</p>
                        </div>
                    </div>

                    <!-- Salary & Payouts Tile -->
                    <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                        <div class="flex flex-col items-center">
                            <i class="fas fa-money-bill-wave text-4xl text-blue-600 mb-4"></i>
                            <h2 class="text-xl font-semibold text-gray-800">Salary & Payouts</h2>
                            <p class="text-gray-600">Salary reports & payouts</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>