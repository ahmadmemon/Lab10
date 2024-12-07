<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
try {
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList != null) {    
        String id = request.getParameter("id");
        String quantity = request.getParameter("quantity");

        if (id != null && quantity != null) {
            // Convert quantity to int
            try {
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
            } catch (NumberFormatException e) {
                // Handle invalid number format
            }
        }
    }
} catch (Exception e) {
    // Handle any other exceptions
}

// Back to cart page
response.sendRedirect("showcart.jsp");
%> 