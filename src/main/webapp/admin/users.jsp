<%@page import="com.dao.UserDAO" %>
<%@page import="com.model.User" %>
<%@page import="com.daoimp.UserDAOImp" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Collections"
        import="com.model.Order"
        import="com.dao.OrderDAO"
        import="com.daoimp.OrderDAOImp"%>

<%
    // Get the results list and pagination data
    List<User> users = (List<User>) request.getAttribute("results");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    String query = request.getParameter("query");
    OrderDAO orderDAO=new OrderDAOImp();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <style>
          body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f5f7fa;
                color: #333;
            }

            .users {
                background: #ffffff;
                border-radius: 8px;
                box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
                padding: 20px;
                display: flex;
                flex-direction: column;
                min-height: 82vh;
            }

            .heading {
                font-size: 28px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #333;
                text-align: center;
            }

            .user-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }

            .user-table th {
                background-color: #3b5998;
                color: #fff;
                font-weight: bold;
                text-transform: uppercase;
                text-align: center;
            }

            .user-table td {
                background-color: #fafafa;
                border-bottom: 1px solid #ddd;
            }

            .user-table th, .user-table td {
                padding: 15px;
                text-align: left;
                font-size: 16px;
            }

            .user-table tr:nth-child(even) {
                background-color: #f8f9fc;
            }

            .user-table tr:hover {
                background-color: #f1f5fb;
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
    </style>
</head>
<body>
 <div class="heading">User Management</div>
    <div class="users">
        <% if (users != null && !users.isEmpty()) { %>
            <table class="user-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Email</th>
                        <th>Username</th>
                        <th>DOB</th>
                        <th>Phone</th>
                        <th>Total Orders</th>
                        <th>Order IDs</th>

                    </tr>
                </thead>
                <tbody>
                    <% for (User user : users) { %>
                        <tr>
                            <td><%= user.getU_id() %></td>
                            <td><%= user.getEmail() %></td>
                            <td><%= user.getName() %></td>
                            <td><%= user.getDob() %></td>
                            <td><%= user.getPhone() %></td>
                            <td><% orderDAO.connect();
                                 List<Order> userOrders = orderDAO.getUserOrders(user);%>
                                 <%= userOrders.size() %>
                            </td>
                            <td><%
                              for (Order order : userOrders) {
                                %>
                                    <%= order.getOrder_id() %> <!-- Print each order ID -->
                                    <% if (userOrders.indexOf(order) < userOrders.size() - 1) { %>, <% } %>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p>No records found.</p>
        <% } %>
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <button onclick="loadPage3(<%= currentPage - 1 %>)">Previous</button>
            <% } %>
            <% if (totalPages != 1) { %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <button onclick="loadPage3(<%= i %>)" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></button>
                <% } %>
            <% } %>
            <% if (currentPage < totalPages) { %>
                <button onclick="loadPage3(<%= currentPage + 1 %>)">Next</button>
            <% } %>
        </div>
    </div>
</body>
</html>
