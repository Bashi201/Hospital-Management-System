<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Details - ${patient.name}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .note-card {
            transition: all 0.3s ease;
        }
        .note-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
         .main-content {
            background:  
                        url('${pageContext.request.contextPath}/doctor/assets/DoctorBGWithoutLogo.png') no-repeat center center/cover;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-purple-50 font-sans">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-900 text-white flex flex-col min-h-screen">
            <div class="p-5 text-lg font-bold border-b border-gray-800 flex items-center space-x-3">
                <i class="fas fa-hospital text-purple-400"></i>
                <span>Doctor Portal</span>
            </div>
            <nav class="flex-1 p-4">
                <ul>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor" class="flex items-center p-2 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-tachometer-alt mr-3 text-purple-400"></i> Dashboard
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor?action=appointments" class="flex items-center p-2 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-calendar-check mr-3 text-purple-400"></i> Appointments
                        </a>
                    </li>
                    <li class="mb-4">
                        <a href="${pageContext.request.contextPath}/doctor?action=patients" class="flex items-center p-2 bg-purple-600 rounded text-white">
                            <i class="fas fa-users mr-3 text-purple-200"></i> Patients
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/doctor?action=rooms" class="flex items-center p-2 hover:bg-gray-700 rounded text-white">
                            <i class="fas fa-bed mr-3 text-purple-400"></i> Room Assignments
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col main-content">
            <!-- Top Navbar -->
            <header class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white p-4 flex justify-between items-center shadow-lg">
                <span id="datetime" class="text-lg font-medium"></span>
                <div class="flex items-center space-x-4 relative">
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

            <!-- Patient Details Content -->
            <div class="container mx-auto p-6 flex-1">
                <div class="flex items-center mb-6">
                    <a href="${pageContext.request.contextPath}/doctor?action=patients" class="text-purple-600 hover:text-purple-800 mr-4">
                        <i class="fas fa-arrow-left text-2xl"></i>
                    </a>
                    <h1 class="text-3xl font-bold text-gray-800">Patient: ${patient.name}</h1>
                </div>

                <!-- Success/Error Message -->
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${successMessage}</p>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${errorMessage}</p>
                    </div>
                </c:if>

                <!-- Patient Information -->
                <div class="bg-white p-6 rounded-xl shadow-md mb-6">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Patient Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <p class="text-gray-600 mb-2"><strong>ID:</strong> ${patient.id}</p>
                            <p class="text-gray-600 mb-2"><strong>Name:</strong> ${patient.name}</p>
                            <p class="text-gray-600 mb-2"><strong>Gender:</strong> ${patient.gender}</p>
                        </div>
                        <div>
                            <p class="text-gray-600 mb-2"><strong>Phone:</strong> ${patient.phoneNumber}</p>
                            <p class="text-gray-600 mb-2"><strong>Email:</strong> ${patient.gmail}</p>
                            <p class="text-gray-600 mb-2"><strong>Admitted Time:</strong> ${patient.admittedTime}</p>
                        </div>
                    </div>
                </div>

                <!-- Add Note Section -->
                <div class="bg-white p-6 rounded-xl shadow-md mb-6">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Add New Note</h2>
                    <form action="${pageContext.request.contextPath}/doctor?action=addNote" method="POST">
                        <input type="hidden" name="patientId" value="${patient.id}">
                        <div class="mb-4">
                            <textarea name="noteText" rows="4" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500" placeholder="Enter your notes here..." required></textarea>
                        </div>
                        <button type="submit" class="bg-purple-600 text-white px-4 py-2 rounded-lg hover:bg-purple-700 transition-colors">
                            <i class="fas fa-plus mr-2"></i> Add Note
                        </button>
                    </form>
                </div>

                <!-- Notes Section -->
                <div class="bg-white p-6 rounded-xl shadow-md">
                    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Patient Notes</h2>
                    <c:if test="${empty notes}">
                        <p class="text-gray-500">No notes available for this patient.</p>
                    </c:if>
                    <c:forEach var="note" items="${notes}">
                        <div class="note-card border border-gray-200 p-4 rounded-lg mb-4">
                            <div class="flex justify-between items-center mb-2">
                                <p class="text-sm text-gray-500">Created: ${note.createdAt} | Updated: ${note.updatedAt}</p>
                                <button onclick="editNote(${note.id}, '${note.noteText}')" class="text-blue-600 hover:text-blue-800">
                                    <i class="fas fa-edit mr-1"></i> Edit
                                </button>
                            </div>
                            <p class="text-gray-700">${note.noteText}</p>
                        </div>
                    </c:forEach>
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

        function editNote(noteId, noteText) {
            const newText = prompt("Edit Note:", noteText);
            if (newText !== null && newText.trim() !== "") {
                const form = document.createElement("form");
                form.method = "POST";
                form.action = "${pageContext.request.contextPath}/doctor?action=updateNote";
                
                const noteIdInput = document.createElement("input");
                noteIdInput.type = "hidden";
                noteIdInput.name = "noteId";
                noteIdInput.value = noteId;
                form.appendChild(noteIdInput);

                const patientIdInput = document.createElement("input");
                patientIdInput.type = "hidden";
                patientIdInput.name = "patientId";
                patientIdInput.value = "${patient.id}";
                form.appendChild(patientIdInput);

                const noteTextInput = document.createElement("input");
                noteTextInput.type = "hidden";
                noteTextInput.name = "noteText";
                noteTextInput.value = newText;
                form.appendChild(noteTextInput);

                document.body.appendChild(form);
                form.submit();
            }
        }

        updateDateTime();
        setInterval(updateDateTime, 1000);
    </script>
</body>
</html>