<%@page import="java.util.Map"%>
<%@page import="java.util.Collections"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="com.google.gson.Gson"
        import="java.util.List"
        import="java.util.ArrayList"%>

<%
    int totalUsers = (int) request.getAttribute("totalUsers");
    int totalOrders = (int) request.getAttribute("totalOrders");
    int totalProducts = (int) request.getAttribute("totalProducts");
    double totalOrderPrices = (double) request.getAttribute("totalOrderPrices");

    Map<String, Integer> ordersPerDayOrMonth = (Map<String, Integer>) request.getAttribute("ordersPerDayOrMonth");
    ordersPerDayOrMonth = ordersPerDayOrMonth != null ? ordersPerDayOrMonth : Collections.emptyMap();

    Map<String, Integer> usersByAgeGroup = (Map<String, Integer>) request.getAttribute("usersByAgeGroup");
    usersByAgeGroup = usersByAgeGroup != null ? usersByAgeGroup : Collections.emptyMap();

    Map<String, Integer> productsBySales = (Map<String, Integer>) request.getAttribute("productsBySales");
    productsBySales = productsBySales != null ? productsBySales : Collections.emptyMap();

    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f7fa;
            color: #333;
        }

        .dashboard {
            padding: 20px;
            max-width: 1200px;
            margin: auto;
        }

        .card-container {
            display: flex;
            gap: 20px;
            margin-bottom: 45px;
        }

        .card {
           background: #ffffff;
           padding: 10px;
           border-radius: 10px;
           box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.1);
           text-align: center;
           width: 20%;
        }

        .card h3 {
            font-size: 20px;
            color: #1a7ac4;
        }

        .card p {
            font-size: 18px;
            margin: 10px 0 0;
        }

        .tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .tab {
            padding: 10px 20px;
            margin: 0 5px;
            background: #ffffff;
            color: #1a7ac4;
            border-radius: 5px;
            cursor: pointer;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .tab:hover,
        .tab.active {
            background-color: #1a7ac4;
            color: #ffffff;
        }

        .chart-container {
             position: relative;
             width: 80%;
             margin:0 auto;
         }

        .fade-out {
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .fade-in {
            opacity: 1;
            transition: opacity 0.5s ease;
        }

    </style>
</head>
<body>
    <div class="dashboard">
        <!-- Cards Section -->
        <div class="card-container">
            <div class="card">
                <h3>Total Users</h3>
                <p><%= totalUsers %></p>
            </div>
            <div class="card">
                <h3>Total Orders</h3>
                <p><%= totalOrders %></p>
            </div>
            <div class="card">
                <h3>Total Products</h3>
                <p><%= totalProducts %></p>
            </div>
            <div class="card">
                <h3>Total Sales</h3>
                <p><%= currencyFormatter.format(totalOrderPrices) %></p>
            </div>
            <div class="card">
                <h3>Average Order Value</h3>
                <p><%= totalOrders > 0 ? currencyFormatter.format(totalOrderPrices / totalOrders) : "N/A" %></p>
            </div>
        </div>

        <!-- Tabs Section -->
        <div class="tabs">
            <button class="tab active" data-chart="orders">Orders Trend</button>
            <button class="tab" data-chart="users">Users by Age Group</button>
            <button class="tab" data-chart="products">Product Sales</button>
        </div>

        <div id="chartContainer" class="chart-container">
            <canvas id="dynamicChart"></canvas>
        </div>


    <% Gson gson = new Gson(); %>
    <script id="ordersDataScript" type="application/json">
        <%= gson.toJson(ordersPerDayOrMonth) %>
    </script>
    <script id="ageGroupsDataScript" type="application/json">
        <%= gson.toJson(usersByAgeGroup) %>
    </script>
    <script id="productSalesDataScript" type="application/json">
        <%= gson.toJson(productsBySales) %>
    </script>

</body>
</html>
