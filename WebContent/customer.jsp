<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
            color: #333;
        }
        h1 {
            color: #007185;
            text-align: center;
            font-size: 32px;
            margin: 30px 0;
        }
        .table-container {
            display: flex;
            justify-content: center;
            padding: 20px;
        }
        table {
            width: 90%;
            max-width: 900px;
            border-collapse: collapse;
            margin: 0 auto;
            background-color: #fff;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 18px 24px;
            text-align: left;
        }
        th {
            background-color: #007185;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }
        tr:nth-child(even) {
            background-color: #f7f9fc;
        }
        tr:hover {
            background-color: #e3f2fd;
        }
        td {
            font-size: 16px;
            color: #555;
        }
        .no-info, .error-message {
            text-align: center;
            color: #d32f2f;
            font-weight: bold;
            margin-top: 20px;
        }
        .error-message {
            margin-top: 40px;
        }
        @media (max-width: 768px) {
            table {
                width: 100%;
            }
            th, td {
                padding: 12px 16px;
            }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<h1>Customer Profile</h1>

<%@ include file="auth.jsp"%>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<div class="table-container">
<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
        out.println("<p class='error-message'>Error: You must be logged in to view this page.</p>");
        return;
    }

    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer WHERE userid = ?";
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement stmt = con.prepareStatement(sql)) {

        stmt.setString(1, userName);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            out.println("<table>");
            out.println("<tr><th>Customer Id</th><td>" + rs.getInt("customerId") + "</td></tr>");
            out.println("<tr><th>User Id</th><td>" + rs.getString("userid") + "</td></tr>");
            out.println("<tr><th>First Name</th><td>" + rs.getString("firstName") + "</td></tr>");
            out.println("<tr><th>Last Name</th><td>" + rs.getString("lastName") + "</td></tr>");
            out.println("<tr><th>Email</th><td>" + rs.getString("email") + "</td></tr>");
            out.println("<tr><th>Phone</th><td>" + rs.getString("phonenum") + "</td></tr>");
            out.println("<tr><th>Address</th><td>" + rs.getString("address") + "</td></tr>");
            out.println("<tr><th>City</th><td>" + rs.getString("city") + "</td></tr>");
            out.println("<tr><th>State</th><td>" + rs.getString("state") + "</td></tr>");
            out.println("<tr><th>Postal Code</th><td>" + rs.getString("postalCode") + "</td></tr>");
            out.println("<tr><th>Country</th><td>" + rs.getString("country") + "</td></tr>");
            out.println("</table>");
        } else {
            out.println("<p class='no-info'>No customer information found.</p>");
        }
    } catch (SQLException e) {
        out.println("<p class='error-message'>Error retrieving customer information: " + e.getMessage() + "</p>");
    }
%>
</div>

</body>
</html>
