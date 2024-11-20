<%@page import="com.dao.OrderItemDAO"
        import="com.model.Order"
        import="com.model.OrderItem"
        import="com.daoimp.OrderDAOImp"
        import="java.util.List"
        import="java.util.Collections"
        import="java.util.Map"%>

<%
    // Get the results list and pagination data
    List<Order> orders = (List<Order>) request.getAttribute("results");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    Map<String, String> filters = (Map<String, String>) request.getAttribute("filters");
    if (filters == null) {
        filters = Collections.emptyMap();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f7fa;
            color: #333;
        }

    .top-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin: 0 auto;
        padding: 20px;
    }

    .heading {
        font-size: 24px;
        font-weight: bold;
        color: #333;
        margin-right: auto;
    }

    /* Filter Section */
    .filters {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        align-items: center;
        margin-left: auto;
    }

    .filter-group label {
        font-size: 14px;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .filter-group input,
    .filter-group select,
    .filters button {
        padding: 10px;
        font-size: 14px;
        border: 1px solid #ccc;
        border-radius: 5px;
        width: 115px;
        background-color: #f5f5f5;
    }

    .filters button {
        background-color: #3b5998;
        color: #fff;
        cursor: pointer;
        font-weight: bold;
        transition: background-color 0.3s ease;
    }

    .filters button:hover {
        background-color: #2d4373;
    }

        .orders {
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            min-height: 78vh;
        }

        .order-content {
            overflow-x: auto;
            flex:1;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-table th, .order-table td {
            padding: 15px;
            text-align: left;
            font-size: 16px;
        }

        .order-table th {
            background-color: #3b5998;
            color: #fff;
            font-weight: bold;
            text-transform: uppercase;
            text-align: center;
        }

        .order-table td {
            background-color: #fafafa;
            border-bottom: 1px solid #ddd;
        }

        .order-table tr:hover td {
            background-color: #f1f1f1;
        }

        .dropdown {
            padding: 5px 10px;
            font-size: 14px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }

        .pagination {
            text-align: center;
            margin: 20px auto;
        }

        .pagination button {
            text-decoration: none;
            color: #333;
            margin: 0 5px;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #fff;
            transition: background-color 0.3s;
        }

        .pagination button:hover {
            background-color: #3b5998;
            color: white;
            cursor: pointer;
        }

        .pagination button.active {
            background-color: #3b5998;
            color: white;
            pointer-events: none;
        }

        .no-product {
            text-align: center;
            font-size: 18px;
            color: #666;
        }

        .no-product a {
            color: #3b5998;
            text-decoration: none;
            font-weight: bold;
        }

        .no-product a:hover {
            border-bottom: 2px solid #3b5998;
        }

        .order-items-table {
            width: 100%;
            border: none;
        }

        .order-items-table td {
            padding: 5px;
            text-align: left;
            font-size: 14px;
        }

        .order-items-table tr {
            border-bottom: 1px solid #ddd;
        }

        .order-items-table td:first-child {
            font-weight: bold;
        }
    </style>
</head>
<body>
   <div class="top-section">
       <div class="heading">Order Management</div>

       <!-- Filter Section -->
       <div class="filters">
                  <div class="filter-group">

                      <input type="text" id="user" name="user" placeholder="Email" value="<%= filters.getOrDefault("user", "") %>">
                  </div>
                  <div class="filter-group">

                      <input type="text" id="product" name="product" placeholder="Product Name" value="<%= filters.getOrDefault("product", "") %>">
                  </div>
                  <div class="filter-group">
                      <label for="fromDate">From:</label> <input type="date" id="fromDate" name="fromDate" style="width: 100px;" value="<%= filters.getOrDefault("fromDate", "") %>">
                  </div>
                  <div class="filter-group" >
                      <label for="toDate">To:</label> <input type="date" id="toDate" name="toDate" style="width: 100px;" value="<%= filters.getOrDefault("toDate", "") %>">
                  </div>
                  <div class="filter-group">
                      <label for="orderStatus">Status</label>
                      <select id="orderStatus" name="orderStatus" style="width: 65px;">
                          <option value="" <%= filters.getOrDefault("orderStatus", "").equals("") ? "selected" : "" %>>All</option>
                          <option value="Pending" <%= filters.getOrDefault("orderStatus", "").equals("Pending") ? "selected" : "" %>>Pending</option>
                          <option value="Shipped" <%= filters.getOrDefault("orderStatus", "").equals("Shipped") ? "selected" : "" %>>Shipped</option>
                          <option value="Delivered" <%= filters.getOrDefault("orderStatus", "").equals("Delivered") ? "selected" : "" %>>Delivered</option>
                          <option value="Cancelled" <%= filters.getOrDefault("orderStatus", "").equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                      </select>
                  </div>
                  <button onclick="applyFilters()">Apply Filters</button>
              </div>
          </div>


    <div class="orders">
        <div class="order-content">
            <% if (orders == null || orders.isEmpty()) { %>
                <div class="no-product">
                    <h1>Your Orders</h1>
                    <p>No products have been ordered.</p><br>
                </div>
            <% } else { %>
                <table class="order-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>User</th>
                            <th style="width: 23%;">Order Items</th>
                            <th>Total Price</th>
                            <th>Payment Type</th>
                            <th>Order Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order order : orders) { %>
                        <tr>
                            <td><%= order.getOrder_id() %></td>
                            <td><%= order.getUser().getEmail() %></td>
                            <td>
                                <table class="order-items-table">
                                    <% for (OrderItem item : order.getOrderItems()) { %>
                                    <tr>
                                        <td><%= item.getProduct().getName() %></td>
                                        <td><%= item.getQuantity() %></td>
                                        <td><i class="bi bi-currency-rupee"><%= item.getQuantity() * item.getProduct().getPrice() %></td>
                                    </tr>
                                    <% } %>
                                </table>
                            </td>
                            <td>Rs. <%= order.getTotalPrice() %></td>
                            <td><%= order.getPaymentType() %></td>
                            <td><%= order.getOrderDate() %></td>
                            <td>
                                <select class="dropdown" onchange="updateStatus('<%= order.getOrder_id() %>', this.value)">
                                    <option value="Pending" <%= order.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                                    <option value="Shipped" <%= order.getStatus().equals("Shipped") ? "selected" : "" %>>Shipped</option>
                                    <option value="Delivered" <%= order.getStatus().equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                    <option value="Cancelled" <%= order.getStatus().equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                                </select>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

       <div class="pagination">
           <% if (currentPage > 1) { %>
               <button onclick="loadPage2(<%= currentPage - 1 %>)">Previous</button>
           <% } %>
           <% if (totalPages != 1) { %>
               <% for (int i = 1; i <= totalPages; i++) { %>
                   <button onclick="loadPage2(<%= i %>)" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></button>
               <% } %>
           <% } %>
           <% if (currentPage < totalPages) { %>
               <button onclick="loadPage2(<%= currentPage + 1 %>)">Next</button>
           <% } %>
       </div>
   </div>
</body>
</html>
