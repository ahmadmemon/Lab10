<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order Processing</title>
    <style>
        .process-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .success-message {
            color: #28a745;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .error-message {
            color: #dc3545;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>
<div class="process-container">

<%
// Get shopping cart
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null || productList.isEmpty()) {
    %>
    <div class="error-message">Your shopping cart is empty!</div>
    <%
    return;
}

try {
    // Get checkout option
    String checkoutOption = request.getParameter("checkoutOption");
    String customerId = "";

    // Handle different checkout options
    if ("customerId".equals(checkoutOption)) {
        // Get customer ID from form
        customerId = request.getParameter("customerId");
        String password = request.getParameter("password");

        // Validate customer credentials
        String validateQuery = "SELECT customerId FROM customer WHERE userid = ? AND password = ?";
        Connection con = DriverManager.getConnection(url, uid, pw);
        PreparedStatement pstmt = con.prepareStatement(validateQuery);
        pstmt.setString(1, customerId);
        pstmt.setString(2, password);
        ResultSet rst = pstmt.executeQuery();

        if (!rst.next()) {
            %>
            <div class="error-message">Invalid customer ID or password.</div>
            <%
            return;
        }
        customerId = rst.getString("customerId");
    } else if ("paymentInfo".equals(checkoutOption)) {
        // Process payment information
        String cardNumber = request.getParameter("cardNumber");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");
        
        // Create new customer record with shipping information
        String insertCustomerQuery = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = DriverManager.getConnection(url, uid, pw);
        PreparedStatement pstmt = con.prepareStatement(insertCustomerQuery, Statement.RETURN_GENERATED_KEYS);
        
        // Set shipping details as customer information
        pstmt.setString(1, "Guest");  // firstName
        pstmt.setString(2, "Customer");  // lastName
        pstmt.setString(3, "guest@example.com");  // email
        pstmt.setString(4, "0000000000");  // phonenum
        pstmt.setString(5, request.getParameter("shipAddress"));
        pstmt.setString(6, request.getParameter("shipCity"));
        pstmt.setString(7, request.getParameter("shipState"));
        pstmt.setString(8, request.getParameter("shipPostal"));
        pstmt.setString(9, request.getParameter("shipCountry"));
        
        pstmt.executeUpdate();
        
        // Get the generated customer ID
        ResultSet keys = pstmt.getGeneratedKeys();
        if (keys.next()) {
            customerId = keys.getString(1);
        }
    }

    // Process the order
    Connection con = DriverManager.getConnection(url, uid, pw);
    con.setAutoCommit(false);

    // Create order summary
    String sql = "INSERT INTO ordersummary (orderDate, customerId, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

    double totalAmount = 0;
    // Calculate total amount
    for (ArrayList<Object> product : productList.values()) {
        double price = Double.parseDouble(product.get(2).toString());
        int qty = Integer.parseInt(product.get(3).toString());
        totalAmount += price * qty;
    }

    pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
    pstmt.setString(2, customerId);
    pstmt.setDouble(3, totalAmount);
    pstmt.setString(4, request.getParameter("shipAddress"));
    pstmt.setString(5, request.getParameter("shipCity"));
    pstmt.setString(6, request.getParameter("shipState"));
    pstmt.setString(7, request.getParameter("shipPostal"));
    pstmt.setString(8, request.getParameter("shipCountry"));
    
    pstmt.executeUpdate();

    // Get the order id
    ResultSet keys = pstmt.getGeneratedKeys();
    keys.next();
    int orderId = keys.getInt(1);

    // Insert each item into OrderProduct
    sql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
    pstmt = con.prepareStatement(sql);

    for (ArrayList<Object> product : productList.values()) {
        pstmt.setInt(1, orderId);
        pstmt.setInt(2, Integer.parseInt(product.get(0).toString()));
        pstmt.setInt(3, Integer.parseInt(product.get(3).toString()));
        pstmt.setDouble(4, Double.parseDouble(product.get(2).toString()));
        pstmt.executeUpdate();
    }

    // Update inventory
    sql = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
    pstmt = con.prepareStatement(sql);

    for (ArrayList<Object> product : productList.values()) {
        pstmt.setInt(1, Integer.parseInt(product.get(3).toString()));
        pstmt.setInt(2, Integer.parseInt(product.get(0).toString()));
        pstmt.executeUpdate();
    }

    con.commit();
    con.close();

    // Clear cart if order successful
    session.removeAttribute("productList");
    %>
    <div class="success-message">
        <h2>Order Completed Successfully</h2>
        <p>Order ID: <%= orderId %></p>
        <p>Total Amount: $<%= String.format("%.2f", totalAmount) %></p>
        <p><a href="order.jsp?orderId=<%= orderId %>">View Order Details</a></p>
        <p><a href="listprod.jsp">Continue Shopping</a></p>
    </div>
    <%
} catch (SQLException ex) {
    %>
    <div class="error-message">
        <h2>Error Processing Order</h2>
        <p><%= ex.getMessage() %></p>
        <p><a href="checkout.jsp">Return to Checkout</a></p>
    </div>
    <%
}
%>

</div>
</body>
</html> 