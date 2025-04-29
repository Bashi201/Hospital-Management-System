<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.UUID" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Patient</title>
     <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/doctor/assets/favicon.png">
    <style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css');
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { min-height: 100vh; display: flex; justify-content: center; align-items: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .patient-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); width: 100%; max-width: 450px; }
        .patient-header { text-align: center; margin-bottom: 30px; }
        .patient-header h1 { color: #333; font-size: 28px; }
        .input-group { position: relative; margin-bottom: 20px; }
        .input-group i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #764ba2; font-size: 18px; }
        .input-group input, .input-group select { width: 100%; padding: 12px 15px 12px 45px; border: 2px solid #eee; border-radius: 8px; font-size: 16px; transition: all 0.3s ease; }
        .input-group input:focus, .input-group select:focus { border-color: #667eea; outline: none; box-shadow: 0 0 5px rgba(102, 126, 234, 0.3); }
        .create-btn { width: 100%; padding: 15px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 8px; color: white; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.2s ease; }
        .create-btn:hover { transform: translateY(-2px); }
        .error { color: #ff4444; font-size: 14px; text-align: center; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="patient-container">
        <div class="patient-header">
            <h1>Create Patient</h1>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <% 
            // Generate a unique ID using UUID with a "P" prefix
            String uniqueId = "P" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        %>

        <form action="${pageContext.request.contextPath}/patient/ManagePatientCreate" method="POST">
            <div class="input-group">
                <i class="fas fa-id-badge"></i>
                <input type="text" id="id" name="id" value="<%= uniqueId %>" placeholder="Patient ID" readonly required>
            </div>
            <div class="input-group">
                <i class="fas fa-phone"></i>
                <input type="text" id="phoneNumber" name="phoneNumber" placeholder="Phone Number" required>
            </div>
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" id="name" name="name" placeholder="Full Name" required>
            </div>
            <div class="input-group">
                <i class="fas fa-venus-mars"></i>
                <select id="gender" name="gender" required>
                    <option value="" disabled selected>Select Gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="input-group">
                <i class="fas fa-clock"></i>
                <input type="datetime-local" id="admittedTime" name="admittedTime" placeholder="Admitted Time" required>
            </div>
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" id="gmail" name="gmail" placeholder="Gmail" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit" class="create-btn">Create Patient</button>
        </form>

        <% if (request.getAttribute("patientExists") != null && (boolean) request.getAttribute("patientExists")) { %>
            <a href="${pageContext.request.contextPath}/patient/login" class="create-btn">Go to Login</a>
        <% } %>
    </div>
</body>
</html>