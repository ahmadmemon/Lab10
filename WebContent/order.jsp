<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <style>
        .order-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .order-summary, .order-items {
            margin-bottom: 30px;
        }
        .order-summary p, .order-items p {
            margin: 5px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #f8f9fa;
            color: #495057;
        }
        .total {
            font-weight: bold;
            text-align: right;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="order-container">
    <h1>Order Details</h1>

    <%
    String orderIdParam = request.getParameter("orderId");
    if (orderIdParam == null) {
        out.println("<p style='color:red;'>Error: Order ID is missing.</p>");
        return;
    }

    int orderId = Integer.parseInt(orderIdParam);
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        // Retrieve order summary
        String orderSummaryQuery = "SELECT orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry FROM ordersummary WHERE orderId = ?";
        PreparedStatement orderStmt = con.prepareStatement(orderSummaryQuery);
        orderStmt.setInt(1, orderId);
        ResultSet orderRs = orderStmt.executeQuery();

        if (orderRs.next()) {
            Timestamp orderDate = orderRs.getTimestamp("orderDate");
            double totalAmount = orderRs.getDouble("totalAmount");
            String shipAddress = orderRs.getString("shiptoAddress");
            String shipCity = orderRs.getString("shiptoCity");
            String shipState = orderRs.getString("shiptoState");
            String shipPostal = orderRs.getString("shiptoPostalCode");
            String shipCountry = orderRs.getString("shiptoCountry");
    %>
            <div class="order-summary">
                <h2>Order Summary</h2>
                <p><strong>Order ID:</strong> <%= orderId %></p>
                <p><strong>Order Date:</strong> <%= orderDate %></p>
                <p><strong>Total Amount:</strong> <%= currFormat.format(totalAmount) %></p>
                <p><strong>Shipping Address:</strong> <%= shipAddress %>, <%= shipCity %>, <%= shipState %>, <%= shipPostal %>, <%= shipCountry %></p>
            </div>

            <div class="order-items">
                <h2>Order Items</h2>
                <table>
                    <tr>
                        <th>Product ID</th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Subtotal</th>
                    </tr>
    <%
            // Retrieve order items
            String orderItemsQuery = "SELECT op.productId, p.productName, op.quantity, op.price FROM orderproduct op JOIN product p ON op.productId = p.productId WHERE op.orderId = ?";
            PreparedStatement itemsStmt = con.prepareStatement(orderItemsQuery);
            itemsStmt.setInt(1, orderId);
            ResultSet itemsRs = itemsStmt.executeQuery();

            while (itemsRs.next()) {
                int productId = itemsRs.getInt("productId");
                String productName = itemsRs.getString("productName");
                int quantity = itemsRs.getInt("quantity");
                double price = itemsRs.getDouble("price");
                double subtotal = price * quantity;
    %>
                    <tr>
                        <td><%= productId %></td>
                        <td><%= productName %></td>
                        <td><%= quantity %></td>
                        <td><%= currFormat.format(price) %></td>
                        <td><%= currFormat.format(subtotal) %></td>
                    </tr>
    <%
            }
    %>
                </table>
            </div>
    <%
        } else {
            out.println("<p style='color:red;'>Error: Order not found.</p>");
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
    %>
</div>

</body>
</html>

