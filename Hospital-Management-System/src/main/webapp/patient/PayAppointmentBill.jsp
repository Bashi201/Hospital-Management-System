<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pay Appointment Bill</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/doctor/assets/favicon.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .header-gradient {
            background: linear-gradient(90deg, #134e4a, #2dd4bf);
            position: fixed;
            top: 0;
            left: 256px;
            right: 0;
            z-index: 900;
        }
        .sidebar-link {
            transition: all 0.3s ease;
        }
        .sidebar-link:hover {
            transform: translateX(10px);
            background: linear-gradient(90deg, #2dd4bf, #5eead4);
        }
        .form-container {
            transition: all 0.3s ease;
        }
        .form-container:hover {
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        .profile-img {
            transition: transform 0.3s ease;
        }
        .profile-img:hover {
            transform: scale(1.1);
        }
        .sidebar::-webkit-scrollbar {
            width: 8px;
        }
        .sidebar::-webkit-scrollbar-thumb {
            background: #2dd4bf;
            border-radius: 4px;
        }
        .sidebar::-webkit-scrollbar-track {
            background: #1f2937;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-teal-100 font-sans h-full">
    <div class="flex h-full">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white fixed top-0 left-0 h-screen flex flex-col flex-shrink-0 sidebar">
            <div class="p-6 text-xl font-bold border-b border-gray-800 flex items-center space-x-3">
                <i class="fas fa-hospital text-teal-400"></i>
                <span>Patient Portal</span>
            </div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-teal-400"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient?action=channeling" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-calendar-check mr-3 text-teal-400"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient?action=doctors" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-user-md mr-3 text-teal-400"></i> Doctors
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient?action=rooms" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-bed mr-3 text-teal-400"></i> Rooms
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/patient?action=ambulanceDashboard" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-ambulance mr-3 text-teal-400"></i> Ambulance
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/patient?action=settings" class="sidebar-link flex items-center p-3 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-cog mr-3 text-teal-400"></i> Settings
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col ml-64">
            <!-- Top Navbar -->
            <header class="header-gradient text-white p-4 flex justify-between items-center shadow-lg">
                <span id="datetime" class="text-lg font-medium"></span>
                <div class="flex items-center space-x-4">
                    <div class="relative group">
                        <img src="${pageContext.request.contextPath}/patient_dp.jpeg" alt="Patient Profile" class="w-10 h-10 rounded-full border-2 border-teal-200 shadow-sm cursor-pointer object-cover profile-img">
                        <div class="absolute left-1/2 transform -translate-x-1/2 -top-48 hidden group-hover:flex 
                                    w-40 h-40 border-2 border-teal-300 rounded-full overflow-hidden shadow-xl bg-white p-1 z-50">
                            <img src="${pageContext.request.contextPath}/patient_dp.jpeg" alt="Patient Profile Enlarged" class="w-full h-full object-cover rounded-full">
                        </div>
                    </div>
                    <span class="text-white font-medium">${name != null ? name : "Patient"}</span>
                    <form action="${pageContext.request.contextPath}/patient" method="post">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors">
                            Logout
                        </button>
                    </form>
                </div>
            </header>

            <!-- Payment Form -->
            <div class="container mx-auto p-8 pt-20 flex-1">
                <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">Pay Appointment Bill</h1>

                <c:if test="${not empty errorMessage}">
                    <div class="text-red-500 text-center mb-6 font-medium bg-red-50 p-3 rounded-md">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="text-green-500 text-center mb-6 font-medium bg-green-50 p-3 rounded-md">${successMessage}</div>
                </c:if>

                <c:choose>
                    <c:when test="${empty bill}">
                        <p class="text-gray-600 text-center">No bill found for this appointment.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="form-container bg-white p-8 rounded-xl shadow-md max-w-lg mx-auto">
                            <h2 class="text-2xl font-semibold text-gray-700 mb-6">Bill Details</h2>
                            <div class="mb-4">
                                <p><strong>Bill ID:</strong> ${bill.id}</p>
                                <p><strong>Appointment ID:</strong> ${bill.appointmentId}</p>
                                <p><strong>Appointment Date:</strong> ${bill.checkInDate}</p>
                                <p><strong>Total Amount:</strong> $${bill.totalAmount}</p>
                                <p><strong>Status:</strong> ${bill.paymentStatus}</p>
                            </div>

                            <form action="${pageContext.request.contextPath}/patient" method="post" class="space-y-4">
                                <input type="hidden" name="action" value="processPayment">
                                <input type="hidden" name="billId" value="${bill.id}">
                                <input type="hidden" name="appointmentId" value="${bill.appointmentId}">
                                <div>
                                    <label for="cardNumber" class="block text-gray-700 font-medium">Card Number</label>
                                    <input type="text" id="cardNumber" name="cardNumber" class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-teal-500" placeholder="1234 5678 9012 3456" required>
                                </div>
                                <div class="flex space-x-4">
                                    <div class="w-1/2">
                                        <label for="expiry" class="block text-gray-700 font-medium">Expiry Date</label>
                                        <input type="text" id="expiry" name="expiry" class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-teal-500" placeholder="MM/YY" required>
                                    </div>
                                    <div class="w-1/2">
                                        <label for="cvv" class="block text-gray-700 font-medium">CVV</label>
                                        <input type="text" id="cvv" name="cvv" class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-teal-500" placeholder="123" required>
                                    </div>
                                </div>
                                <button type="submit" class="w-full bg-teal-500 text-white p-2 rounded-md hover:bg-teal-600 transition-colors">
                                    Pay Now
                                </button>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>
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