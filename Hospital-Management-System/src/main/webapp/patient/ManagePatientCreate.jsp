<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.UUID" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Patient</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/patient/assets/favicon.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { 
            min-height: 100vh; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            background: linear-gradient(135deg, #f0f9ff, #5eead4); 
            position: relative; 
            overflow: hidden;
        }
        /* Background SVG Pattern */
        .bg-pattern {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0.1;
            z-index: 0;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%23134e4a" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12h16M12 4v16M7.5 7.5L16.5 16.5M16.5 7.5L7.5 16.5"/></svg>');
            background-size: 40px 40px;
        }
        .patient-container { 
            background: white; 
            padding: 32px; 
            border-radius: 12px; 
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1); 
            width: 100%; 
            max-width: 400px; 
            z-index: 100; 
            transition: all 0.3s ease;
            position: relative;
        }
        .patient-container:hover {
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #f0fdfa, #ccfbf1);
        }
        .patient-header { 
            text-align: center; 
            margin-bottom: 24px; 
        }
        .patient-header img {
            width: 48px;
            height: 48px;
            margin-bottom: 8px;
        }
        .patient-header h1 { 
            color: #1f2937; 
            font-size: 24px; 
            margin-bottom: 8px; 
        }
        .patient-header p {
            color: #6b7280;
            font-size: 14px;
        }
        .input-group { 
            position: relative; 
            margin-bottom: 20px; 
        }
        .input-group i { 
            position: absolute; 
            left: 12px; 
            top: 50%; 
            transform: translateY(-50%); 
            color: #2dd4bf; 
            font-size: 16px; 
        }
        .input-group input, .input-group select { 
            width: 100%; 
            padding: 12px 12px 12px 40px; 
            border: 1px solid #d1d5db; 
            border-radius: 6px; 
            font-size: 14px; 
            background: #f9fafb; 
            transition: all 0.3s ease; 
        }
        .input-group input:focus, .input-group select:focus { 
            border-color: #2dd4bf; 
            outline: none; 
            box-shadow: 0 0 4px rgba(45, 212, 191, 0.3); 
        }
        .error-message { 
            color: #dc2626; 
            text-align: center; 
            margin-bottom: 16px; 
            font-size: 14px; 
            background: #fef2f2; 
            padding: 8px; 
            border-radius: 6px; 
        }
        .create-btn { 
            width: 100%; 
            padding: 12px; 
            background: linear-gradient(135deg, #134e4a, #2dd4bf); 
            border: none; 
            border-radius: 6px; 
            color: white; 
            font-size: 14px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: transform 0.2s ease, background 0.3s ease; 
        }
        .create-btn:hover { 
            transform: translateY(-2px); 
            background: linear-gradient(135deg, #2dd4bf, #5eead4); 
        }
        .login-link { 
            text-align: center; 
            margin-top: 16px; 
        }
        .login-link a { 
            color: #2dd4bf; 
            text-decoration: none; 
            font-size: 14px; 
            transition: color 0.3s ease; 
        }
        .login-link a:hover { 
            color: #5eead4; 
            text-decoration: underline; 
        }
        .footer { 
            text-align: center; 
            margin-top: 16px; 
            color: #6b7280; 
            font-size: 12px; 
        }
    </style>
</head>
<body>
    <div class="bg-pattern"></div>
    <div class="patient-container">
        <div class="patient-header">
            <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%232dd4bf' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z'/></svg>" alt="Hospital Icon">
            <h1>Create Patient</h1>
            <p>Deegayu Hospitals (Pvt Ltd)</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
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
            <div class="login-link">
                <a href="${pageContext.request.contextPath}/patient/login">Go to Login</a>
            </div>
        <% } %>

        <div class="footer">
            Your Health, Our Priority
        </div>
    </div>
</body>
</html>