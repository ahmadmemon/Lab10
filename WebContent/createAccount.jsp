<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account - GADA Electronics</title>
    <style>
        .container {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .error {
            color: red;
            font-size: 0.9em;
            margin-top: 5px;
        }
        .submit-btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container">
        <h2>Create New Account</h2>
        <%
            String error = request.getParameter("error");
            if (error != null) {
                if (error.equals("email")) {
        %>
                    <div class="error-message" style="color: red; text-align: center; margin: 10px 0;">
                        This email address is already registered. Please use a different email.
                    </div>
        <%
                } else if (error.equals("phone")) {
        %>
                    <div class="error-message" style="color: red; text-align: center; margin: 10px 0;">
                        This phone number is already registered. Please use a different number.
                    </div>
        <%
                }
            }
        %>
        <form action="validateAccount.jsp" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="userid">Username:</label>
                <input type="text" id="userid" name="userid" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <div class="form-group">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="phonenum">Phone Number:</label>
                <input type="tel" id="phonenum" name="phonenum" pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number">
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" required>
            </div>
            <div class="form-group">
                <label for="city">City:</label>
                <input type="text" id="city" name="city" required>
            </div>
            <div class="form-group">
                <label for="state">State:</label>
                <input type="text" id="state" name="state" required>
            </div>
            <div class="form-group">
                <label for="postalCode">Postal Code:</label>
                <input type="text" id="postalCode" name="postalCode" required>
            </div>
            <div class="form-group">
                <label for="country">Country:</label>
                <input type="text" id="country" name="country" required>
            </div>
            <button type="submit" class="submit-btn">Create Account</button>
        </form>
    </div>

    <script>
    function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;
        var email = document.getElementById("email").value;
        var phonenum = document.getElementById("phonenum").value;

        // Password validation
        if (password !== confirmPassword) {
            alert("Passwords do not match!");
            return false;
        }
        if (password.length < 6) {
            alert("Password must be at least 6 characters long!");
            return false;
        }

        // Email validation
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            alert("Please enter a valid email address!");
            return false;
        }

        // Phone number validation
        var phoneRegex = /^\d{10}$/;
        if (phonenum && !phoneRegex.test(phonenum)) {
            alert("Please enter a valid 10-digit phone number!");
            return false;
        }

        return true;
    }
    </script>
</body>
</html> 