<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html class="h-full">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Nurses</title>
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
            height: 64px;
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

        /* Input Group Styling */
        .input-group {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .input-group i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #3b82f6;
            font-size: 16px;
        }
        .input-group input,
        .input-group select {
            padding-left: 40px;
            width: 100%;
            background: #f9fafb;
            transition: all 0.3s ease;
        }
        .input-group input:focus,
        .input-group select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 4px rgba(59, 130, 246, 0.3);
        }

        /* Modal Styling */
        .modal {
            display: none;
            visibility: hidden;
            opacity: 0;
            transition: all 0.3s ease;
            pointer-events: none;
        }
        .modal.active {
            display: flex;
            visibility: visible;
            opacity: 1;
            transform: scale(1);
            pointer-events: auto;
            z-index: 50;
        }
        .modal-content {
            max-height: 80vh;
            overflow-y: auto;
            pointer-events: auto;
        }
        .modal-content::-webkit-scrollbar {
            width: 6px;
        }
        .modal-content::-webkit-scrollbar-thumb {
            background: #3b82f6;
            border-radius: 3px;
        }
        .modal-content::-webkit-scrollbar-track {
            background: #f1f5f9;
        }

        /* Plus Button */
        .plus-button {
            transition: all 0.3s ease;
            z-index: 20;
            pointer-events: auto;
            cursor: pointer;
        }
        .plus-button:hover {
            background: #60a5fa;
            transform: scale(1.1);
        }
        .plus-button:hover .tooltip {
            visibility: visible;
            opacity: 1;
        }
        .tooltip {
            visibility: hidden;
            opacity: 0;
            transition: all 0.3s ease;
            position: absolute;
            bottom: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: #3b82f6;
            color: white;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 14px;
            white-space: nowrap;
            margin-bottom: 8px;
        }

        /* Table Styling */
        .nurse-table {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            z-index: 10;
        }
        .nurse-table thead {
            position: sticky;
            top: 0;
            z-index: 15;
            background: linear-gradient(90deg, #1e3a8a, #3b82f6);
            color: white;
        }
        .nurse-table th {
            padding: 16px;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 1px;
        }
        .nurse-table tbody tr {
            transition: all 0.3s ease;
        }
        .nurse-table tbody tr:nth-child(odd) {
            background: #f9fafb;
        }
        .nurse-table tbody tr:nth-child(even) {
            background: #ffffff;
        }
        .nurse-table tbody tr:hover {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            transform: scale(1.01);
        }
        .nurse-table td {
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
        .delete-button, .assign-button, .remove-room-button, .submit-button, .close-button {
            pointer-events: auto;
            z-index: 20;
            cursor: pointer;
        }
        .main-content {
            position: relative;
            padding-top: 80px;
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
                            <i class="fas fa-bed mr-3 text-blue-400"></i> Manage Rooms
                        </a>
                    </li>
                    <li class="mb-3">
                        <a href="${pageContext.request.contextPath}/admin?action=nurses" class="sidebar-link flex items-center p-3 bg-blue-600 rounded text-white">
                            <i class="fas fa-user-nurse mr-3 text-blue-200"></i> Manage Nurses
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

            <!-- Nurse Management -->
            <div class="container mx-auto p-8 flex-1">
                <div class="mb-8 text-center">
                    <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2'/><circle cx='9' cy='7' r='4'/><path d='M23 21v-2a4 4 0 0 0-3-3.87'/><path d='M16 3.13a4 4 0 0 1 0 7.75'/></svg>" alt="Nurse Icon" class="w-12 h-12 mx-auto mb-2">
                    <h2 class="text-2xl font-semibold text-gray-800">Manage Nurses</h2>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="text-red-500 text-center mb-6 font-medium bg-red-50 p-3 rounded-md max-w-7xl mx-auto">${errorMessage}</div>
                </c:if>

                <!-- Instruction for Plus Button -->
                <div class="text-center mb-6 max-w-7xl mx-auto">
                    <p class="text-gray-600 bg-blue-50 p-3 rounded-md text-sm font-medium">Use the + button to create a new nurse, 'Assign Room' to assign a nurse to a booked room, or 'Remove Room' to unassign a nurse from their room.</p>
                </div>

                <!-- Nurse List (Table Layout) -->
                <div class="table-container max-w-7xl mx-auto">
                    <table class="nurse-table min-w-full">
                        <thead>
                            <tr>
                                <th class="text-left">Nurse ID</th>
                                <th class="text-left">Name</th>
                                <th class="text-left">Email</th>
                                <th class="text-left">Phone</th>
                                <th class="text-left">Shift</th>
                                <th class="text-left">Assigned Room</th>
                                <th class="text-left">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="nurse" items="${nurses}">
                                <tr>
                                    <td class="text-sm text-gray-900">${nurse.id}</td>
                                    <td class="text-sm text-gray-900">${nurse.name}</td>
                                    <td class="text-sm text-gray-900">${nurse.email}</td>
                                    <td class="text-sm text-gray-900">${nurse.phone}</td>
                                    <td class="text-sm text-gray-900">${nurse.shift}</td>
                                    <td class="text-sm text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty nurse.assignedRoomId}">
                                                ${nurse.assignedRoomId}
                                            </c:when>
                                            <c:otherwise>
                                                None
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty rooms}">
                                            <button class="assign-button inline-flex items-center px-3 py-1 bg-green-600 text-white text-sm font-medium rounded-md hover:bg-green-700 transition-colors"
                                                    onclick="openAssignModal('${nurse.id}', '${nurse.name}')">
                                                <i class="fas fa-bed mr-2"></i> Assign Room
                                            </button>
                                        </c:if>
                                        <c:if test="${not empty nurse.assignedRoomId}">
                                            <a href="${pageContext.request.contextPath}/admin?action=removeNurseRoom&nurseId=${nurse.id}"
                                               class="remove-room-button inline-flex items-center px-3 py-1 bg-yellow-600 text-white text-sm font-medium rounded-md hover:bg-yellow-700 transition-colors ml-2"
                                               onclick="return confirm('Are you sure you want to remove nurse ${nurse.id} from room ${nurse.assignedRoomId}?');">
                                                <i class="fas fa-times-circle mr-2"></i> Remove Room
                                            </a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/admin?action=deleteNurse&id=${nurse.id}"
                                           class="delete-button inline-flex items-center px-3 py-1 bg-red-600 text-white text-sm font-medium rounded-md hover:bg-red-700 transition-colors ml-2"
                                           onclick="return confirm('Are you sure you want to delete nurse ${nurse.id}?');">
                                            <i class="fas fa-trash mr-2"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty rooms}">
                    <div class="text-yellow-600 text-center mt-6 font-medium bg-yellow-50 p-3 rounded-md max-w-7xl mx-auto">
                        No booked rooms are currently available for nurse assignment.
                    </div>
                </c:if>

                <!-- Plus Button -->
                <div class="relative">
                    <button id="toggleForm" class="plus-button fixed bottom-8 right-8 bg-blue-600 text-white w-16 h-16 rounded-full flex items-center justify-center shadow-lg hover:bg-blue-700">
                        <i class="fas fa-plus text-2xl"></i>
                        <span class="tooltip">Click to add a new nurse</span>
                    </button>
                </div>

                <!-- Modal Form for Creating Nurse -->
                <div id="formModal" class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                    <div class="modal-content bg-white p-8 rounded-xl shadow-2xl max-w-lg w-full">
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-xl font-semibold text-gray-800">Create New Nurse</h3>
                            <button id="closeForm" class="close-button text-gray-500 hover:text-gray-700">
                                <i class="fas fa-times text-xl"></i>
                            </button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin" method="post" enctype="multipart/form-data" class="space-y-6">
                            <input type="hidden" name="action" value="createNurse">
                            <div class="input-group">
                                <i class="fas fa-id-badge"></i>
                                <input type="text" id="id" name="id" placeholder="Nurse ID (e.g., N101)" required
                                       class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>
                            <div class="input-group">
                                <i class="fas fa-user"></i>
                                <input type="text" id="name" name="name" placeholder="Name" required
                                       class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>
                            <div class="input-group">
                                <i class="fas fa-envelope"></i>
                                <input type="email" id="email" name="email" placeholder="Email" required
                                       class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>
                            <div class="input-group">
                                <i class="fas fa-phone"></i>
                                <input type="text" id="phone" name="phone" placeholder="Phone" required
                                       class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>
                            <div class="input-group">
                                <i class="fas fa-clock"></i>
                                <select id="shift" name="shift" required
                                        class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                    <option value="Day">Day</option>
                                    <option value="Night">Night</option>
                                    <option value="Evening">Evening</option>
                                </select>
                            </div>
                            <div class="input-group">
                                <i class="fas fa-image"></i>
                                <input type="file" id="filename" name="filename" accept="image/*"
                                       class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                            </div>
                            <div class="text-center">
                                <button type="submit" class="submit-button w-full bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition-colors">
                                    Create Nurse
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal Form for Assigning Room -->
                <div id="assignRoomModal" class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                    <div class="modal-content bg-white p-8 rounded-xl shadow-2xl max-w-lg w-full">
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-xl font-semibold text-gray-800">Assign Room to Nurse</h3>
                            <button id="closeAssignRoom" class="close-button text-gray-500 hover:text-gray-700">
                                <i class="fas fa-times text-xl"></i>
                            </button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin" method="post" class="space-y-6">
                            <input type="hidden" name="action" value="assignNurseRoom">
                            <input type="hidden" id="assignNurseId" name="nurseId">
                            <div class="input-group">
                                <i class="fas fa-user"></i>
                                <input type="text" id="assignNurseName" name="nurseName" readonly
                                       class="w-full p-3 border border-gray-300 rounded-md bg-gray-100">
                            </div>
                            <div class="input-group">
                                <i class="fas fa-bed"></i>
                                <select id="roomId" name="roomId" required
                                        class="w-full p-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                                    <option value="">Select Booked Room</option>
                                    <c:forEach var="room" items="${rooms}">
                                        <option value="${room.id}">${room.id} - ${room.type} (Booked)</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="text-center">
                                <button type="submit" class="submit-button w-full bg-blue-600 text-white px-6 py-3 rounded-md hover:bg-blue-700 transition-colors">
                                    Assign Room
                                </button>
                            </div>
                        </form>
                    </div>
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

        // Toggle Create Nurse Modal
        const toggleButton = document.getElementById('toggleForm');
        const formModal = document.getElementById('formModal');
        const closeFormButton = document.getElementById('closeForm');
        const createModalContent = document.querySelector('#formModal .modal-content');

        toggleButton.addEventListener('click', (e) => {
            e.stopPropagation();
            formModal.classList.toggle('active');
        });

        closeFormButton.addEventListener('click', (e) => {
            e.stopPropagation();
            formModal.classList.remove('active');
        });

        formModal.addEventListener('click', (e) => {
            if (e.target === formModal) {
                formModal.classList.remove('active');
            }
        });

        createModalContent.addEventListener('click', (e) => {
            e.stopPropagation();
        });

        // Toggle Assign Room Modal
        const assignRoomModal = document.getElementById('assignRoomModal');
        const closeAssignRoomButton = document.getElementById('closeAssignRoom');
        const assignModalContent = document.querySelector('#assignRoomModal .modal-content');

        function openAssignModal(nurseId, nurseName) {
            document.getElementById('assignNurseId').value = nurseId;
            document.getElementById('assignNurseName').value = nurseName;
            assignRoomModal.classList.add('active');
        }

        closeAssignRoomButton.addEventListener('click', (e) => {
            e.stopPropagation();
            assignRoomModal.classList.remove('active');
        });

        assignRoomModal.addEventListener('click', (e) => {
            if (e.target === assignRoomModal) {
                assignRoomModal.classList.remove('active');
            }
        });

        assignModalContent.addEventListener('click', (e) => {
            e.stopPropagation();
        });
    </script>
</body>
</html>