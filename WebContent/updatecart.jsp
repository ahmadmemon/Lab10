<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {    
    String id = request.getParameter("id");
    String quantity = request.getParameter("quantity");

    if (id != null && quantity != null) {
        // Convert quantity to int
        int qty = Integer.parseInt(quantity);
        
        if (qty <= 0) {
            // If quantity is 0 or negative, remove the product
            productList.remove(id);
        } else {
            // Update the quantity
            ArrayList<Object> product = productList.get(id);
            if (product != null) {
                product.set(3, qty); // Index 3 is quantity
            }
        }
        
        session.setAttribute("productList", productList);
    }
}

// Back to cart page
response.sendRedirect("showcart.jsp");
%> 