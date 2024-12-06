<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Product Details - GADA ELECTRONICS</title>
    <style>
        .main-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .navigation-path {
            margin: 20px 0;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        .product-layout {
            display: grid;
            grid-template-columns: 450px 1fr;
            gap: 40px;
            margin-top: 20px;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .image-section {
            padding: 20px;
            background: #fff;
            border-radius: 8px;
        }
        .product-image {
            width: 100%;
            height: auto;
            border-radius: 8px;
            object-fit: contain;
        }
        .product-details {
            padding: 20px;
        }
        .product-title {
            font-size: 24px;
            font-weight: 500;
            color: #0F1111;
            margin-bottom: 10px;
        }
        .product-description {
            color: #565959;
            font-size: 16px;
            line-height: 1.5;
            margin: 15px 0;
        }
        .product-price {
            font-size: 28px;
            color: #B12704;
            margin: 20px 0;
        }
        .purchase-section {
            background: #f8f9fa;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-top: 20px;
        }
        .quantity-selector {
            margin: 15px 0;
        }
        .quantity-selector select {
            padding: 8px;
            width: 70px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: #fff;
        }
        .add-to-cart-btn {
            width: 100%;
            padding: 12px 0;
            background: #FFD814;
            border: 1px solid #FCD200;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            margin: 10px 0;
        }
        .add-to-cart-btn:hover {
            background: #eff700;
        }
        .back-link {
            color: #007185;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover {
            color: #C7511F;
            text-decoration: underline;
        }
        .reviews-section {
            margin-top: 40px;
            padding: 20px;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .review-item {
            padding: 15px 0;
            border-bottom: 1px solid #ddd;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .rating {
            color: #fff71c;
        }
        @media (max-width: 768px) {
            .product-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="main-container">
        <div class="navigation-path">
            <a href="listprod.jsp" class="back-link">← Back to Products</a>
        </div>
        
        <%
        String productId = request.getParameter("id");
        try {
            Connection con = DriverManager.getConnection(url, uid, pw);
            String sql = "SELECT * FROM product WHERE productId = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, productId);
            ResultSet rst = pstmt.executeQuery();

            if (rst.next()) {
                String productName = rst.getString("productName");
                String productDesc = rst.getString("productDesc");
                double productPrice = rst.getDouble("productPrice");
                String productImage = rst.getString("productImageURL");
        %>
                <div class="product-layout">
                    <div class="image-section">
                        <img src="<%= productImage %>" alt="<%= productName %>" class="product-image">
                    </div>
                    
                    <div class="product-details">
                        <h1 class="product-title"><%= productName %></h1>
                        <p class="product-description"><%= productDesc %></p>
                        <div class="product-price">$<%= String.format("%.2f", productPrice) %></div>
                        
                        <div class="purchase-section">
                            <form action="addcart.jsp" method="post">
                                <input type="hidden" name="id" value="<%= productId %>">
                                <input type="hidden" name="name" value="<%= productName %>">
                                <input type="hidden" name="price" value="<%= productPrice %>">
                                
                                <div class="quantity-selector">
                                    <label for="quantity">Quantity: </label>
                                    <select name="quantity" id="quantity">
                                        <% for(int i = 1; i <= 10; i++) { %>
                                            <option value="<%= i %>"><%= i %></option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <button type="submit" class="add-to-cart-btn">Add to Cart</button>
                            </form>
                            
                            <% if (session.getAttribute("authenticatedUser") == null) { %>
                                <p style="text-align: center; margin-top: 10px;">
                                    <a href="login.jsp" style="color: #007185;">Sign in</a> to purchase
                                </p>
                            <% } %>
                        </div>
                    </div>
                </div>
        <%
            }
            con.close();
        } catch (SQLException ex) {
            out.println("<p>Error loading product: " + ex.getMessage() + "</p>");
        }
        %>
        
        <!-- Reviews Section -->
        <div class="reviews-section">
            <h2 style="color: #0F1111; margin-bottom: 20px;">Customer Reviews</h2>
            
            <% 
            // Add error message display
            String error = request.getParameter("error");
            if ("reviewExists".equals(error)) { 
            %>
                <div style="color: #B12704; background-color: #FFF4F4; padding: 10px; 
                            border-radius: 4px; margin-bottom: 20px; border: 1px solid #B12704;">
                    You have already submitted a review for this product.
                </div>
            <% } else if ("notPurchased".equals(error)) { %>
                <div style="color: #B12704; background-color: #FFF4F4; padding: 10px; 
                            border-radius: 4px; margin-bottom: 20px; border: 1px solid #B12704;">
                    You can only review products you have purchased.
                </div>
            <% } %>
            
            <% 
            boolean canReview = false;
            if (session.getAttribute("authenticatedUser") != null) {
                // Check if user has purchased the product and hasn't reviewed it yet
                try {
                    Connection conCheck = DriverManager.getConnection(url, uid, pw);
                    String userIdString = (String) session.getAttribute("authenticatedUser");
                    
                    // First get customerId
                    String customerIdQuery = "SELECT customerId FROM customer WHERE userid = ?";
                    PreparedStatement custStmt = conCheck.prepareStatement(customerIdQuery);
                    custStmt.setString(1, userIdString);
                    ResultSet custRs = custStmt.executeQuery();
                    
                    if (custRs.next()) {
                        int customerId = custRs.getInt("customerId");
                        
                        // Check if purchased and not reviewed
                        String checkQuery = 
                            "SELECT 1 FROM orderproduct op " +
                            "JOIN ordersummary os ON op.orderId = os.orderId " +
                            "WHERE os.customerId = ? AND op.productId = ? " +
                            "AND NOT EXISTS (SELECT 1 FROM review r WHERE r.customerId = ? AND r.productId = ?)";
                        
                        PreparedStatement checkStmt = conCheck.prepareStatement(checkQuery);
                        checkStmt.setInt(1, customerId);
                        checkStmt.setString(2, productId);
                        checkStmt.setInt(3, customerId);
                        checkStmt.setString(4, productId);
                        
                        ResultSet checkRs = checkStmt.executeQuery();
                        canReview = checkRs.next(); // Can review if query returns a result
                    }
                    conCheck.close();
                } catch (SQLException ex) {
                    out.println("Error checking review eligibility: " + ex);
                }
                
                if (canReview) {
            %>
                    <div class="review-form">
                        <h3 style="color: #0F1111; margin-bottom: 15px;">Write a Review</h3>
                        <form action="submitReview.jsp" method="post" style="margin-bottom: 30px;">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            
                            <div class="rating-select" style="margin-bottom: 15px;">
                                <label for="reviewRating" style="display: block; margin-bottom: 8px;">Rating:</label>
                                <select name="reviewRating" id="reviewRating" required 
                                        style="padding: 8px; border: 1px solid #ddd; border-radius: 4px; width: 200px;">
                                    <option value="">Select a rating</option>
                                    <option value="5">★★★★★ (5 stars)</option>
                                    <option value="4">★★★★☆ (4 stars)</option>
                                    <option value="3">★★★☆☆ (3 stars)</option>
                                    <option value="2">★★☆☆☆ (2 stars)</option>
                                    <option value="1">★☆☆☆☆ (1 star)</option>
                                </select>
                            </div>
                            
                            <div class="review-text" style="margin-bottom: 15px;">
                                <label for="reviewComment" style="display: block; margin-bottom: 8px;">Your Review:</label>
                                <textarea name="reviewComment" id="reviewComment" required
                                        style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; 
                                        min-height: 100px; resize: vertical;"></textarea>
                            </div>
                            
                            <button type="submit" style="background: #ffc800; color: #000; padding: 8px 30px; 
                                    border: none; border-radius: 4px; cursor: pointer; font-size: 16px;">
                                Submit Review
                            </button>
                        </form>
                    </div>
            <%  } else { %>
                    <div style="margin-bottom: 20px; padding: 10px; background-color: #F0F2F2; border-radius: 4px;">
                        <p>You must purchase this product before writing a review, or you have already submitted a review.</p>
                    </div>
            <%  
                }
            } 
            %>

            <!-- Display Reviews -->
            <%
            try {
                Connection con = DriverManager.getConnection(url, uid, pw);
                String reviewSql = "SELECT r.reviewRating, r.reviewComment, r.reviewDate, " +
                                 "c.firstName, c.lastName " +
                                 "FROM review r JOIN customer c ON r.customerId = c.customerId " +
                                 "WHERE r.productId = ? ORDER BY r.reviewDate DESC";
                PreparedStatement reviewStmt = con.prepareStatement(reviewSql);
                reviewStmt.setString(1, productId);
                ResultSet reviewRs = reviewStmt.executeQuery();

                if (!reviewRs.isBeforeFirst()) {
            %>
                    <p style="color: #565959; font-style: italic;">No reviews yet. Be the first to review this product!</p>
            <%
                } else {
                    while (reviewRs.next()) {
                        int rating = reviewRs.getInt("reviewRating");
                        String reviewText = reviewRs.getString("reviewComment");
                        String reviewDate = reviewRs.getString("reviewDate");
                        String reviewerName = reviewRs.getString("firstName") + " " + 
                                            reviewRs.getString("lastName").charAt(0) + ".";
            %>
                        <div class="review-item">
                            <div class="review-header">
                                <span class="reviewer-name" style="font-weight: 500;">
                                    <%= reviewerName %>
                                </span>
                                <span class="review-date" style="color: #565959;">
                                    <%= reviewDate %>
                                </span>
                            </div>
                            <div class="rating" style="margin: 8px 0;">
                                <% for (int i = 0; i < rating; i++) { %>
                                    <span style="color: #e5ff1c;">★</span>
                                <% } %>
                                <% for (int i = rating; i < 5; i++) { %>
                                    <span style="color: #DDD;">☆</span>
                                <% } %>
                            </div>
                            <div class="review-text" style="color: #0F1111; margin-top: 10px;">
                                <%= reviewText %>
                            </div>
                        </div>
            <%
                    }
                }
                con.close();
            } catch (SQLException ex) {
                out.println("<p>Error loading reviews: " + ex.getMessage() + "</p>");
            }
            %>
        </div>
    </div>
</body>
</html>
