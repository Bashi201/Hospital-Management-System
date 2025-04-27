<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dispatcher Login</title>
    <style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css');
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { min-height: 100vh; display: flex; justify-content: center; align-items: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .login-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); width: 100%; max-width: 400px; }
        .login-header { text-align: center; margin-bottom: 40px; }
        .login-header h1 { color: #333; font-size: 28px; margin-bottom: 10px; }
        .input-group { position: relative; margin-bottom: 25px; }
        .input-group i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #764ba2; font-size: 18px; }
        .input-group input { width: 100%; padding: 15px 15px 15px 45px; border: 2px solid #eee; border-radius: 8px; font-size: 16px; transition: all 0.3s ease; }
        .input-group input:focus { border-color: #667eea; outline: none; box-shadow: 0 0 5px rgba(102, 126, 234, 0.3); }
        .error { color: #ff4444; font-size: 12px; margin-top: 5px; display: none; }
        .error-message { color: #ff4444; text-align: center; margin-bottom: 20px; }
        .login-btn { width: 100%; padding: 15px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 8px; color: white; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.2s ease; }
        .login-btn:hover { transform: translateY(-2px); }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Dispatcher Login</h1>
        </div>

        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { 
        %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/dispatcher" method="POST">
            <input type="hidden" name="action" value="login">
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
    </div>

    <script>
        function validateForm(event) {
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            const emailError = document.getElementById('emailError');
            const passwordError = document.getElementById('passwordError');

            emailError.style.display = 'none';
            passwordError.style.display = 'none';

            let isValid = true;

            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email.value)) {
                emailError.style.display = 'block';
                isValid = false;
            }

            if (password.value.length < 6) {
                passwordError.style.display = 'block';
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
            }
            return isValid;
        }

        document.querySelector('form').addEventListener('submit', validateForm);
    </script>
</body>
</html>