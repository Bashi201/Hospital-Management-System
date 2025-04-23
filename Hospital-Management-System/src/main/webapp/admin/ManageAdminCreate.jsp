<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Admin</title>
    <style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css');
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { min-height: 100vh; display: flex; justify-content: center; align-items: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .admin-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); width: 100%; max-width: 450px; }
        .admin-header { text-align: center; margin-bottom: 30px; }
        .admin-header h1 { color: #333; font-size: 28px; }
        .input-group { position: relative; margin-bottom: 20px; }
        .input-group i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #764ba2; font-size: 18px; }
        .input-group input { width: 100%; padding: 12px 15px 12px 45px; border: 2px solid #eee; border-radius: 8px; font-size: 16px; transition: all 0.3s ease; }
        .input-group input:focus { border-color: #667eea; outline: none; box-shadow: 0 0 5px rgba(102, 126, 234, 0.3); }
        .create-btn { width: 100%; padding: 15px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; border-radius: 8px; color: white; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.2s ease; }
        .create-btn:hover { transform: translateY(-2px); }
        .error { color: #ff4444; font-size: 14px; text-align: center; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="admin-header">
            <h1>Create Admin</h1>
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
            <a href="${pageContext.request.contextPath}/admin/login" class="create-btn">Go to Login</a>
        <% } %>
    </div>
</body>
</html>
