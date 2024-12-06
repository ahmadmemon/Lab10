<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String userid = request.getParameter("userid");
String password = request.getParameter("password");
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String email = request.getParameter("email");
String phonenum = request.getParameter("phonenum");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalCode = request.getParameter("postalCode");
String country = request.getParameter("country");

try {
    Connection con = DriverManager.getConnection(url, uid, pw);
    
    // Insert into customer table without specifying customerId (let it auto-increment)
    String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    
    pstmt.setString(1, firstName);
    pstmt.setString(2, lastName);
    pstmt.setString(3, email);
    pstmt.setString(4, phonenum);
    pstmt.setString(5, address);
    pstmt.setString(6, city);
    pstmt.setString(7, state);
    pstmt.setString(8, postalCode);
    pstmt.setString(9, country);
    pstmt.setString(10, userid);
    pstmt.setString(11, password);

    int rows = pstmt.executeUpdate();
    if (rows > 0) {
        session.setAttribute("authenticatedUser", userid);
        response.sendRedirect("index.jsp");  // Redirect to home page after successful creation
    } else {
        out.println("<h1>Failed to create account.</h1>");
    }
    
    con.close();
} catch (SQLException e) {
    out.println("<h1>Error creating account:</h1>");
    out.println("<p>" + e.getMessage() + "</p>");
}
%>