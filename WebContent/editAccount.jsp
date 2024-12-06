<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Account - GADA Electronics</title>
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
        <h2>Edit Account Information</h2>
        
        <%
        String userid = (String) session.getAttribute("authenticatedUser");
        if (userid == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection con = DriverManager.getConnection(url, uid, pw);
            String sql = "SELECT * FROM Customer WHERE userid = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userid);
            ResultSet rst = pstmt.executeQuery();

            if (rst.next()) {
        %>
        <form action="updateAccount.jsp" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" value="<%= rst.getString("firstName") %>" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" value="<%= rst.getString("lastName") %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= rst.getString("email") %>" required>
            </div>
            <div class="form-group">
                <label for="phonenum">Phone Number:</label>
                <input type="tel" id="phonenum" name="phonenum" value="<%= rst.getString("phonenum") %>" pattern="[0-9]{10}">
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" value="<%= rst.getString("address") %>" required>
            </div>
            <div class="form-group">
                <label for="city">City:</label>
                <input type="text" id="city" name="city" value="<%= rst.getString("city") %>" required>
            </div>
            <div class="form-group">
                <label for="state">State:</label>
                <input type="text" id="state" name="state" value="<%= rst.getString("state") %>" required>
            </div>
            <div class="form-group">
                <label for="postalCode">Postal Code:</label>
                <input type="text" id="postalCode" name="postalCode" value="<%= rst.getString("postalCode") %>" required>
            </div>
            <div class="form-group">
                <label for="country">Country:</label>
                <input type="text" id="country" name="country" value="<%= rst.getString("country") %>" required>
            </div>
            <div class="form-group">
                <label for="newPassword">New Password (leave blank to keep current):</label>
                <input type="password" id="newPassword" name="newPassword">
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm New Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword">
            </div>
            <button type="submit" class="submit-btn">Update Account</button>
        </form>
        <%
            }
            con.close();
        } catch (SQLException ex) {
            out.println("Error: " + ex.getMessage());
        }
        %>
    </div>

    <script>
    function validateForm() {
        var newPassword = document.getElementById("newPassword").value;
        var confirmPassword = document.getElementById("confirmPassword").value;
        var email = document.getElementById("email").value;
        var phonenum = document.getElementById("phonenum").value;

        // Password validation (only if new password is being set)
        if (newPassword) {
            if (newPassword !== confirmPassword) {
                alert("New passwords do not match!");
                return false;
            }
            if (newPassword.length < 6) {
                alert("Password must be at least 6 characters long!");
                return false;
            }
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