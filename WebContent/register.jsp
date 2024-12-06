<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>GADA ELECTRONICS - Register</title>
    <style>
        .register-container {
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
            color: #333;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .error {
            color: red;
            font-size: 0.9em;
            margin-top: 5px;
            display: none;
        }
        .submit-btn {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }
        .submit-btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="register-container">
    <h2>Create New Account</h2>
    
    <form name="registerForm" action="validateRegister.jsp" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" required>
            <div id="firstNameError" class="error">Please enter your first name</div>
        </div>

        <div class="form-group">
            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" required>
            <div id="lastNameError" class="error">Please enter your last name</div>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <div id="emailError" class="error">Please enter a valid email address</div>
        </div>

        <div class="form-group">
            <label for="phonenum">Phone Number:</label>
            <input type="tel" id="phonenum" name="phonenum" required>
            <div id="phoneError" class="error">Please enter a 10-digit phone number</div>
        </div>

        <div class="form-group">
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" required>
            <div id="addressError" class="error">Please enter your address</div>
        </div>

        <div class="form-group">
            <label for="city">City:</label>
            <input type="text" id="city" name="city" required>
            <div id="cityError" class="error">Please enter your city</div>
        </div>

        <div class="form-group">
            <label for="state">State/Province:</label>
            <input type="text" id="state" name="state" required>
            <div id="stateError" class="error">Please enter your state/province</div>
        </div>

        <div class="form-group">
            <label for="postalCode">Postal Code:</label>
            <input type="text" id="postalCode" name="postalCode" required>
            <div id="postalError" class="error">Please enter your postal code</div>
        </div>

        <div class="form-group">
            <label for="country">Country:</label>
            <input type="text" id="country" name="country" required>
            <div id="countryError" class="error">Please enter your country</div>
        </div>

        <div class="form-group">
            <label for="userid">Username:</label>
            <input type="text" id="userid" name="userid" required>
            <div id="useridError" class="error">Please enter a username (3-20 characters)</div>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <div id="passwordError" class="error">Password must be at least 6 characters</div>
        </div>

        <input type="submit" value="Register" class="submit-btn">
    </form>
</div>

<script>
function validateForm() {
    let isValid = true;
    
    // Email validation
    const email = document.getElementById('email').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        document.getElementById('emailError').style.display = 'block';
        isValid = false;
    } else {
        document.getElementById('emailError').style.display = 'none';
    }

    // Phone validation (10 digits)
    const phone = document.getElementById('phonenum').value;
    const phoneRegex = /^\d{10}$/;
    if (!phoneRegex.test(phone)) {
        document.getElementById('phoneError').style.display = 'block';
        isValid = false;
    } else {
        document.getElementById('phoneError').style.display = 'none';
    }

    // Username validation (3-20 characters)
    const userid = document.getElementById('userid').value;
    if (userid.length < 3 || userid.length > 20) {
        document.getElementById('useridError').style.display = 'block';
        isValid = false;
    } else {
        document.getElementById('useridError').style.display = 'none';
    }

    // Password validation (minimum 6 characters)
    const password = document.getElementById('password').value;
    if (password.length < 6) {
        document.getElementById('passwordError').style.display = 'block';
        isValid = false;
    } else {
        document.getElementById('passwordError').style.display = 'none';
    }

    return isValid;
}
</script>

</body>
</html>