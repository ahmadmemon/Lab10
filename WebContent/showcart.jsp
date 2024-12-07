<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Your Shopping Cart</title>
<style>
    .cart-container {
        max-width: 1200px;
        margin: 20px auto;
        padding: 0 20px;
    }
    .cart-table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
        background: white;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        border-radius: 8px;
    }
    .cart-table th, .cart-table td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }
    .cart-table th {
        background-color: #f8f9fa;
        color: #333;
        font-weight: 600;
    }
    .product-image {
        width: 100px;
        height: 100px;
        object-fit: contain;
    }
    .product-info {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    .product-name {
        color: #007185;
        text-decoration: none;
        font-weight: 500;
    }
    .product-name:hover {
        color: #C7511F;
        text-decoration: underline;
    }
    .quantity-input {
        width: 60px;
        padding: 5px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .update-btn, .remove-btn {
        padding: 5px 10px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        margin: 0 5px;
    }
    .update-btn {
        background: #007185;
        color: white;
    }
    .remove-btn {
        background: #dc3545;
        color: white;
    }
    .total-section {
        text-align: right;
        padding: 20px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        margin-top: 20px;
    }
    .checkout-btn {
        background: #FFD814;
        border: 1px solid #FCD200;
        padding: 10px 30px;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 10px;
    }
    .checkout-btn:hover {
        background: #F7CA00;
    }
    .empty-cart {
        text-align: center;
        padding: 40px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="cart-container">
    <h1>Shopping Cart</h1>

<%
try {
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
        %>
        <div class="empty-cart">
            <h2>Your cart is empty</h2>
            <p>Browse our products and add items to your cart!</p>
            <a href="listprod.jsp" style="color: #007185; text-decoration: none;">Continue Shopping</a>
        </div>
        <%
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        %>
        <table class="cart-table">
            <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
                <th>Actions</th>
            </tr>
            <%
            double total = 0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = entry.getValue();
                try {
                    String productId = product.get(0).toString();
                    String productName = product.get(1).toString();
                    String price = product.get(2).toString();
                    double pr = Double.parseDouble(price);
                    int qty = Integer.parseInt(product.get(3).toString());
                    
                    // Get product image from database
                    String imageUrl = "";
                    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                        String sql = "SELECT productImageURL FROM product WHERE productId = ?";
                        PreparedStatement pstmt = con.prepareStatement(sql);
                        pstmt.setString(1, productId);
                        ResultSet rst = pstmt.executeQuery();
                        
                        if (rst.next()) {
                            imageUrl = rst.getString("productImageURL");
                        }
                    }
                    %>
                    <tr>
                        <td>
                            <div class="product-info">
                                <img src="<%= imageUrl %>" alt="<%= productName %>" class="product-image">
                                <a href="product.jsp?id=<%= productId %>" class="product-name"><%= productName %></a>
                            </div>
                        </td>
                        <td><%= currFormat.format(pr) %></td>
                        <td>
                            <form method="post" action="updatecart.jsp">
                                <input type="hidden" name="id" value="<%= productId %>">
                                <input type="number" name="quantity" value="<%= qty %>" min="0" class="quantity-input">
                        </td>
                        <td><%= currFormat.format(pr * qty) %></td>
                        <td>
                                <input type="submit" value="Update" class="update-btn">
                            </form>
                            <form method="post" action="removecart.jsp">
                                <input type="hidden" name="id" value="<%= productId %>">
                                <input type="submit" value="Remove" class="remove-btn">
                            </form>
                        </td>
                    </tr>
                    <%
                    total = total + pr * qty;
                } catch (NumberFormatException e) {
                    // Handle invalid number format
                }
            }
            %>
        </table>

        <div class="total-section">
            <h3>Order Total: <%= currFormat.format(total) %></h3>
            <a href="checkout.jsp" class="checkout-btn">Proceed to Checkout</a>
        </div>
        <%
    }
} catch (Exception e) {
    // Handle any other exceptions
}
%>
</div>

</body>
</html>

