<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
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
        }
        .cart-table th, .cart-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .cart-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: contain;
            margin-right: 15px;
        }
        .quantity-input {
            width: 60px;
            padding: 5px;
            margin-right: 10px;
        }
        .update-btn, .remove-btn {
            padding: 5px 10px;
            margin: 5px;
            cursor: pointer;
        }
        .update-btn {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
        }
        .remove-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
        }
        .total-section {
            text-align: right;
            margin-top: 20px;
            padding: 20px;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .empty-cart {
            text-align: center;
            padding: 40px;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .product-info {
            display: flex;
            align-items: center;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="cart-container">
    <h1>Shopping Cart</h1>

    <%
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
    %>
        <div class="empty-cart">
            <h2>Your cart is empty</h2>
            <p>Browse our products and add items to your cart!</p>
            <a href="listprod.jsp" style="color: #007bff; text-decoration: none;">Continue Shopping</a>
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
            try {
                Connection con = DriverManager.getConnection(url, uid, pw);

                for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                    String productId = entry.getKey();
                    ArrayList<Object> product = entry.getValue();
                    String price = product.get(2).toString();
                    double pr = Double.parseDouble(price);
                    int qty = ((Integer)product.get(3)).intValue();

                    // Get product details including image from database
                    String sql = "SELECT productName, productImageURL FROM product WHERE productId = ?";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(productId));
                    ResultSet rst = pstmt.executeQuery();

                    if (rst.next()) {
                        String productName = rst.getString("productName");
                        String imageUrl = rst.getString("productImageURL");
            %>
                        <tr>
                            <td>
                                <div class="product-info">
                                    <img src="<%= imageUrl %>" alt="<%= productName %>" class="product-image">
                                    <span><%= productName %></span>
                                </div>
                            </td>
                            <td><%= currFormat.format(pr) %></td>
                            <td>
                                <form method="post" action="updatecart.jsp" style="display: inline;">
                                    <input type="hidden" name="id" value="<%= productId %>">
                                    <input type="number" name="quantity" value="<%= qty %>" 
                                           min="0" class="quantity-input">
                                    <input type="submit" value="Update" class="update-btn">
                                </form>
                            </td>
                            <td><%= currFormat.format(pr * qty) %></td>
                            <td>
                                <form method="post" action="removecart.jsp" style="display: inline;">
                                    <input type="hidden" name="id" value="<%= productId %>">
                                    <input type="submit" value="Remove" class="remove-btn">
                                </form>
                            </td>
                        </tr>
            <%
                        total = total + pr * qty;
                    }
                }
                con.close();
            } catch (SQLException ex) {
                out.println("SQLException: " + ex);
            }
            %>

        </table>

        <div class="total-section">
            <h3>Order Total: <%= currFormat.format(total) %></h3>
            <a href="checkout.jsp" class="checkout-btn" 
               style="display: inline-block; padding: 10px 20px; background-color: #28a745; 
                      color: white; text-decoration: none; border-radius: 4px; margin-top: 10px;">
                Proceed to Checkout
            </a>
        </div>
    <% } %>
</div>

</body>
</html>

