<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<%
try {
    // Get customer ID from session
    String userid = (String) session.getAttribute("authenticatedUser");
    if (userid == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get form parameters
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String newPassword = request.getParameter("newPassword");

    // Connect to database
    Connection con = DriverManager.getConnection(url, uid, pw);

    if (newPassword != null && !newPassword.trim().isEmpty()) {
        // Update including password
        String sql = "UPDATE Customer SET firstName=?, lastName=?, email=?, phonenum=?, address=?, city=?, state=?, postalCode=?, country=?, password=? WHERE userid=?";
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
        pstmt.setString(10, newPassword);
        pstmt.setString(11, userid);
        pstmt.executeUpdate();
    } else {
        // Update without changing password
        String sql = "UPDATE Customer SET firstName=?, lastName=?, email=?, phonenum=?, address=?, city=?, state=?, postalCode=?, country=? WHERE userid=?";
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
        pstmt.executeUpdate();
    }

    con.close();

    session.setAttribute("updateMessage", "Account information updated successfully!");
    response.sendRedirect("editAccount.jsp");

} catch (SQLException ex) {
    session.setAttribute("updateMessage", "Error updating account: " + ex.getMessage());
    response.sendRedirect("editAccount.jsp");
} catch (Exception e) {
    session.setAttribute("updateMessage", "Error updating account: " + e.getMessage());
    response.sendRedirect("editAccount.jsp");
}
%> 