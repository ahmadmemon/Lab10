<%
String contextPath = request.getContextPath();
%>
<header style="width: 100%; background-color: #f8f9f9;">
    <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 20px; border-bottom: 1px solid #ddd;">
        <!-- Left side - Title -->
        <div>
            <a href="index.jsp" style="text-decoration: none; color: #FF0000; font-size: 28px; font-weight: 800; letter-spacing: 1px; text-transform: uppercase;">
                <strong>GADA ELECTRONICS</strong>
            </a>
        </div>

        <!-- Right side - Navigation -->
        <div style="display: flex; gap: 20px; align-items: center;">
            <a href="listprod.jsp" style="text-decoration: none; color: #333; font-weight: 600;">Shop</a>
            <a href="listorder.jsp" style="text-decoration: none; color: #333; font-weight: 600;">Orders</a>
            <a href="showcart.jsp" style="text-decoration: none; color: #333; font-weight: 600;">Cart</a>
            <a href="customer.jsp" style="text-decoration: none; color: #333; font-weight: 600;">About You</a>
            
            <%
            try {
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName != null && !userName.isEmpty()) {
            %>
                    <span style="color: #333; font-weight: 600;">Hello, <%= userName %></span>
                    <a href="logout.jsp" style="text-decoration: none; color: #666; font-weight: 600;">Logout</a>
            <%
                } else {
            %>
                    <a href="login.jsp" style="text-decoration: none; color: #666; font-weight: 600;">Login</a>
                    <a href="createAccount.jsp" style="text-decoration: none; color: #666; font-weight: 600;">Register</a>
            <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
            %>
        </div>
    </div>
</header>