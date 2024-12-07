<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - GADA ELECTRONICS</title>
    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 30px;
            background: linear-gradient(145deg, #ffffff, #f5f5f5);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .login-title {
            text-align: center;
            color: #2c3e50;
            font-size: 2em;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }
        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #FF0000;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .submit-btn:hover {
            background-color: #E60000;
        }
        .error-message {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #fde8e8;
            border-radius: 5px;
            display: none;
        }
        .register-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
        .register-link a {
            color: #007185;
            text-decoration: none;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="login-container">
        <h1 class="login-title">Login</h1>
        
        <% 
        // Print prior error message if present
        if (session.getAttribute("loginMessage") != null) {
            out.println("<div class='error-message' style='display: block;'>" + session.getAttribute("loginMessage") + "</div>");
            session.removeAttribute("loginMessage");
        }
        %>

        <form action="validateLogin.jsp" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required 
                       placeholder="Enter your username">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required 
                       placeholder="Enter your password">
            </div>
            
            <button type="submit" class="submit-btn">Login</button>
        </form>

        <div class="register-link">
            Don't have an account? <a href="createAccount.jsp">Register Now</a>
        </div>
    </div>

    <script>
        // Add smooth fade-out for error messages
        document.addEventListener('DOMContentLoaded', function() {
            const errorMessage = document.querySelector('.error-message');
            if (errorMessage && errorMessage.style.display === 'block') {
                setTimeout(() => {
                    errorMessage.style.transition = 'opacity 0.5s ease';
                    errorMessage.style.opacity = '0';
                    setTimeout(() => {
                        errorMessage.style.display = 'none';
                    }, 500);
                }, 5000);
            }
        });
    </script>
</body>
</html>

