<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>Order History - GADA ELECTRONICS</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f4f4f4;
			margin: 0;
			padding: 0;
			color: #333;
		}
		.container {
			max-width: 1200px;
			margin: 40px auto;
			padding: 20px;
		}
		.page-title {
			color: #333;
			font-size: 24px;
			margin-bottom: 30px;
			padding-bottom: 10px;
			border-bottom: 2px solid #007185;
		}
		.order-card {
			background: white;
			border-radius: 8px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.1);
			margin-bottom: 30px;
			overflow: hidden;
		}
		.order-header {
			background: #007185;
			color: white;
			padding: 15px 20px;
			display: grid;
			grid-template-columns: repeat(4, 1fr);
			gap: 15px;
		}
		.order-header div {
			font-size: 14px;
		}
		.order-header .label {
			font-size: 12px;
			opacity: 0.8;
			margin-bottom: 4px;
		}
		.order-details {
			padding: 20px;
		}
		.product-table {
			width: 100%;
			border-collapse: collapse;
			margin-top: 15px;
		}
		.product-table th {
			background: #f8f9fa;
			padding: 12px;
			text-align: left;
			font-weight: 500;
			color: #333;
			border-bottom: 2px solid #dee2e6;
		}
		.product-table td {
			padding: 12px;
			border-bottom: 1px solid #dee2e6;
		}
		.total-amount {
			text-align: right;
			padding: 15px 20px;
			font-size: 18px;
			color: #B12704;
			border-top: 1px solid #dee2e6;
		}
		.status-badge {
			display: inline-block;
			padding: 4px 8px;
			border-radius: 4px;
			background: #28a745;
			color: white;
			font-size: 12px;
		}
		.product-image {
			width: 50px;
			height: auto;
			margin-right: 10px;
			vertical-align: middle;
		}
	</style>
</head>
<body>
<%@ include file="header.jsp" %>

<div class="container">
	<h1 class="page-title">Order History</h1>

	<%
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	try (Connection con = DriverManager.getConnection(url, uid, pw)) {
		String query = "SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
					  "FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId " +
					  "ORDER BY orderDate DESC";
		PreparedStatement stmt = con.prepareStatement(query);
		ResultSet rs = stmt.executeQuery();

		String productQuery = "SELECT op.productId, op.quantity, op.price, p.productName, p.productImageURL " +
							  "FROM orderproduct op JOIN product p ON op.productId = p.productId " +
							  "WHERE op.orderId = ?";
			PreparedStatement pstmt = con.prepareStatement(productQuery);

		while (rs.next()) {
			int orderId = rs.getInt("orderId");
	%>
			<div class="order-card">
				<div class="order-header">
					<div>
						<div class="label">Order #</div>
						<%= orderId %>
					</div>
					<div>
						<div class="label">Order Date</div>
						<%= rs.getTimestamp("orderDate") %>
					</div>
					<div>
						<div class="label">Customer</div>
						<%= rs.getString("firstName") %> <%= rs.getString("lastName") %>
					</div>
					<div>
						<div class="label">Status</div>
						<span class="status-badge">Completed</span>
					</div>
				</div>

				<div class="order-details">
					<table class="product-table">
						<thead>
							<tr>
								<th>Product</th>
								<th>Quantity</th>
								<th>Price</th>
								<th>Subtotal</th>
							</tr>
						</thead>
						<tbody>
							<%
							pstmt.setInt(1, orderId);
							ResultSet productRs = pstmt.executeQuery();
							while (productRs.next()) {
								double price = productRs.getDouble("price");
								int quantity = productRs.getInt("quantity");
								String productImage = productRs.getString("productImageURL");
							%>
								<tr>
									<td>
										<img src="<%= productImage %>" alt="<%= productRs.getString("productName") %>" class="product-image">
										<%= productRs.getString("productName") %>
									</td>
									<td><%= quantity %></td>
									<td><%= currFormat.format(price) %></td>
									<td><%= currFormat.format(price * quantity) %></td>
								</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>
				<div class="total-amount">
					Total: <%= currFormat.format(rs.getDouble("totalAmount")) %>
				</div>
			</div>
	<%
		}
	} catch (SQLException ex) {
		out.println("<p>Error: " + ex.getMessage() + "</p>");
	}
	%>
</div>

</body>
</html>
