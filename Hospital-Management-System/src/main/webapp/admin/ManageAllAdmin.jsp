<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Admin Info</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <% 
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
    %>
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen">
            <div class="p-5 text-lg font-bold border-b border-gray-800">All Admin Info</div>
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
        <div class="flex-1 flex flex-col">
            <!-- Top Navbar -->
            <header class="bg-white shadow p-4 flex justify-between items-center">
                <!-- Date and Time Display -->
                <span id="datetime" class="text-xl font-semibold text-gray-800"></span>

				<div class="flex items-center space-x-4 relative">
					<!-- Profile Picture Container -->
					<div class="relative group">
						<img
							src="${picture ? pageContext.request.contextPath + '/uploads/' + picture : 'admin/assets/default.jpg'}"
							alt="${name}"
							class="w-12 h-12 rounded-full border-2 border-gray-300 shadow-sm cursor-pointer object-cover">

						<div
							class="absolute left-1/2 transform -translate-x-1/2 hidden group-hover:flex 
                    w-44 h-44 border-2 border-gray-400 rounded-full overflow-hidden shadow-lg bg-white p-1 z-10">
							<img
								src="${picture ? pageContext.request.contextPath + '/uploads/' + picture : 'path/to/default-image.jpg'}"
								alt="${name}" class="w-full h-full object-cover rounded-full">
						</div>
					</div>

					<!-- Admin Name -->
					<span class="text-gray-700 font-medium">${name}</span>

					<!-- Logout Button -->
					<a href="${pageContext.request.contextPath}/admin?action=logout"
						class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
						Logout </a>
				</div>

			</header>

            <!-- All Employee Info Table -->
            <main class="flex-1 p-6">
                <div class="bg-white p-6 rounded-lg shadow-lg w-full max-w-6xl mx-auto">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">All Admin Details</h2>
                    
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-500">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3">ID</th>
                                    <th scope="col" class="px-6 py-3">Name</th>
                                    <th scope="col" class="px-6 py-3">Email</th>
                                    <th scope="col" class="px-6 py-3">Password</th>
                                    <th scope="col" class="px-6 py-3">Picture</th>
                                    <th scope="col" class="px-6 py-3">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="admin" items="${admins}">
                                    <tr class="bg-white border-b hover:bg-gray-50">
                                        <td class="px-6 py-4">${admin.id}</td>
                                        <td class="px-6 py-4">${admin.name}</td>
                                        <td class="px-6 py-4">${admin.email}</td>
                                        <td class="px-6 py-4">••••••••</td>
                                        <td class="px-6 py-4">
                                            <img src="${pageContext.request.contextPath}/uploads/${admin.filename}" class="rounded-full w-10 h-10" onerror="this.src='https://via.placeholder.com/40';">
                                        </td>
                                        <td class="px-6 py-4 flex space-x-2">
   

    <!-- Delete Form -->
    <form action="${pageContext.request.contextPath}/admin/delete" method="post" onsubmit="return confirmDelete();">
    <input type="hidden" name="id" value="${admin.id}">
    <button type="submit" class="text-red-500 hover:text-red-700">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5-4h4m-4 0a2 2 0 00-2 2h8a2 2 0 00-2-2m-4 0V3"></path>
        </svg>
    </button>
</form>
</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        // Date and Time Update
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
        
        function confirmDelete() {
            let isConfirmed = confirm("Are you sure you want to delete this admin?");
            if (isConfirmed) {
                alert("Form is being submitted!");
            } else {
                alert("Deletion canceled.");
            }
            return isConfirmed;
        }
        
        
</body>
</html>