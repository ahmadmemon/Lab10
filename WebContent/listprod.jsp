<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Products - GADA ELECTRONICS</title>
    <style>
        body {
            background-color: #ffffff;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .page-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #007185;
        }
        .filters {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            padding: 15px 20px;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.08);
            align-items: center;
        }
        .search-box {
            flex: 1;
        }
        .search-box input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .category-filter select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            width: 180px;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            padding: 10px 0;
        }
        .product-card {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
        }
        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .product-image-container {
            position: relative;
            width: 100%;
            height: 180px;
            overflow: hidden;
            background: #ffffff;
        }
        .product-image {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: auto;
            height: auto;
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
        }
        .product-info {
            padding: 12px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .product-name {
            font-size: 0.95em;
            color: #333;
            text-decoration: none;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.3;
            height: 2.6em;
        }
        .product-name:hover {
            color: #007185;
        }
        .product-price {
            color: #B12704;
            font-size: 1.1em;
            font-weight: 500;
            margin: 8px 0;
        }
        .add-to-cart-btn {
            width: 100%;
            padding: 8px;
            background: #007185;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.2s;
            font-size: 0.9em;
            margin-top: auto;
        }
        .add-to-cart-btn:hover {
            background: #005a6a;
        }
        .no-results {
            text-align: center;
            padding: 30px;
            color: #666;
            font-size: 1em;
            grid-column: 1 / -1;
            background: white;
            border-radius: 8px;
        }
        @media (max-width: 768px) {
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            }
            .product-image-container {
                height: 150px;
            }
        }
        /* Custom adjustment for Samsung product image */
        .product-image[alt*="Samsung"] {
            max-width: 75%;
            max-height: 75%;
        }
        .category-select {
            padding: 8px 12px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-right: 10px;
            background-color: white;
            min-width: 200px;
        }

        .category-select:focus {
            outline: none;
            border-color: #007185;
        }

        .submit-button {
            padding: 8px 20px;
            background-color: #007185;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        .submit-button:hover {
            background-color: #005a6e;
        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

<%
    String productName = request.getParameter("productName");
    String category = request.getParameter("category");
%>

<div class="container">
    <h1 class="page-title">Our Products</h1>
    
    <div class="filters">
        <form method="get" action="listprod.jsp" class="search-box">
            <input type="text" name="productName" placeholder="Search products..." 
                   value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
        </form>
        <div class="category-filter">
            <form method="get" action="listprod.jsp" style="margin: 0;">
                <select name="category" onchange="this.form.submit()">
                    <option value="">All Categories</option>
                    <%
                    try {
                        // New connection for categories
                        Connection catCon = DriverManager.getConnection(url, uid, pw);
                        Statement catStmt = catCon.createStatement();
                        ResultSet catRst = catStmt.executeQuery("SELECT DISTINCT categoryName FROM category ORDER BY categoryName");
                        
                        String currentCategory = request.getParameter("category");
                        while (catRst.next()) {
                            String catName = catRst.getString("categoryName");
                            boolean isSelected = catName.equals(currentCategory);
                    %>
                            <option value="<%= catName %>" <%= isSelected ? "selected" : "" %>><%= catName %></option>
                    <%
                        }
                        catRst.close();
                        catStmt.close();
                        catCon.close();
                    } catch (SQLException ex) {
                        out.println("<!-- Category loading error: " + ex + " -->");
                    }
                    %>
                </select>
                <% if (productName != null && !productName.trim().isEmpty()) { %>
                    <input type="hidden" name="productName" value="<%= productName %>">
                <% } %>
            </form>
        </div>
    </div>

    <div class="product-grid">
        <%
        try {
            Connection con = DriverManager.getConnection(url, uid, pw);
            
            String sql = "SELECT p.productId, p.productName, p.productPrice, p.productImageURL, c.categoryName " +
                        "FROM product p " +
                        "JOIN category c ON p.categoryId = c.categoryId " +
                        "WHERE 1=1";
            
            if (productName != null && !productName.trim().isEmpty()) {
                sql += " AND p.productName LIKE ?";
            }
            if (category != null && !category.trim().isEmpty()) {
                sql += " AND c.categoryName = ?";
            }
            
            PreparedStatement pstmt = con.prepareStatement(sql);
            
            int paramIndex = 1;
            if (productName != null && !productName.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + productName + "%");
            }
            if (category != null && !category.trim().isEmpty()) {
                pstmt.setString(paramIndex, category);
            }
            
            ResultSet rst = pstmt.executeQuery();
            
            boolean hasProducts = false;
            while (rst.next()) {
                hasProducts = true;
                int productId = rst.getInt("productId");
                String name = rst.getString("productName");
                double price = rst.getDouble("productPrice");
                String imageURL = rst.getString("productImageURL");
        %>
                <div class="product-card">
                    <a href="product.jsp?id=<%= productId %>">
                        <div class="product-image-container">
                            <img src="<%= imageURL %>" alt="<%= name %>" class="product-image">
                        </div>
                    </a>
                    <div class="product-info">
                        <a href="product.jsp?id=<%= productId %>" class="product-name"><%= name %></a>
                        <div class="product-price">$<%= String.format("%.2f", price) %></div>
                        <form action="addcart.jsp" method="post">
                            <input type="hidden" name="id" value="<%= productId %>">
                            <input type="hidden" name="name" value="<%= name %>">
                            <input type="hidden" name="price" value="<%= price %>">
                            <button type="submit" class="add-to-cart-btn">Add to Cart</button>
                        </form>
                    </div>
                </div>
        <%
            }
            
            if (!hasProducts) {
        %>
                <div class="no-results">
                    <p>No products found matching your criteria.</p>
                </div>
        <%
            }
            
            con.close();
        } catch (SQLException ex) {
            out.println("SQLException: " + ex);
        }
        %>
    </div>
</div>

</body>
</html>
