<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<%
try {
    String userIdString = (String) session.getAttribute("authenticatedUser");
    if (userIdString == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get the numeric customerId from the database using the username
    int customerId = 0;
    Connection con = DriverManager.getConnection(url, uid, pw);
    String customerQuery = "SELECT customerId FROM customer WHERE userid = ?";
    PreparedStatement custStmt = con.prepareStatement(customerQuery);
    custStmt.setString(1, userIdString);
    ResultSet custRs = custStmt.executeQuery();
    
    if (custRs.next()) {
        customerId = custRs.getInt("customerId");
    } else {
        throw new Exception("Customer not found");
    }

    String productId = request.getParameter("productId");

    // Check if the user has purchased this product
    String purchaseCheck = "SELECT * FROM orderproduct op JOIN ordersummary os ON op.orderId = os.orderId " +
                          "WHERE os.customerId = ? AND op.productId = ?";
    PreparedStatement purchaseStmt = con.prepareStatement(purchaseCheck);
    purchaseStmt.setInt(1, customerId);
    purchaseStmt.setString(2, productId);
    ResultSet purchaseRs = purchaseStmt.executeQuery();

    if (!purchaseRs.next()) {
        // User hasn't purchased this product
        response.sendRedirect("product.jsp?id=" + productId + "&error=notPurchased");
        return;
    }

    // Check if the user has already reviewed this product
    String checkReviewQuery = "SELECT * FROM review WHERE productId = ? AND customerId = ?";
    PreparedStatement checkStmt = con.prepareStatement(checkReviewQuery);
    checkStmt.setString(1, productId);
    checkStmt.setInt(2, customerId);
    ResultSet checkRs = checkStmt.executeQuery();

    if (checkRs.next()) {
        // Review already exists
        response.sendRedirect("product.jsp?id=" + productId + "&error=reviewExists");
        return;
    }

    int reviewRating = Integer.parseInt(request.getParameter("reviewRating"));
    String reviewComment = request.getParameter("reviewComment");

    // Get current date and time
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String reviewDate = formatter.format(new Date());

    String sql = "INSERT INTO review (productId, customerId, reviewRating, reviewComment, reviewDate) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, productId);
    pstmt.setInt(2, customerId);
    pstmt.setInt(3, reviewRating);
    pstmt.setString(4, reviewComment);
    pstmt.setString(5, reviewDate);
    pstmt.executeUpdate();

    con.close();

    response.sendRedirect("product.jsp?id=" + productId);

} catch (SQLException ex) {
    out.println("<p>Error submitting review: " + ex.getMessage() + "</p>");
} catch (Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
}
%> 