<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payroll Management</title>
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

        /* Sidebar Hover Effect */
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #3b82f6, #60a5fa);
        }

        /* Table Styling */
        .payroll-table {
            border-collapse: collapse;
            width: 100%;
        }
        .payroll-table th, .payroll-table td {
            border: 1px solid #d1d5db;
            padding: 8px;
            text-align: left;
        }
        .payroll-table th {
            background-color: #eff6ff;
            font-weight: 600;
        }
        .payroll-table tr:nth-child(even) {
            background-color: #f9fafb;
        }
        .payroll-table input {
            width: 100%;
            border: none;
            outline: none;
            padding: 4px;
            background: transparent;
        }
        .payroll-table .total-row {
            background-color: #dbeafe;
            font-weight: bold;
        }

        /* User-Friendly Buttons */
        .action-button {
            background: #3b82f6;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        .action-button:hover {
            background: #1e3a8a;
        }

        /* Search Bar Styling */
        .search-bar {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }
        .search-bar input {
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 8px;
            width: 300px;
        }
        .search-bar input:focus {
            outline: none;
            ring: 2px;
            ring-blue-500;
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

        /* Month and Year Picker */
        .month-year-picker {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .month-year-picker select,
        .month-year-picker input {
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 8px;
            background: white;
            cursor: pointer;
        }
        .month-year-picker select:focus,
        .month-year-picker input:focus {
            outline: none;
            ring: 2px;
            ring-blue-500;
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
        <div class="flex-1 flex flex-col">
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

            <!-- Payroll Management Section -->
            <div class="container mx-auto p-8 flex-1">
                <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">Payroll Management System</h1>
                <div class="max-w-6xl mx-auto">
                    <!-- User-Friendly Buttons for Employee, Deductions, Paysheets -->
                    <div class="flex space-x-4 mb-6">
                        <a href="${pageContext.request.contextPath}/admin?action=manageEmployees" class="action-button">
                            <i class="fas fa-users"></i> Manage Employees
                        </a>
                        <a href="${pageContext.request.contextPath}/admin?action=manageDeductions" class="action-button">
                            <i class="fas fa-minus-circle"></i> Manage Deductions
                        </a>
                        <a href="${pageContext.request.contextPath}/admin?action=viewPaysheets" class="action-button">
                            <i class="fas fa-money-bill-wave"></i> View Paysheets
                        </a>
                    </div>

                    <!-- Pay Month with Month and Year Picker -->
                    <div class="flex items-center space-x-4 mb-6">
                        <div class="flex-1">
                            <label class="block text-gray-700 font-medium mb-1">Pay month</label>
                            <div class="month-year-picker">
                                <select id="month-picker" name="month" class="flex-1">
                                    <option value="01">January</option>
                                    <option value="02">February</option>
                                    <option value="03" selected>March</option>
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
                                <input type="number" id="year-picker" name="year" class="w-24" value="2025" min="2000" max="2099">
                            </div>
                        </div>
                    </div>

                    <!-- Search Bar -->
                    <div class="search-bar">
                        <input type="text" id="search-input" placeholder="Search by ID or Name..." class="focus:ring-2 focus:ring-blue-500">
                    </div>

                    <!-- Payroll Table -->
                    <div class="overflow-x-auto">
                        <form id="payroll-form" action="${pageContext.request.contextPath}/admin" method="post">
                            <input type="hidden" name="action" value="savePayroll">
                            <input type="hidden" id="month-input" name="month" value="">
                            <table class="payroll-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Position</th>
                                        <th>Gross Salary</th>
                                        <th>Deductions</th>
                                        <th>Overtime</th>
                                        <th>Bonus</th>
                                        <th>Net Pay</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="payroll-table-body">
                                    <!-- Admins -->
                                    <c:forEach var="admin" items="${admins}">
                                        <tr class="payroll-row">
                                            <td>
                                                <input type="text" name="employeeIds" class="id" value="${admin.id}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="employeeNames" class="name" value="${admin.name}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="positions" value="Admin" readonly>
                                            </td>
                                            <td>
                                                <input type="number" name="grossSalaries" class="gross-salary" placeholder="Gross Salary" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="deductions" class="deductions" placeholder="Deductions" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="overtimes" class="overtime" placeholder="Overtime" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="bonuses" class="bonus" placeholder="Bonus" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="netPays" class="net-pay" placeholder="Net Pay" step="0.01" readonly>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="text-blue-500 hover:text-blue-700 remove-row">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <!-- Doctors -->
                                    <c:forEach var="doctor" items="${doctors}">
                                        <tr class="payroll-row">
                                            <td>
                                                <input type="text" name="employeeIds" class="id" value="${doctor.id}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="employeeNames" class="name" value="${doctor.name}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="positions" value="Doctor" readonly>
                                            </td>
                                            <td>
                                                <input type="number" name="grossSalaries" class="gross-salary" placeholder="Gross Salary" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="deductions" class="deductions" placeholder="Deductions" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="overtimes" class="overtime" placeholder="Overtime" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="bonuses" class="bonus" placeholder="Bonus" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="netPays" class="net-pay" placeholder="Net Pay" step="0.01" readonly>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="text-blue-500 hover:text-blue-700 remove-row">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <!-- Nurses -->
                                    <c:forEach var="nurse" items="${nurses}">
                                        <tr class="payroll-row">
                                            <td>
                                                <input type="text" name="employeeIds" class="id" value="${nurse.id}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="employeeNames" class="name" value="${nurse.name}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="positions" value="Nurse" readonly>
                                            </td>
                                            <td>
                                                <input type="number" name="grossSalaries" class="gross-salary" placeholder="Gross Salary" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="deductions" class="deductions" placeholder="Deductions" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="overtimes" class="overtime" placeholder="Overtime" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="bonuses" class="bonus" placeholder="Bonus" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="netPays" class="net-pay" placeholder="Net Pay" step="0.01" readonly>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="text-blue-500 hover:text-blue-700 remove-row">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <!-- Drivers -->
                                    <c:forEach var="driver" items="${drivers}">
                                        <tr class="payroll-row">
                                            <td>
                                                <input type="text" name="employeeIds" class="id" value="${driver.driverId}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="employeeNames" class="name" value="${driver.name}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" name="positions" value="Driver" readonly>
                                            </td>
                                            <td>
                                                <input type="number" name="grossSalaries" class="gross-salary" placeholder="Gross Salary" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="deductions" class="deductions" placeholder="Deductions" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="overtimes" class="overtime" placeholder="Overtime" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="bonuses" class="bonus" placeholder="Bonus" step="0.01">
                                            </td>
                                            <td>
                                                <input type="number" name="netPays" class="net-pay" placeholder="Net Pay" step="0.01" readonly>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="text-blue-500 hover:text-blue-700 remove-row">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <!-- Total Row -->
                                    <tr class="total-row">
                                        <td colspan="3" class="text-center">Total</td>
                                        <td id="total-gross-salary">0.00</td>
                                        <td id="total-deductions">0.00</td>
                                        <td id="total-overtime">0.00</td>
                                        <td id="total-bonus">0.00</td>
                                        <td id="total-net-pay">0.00</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                            <!-- Save and Clear Buttons -->
                            <div class="flex space-x-4 mt-6">
                                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">Save</button>
                                <button type="button" id="clear-button" class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors">Clear</button>
                            </div>
                        </form>
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
                month: 'long', 
                day: 'numeric', 
                year: 'numeric',
                hour: 'numeric',
                minute: '2-digit',
                second: '2-digit',
                hour12: true
            };
            const formattedDateTime = now.toLocaleString('en-US', options).replace(',', ' at');
            document.getElementById('datetime').textContent = formattedDateTime;
        }
        updateDateTime();
        setInterval(updateDateTime, 1000);

        // Function to calculate net pay for a row
        function calculateNetPay(row) {
            const grossSalary = parseFloat(row.querySelector('.gross-salary').value) || 0;
            const deductions = parseFloat(row.querySelector('.deductions').value) || 0;
            const overtime = parseFloat(row.querySelector('.overtime').value) || 0;
            const bonus = parseFloat(row.querySelector('.bonus').value) || 0;
            const netPay = grossSalary - deductions + overtime + bonus;
            row.querySelector('.net-pay').value = netPay.toFixed(2);
            return netPay;
        }

        // Function to calculate totals
        function calculateTotals() {
            let totalGrossSalary = 0, totalDeductions = 0, totalOvertime = 0, totalBonus = 0, totalNetPay = 0;

            document.querySelectorAll('.payroll-row').forEach(row => {
                if (row.style.display !== 'none') {
                    totalGrossSalary += parseFloat(row.querySelector('.gross-salary').value) || 0;
                    totalDeductions += parseFloat(row.querySelector('.deductions').value) || 0;
                    totalOvertime += parseFloat(row.querySelector('.overtime').value) || 0;
                    totalBonus += parseFloat(row.querySelector('.bonus').value) || 0;
                    totalNetPay += parseFloat(row.querySelector('.net-pay').value) || 0;
                }
            });

            document.getElementById('total-gross-salary').textContent = totalGrossSalary.toFixed(2);
            document.getElementById('total-deductions').textContent = totalDeductions.toFixed(2);
            document.getElementById('total-overtime').textContent = totalOvertime.toFixed(2);
            document.getElementById('total-bonus').textContent = totalBonus.toFixed(2);
            document.getElementById('total-net-pay').textContent = totalNetPay.toFixed(2);
        }

        // Search functionality
        document.getElementById('search-input').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.payroll-row');

            rows.forEach(row => {
                const id = row.querySelector('.id').value.toLowerCase();
                const name = row.querySelector('.name').value.toLowerCase();
                if (id.includes(searchTerm) || name.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });

            calculateTotals();
        });

        // Add event listeners to inputs for real-time updates
        document.querySelectorAll('.gross-salary, .deductions, .overtime, .bonus').forEach(input => {
            input.addEventListener('input', function() {
                const row = this.closest('tr');
                calculateNetPay(row);
                calculateTotals();
            });
        });

        // Remove row functionality
        document.querySelectorAll('.remove-row').forEach(button => {
            button.addEventListener('click', function() {
                const row = this.closest('tr');
                row.remove();
                calculateTotals();
            });
        });

        // Clear button functionality
        document.getElementById('clear-button').addEventListener('click', function() {
            document.querySelectorAll('.gross-salary, .deductions, .overtime, .bonus, .net-pay').forEach(input => {
                input.value = '';
            });
            calculateTotals();
        });

        // Set the month value before form submission
        document.getElementById('payroll-form').addEventListener('submit', function() {
            const month = document.getElementById('year-picker').value + '-' + document.getElementById('month-picker').value;
            document.getElementById('month-input').value = month;
        });

        // Initial calculation
        calculateTotals();
    </script>
</body>
</html>