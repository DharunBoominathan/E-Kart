<%@ page session="true" %>
<%@page import="com.google.gson.Gson" %>
<%
    if (session.getAttribute("isAdminLoggedIn") == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="main.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="scripts/main.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="icon" type="image/png" href="../images/tabIcon.png">
</head>
<body>
  <div id="main-content"></div>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
             <a href="../home.jsp" class="logo">
                <img src="../images/logo.png" alt="logo" style="width:90%;">
            </a>
            <ul>
                <li><a href="#" data-content="dashboard" data-url="../dashboardServlet" data-script="/E-Kart/admin/scripts/dashboard.js">Dashboard</a></li>
                <li><a href="#" data-content="users" data-url="../allUsersServlet" >Users</a></li>
                <li><a href="#" data-content="orders" data-url="../allOrdersServlet">Orders</a></li>
                <li> <a href="#" data-content="products" data-url="../allProductsServlet" data-script="/E-Kart/admin/scripts/products.js">Products</a></li>
            </ul>
        </div>
        <!-- Content Area -->
        <div class="content">
            <div id="loading-spinner" class="spinner">
                <div class="spinner-inner"></div>
            </div>
            <div id="dynamic-content">
            </div>

    </div>

</body>
</html>

