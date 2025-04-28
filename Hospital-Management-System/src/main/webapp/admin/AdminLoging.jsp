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
            z-index: 100; 
            transition: all 0.3s ease;
            position: relative;
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

        /* Flower Animation Styles (from style.css) */
        *,
        *::after,
        *::before {
            padding: 0;
            margin: 0;
            box-sizing: border-box;
        }

        :root {
            --dark-color: #000;
        }

        .night {
            position: fixed;
            left: 50%;
            top: 0;
            transform: translateX(-50%);
            width: 100%;
            height: 100%;
            filter: blur(0.1vmin);
            background-image: radial-gradient(ellipse at top, transparent 0%, var(--dark-color)), radial-gradient(ellipse at bottom, var(--dark-color), rgba(145, 233, 255, 0.2)), repeating-linear-gradient(220deg, black 0px, black 19px, transparent 19px, transparent 22px), repeating-linear-gradient(189deg, black 0px, black 19px, transparent 19px, transparent 22px), repeating-linear-gradient(148deg, black 0px, black 19px, transparent 19px, transparent 22px), linear-gradient(90deg, #00fffa, #f0f0f0);
        }

        .flowers {
            position: absolute;
            transform: scale(0.5);
            z-index: 10;
        }

        .flower {
            position: absolute;
            bottom: 10vmin;
            transform-origin: bottom center;
            z-index: 10;
            --fl-speed: 0.8s;
        }
        .flower--1 {
            animation: moving-flower-1 4s linear infinite;
            left: -20vw; /* Position to the left of the login container */
        }
        .flower--1 .flower__line {
            height: 70vmin;
            animation-delay: 0.3s;
        }
        .flower--1 .flower__line__leaf--1 {
            animation: blooming-leaf-right var(--fl-speed) 1.6s backwards;
        }
        .flower--1 .flower__line__leaf--2 {
            animation: blooming-leaf-right var(--fl-speed) 1.4s backwards;
        }
        .flower--1 .flower__line__leaf--3 {
            animation: blooming-leaf-left var(--fl-speed) 1.2s backwards;
        }
        .flower--1 .flower__line__leaf--4 {
            animation: blooming-leaf-left var(--fl-speed) 1s backwards;
        }
        .flower--1 .flower__line__leaf--5 {
            animation: blooming-leaf-right var(--fl-speed) 1.8s backwards;
        }
        .flower--1 .flower__line__leaf--6 {
            animation: blooming-leaf-left var(--fl-speed) 2s backwards;
        }
        .flower--2 {
            left: 20vw; /* Position to the right of the login container */
            transform: rotate(30deg);
            animation: moving-flower-2 4s linear infinite;
        }
        .flower--2 .flower__line {
            height: 60vmin;
            animation-delay: 0.8s;
        }
        .flower--2 .flower__line__leaf--1 {
            animation: blooming-leaf-right var(--fl-speed) 1.9s backwards;
        }
        .flower--2 .flower__line__leaf--2 {
            animation: blooming-leaf-right var(--fl-speed) 1.7s backwards;
        }
        .flower--2 .flower__line__leaf--3 {
            animation: blooming-leaf-left var(--fl-speed) 1.5s backwards;
        }
        .flower--2 .flower__line__leaf--4 {
            animation: blooming-leaf-left var(--fl-speed) 1.3s backwards;
        }
        .flower__leafs {
            position: relative;
            animation: blooming-flower 2s backwards;
        }
        .flower__leafs--1 {
            animation-delay: 1.1s;
        }
        .flower__leafs--2 {
            animation-delay: 1.4s;
        }
        .flower__leafs::after {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            transform: translate(-50%, -100%);
            width: 8vmin;
            height: 8vmin;
            background-color: #6bf0ff;
            filter: blur(10vmin);
        }
        .flower__leaf {
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 8vmin;
            height: 11vmin;
            border-radius: 51% 49% 47% 53%/44% 45% 55% 69%;
            background-color: #ff69b4; /* Pink color for the flower on the right */
            background-image: linear-gradient(to top, #ff1493, #ffb6c1);
            transform-origin: bottom center;
            opacity: 0.9;
            box-shadow: inset 0 0 2vmin rgba(255, 255, 255, 0.5);
        }
        .flower--1 .flower__leaf {
            background-color: #ffa500; /* Orange color for the flower on the left */
            background-image: linear-gradient(to top, #ff8c00, #ffd700);
        }
        .flower__leaf--1 {
            transform: translate(-10%, 1%) rotateY(40deg) rotateX(-50deg);
        }
        .flower__leaf--2 {
            transform: translate(-50%, -4%) rotateX(40deg);
        }
        .flower__leaf--3 {
            transform: translate(-90%, 0%) rotateY(45deg) rotateX(50deg);
        }
        .flower__leaf--4 {
            width: 8vmin;
            height: 8vmin;
            transform-origin: bottom left;
            border-radius: 4vmin 10vmin 4vmin 4vmin;
            transform: translate(0%, 18%) rotateX(70deg) rotate(-43deg);
            background-image: linear-gradient(to top, #ff1493, #ffb6c1);
            z-index: 1;
            opacity: 0.8;
        }
        .flower--1 .flower__leaf--4 {
            background-image: linear-gradient(to top, #ff8c00, #ffd700);
        }
        .flower__white-circle {
            position: absolute;
            left: -3.5vmin;
            top: -3vmin;
            width: 9vmin;
            height: 4vmin;
            border-radius: 50%;
            background-color: #fff;
        }
        .flower__white-circle::after {
            content: "";
            position: absolute;
            left: 50%;
            top: 45%;
            transform: translate(-50%, -50%);
            width: 60%;
            height: 60%;
            border-radius: inherit;
            background-image: repeating-linear-gradient(135deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(45deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(67.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(135deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(45deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(112.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(112.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(45deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(22.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(45deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(22.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(135deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(157.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(67.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), repeating-linear-gradient(67.5deg, rgba(0, 0, 0, 0.03) 0px, rgba(0, 0, 0, 0.03) 1px, transparent 1px, transparent 12px), linear-gradient(90deg, #ffeb12, #ffce00);
        }
        .flower__line {
            height: 55vmin;
            width: 1.5vmin;
            background-image: linear-gradient(to left, rgba(0, 0, 0, 0.2), transparent, rgba(255, 255, 255, 0.2)), linear-gradient(to top, transparent 10%, #14757a, #39c6d6);
            box-shadow: inset 0 0 2px rgba(0, 0, 0, 0.5);
            animation: grow-flower-tree 4s backwards;
        }
        .flower__line__leaf {
            --w: 7vmin;
            --h: calc(var(--w) + 2vmin);
            position: absolute;
            top: 20%;
            left: 90%;
            width: var(--w);
            height: var(--h);
            border-top-right-radius: var(--h);
            border-bottom-left-radius: var(--h);
            background-image: linear-gradient(to top, rgba(20, 117, 122, 0.4), #39c6d6);
        }
        .flower__line__leaf--1 {
            transform: rotate(70deg) rotateY(30deg);
        }
        .flower__line__leaf--2 {
            top: 45%;
            transform: rotate(70deg) rotateY(30deg);
        }
        .flower__line__leaf--3, .flower__line__leaf--4, .flower__line__leaf--6 {
            border-top-right-radius: 0;
            border-bottom-left-radius: 0;
            border-top-left-radius: var(--h);
            border-bottom-right-radius: var(--h);
            left: -460%;
            top: 12%;
            transform: rotate(-70deg) rotateY(30deg);
        }
        .flower__line__leaf--4 {
            top: 40%;
        }
        .flower__line__leaf--5 {
            top: 0;
            transform-origin: left;
            transform: rotate(70deg) rotateY(30deg) scale(0.6);
        }
        .flower__line__leaf--6 {
            top: -2%;
            left: -450%;
            transform-origin: right;
            transform: rotate(-70deg) rotateY(30deg) scale(0.6);
        }
        .flower__light {
            position: absolute;
            bottom: 0vmin;
            width: 1vmin;
            height: 1vmin;
            background-color: #fffb00;
            border-radius: 50%;
            filter: blur(0.2vmin);
            animation: light-ans 4s linear infinite backwards;
        }
        .flower__light:nth-child(odd) {
            background-color: #23f0ff;
        }
        .flower__light--1 {
            left: -2vmin;
            animation-delay: 1s;
        }
        .flower__light--2 {
            left: 3vmin;
            animation-delay: 0.5s;
        }
        .flower__light--3 {
            left: -6vmin;
            animation-delay: 0.3s;
        }
        .flower__light--4 {
            left: 6vmin;
            animation-delay: 0.9s;
        }
        .flower__light--5 {
            left: -1vmin;
            animation-delay: 1.5s;
        }
        .flower__light--6 {
            left: -4vmin;
            animation-delay: 3s;
        }
        .flower__light--7 {
            left: 3vmin;
            animation-delay: 2s;
        }
        .flower__light--8 {
            left: -6vmin;
            animation-delay: 3.5s;
        }
        .grow-ans {
            animation: grow-ans 2s var(--d) backwards;
        }

        @keyframes grow-ans {
            0% {
                transform: scale(0);
                opacity: 0;
            }
        }
        @keyframes light-ans {
            0% {
                opacity: 0;
                transform: translateY(0vmin);
            }
            25% {
                opacity: 1;
                transform: translateY(-5vmin) translateX(-2vmin);
            }
            50% {
                opacity: 1;
                transform: translateY(-15vmin) translateX(2vmin);
                filter: blur(0.2vmin);
            }
            75% {
                transform: translateY(-20vmin) translateX(-2vmin);
                filter: blur(0.2vmin);
            }
            100% {
                transform: translateY(-30vmin);
                opacity: 0;
                filter: blur(1vmin);
            }
        }
        @keyframes moving-flower-1 {
            0%, 100% {
                transform: rotate(2deg);
            }
            50% {
                transform: rotate(-2deg);
            }
        }
        @keyframes moving-flower-2 {
            0%, 100% {
                transform: rotate(18deg);
            }
            50% {
                transform: rotate(14deg);
            }
        }
        @keyframes blooming-leaf-right {
            0% {
                transform-origin: left;
                transform: rotate(70deg) rotateY(30deg) scale(0);
            }
        }
        @keyframes blooming-leaf-left {
            0% {
                transform-origin: right;
                transform: rotate(-70deg) rotateY(30deg) scale(0);
            }
        }
        @keyframes grow-flower-tree {
            0% {
                height: 0;
                border-radius: 1vmin;
            }
        }
        @keyframes blooming-flower {
            0% {
                transform: scale(0);
            }
        }
        .not-loaded * {
            animation-play-state: paused !important;
        }
    </style>
</head>
<body class="not-loaded">
    <div class="bg-pattern"></div>
    <div class="flowers">
        <div class="flower flower--1">
            <div class="flower__leafs flower__leafs--1">
                <div class="flower__leaf flower__leaf--1"></div>
                <div class="flower__leaf flower__leaf--2"></div>
                <div class="flower__leaf flower__leaf--3"></div>
                <div class="flower__leaf flower__leaf--4"></div>
                <div class="flower__white-circle"></div>
                <div class="flower__light flower__light--1"></div>
                <div class="flower__light flower__light--2"></div>
                <div class="flower__light flower__light--3"></div>
                <div class="flower__light flower__light--4"></div>
                <div class="flower__light flower__light--5"></div>
                <div class="flower__light flower__light--6"></div>
                <div class="flower__light flower__light--7"></div>
                <div class="flower__light flower__light--8"></div>
            </div>
            <div class="flower__line">
                <div class="flower__line__leaf flower__line__leaf--1"></div>
                <div class="flower__line__leaf flower__line__leaf--2"></div>
                <div class="flower__line__leaf flower__line__leaf--3"></div>
                <div class="flower__line__leaf flower__line__leaf--4"></div>
                <div class="flower__line__leaf flower__line__leaf--5"></div>
                <div class="flower__line__leaf flower__line__leaf--6"></div>
            </div>
        </div>
        <div class="flower flower--2">
            <div class="flower__leafs flower__leafs--2">
                <div class="flower__leaf flower__leaf--1"></div>
                <div class="flower__leaf flower__leaf--2"></div>
                <div class="flower__leaf flower__leaf--3"></div>
                <div class="flower__leaf flower__leaf--4"></div>
                <div class="flower__white-circle"></div>
                <div class="flower__light flower__light--1"></div>
                <div class="flower__light flower__light--2"></div>
                <div class="flower__light flower__light--3"></div>
                <div class="flower__light flower__light--4"></div>
                <div class="flower__light flower__light--5"></div>
                <div class="flower__light flower__light--6"></div>
                <div class="flower__light flower__light--7"></div>
                <div class="flower__light flower__light--8"></div>
            </div>
            <div class="flower__line">
                <div class="flower__line__leaf flower__line__leaf--1"></div>
                <div class="flower__line__leaf flower__line__leaf--2"></div>
                <div class="flower__line__leaf flower__line__leaf--3"></div>
                <div class="flower__line__leaf flower__line__leaf--4"></div>
            </div>
        </div>
    </div>
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
        // Flower Animation Script (from script.js)
        window.onload = () => {
            const c = setTimeout(() => {
                document.body.classList.remove("not-loaded");
                clearTimeout(c);
            }, 1000);
        };

        // Existing Validation Script
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