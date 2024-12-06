<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer List - GADA Electronics</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .customer-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        .customer-table th, .customer-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .customer-table th {
            background-color: #007185;
            color: white;
            font-weight: 500;
        }
        .customer-table tr:hover {
            background-color: #f5f5f5;
        }
        .page-title {
            color: #333;
            margin-bottom: 20px;
        }
        .email-link {
            color: #007185;
            text-decoration: none;
        }
        .email-link:hover {
            text-decoration: underline;
        }
        .no-customers {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <h1 class="page-title">Customer Directory</h1>
        
        <%
        try {
            Connection con = DriverManager.getConnection(url, uid, pw);
            
            String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country " +
                        "FROM customer ORDER BY lastName, firstName";
            
            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery(sql);
            
            if (!rst.isBeforeFirst()) {
                // No customers found
                %>
                <div class="no-customers">
                    <h3>No customers found in the database.</h3>
                </div>
                <%
            } else {
                %>
                <table class="customer-table">
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>City</th>
                        <th>State</th>
                        <th>Country</th>
                    </tr>
                    <%
                    while (rst.next()) {
                        %>
                        <tr>
                            <td><%= rst.getString("firstName") + " " + rst.getString("lastName") %></td>
                            <td><a href="mailto:<%= rst.getString("email") %>" class="email-link"><%= rst.getString("email") %></a></td>
                            <td><%= rst.getString("phonenum") != null ? rst.getString("phonenum") : "N/A" %></td>
                            <td><%= rst.getString("address") %></td>
                            <td><%= rst.getString("city") %></td>
                            <td><%= rst.getString("state") %></td>
                            <td><%= rst.getString("country") %></td>
                        </tr>
                        <%
                    }
                    %>
                </table>
                <%
            }
            
            con.close();
        } catch (SQLException ex) {
            out.println("SQLException: " + ex);
        }
        %>
    </div>
</body>
</html> 