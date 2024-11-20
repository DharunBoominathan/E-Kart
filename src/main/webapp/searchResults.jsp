<%@ page import="java.util.List, com.model.Product" %>
<%@ page  import="com.dao.OrderItemDAO"
          import="com.daoimp.OrderItemDAOImp"%>
<%
    // Get the results list and pagination data
    List<Product> results = (List<Product>) request.getAttribute("results");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    int productsPerPage = 8; // Number of products to display per page
%>

<!-- Header -->
<%@include file="header.jsp"%>

<html>
<head>
    <title>Search Results</title>
    <style>
         body {
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
                background-color: #f1f3f6;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
        .product-wrapper{
            margin-top: 90px;
            flex:1;
            justify-items:center;
        }
        .products {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* Four columns */
            gap: 65px; /* Space between cards */
            width: 90%;
        }

        .product-card {
            width: 90%;
            background-color: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            text-decoration: none;
            transition: box-shadow 0.3s ease;
            position:relative;
        }

        .product-card img {
            width: 100%;
            height: 150px;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .product-card:hover {
            box-shadow: 0 0 15px #333;
        }

        .product-card img:hover {
            transform: scale(1.1);
        }

        .product-card h3 {
            font-size: 16px;
            margin-top: 8px;
            color: #333;
        }

        .product-card h3:hover {
            color: #1a7ac4;
        }

        .product-card p {
            color: #333;
            font-weight: bold;
            font-size: 18px;
        }

        .pagination {
            text-align: center;
            margin: 20px auto;
        }

        .pagination a {
            text-decoration: none;
            color: #333;
            margin: 0 5px;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .pagination a:hover {
            background-color: #1a7ac4;
            color: white;
        }

        .pagination a.active {
            background-color: #1a7ac4;
            color: white;
            pointer-events: none;
        }

        .stock{
            width: 30% !important;
            position: absolute;
            top: 25%;
            left: 65%;
            transform: rotate(-30deg);
         }
         .no-stock{
             width: 30% !important;
             position: absolute;
             top: 25%;
             left: 65%;
          }
         .seller{
            width: 50% !important;
            position: absolute;
            top: -28%;
         }
    </style>
</head>
<body>
    <div class="product-wrapper">
    <h1>Search Results</h1>
    <div class="products">
        <%   OrderItemDAO orderItemDAO=new OrderItemDAOImp();
        for (Product product : results) {
        %>
             <a href="productDetails.jsp?id=<%= product.getP_id() %>" class="product-card">
                 <%if(orderItemDAO.getOrderCountOfProduct(product.getP_id())>0){%>
                      <img src="images/best.png" alt="best-seller" class="seller">
                 <%}%>
                   <img src="<%= product.getImg_url() %>" alt="<%= product.getName() %>">
                   <h3><%= product.getName() %></h3>
                   <%if(product.getStock()==0){%>
                      <img src="images/soldout.png" alt="out-of-stock" class="no-stock">
                  <%}else if(product.getStock()<5){%>
                     <img src="images/limited.png" alt="limited-stock" class="stock">
                  <%}%>
                   <p><i class="bi bi-currency-rupee"></i><%= product.getPrice() %></p>
             </a>
        <%
        }
        %>
    </div>

    <!-- Pagination -->
    <div class="pagination">
        <% if (currentPage > 1) { %>
            <a href="searchResultsServlet?query=<%= request.getParameter("query") %>&page=<%= currentPage - 1 %>">Previous</a>
        <% } %>
        <%
        if(totalPages!=1){
        for (int i = 1; i <= totalPages; i++) { %>
            <a href="searchResultsServlet?query=<%= request.getParameter("query") %>&page=<%= i %>"
               class="<%= (i == currentPage) ? "active" : "" %>">
               <%= i %>
            </a>
        <% } }%>
        <% if (currentPage < totalPages) { %>
            <a href="searchResultsServlet?query=<%= request.getParameter("query") %>&page=<%= currentPage + 1 %>">Next</a>
        <% } %>
    </div>
    </div>
    <!-- Footer -->
    <%@include file="footer.jsp"%>
</body>
</html>
