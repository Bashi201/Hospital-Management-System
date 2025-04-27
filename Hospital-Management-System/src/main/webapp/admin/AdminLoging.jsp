<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
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
        .login-container { 
            background: white; 
            padding: 32px; 
            border-radius: 12px; 
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1); 
            width: 100%; 
            max-width: 400px; 
            z-index: 1; 
            transition: all 0.3s ease;
        }
        .login-container:hover {
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
        }
        .login-header { 
            text-align: center; 
            margin-bottom: 24px; 
        }
        .login-header img {
            width: 48px;
            height: 48px;
            margin-bottom: 8px;
        }
        .login-header h1 { 
            color: #1f2937; 
            font-size: 24px; 
            margin-bottom: 8px; 
        }
        .login-header p {
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
        .input-group input:focus { 
            border-color: #3b82f6; 
            outline: none; 
            box-shadow: 0 0 4px rgba(59, 130, 246, 0.3); 
        }
        .error { 
            color: #dc2626; 
            font-size: 12px; 
            margin-top: 4px; 
            display: none; 
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
        .login-btn { 
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
        .login-btn:hover { 
            transform: translateY(-2px); 
            background: linear-gradient(135deg, #3b82f6, #60a5fa); 
        }
        .create-account { 
            text-align: center; 
            margin-top: 16px; 
        }
        .create-account a { 
            color: #3b82f6; 
            text-decoration: none; 
            font-size: 14px; 
            transition: color 0.3s ease; 
        }
        .create-account a:hover { 
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
    <div class="login-container">
        <div class="login-header">
            <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%233b82f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z'/></svg>" alt="Admin Icon">
            <h1>Admin Login</h1>
            <p>Manage healthcare services</p>
        </div>
        
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { 
        %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
        <% } %>
        
        <form id="loginForm" action="${pageContext.request.contextPath}/admin/login" method="POST" onsubmit="return validateForm(event)">
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    placeholder="Email" 
                    required 
                >
                <div id="emailError" class="error">Please enter a valid email</div>
            </div>
            
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    placeholder="Password" 
                    required 
                >
                <div id="passwordError" class="error">Password must be at least 6 characters</div>
            </div>
            
            <button type="submit" class="login-btn">Sign In</button>
        </form>
        
        <div class="create-account">
            <a href="${pageContext.request.contextPath}/admin/ManageAdminCreate">New admin? Register here</a>
        </div>
        
        <div class="footer">
            Administering Care, Ensuring Excellence
        </div>
    </div>

    <script>
        function validateForm(event) {
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            const emailError = document.getElementById('emailError');
            const passwordError = document.getElementById('passwordError');

            // Reset error messages
            emailError.style.display = 'none';
            passwordError.style.display = 'none';

            let isValid = true;

            // Email validation
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email.value)) {
                emailError.style.display = 'block';
                isValid = false;
            }

            // Password validation
            if (password.value.length < 6) {
                passwordError.style.display = 'block';
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault(); // Prevent submission if validation fails
            }
            // If validation passes, allow the form to submit to the servlet
            return isValid;
        }
    </script>
</body>
</html>