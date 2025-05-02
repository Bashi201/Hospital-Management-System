<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meal Order System</title>
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

        /* Sidebar Styling */
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

        /* Card Hover Effect */
        .meal-card {
            transition: all 0.3s ease;
        }
        .meal-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        /* Input Spinner Styling */
        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button {
            opacity: 1;
        }

        /* Background */
        .main-content {
            background: url('${pageContext.request.contextPath}/doctor/assets/DoctorBGWithoutLogo.png') no-repeat center center/cover;
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
                        <a href="${pageContext.request.contextPath}/doctor" class="flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-purple-400"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/doctor?action=appointments" class="flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-calendar-check mr-3 text-purple-400"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/doctor?action=patients" class="flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-users mr-3 text-purple-400"></i> Patients
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/doctor?action=salary" class="flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-money-bill-wave mr-3 text-purple-400"></i> Salary
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor?action=settings" class="flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-cog mr-3 text-purple-400"></i> Settings
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
                        <img src="doctor_dp.jpeg" alt="Doctor Profile" class="w-10 h-10 rounded-full border-2 border-purple-200 shadow-sm cursor-pointer object-cover">
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

            <!-- Meal Order System -->
            <div class="container mx-auto p-8 pt-20 flex-1">
                <h1 class="text-4xl font-bold text-gray-800 mb-8 text-center">Meal Order System</h1>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded">
                        <p>${successMessage}</p>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded">
                        <p>${errorMessage}</p>
                    </div>
                </c:if>

                <!-- Meal Order Form -->
                <div class="bg-white p-6 rounded-xl shadow-lg">
                    <form action="${pageContext.request.contextPath}/doctor" method="post">
                        <input type="hidden" name="action" value="placeMealOrder">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <!-- Sample Meal Items (Hardcoded for simplicity) -->
                            <div class="meal-card bg-gray-50 p-4 rounded-lg shadow">
                                <h3 class="text-xl font-semibold text-gray-800">Grilled Chicken Salad</h3>
                                <p class="text-gray-600 mt-2">Fresh greens with grilled chicken, avocado, and vinaigrette.</p>
                                <p class="text-purple-600 font-medium mt-2">$10.00</p>
                                <div class="mt-4">
                                    <label for="chickenSalad" class="text-gray-700">Quantity:</label>
                                    <input type="number" id="chickenSalad" name="chickenSalad" min="0" max="10" value="0" 
                                           class="w-20 p-2 border rounded focus:outline-none focus:ring-2 focus:ring-purple-600">
                                </div>
                            </div>
                            <div class="meal-card bg-gray-50 p-4 rounded-lg shadow">
                                <h3 class="text-xl font-semibold text-gray-800">Vegetarian Pasta</h3>
                                <p class="text-gray-600 mt-2">Whole wheat pasta with seasonal vegetables and marinara sauce.</p>
                                <p class="text-purple-600 font-medium mt-2">$8.50</p>
                                <div class="mt-4">
                                    <label for="vegPasta" class="text-gray-700">Quantity:</label>
                                    <input type="number" id="vegPasta" name="vegPasta" min="0" max="10" value="0" 
                                           class="w-20 p-2 border rounded focus:outline-none focus:ring-2 focus:ring-purple-600">
                                </div>
                            </div>
                            <div class="meal-card bg-gray-50 p-4 rounded-lg shadow">
                                <h3 class="text-xl font-semibold text-gray-800">Beef Stir-Fry</h3>
                                <p class="text-gray-600 mt-2">Tender beef with mixed vegetables in a savory sauce.</p>
                                <p class="text-purple-600 font-medium mt-2">$12.00</p>
                                <div class="mt-4">
                                    <label for="beefStirFry" class="text-gray-700">Quantity:</label>
                                    <input type="number" id="beefStirFry" name="beefStirFry" min="0" max="10" value="0" 
                                           class="w-20 p-2 border rounded focus:outline-none focus:ring-2 focus:ring-purple-600">
                                </div>
                            </div>
                        </div>
                        <div class="mt-8 flex justify-center">
                            <button type="submit" 
                                    class="bg-purple-600 text-white px-6 py-3 rounded-lg hover:bg-purple-700 transition-colors">
                                Place Order
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Order History -->
                <div class="mt-12">
                    <h2 class="text-2xl font-bold text-gray-800 mb-4">Order History</h2>
                    <div class="bg-white p-6 rounded-xl shadow-lg">
                        <c:if test="${empty mealOrders}">
                            <p class="text-gray-600">No orders placed yet.</p>
                        </c:if>
                        <c:if test="${not empty mealOrders}">
                            <table class="w-full text-left">
                                <thead>
                                    <tr class="border-b">
                                        <th class="py-3 text-gray-700">Order ID</th>
                                        <th class="py-3 text-gray-700">Items</th>
                                        <th class="py-3 text-gray-700">Total Cost</th>
                                        <th class="py-3 text-gray-700">Ordered At</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${mealOrders}">
                                        <tr class="border-b">
                                            <td class="py-3">${order.id}</td>
                                            <td class="py-3">${order.items}</td>
                                            <td class="py-3">$${order.totalCost}</td>
                                            <td class="py-3">${order.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
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