<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Appointments</title>
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
            height: 64px; /* Explicitly set height for consistency */
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
        .appointment-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            z-index: 10;
        }
        .appointment-table thead {
            position: sticky;
            top: 0;
            z-index: 15;
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
            color: white;
        }
        .appointment-table th {
            padding: 16px;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
        }
        .appointment-table tbody tr {
            transition: all 0.3s ease;
        }
        .appointment-table tbody tr:nth-child(odd) {
            background: #f9fafb;
        }
        .appointment-table tbody tr:nth-child(even) {
            background: #ffffff;
        }
        .appointment-table tbody tr:hover {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            transform: scale(1.01);
        }
        .appointment-table td {
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

        .main-content {
            position: relative;
            padding-top: 80px; /* Added padding to push content below the fixed header */
        }
        .main-content::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('${pageContext.request.contextPath}/admin/assets/AdminDashBGWithoutLogo.png') no-repeat center center/cover;
            z-index: -1;
        }

        /* Search Input Styling */
        .search-input {
            transition: all 0.3s ease;
        }
        .search-input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-blue-50 font-sans h-full">
    <div class="flex h-full">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white fixed top-0 left-0 h-screen flex flex-col flex-shrink-0 sidebar">
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
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=rooms" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-bed mr-3 text-blue-400"></i> Manage Rooms
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
        <div class="flex-1 flex flex-col ml-64 main-content">
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

            <!-- Appointment Management -->
            <div class="container mx-auto p-8 flex-1">
                <div class="mb-8 text-center">
                    <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><rect x='3' y='4' width='18' height='18' rx='2' ry='2'/><line x1='16' y1='2' x2='16' y2='6'/><line x1='8' y1='2' x2='8' y2='6'/><line x1='3' y1='10' x2='21' y2='10'/></svg>" alt="Appointment Icon" class="w-12 h-12 mx-auto mb-2">
                    <h2 class="text-2xl font-semibold text-gray-800">View Appointments</h2>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="text-red-500 text-center mb-6 font-medium bg-red-50 p-3 rounded-md max-w-7xl mx-auto">${errorMessage}</div>
                </c:if>

                <!-- Search Bar -->
                <div class="mb-6 max-w-7xl mx-auto">
                    <div class="relative">
                        <input type="text" id="searchInput" placeholder="Search by Patient ID, Doctor ID, or Date (YYYY-MM-DD)" 
                               class="w-full p-3 pl-10 border border-gray-300 rounded-lg search-input focus:outline-none"
                               onkeyup="filterAppointments()">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                </div>

                <!-- Appointment List (Grouped by Month) -->
                <div class="table-container max-w-7xl mx-auto">
                    <c:set var="currentMonth" value="" />
                    <c:forEach var="appointment" items="${appointments}" varStatus="loop">
                        <!-- Extract month and year from appointment date -->
                        <c:set var="appointmentMonth" value="${fn:substring(appointment.appointmentDate, 0, 7)}" />

                        <!-- Start a new table for each new month -->
                        <c:if test="${appointmentMonth != currentMonth}">
                            <c:if test="${not loop.first}">
                                </tbody>
                                </table>
                            </c:if>
                            <h3 class="text-xl font-semibold text-gray-800 mt-6 mb-4">
                                <c:out value="${appointmentMonth}" />
                            </h3>
                            <table class="appointment-table min-w-full mb-6">
                                <thead>
                                    <tr>
                                        <th class="text-left">Appointment ID</th>
                                        <th class="text-left">Patient ID</th>
                                        <th class="text-left">Doctor ID</th>
                                        <th class="text-left">Date</th>
                                        <th class="text-left">Time</th>
                                        <th class="text-left">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="appointment-group">
                            <c:set var="currentMonth" value="${appointmentMonth}" />
                        </c:if>

                        <tr class="appointment-row">
                            <td class="text-sm text-gray-900">${appointment.id}</td>
                            <td class="text-sm text-gray-900">${appointment.patientId}</td>
                            <td class="text-sm text-gray-900">${appointment.doctorId}</td>
                            <td class="text-sm text-gray-900">${appointment.appointmentDate}</td>
                            <td class="text-sm text-gray-900">${appointment.appointmentTime}</td>
                            <td class="text-sm">
                                <span class="flex items-center ${appointment.status == 'Confirmed' ? 'text-green-600' : appointment.status == 'Pending' ? 'text-yellow-600' : 'text-red-600'} font-medium">
                                    <i class="fas fa-circle mr-2 text-xs"></i> ${appointment.status}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <!-- Close the last table -->
                    <c:if test="${not empty appointments}">
                        </tbody>
                        </table>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Update DateTime
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

        // Search Functionality
        function filterAppointments() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('.appointment-row');
            const groups = document.querySelectorAll('.appointment-group');

            let hasVisibleRows = false;

            rows.forEach(row => {
                const patientId = row.cells[1].textContent.toLowerCase();
                const doctorId = row.cells[2].textContent.toLowerCase();
                const date = row.cells[3].textContent.toLowerCase();

                if (patientId.includes(searchInput) || doctorId.includes(searchInput) || date.includes(searchInput)) {
                    row.style.display = '';
                    hasVisibleRows = true;
                } else {
                    row.style.display = 'none';
                }
            });

            // Show/hide month headers and tables based on visible rows
            groups.forEach(group => {
                const parentTable = group.closest('table');
                const monthHeader = parentTable.previousElementSibling;
                const visibleRows = Array.from(group.querySelectorAll('tr')).some(row => row.style.display !== 'none');
                
                if (visibleRows) {
                    parentTable.style.display = '';
                    if (monthHeader && monthHeader.tagName === 'H3') {
                        monthHeader.style.display = '';
                    }
                } else {
                    parentTable.style.display = 'none';
                    if (monthHeader && monthHeader.tagName === 'H3') {
                        monthHeader.style.display = 'none';
                    }
                }
            });
        }
    </script>
</body>
</html>