<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

if (username != null && password != null) {
    try {
        Connection con = DriverManager.getConnection(url, uid, pw);
        String sql = "SELECT * FROM customer WHERE userid = ? AND password = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, username);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            // Successful login
            session.setAttribute("authenticatedUser", username);
            session.removeAttribute("loginMessage");
            response.sendRedirect("index.jsp");
        } else {
            // Failed login
            session.setAttribute("loginMessage", "Invalid username or password.");
            response.sendRedirect("login.jsp");
        }

        rs.close();
        stmt.close();
        con.close();
    } catch (SQLException e) {
        session.setAttribute("loginMessage", "Database error: " + e.getMessage());
        response.sendRedirect("login.jsp");
    }
} else {
    session.setAttribute("loginMessage", "Please enter both username and password.");
    response.sendRedirect("login.jsp");
}
%>
