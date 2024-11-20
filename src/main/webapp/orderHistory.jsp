<%@ page import="java.util.List" %>
<%@ page import="com.model.Order" %>
<%@ page import="com.model.OrderItem" %>
<%@ page import="com.model.User" %>
<%@ page import="com.dao.OrderDAO" %>
<%@ page import="com.daoimp.OrderDAOImp" %>
<%@ page import="com.model.Address"
         import="java.util.stream.Collectors"
%>

<!-- Header -->
   <%@include file="header.jsp"%>

<%@include file="popup.jsp"%>


 <% String error = (String) session.getAttribute("error");
     if (error != null) { %>
     <script>
         showPopup("<%=error%>");
       </script>
  <% session.removeAttribute("error"); } %>

<!DOCTYPE html>
<html>
<head>
    <title>Order History</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin:0px;
            display: flex;
            min-height: 100vh;
            background-color:#DDD0C8;
            flex-direction: column;
        }
        .order-history-container {
            width: 90%;
            padding: 2% 5%;
            padding-top: 120px;
            flex:1;
        }

        .no-product{
            text-align: center;
        }
        .no-product a{
            color: #323232;
            text-decoration: none;
            cursor:pointer;
        }
        .no-product a:hover{
            border-bottom: 2px solid  #323232;
        }
        .order {
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
        .order-id, .order-date {
            font-size: 18px;
            color: #333;
        }
        .order-items {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto;
        }

        .order-items th{
            padding: 8px 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .order-items td {
            padding: 8px 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
            padding-left: 3%;
        }
        .order-items th {
            background-color: #f8f8f8;
            font-size: 16px;
            color: #333;
        }

        .item-name, .item-price, .item-quantity, .item-total, .item-address, .item-status {
            font-size: 16px;
            color: #777;
        }
        .item-name a{
            color:#333;
            text-decoration: none;
        }
        .item-name a:hover{
             color:#1a7ac4;
        }
        .item-image img {
            width: 80px;
            height: auto;
        }
        .item-image img:hover{
            transform: scale(1.2);
         }
        .order-total {
            font-size: 18px;
            color: #333;
            font-weight: bold;
            margin-left: 5%;
            margin-top: 10px;
        }

        .order-again-btn, .order-cancel-btn{
           color: #fff;
           background: #e7e7e7;
           position: relative;
           overflow: hidden;
           border: none;
           border-radius: 5px;
           padding: 10px 20px;
           font-size: 16px;
           cursor: pointer;
       }

       .order-again-btn::before{
           content: '';
           position: absolute;
           top: 0;
           left: -10%;
           width: 120%;
           height: 100%;
           background: #000;
           z-index: 1;
           transform: skew(-30deg) translateX(-100%);
           transition: transform 0.5s cubic-bezier(0.3, 1, 0.8, 1);
       }
       .order-cancel-btn::before{
              content: '';
              position: absolute;
              top: 0;
              left: -10%;
              width: 120%;
              height: 100%;
              background: #000;
              z-index: 1;
              transform: skew(-30deg) translateX(-100%);
              transition: transform 0.5s cubic-bezier(0.3, 1, 0.8, 1);
       }

       .order-again-btn:hover::before {
           transform: skew(-30deg) translateX(0);

       }
       .order-cancel-btn:hover::before{
          transform: skew(-30deg) translateX(0);

      }

      .order-again-btn span{
           position: relative;
           mix-blend-mode: difference;
           z-index: 2;
      }
      .order-cancel-btn span {
          position: relative;
          mix-blend-mode: difference;
          z-index: 2;
      }
        .hidden_forms{
            display:flex;
            align-items: center;
            justify-content: space-between;
            padding-left: 3%;
        }
    </style>
</head>
<body>

    <div class="order-history-container">


        <%
            User user = (User) session.getAttribute("user");
            OrderDAO orderDAO = new OrderDAOImp();
            orderDAO.connect();
            List<Order> orders = (List<Order>) orderDAO.getUserOrders(user);
            if (orders == null || orders.isEmpty()) {
        %>
        <div class="no-product">
            <h1>Your Orders</h1>
            <p>No products have been ordered.</p><br>
            <p><a href="home.jsp">Click here</a> to order products</p>
        </div>
        <%
            } else {
                for (Order order : orders) { %>
                <div class="order">
                    <div class="order-header">
                        <span class="order-id">Order ID: <%= order.getOrder_id() %></span>
                        <span class="order-date">Date: <%= order.getOrderDate() %></span>
                    </div>

                    <!-- Table headers for product details -->
                    <table class="order-items">
                        <tr>
                            <th>Product</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Address</th>
                            <th>Payment</th>
                            <th>Status</th>
                        </tr>

                        <!-- Display order items -->
                        <% boolean displayAddressAndStatus = true; %>
                        <% for (OrderItem item : order.getOrderItems()) { %>
                            <tr class="order-item">
                                <td class="item-image">
                                    <a href="productDetails.jsp?id=<%= item.getProduct().getP_id() %>">
                                        <img src="<%= item.getProduct().getImg_url() %>" alt="<%= item.getProduct().getName() %>"></a>
                                </td>
                                <td class="item-name">
                                    <a href="productDetails.jsp?id=<%= item.getProduct().getP_id() %>">
                                        <%= item.getProduct().getName() %></td>
                                    </a>
                                <td class="item-price">Rs. <%= item.getProduct().getPrice() %></td>
                                <td class="item-quantity" style="padding-left: 5%;"><%= item.getQuantity() %></td>
                                <td class="item-total"><i class="bi bi-currency-rupee"></i><%= item.getProduct().getPrice() * item.getQuantity() %></td>


                                <% if (displayAddressAndStatus) { %>
                                    <td class="item-address" rowspan="<%= order.getOrderItems().size() %>"
                                                                    style="width: 20%;text-align: left;">
                                            <%= order.getAddress() %>
                                    </td>
                                    <td class="item-payment" style="padding-left: 1%;text-align: center;"
                                            rowspan="<%= order.getOrderItems().size() %>"><%= order.getPaymentType() %></td>
                                    <td class="item-status"  rowspan="<%= order.getOrderItems().size() %>"><%= order.getStatus() %></td>
                                    <% displayAddressAndStatus = false; %>
                                <% } %>
                            </tr>
                        <% } %>
                    </table>

                    <div class="hidden_forms">

                        <form action="orderAgainServlet" method="POST">
                            <input type="hidden" name="selectedOrderItems"
                                 value="<%=
                                     order.getOrderItems().stream()
                                          .map(item -> item.getProduct().getP_id() + "," + item.getQuantity())
                                          .collect(Collectors.joining(";"))
                                 %>">
                            <button type="submit" class="order-again-btn"><span>Order Again</span></button>
                        </form>

                        <div class="order-total"><i class="bi bi-currency-rupee"></i><%= order.getTotalPrice() %></div>

                        <form action="orderCancelServlet" method="POST">
                            <input type="hidden" name="canceledItems"
                                 value="<%=
                                       order.getOrderItems().stream()
                                              .map(item -> String.valueOf(item.getOrder_item_id()))
                                              .collect(Collectors.joining(","))
                                 %>">
                            <input type="hidden" name="canceledOrder"
                                 value="<%= order.getOrder_id()%>">

                            <input type="hidden" name="selectedOrderItems"
                                 value="<%=
                                   order.getOrderItems().stream()
                                      .map(item -> item.getProduct().getP_id() + "," + item.getQuantity())
                                      .collect(Collectors.joining(";"))
                             %>">
                              <%if(!order.getStatus().equals("Success")){%>
                                   <button type="submit" class="order-cancel-btn"><span>Order Cancel</span></button>
                            <%}else{%>
                                <button type="submit" class="order-cancel-btn">return Product</button>
                            <%}%>
                        </form>
                    </div>
                </div>
            <% }} %>
    </div>

    <!-- Footer -->
            <%@include file="footer.jsp"%>

</body>
</html>
