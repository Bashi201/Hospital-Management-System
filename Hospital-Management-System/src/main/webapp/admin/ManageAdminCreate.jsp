<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { 
            min-height: 100vh; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            background: linear-gradient(135deg, #f3f4f6, #e0f2fe); 
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
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="%231e3a8a" stroke-width="1" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12h16M12 4v16M7.5 7.5L16.5 16.5M16.5 7.5L7.5 16.5"/></svg>');
            background-size: 40px 40px;
        }
        .admin-container { 
            background: white; 
            padding: 32px; 
            border-radius: 12px; 
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1); 
            width: 100%; 
            max-width: 450px; 
            z-index: 1; 
            transition: all 0.3s ease;
        }
        .admin-container:hover {
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
        }
        .admin-header { 
            text-align: center; 
            margin-bottom: 24px; 
        }
        .admin-header img {
            width: 48px;
            height: 48px;
            margin-bottom: 8px;
        }
        .admin-header h1 { 
            color: #1f2937; 
            font-size: 24px; 
            margin-bottom: 8px; 
        }
        .admin-header p {
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
            color: #3b82f6; 
            font-size: 16px; 
        }
        .input-group input { 
            width: 100%; 
            padding: 12px 12px 12px 40px; 
            border: 1px solid #d1d5db; 
            border-radius: 6px; 
            font-size: 14px; 
            background: #f9fafb; 
            transition: all 0.3s ease; 
        }
        .input-group input[type="file"] {
            padding: 12px 12px 12px 40px;
            line-height: 1.5;
        }
        .input-group input:focus { 
            border-color: #3b82f6; 
            outline: none; 
            box-shadow: 0 0 4px rgba(59, 130, 246, 0.3); 
        }
        .error { 
            color: #dc2626; 
            font-size: 14px; 
            text-align: center; 
            margin-bottom: 16px; 
            background: #fef2f2; 
            padding: 8px; 
            border-radius: 6px; 
        }
        .create-btn { 
            width: 100%; 
            padding: 12px; 
            background: linear-gradient(135deg, #1e3a8a, #3b82f6); 
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
            background: linear-gradient(135deg, #3b82f6, #60a5fa); 
        }
        .login-link { 
            text-align: center; 
            margin-top: 16px; 
        }
        .login-link a { 
            color: #3b82f6; 
            text-decoration: none; 
            font-size: 14px; 
            transition: color 0.3s ease; 
        }
        .login-link a:hover { 
            color: #60a5fa; 
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
    <div class="admin-container">
        <div class="admin-header">
            <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z'/></svg>" alt="Admin Icon">
            <h1>Create Admin</h1>
            <p>Register a new admin account</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/admin/ManageAdminCreate" method="POST" enctype="multipart/form-data">
            <div class="input-group">
                <i class="fas fa-id-badge"></i>
                <input type="text" id="id" name="id" placeholder="Admin ID" required>
            </div>
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" id="name" name="name" placeholder="Full Name" required>
            </div>
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" id="email" name="email" placeholder="Email" required>
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Password" required>
            </div>
            <div class="input-group">
                <i class="fas fa-image"></i>
                <input type="file" id="profilePic" name="profilePic" accept="image/*">
            </div>
            <button type="submit" class="create-btn">Create Admin</button>
        </form>

        <% if (request.getAttribute("adminExists") != null && (boolean) request.getAttribute("adminExists")) { %>
            <div class="login-link">
                <a href="${pageContext.request.contextPath}/admin/login" class="create-btn">Go to Login</a>
            </div>
        <% } %>
        
        <div class="footer">
            Administering Care, Ensuring Excellence
        </div>
    </div>
</body>
</html>