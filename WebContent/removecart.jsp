<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {
    String id = request.getParameter("id");
    
    if (id != null) {
        // Remove the product
        productList.remove(id);
        session.setAttribute("productList", productList);
    }
}

// Back to cart page
response.sendRedirect("showcart.jsp");
%> 