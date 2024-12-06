<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<%
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String email = request.getParameter("email");
String phone = request.getParameter("phonenum");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalCode = request.getParameter("postalCode");
String country = request.getParameter("country");
String userid = request.getParameter("userid");
String password = request.getParameter("password");

boolean registrationSuccess = false;

if (firstName != null && lastName != null && email != null && phone != null && address != null &&
    city != null && state != null && postalCode != null && country != null && userid != null && password != null) {
    try {
        Connection con = DriverManager.getConnection(url, uid, pw);
        String sql = "INSERT INTO customer (firstName, lastName, email, phone, address, city, state, postalCode, country, userid, password) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, firstName);
        stmt.setString(2, lastName);
        stmt.setString(3, email);
        stmt.setString(4, phone);
        stmt.setString(5, address);
        stmt.setString(6, city);
        stmt.setString(7, state);
        stmt.setString(8, postalCode);
        stmt.setString(9, country);
        stmt.setString(10, userid);
        stmt.setString(11, password);

        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            registrationSuccess = true;
            session.setAttribute("authenticatedUser", userid);
        }

        stmt.close();
        con.close();
    } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
    }
}

if (registrationSuccess) {
    response.sendRedirect("index.jsp");
} else {
    session.setAttribute("registrationError", "Registration failed. Please try again.");
    response.sendRedirect("register.jsp");
}
%> 