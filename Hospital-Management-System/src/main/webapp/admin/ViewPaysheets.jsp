<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Paysheets</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/admin/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* Custom Gradient for Header */
        .header-gradient {
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
        }

        /* Sidebar Styling - Ensure it stretches to bottom */
        .sidebar {
            height: 100vh; /* Full viewport height */
            position: sticky; /* Keeps sidebar in view while scrolling */
            top: 0; /* Aligns to top */
        }

        /* Sidebar Hover Effect */
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #3b82f6, #60a5fa);
        }

        /* Table Row Hover Effect for Paysheets Table - Simplified */
        .paysheets-table .table-row:hover {
            background-color: #f3f4f6; /* Subtle gray background on hover */
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

        /* Month Filter Styling */
        .month-filter {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }
        .month-filter select {
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 8px;
            background: white;
            cursor: pointer;
        }
        .month-filter select:focus {
            outline: none;
            ring: 2px;
            ring-blue-500;
        }

        /* Ensure table cells have proper padding and alignment */
        .paysheets-table th,
        .paysheets-table td {
            padding: 12px 16px;
            text-align: left;
        }

        /* Style for table headers */
        .paysheets-table th {
            background-color: #e0f2fe;
            color: #374151;
            font-weight: 600;
        }

        /* Ensure rounded corners for the first and last header cells */
        .paysheets-table th:first-child {
            border-top-left-radius: 8px;
        }
        .paysheets-table th:last-child {
            border-top-right-radius: 8px;
        }

        /* Add border and background to table rows */
        .paysheets-table .table-row {
            border-bottom: 1px solid #e5e7eb;
            background-color: #ffffff;
            
        }
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
            background: url('${pageContext.request.contextPath}/admin/assets/AdminDashBGWithoutLogo.png') no-repeat center center/cover;
            z-index: -1;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-blue-50 font-sans">
    <div class="flex min-h-screen"> <!-- Changed to min-h-screen to ensure full height -->
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col sidebar overflow-y-auto">
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
                        <a href="${pageContext.request.contextPath}/admin?action=ambulance" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-ambulance mr-3 text-blue-400"></i> Ambulance
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin?action=salary" class="sidebar-link flex items-center p-3 bg-blue-600 rounded text-white">
                            <i class="fas fa-money-bill-wave mr-3 text-blue-200"></i> Salary
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

            <!-- Paysheets List -->
            <div class="container mx-auto p-8 flex-1">
                <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">View Paysheets</h1>
                <div class="bg-white p-6 rounded-xl shadow-md">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-xl font-semibold text-gray-800">Paysheets List</h2>
                    </div>
                    <!-- Month Filter Dropdown -->
                    <div class="month-filter">
                        <label for="month-filter" class="text-gray-700 font-medium">Filter by Month:</label>
                        <select id="month-filter" class="focus:ring-2 focus:ring-blue-500">
                            <option value="all">All Months</option>
                            <option value="01">January</option>
                            <option value="02">February</option>
                            <option value="03">March</option>
                            <option value="04">April</option>
                            <option value="05">May</option>
                            <option value="06">June</option>
                            <option value="07">July</option>
                            <option value="08">August</option>
                            <option value="09">September</option>
                            <option value="10">October</option>
                            <option value="11">November</option>
                            <option value="12">December</option>
                        </select>
                    </div>
                    <c:if test="${not empty paysheets}">
                        <div class="overflow-x-auto">
                            <table class="w-full table-auto border-collapse paysheets-table">
                                <thead>
                                    <tr class="bg-blue-100 text-gray-700">
                                        <th class="text-left font-semibold">Employee ID</th>
                                        <th class="text-left font-semibold">Employee Name</th>
                                        <th class="text-left font-semibold">Position</th>
                                        <th class="text-left font-semibold">Gross Salary</th>
                                        <th class="text-left font-semibold">Deductions</th>
                                        <th class="text-left font-semibold">Overtime</th>
                                        <th class="text-left font-semibold">Bonus</th>
                                        <th class="text-left font-semibold">Net Pay</th>
                                        <th class="text-left font-semibold">Month</th>
                                        <th class="text-left font-semibold">Year</th>
                                        <th class="text-left font-semibold">Created At</th>
                                    </tr>
                                </thead>
                                <tbody id="paysheet-table-body">
                                    <c:forEach var="paysheet" items="${paysheets}">
                                        <tr class="table-row border-b border-gray-200 bg-white" data-month="${paysheet.month}">
                                            <td class="text-gray-700">${paysheet.employeeId}</td>
                                            <td class="text-gray-700">${paysheet.employeeName}</td>
                                            <td class="text-gray-700">${paysheet.position}</td>
                                            <td class="text-gray-700">${paysheet.grossSalary}</td>
                                            <td class="text-gray-700">${paysheet.deductions}</td>
                                            <td class="text-gray-700">${paysheet.overtime}</td>
                                            <td class="text-gray-700">${paysheet.bonus}</td>
                                            <td class="text-gray-700">${paysheet.netPay}</td>
                                            <td class="text-gray-700">
                                                <c:choose>
                                                    <c:when test="${paysheet.month == '01'}">January</c:when>
                                                    <c:when test="${paysheet.month == '02'}">February</c:when>
                                                    <c:when test="${paysheet.month == '03'}">March</c:when>
                                                    <c:when test="${paysheet.month == '04'}">April</c:when>
                                                    <c:when test="${paysheet.month == '05'}">May</c:when>
                                                    <c:when test="${paysheet.month == '06'}">June</c:when>
                                                    <c:when test="${paysheet.month == '07'}">July</c:when>
                                                    <c:when test="${paysheet.month == '08'}">August</c:when>
                                                    <c:when test="${paysheet.month == '09'}">September</c:when>
                                                    <c:when test="${paysheet.month == '10'}">October</c:when>
                                                    <c:when test="${paysheet.month == '11'}">November</c:when>
                                                    <c:when test="${paysheet.month == '12'}">December</c:when>
                                                    <c:otherwise>${paysheet.month}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-gray-700">${paysheet.year}</td>
                                            <td class="text-gray-700">${paysheet.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                    <c:if test="${empty paysheets}">
                        <p class="text-gray-500 text-center py-6">No paysheets found.</p>
                    </c:if>
                    <div class="mt-6 flex justify-end">
                        <a href="${pageContext.request.contextPath}/admin?action=salary" 
                           class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600 transition-colors">
                            Back to Payroll Management
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

        // Month filter functionality
        document.getElementById('month-filter').addEventListener('change', function() {
            const selectedMonth = this.value;
            const rows = document.querySelectorAll('#paysheet-table-body .table-row');

            rows.forEach(row => {
                const rowMonth = row.getAttribute('data-month');
                if (selectedMonth === 'all' || rowMonth === selectedMonth) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>