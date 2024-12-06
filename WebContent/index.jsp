<!DOCTYPE html>
<html>
<head>
    <title>GADA Electronics</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f2f5;
            color: #333;
        }

        .hero-section {
            background: linear-gradient(135deg, #007185, #00a8c7);
            color: white;
            padding: 40px 20px;
            text-align: center;
            margin-bottom: 30px;
        }

        .hero-section h1 {
            font-size: 2.5em;
            margin-bottom: 15px;
        }

        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .options-list {
            list-style: none;
            padding: 0;
            margin: 20px 0;
        }

        .options-list li {
            margin: 15px 0;
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }

        .options-list li:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .options-list a {
            color: #007185;
            text-decoration: none;
            font-size: 1.1em;
            display: block;
        }

        .options-list a:hover {
            color: #005a6e;
        }

        .welcome-msg {
            text-align: center;
            color: #007185;
            margin: 20px 0;
            font-size: 1.2em;
            padding: 10px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        @media (max-width: 768px) {
            .hero-section {
                padding: 30px 20px;
            }
            .hero-section h1 {
                font-size: 2em;
            }
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="hero-section">
    <h1>Welcome to GADA Electronics</h1>
</div>

<div class="main-content">
    <% 
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName != null) { 
    %>
        <div class="welcome-msg">
            Welcome back, <%= userName %>!
        </div>
        <ul class="options-list">
            <li><a href="listprod.jsp">Begin Shopping</a></li>
            <li><a href="listorder.jsp">List All Orders</a></li>
            <li><a href="customer.jsp">Customer Info</a></li>
            <li><a href="editAccount.jsp">Edit Account</a></li>
            <li><a href="admin.jsp">Administrators</a></li>
            <li><a href="showcart.jsp">View Cart</a></li>
            <li><a href="logout.jsp">Log out</a></li>
        </ul>
    <% } else { %>
        <ul class="options-list">
            <li><a href="listprod.jsp">Begin Shopping</a></li>
            <li><a href="createAccount.jsp">Create Account</a></li>
            <li><a href="login.jsp">Login</a></li>
            <li><a href="admin.jsp">Administrators</a></li>
            <li><a href="showcart.jsp">View Cart</a></li>
        </ul>
    <% } %>
</div>

</body>
</html>


