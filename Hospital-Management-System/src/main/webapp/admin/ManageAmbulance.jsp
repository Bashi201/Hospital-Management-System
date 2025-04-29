<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Ambulance</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/admin/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
            position: fixed; /* Make header fixed */
            top: 0;
            left: 256px; /* Offset to start after the sidebar */
            right: 0;
            z-index: 900; /* Ensure it stays above other content */
        }

        /* Sidebar Styling */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 256px; /* Matches Tailwind's w-64 */
            height: 100vh; /* Full viewport height */
            background: #1f2937; /* Darker gray for consistency */
            color: white;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            z-index: 1000; /* Ensure it stays on top */
        }

        /* Sidebar Hover Effect */
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #3b82f6, #60a5fa);
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

        /* Table Styling */
        .ambulance-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            z-index: 10;
        }
        .ambulance-table thead {
            position: sticky;
            top: 0;
            z-index: 15;
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
            color: white;
        }
        .ambulance-table th {
            padding: 16px;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
        }
        .ambulance-table tbody tr {
            transition: all 0.3s ease;
        }
        .ambulance-table tbody tr:nth-child(odd) {
            background: #f9fafb;
        }
        .ambulance-table tbody tr:nth-child(even) {
            background: #ffffff;
        }
        .ambulance-table tbody tr:hover {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            transform: scale(1.01);
        }
        .ambulance-table td {
            padding: 14px 16px;
            border-bottom: 1px solid #e5e7eb;
        }
        .table-container {
            max-height: 60vh;
            overflow-y: auto;
            z-index: 10;
        }
        .table-container::-webkit-scrollbar {
            width: 8px;
        }
        .table-container::-webkit-scrollbar-thumb {
            background: #3b82f6;
            border-radius: 4px;
        }
        .table-container::-webkit-scrollbar-track {
            background: #f1f5f9;
        }

        /* Ensure buttons are clickable */
        .action-button {
            pointer-events: auto;
            z-index: 20;
            cursor: pointer;
        }

        /* Main Content Styling */
        .main-content {
            margin-left: 256px; /* Matches sidebar width */
            flex: 1;
            position: relative;
            min-height: 100vh; /* Ensure it takes full viewport height */
            padding-top: 64px; /* Add padding to account for fixed header height */
        }
        .main-content::before {
            content: '';
            position: fixed; /* Changed to fixed to cover the entire viewport */
            top: 0;
            left: 256px; /* Offset to start after the sidebar */
            right: 0;
            bottom: 0;
            background: url('${pageContext.request.contextPath}/admin/assets/AdminDashBGWithoutLogo.png') no-repeat center center/cover;
            z-index: -1;
        }

        /* Modal Styling */
        .modal {
            display: none;
            position: fixed;
            z-index: 100;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 8px;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        /* Consistent Spacing and Alignment */
        .container.mx-auto.p-8 {
            padding: 2rem; /* Consistent padding */
        }
        .max-w-7xl.mx-auto {
            max-width: 70rem;
            margin-left: auto;
            margin-right: auto;
            display: flex;
            flex-direction: column;
            gap: 2rem; /* Uniform gap between sections */
        }
        .grid.grid-cols-1.lg\:grid-cols-2 {
            gap: 2rem; /* Consistent gap between cards */
            align-items: stretch; /* Ensure cards stretch to same height */
        }
        .bg-white.p-6.rounded-lg.shadow-md {
            padding: 1.5rem; /* Consistent padding inside cards */
            margin-bottom: 0; /* Remove default margin */
        }
        .flex.justify-between.items-center.mb-4 {
            margin-bottom: 1rem; /* Consistent margin */
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-blue-50 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="sidebar w-64 bg-gray-900 text-white flex flex-col">
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
                        <a href="${pageContext.request.contextPath}/admin?action=patients" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-users mr-3 text-blue-400"></i> Manage Patients
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=doctors" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-user-md mr-3 text-blue-400"></i> Manage Doctors
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=rooms" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-bed mr-3 text-blue-400"></i> Rooms
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=nurses" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-user-nurse mr-3 text-blue-400"></i> Nurses
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=ambulance" class="sidebar-link flex items-center p-3 bg-blue-600 rounded text-white">
                            <i class="fas fa-ambulance mr-3 text-blue-200"></i> Ambulance
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin?action=salary" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-money-bill-wave mr-3 text-blue-400"></i> Salary
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
                    <span class="text-white font-medium">Welcome, ${name != null ? name : "Admin"}</span>
                    <a href="${pageContext.request.contextPath}/admin?action=logout" 
                       class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                        Logout
                    </a>
                </div>
            </header>

            <!-- Ambulance Management Section -->
            <main class="container mx-auto p-8 flex-1">
                <div class="max-w-7xl mx-auto">
                    <div class="mb-8 text-center">
                        <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M22 11.5V13a2 2 0 0 1-2 2h-1l-2 4h-3l-1-3H9l-1 3H5l-2-4H2a2 2 0 0 1-2-2v-1.5a2 2 0 0 1 2-2h2.5L7 6h4l1 3h4l1-3h4l2.5 4.5H22z'/><path d='M6 12h12'/><path d='M9 12v3'/><path d='M15 12v3'/></svg>" alt="Ambulance Icon" class="w-12 h-12 mx-auto mb-2">
                        <h2 class="text-2xl font-semibold text-gray-800">Manage Ambulance</h2>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="text-green-500 text-center mb-6 font-medium bg-green-50 p-3 rounded-md">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="text-red-500 text-center mb-6 font-medium bg-red-50 p-3 rounded-md">${errorMessage}</div>
                    </c:if>

                    <!-- Ambulance Status and Request -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                        <!-- Available Ambulances -->
                        <section class="bg-white p-6 rounded-lg shadow-md">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-ambulance text-blue-600 mr-2"></i> Available Ambulances
                            </h3>
                            <p class="text-gray-600 mb-4">
                                Total: <span class="font-semibold">${availableAmbulances != null ? availableAmbulances : '0'}</span>
                            </p>
                            <c:choose>
                                <c:when test="${empty availableAmbulanceVehicleNumbers}">
                                    <p class="text-gray-600">No ambulances available.</p>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-container">
                                        <table class="ambulance-table min-w-full">
                                            <thead>
                                                <tr>
                                                    <th class="text-left">Vehicle Number</th>
                                                    <th class="text-left">Identifier</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="vehicleNumber" items="${availableAmbulanceVehicleNumbers}">
                                                    <tr>
                                                        <td class="text-sm text-gray-900">${vehicleNumber}</td>
                                                        <td class="text-sm text-gray-900">
                                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                                                                <i class="fas fa-ambulance mr-1"></i> AMB-${vehicleNumber.substring(vehicleNumber.length() - 4)}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </section>

                        <!-- Latest Ambulance Request -->
                        <section class="bg-white p-6 rounded-lg shadow-md">
                            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                <i class="fas fa-file-alt text-blue-600 mr-2"></i> Latest Ambulance Request
                            </h3>
                            <c:choose>
                                <c:when test="${not empty latestAmbulanceRequest}">
                                    <div class="space-y-4">
                                        <div>
                                            <label class="block text-gray-700 text-sm font-medium">Patient ID:</label>
                                            <p class="text-gray-600 text-sm">${latestAmbulanceRequest.patientId}</p>
                                        </div>
                                        <div>
                                            <label class="block text-gray-700 text-sm font-medium">Pickup Location:</label>
                                            <p class="text-gray-600 text-sm">${latestAmbulanceRequest.pickupLocation}</p>
                                        </div>
                                        <div>
                                            <label class="block text-gray-700 text-sm font-medium">Destination:</label>
                                            <p class="text-gray-600 text-sm">${latestAmbulanceRequest.destination}</p>
                                        </div>
                                        <div>
                                            <label class="block text-gray-700 text-sm font-medium">Date:</label>
                                            <p class="text-gray-600 text-sm">${latestAmbulanceRequest.requestDate}</p>
                                        </div>
                                        <div>
                                            <label class="block text-gray-700 text-sm font-medium">Time:</label>
                                            <p class="text-gray-600 text-sm">${latestAmbulanceRequest.requestTime}</p>
                                        </div>
                                        <div>
                                            <label class="block text-gray-700 text-sm font-medium">Assign Ambulance and Driver:</label>
                                            <form action="${pageContext.request.contextPath}/admin" method="POST">
                                                <input type="hidden" name="action" value="dispatchAmbulance">
                                                <input type="hidden" name="bookingId" value="${latestAmbulanceRequest.id}">
                                                <div class="flex space-x-4">
                                                    <select name="vehicleNumber" class="w-1/2 p-2 border rounded-md" required>
                                                        <option value="" disabled selected>Select Ambulance</option>
                                                        <c:forEach var="vehicleNumber" items="${availableAmbulanceVehicleNumbers}">
                                                            <option value="${vehicleNumber}">${vehicleNumber} (AMB-${vehicleNumber.substring(vehicleNumber.length() - 4)})</option>
                                                        </c:forEach>
                                                    </select>
                                                    <select name="driverId" class="w-1/2 p-2 border rounded-md" required>
                                                        <option value="" disabled selected>Select Driver</option>
                                                        <c:forEach var="driver" items="${driversAtHospital}">
                                                            <option value="${driver.driverId}">${driver.name} (${driver.driverId})</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <button type="submit" class="action-button mt-4 inline-flex items-center px-3 py-1 bg-green-600 text-white text-sm font-medium rounded-md hover:bg-green-700 transition-colors">
                                                    <i class="fas fa-truck-medical mr-2"></i> Dispatch
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-gray-600 text-sm">No recent ambulance requests.</p>
                                </c:otherwise>
                            </c:choose>
                        </section>
                    </div>

                    <!-- Drivers at Hospital -->
                    <section class="bg-white p-6 rounded-lg shadow-md mb-8">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-user-tie text-blue-600 mr-2"></i> Drivers at Hospital
                            </h3>
                            <button onclick="openModal()" class="action-button inline-flex items-center px-3 py-1 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition-colors">
                                <i class="fas fa-plus mr-2"></i> Add Driver
                            </button>
                        </div>
                        <c:choose>
                            <c:when test="${empty driversAtHospital}">
                                <p class="text-gray-600 text-sm">No drivers currently at the hospital.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                    <c:forEach var="driver" items="${driversAtHospital}">
                                        <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                                            <i class="fas fa-user-tie text-blue-600 mr-3"></i>
                                            <div>
                                                <span class="text-gray-700 font-medium">${driver.name}</span>
                                                <span class="text-gray-600 text-sm block">(${driver.driverId})</span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <!-- Ambulance History -->
                    <section class="bg-white p-6 rounded-lg shadow-md mb-8">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                            <i class="fas fa-history text-blue-600 mr-2"></i> Ambulance History
                        </h3>
                        <c:choose>
                            <c:when test="${empty ambulanceHistory}">
                                <p class="text-gray-600 text-sm">No ambulance dispatch history available.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-container">
                                    <table class="ambulance-table min-w-full">
                                        <thead>
                                            <tr>
                                                <th class="text-left">Patient ID</th>
                                                <th class="text-left">Pickup Location</th>
                                                <th class="text-left">Destination</th>
                                                <th class="text-left">Vehicle Number</th>
                                                <th class="text-left">Driver ID</th>
                                                <th class="text-left">Dispatch Time</th>
                                                <th class="text-left">Return Time</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="entry" items="${ambulanceHistory}">
                                                <tr>
                                                    <td class="text-sm text-gray-900">${entry.patientId}</td>
                                                    <td class="text-sm text-gray-900">${entry.pickupLocation}</td>
                                                    <td class="text-sm text-gray-900">${entry.destination}</td>
                                                    <td class="text-sm text-gray-900">${entry.vehicleNumber}</td>
                                                    <td class="text-sm text-gray-900">${entry.driverId}</td>
                                                    <td class="text-sm text-gray-900">${entry.dispatchTime}</td>
                                                    <td class="text-sm text-gray-900">
                                                        <c:choose>
                                                            <c:when test="${entry.returnTime != null}">
                                                                ${entry.returnTime}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Not Returned
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <!-- Unavailable Ambulances -->
                    <section class="bg-white p-6 rounded-lg shadow-md">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                            <i class="fas fa-ambulance text-red-600 mr-2"></i> Unavailable Ambulances
                        </h3>
                        <c:choose>
                            <c:when test="${empty unavailableAmbulances}">
                                <p class="text-gray-600 text-sm">No ambulances are currently unavailable.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-container">
                                    <table class="ambulance-table min-w-full">
                                        <thead>
                                            <tr>
                                                <th class="text-left">Vehicle Number</th>
                                                <th class="text-left">Identifier</th>
                                                <th class="text-left">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="vehicleNumber" items="${unavailableAmbulances}">
                                                <tr>
                                                    <td class="text-sm text-gray-900">${vehicleNumber}</td>
                                                    <td class="text-sm text-gray-900">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                                                            <i class="fas fa-ambulance mr-1"></i> AMB-${vehicleNumber.substring(vehicleNumber.length() - 4)}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <form action="${pageContext.request.contextPath}/admin" method="POST">
                                                            <input type="hidden" name="action" value="returnAmbulance">
                                                            <input type="hidden" name="vehicleNumber" value="${vehicleNumber}">
                                                            <button type="submit" class="action-button inline-flex items-center px-3 py-1 bg-yellow-600 text-white text-sm font-medium rounded-md hover:bg-yellow-700 transition-colors">
                                                                <i class="fas fa-undo mr-2"></i> Return
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal for Adding Driver -->
    <div id="addDriverModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">×</span>
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Add New Driver</h2>
            <form action="${pageContext.request.contextPath}/admin" method="POST">
                <input type="hidden" name="action" value="createDriver">
                <div class="mb-4">
                    <label for="driverId" class="block text-gray-700 text-sm font-medium mb-2">Driver ID:</label>
                    <input type="text" id="driverId" name="driverId" class="w-full p-2 border rounded-md" placeholder="Enter Driver ID" required>
                </div>
                <div class="mb-4">
                    <label for="name" class="block text-gray-700 text-sm font-medium mb-2">Driver Name:</label>
                    <input type="text" id="name" name="name" class="w-full p-2 border rounded-md" placeholder="Enter Driver Name" required>
                </div>
                <button type="submit" class="action-button inline-flex items-center px-3 py-1 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition-colors">
                    <i class="fas fa-plus mr-2"></i> Add Driver
                </button>
            </form>
        </div>
    </div>

    <script>
        // Date and Time Display
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
            document.getElementById('datetime').textContent = now.toLocaleDateString('en-US', options);
        }
        setInterval(updateDateTime, 1000);
        updateDateTime();

        // Modal Functions
        function openModal() {
            document.getElementById('addDriverModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('addDriverModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('addDriverModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
</html>