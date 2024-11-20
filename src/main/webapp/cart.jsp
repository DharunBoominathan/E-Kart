<%@page import="com.model.User"%>
<%@page import="com.model.Cart"%>
<%@page import="com.model.Product"%>
<%@page import="com.dao.CartDAO"%>
<%@page import="com.daoimp.CartDAOImp"%>
<%@page import="java.util.List"%>

 <!-- Header -->
     <%@include file="header.jsp"%>

<%@include file="popup.jsp"%>
<%
    if(session.getAttribute("user")==null){
        response.sendRedirect(request.getContextPath()+"/home.jsp");
    }
    else{
%>
<% String removeProductMsg = (String) session.getAttribute("removeProduct");
    if (removeProductMsg != null) { %>
    <script>
         showPopup("<%=removeProductMsg%>");
      </script>
 <% session.removeAttribute("removeProduct"); } %>

 <% String updateProductMsg = (String) session.getAttribute("updateProduct");
     if (updateProductMsg != null) { %>
     <script>
         showPopup("<%=updateProductMsg%>");
       </script>
  <% session.removeAttribute("updateProduct"); } %>

 <% String error = (String) session.getAttribute("error");
     if (error != null) { %>
     <script>
          showAlert("<%=error%>");
       </script>
  <% session.removeAttribute("error"); } %>



<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #DDD0C8 !important;
            margin:0;
            padding:0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .container1{
            flex:1;
            padding-top: 100px;
        }
        .cart-container {
            padding-left: 8%;
            display:flex;
            padding-top: 2%;
        }
        .container2{
            width:60%
        }
        .no-product a{
            color: #323232;
            text-decoration: none;
            cursor:pointer;
        }
        .no-product a:hover{
            border-bottom: 2px solid  #323232;
        }
        .cart-item {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
            text-decoration: none;
            color: #333;
        }
        .cart-item .selectall{
             width:50%;
             text-align: end;
             padding-right: 5%;
        }

        .cart-item .select{
            width: 8%;
        }
        .cart-item img {
            width: 135px;
            height: auto;
            border-radius: 5px;
            margin-right: 20px;
        }
         .cart-item img:hover{
            transform: scale(1.2);
         }
        .cart-item-details {
            display: flex;
            flex-direction: column;
            justify-content: center;
            width: 50%;
        }
        .cart-item-name {
            font-size: 20px;
            font-weight: bold;
            margin: 0;
            color: #333;
        }
        .cart-item-name:hover{
            color:#1a7ac4;
        }

        .cart-item-brand {
            font-size: 14px;
            color: #777;
            margin-top: 5px;
        }
        .cart-item-price {
            font-size: 20px;
            color: #333;
            font-weight: bold;
            margin-top: 10px;
        }
        .cart-item-quantity {
            font-size: 16px;
            color: #333;
            margin-top: 5px;
            display:flex;
        }
        .quant-input {
            padding-left:10px;
        }
        .quant-input input{
            width: 15%;
            text-align: center;
        }
        .quant-input button{
            background: #8d8d8d;
            color: #fff;
            border: none;
        }
        .quant-input button:hover{
            cursor:pointer;
            background: #1a7ac4;
        }
        .remove{
            width: 100%;
            padding: 10px;
            background-color: #e36767;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
         }

         .remove:hover {
             box-shadow: 5px 4px 5px #333;
         }

        .cart-item-btn{
           display: flex;
           flex-direction: column;
           justify-content: center;

        }
        .price-container{
            width: 20%;
            padding-left: 5%;
        }
        .price-items{
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 15px 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
            text-decoration: none;
            color: #333;
        }
        .price-items hr{
            color: black;
            width: 100%;
        }
        .order-now{
            width: 100%;
            padding: 10px;
            background-color: #8d8a8a;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .order-now:hover {
            background-color: #323232;
            color: #fff;
            box-shadow: 5px 4px 5px #333;
        }

    </style>
    <script>
        function toggleSelectAll() {
            var selectAllCheckbox = document.getElementById("selectAll");
            var itemCheckboxes = document.querySelectorAll(".itemCheckbox");
            itemCheckboxes.forEach(function (checkbox) {
                const stock = parseInt(checkbox.getAttribute("data-stock"));
                if (stock != 0) {
                    checkbox.checked = selectAllCheckbox.checked;
            }});
            calculateTotal();
        }

        function calculateTotal() {
                let totalPrice = 0;
                let selectedCount = 0;

                document.querySelectorAll(".itemCheckbox:checked").forEach(function (checkbox) {
                    const cartItemId = checkbox.getAttribute("data-cart-item-id");
                    const productPrice = parseFloat(document.getElementById("quantity-" + cartItemId).getAttribute("data-price"));
                    const quantity = parseInt(document.getElementById("quantity-" + cartItemId).value);
                    totalPrice += productPrice * quantity;
                    selectedCount++;
                });

                document.getElementById("selectedCount").innerText = selectedCount;
                document.getElementById("totalPrice").innerText = totalPrice;
        }

        function toggleSelectAllState() {
            var itemCheckboxes = document.querySelectorAll(".itemCheckbox");
            var selectAllCheckbox = document.getElementById("selectAll");
            var allChecked = true;
            itemCheckboxes.forEach(function (checkbox) {
                if (!checkbox.checked) {
                    allChecked = false;
                }
            });
            selectAllCheckbox.checked = allChecked;
            calculateTotal();
        }

        function updateQuant(cartItemId, change) {
            const quantityInput = document.getElementById("quantity-" + cartItemId);
            let quantity = parseInt(quantityInput.value);
            let stock=parseInt(document.getElementById("cartItem-" + cartItemId).getAttribute("data-stock"));
            if (isNaN(quantity)) quantity = 1;
            quantity += change;
            if (quantity < 1) quantity = 1;
            if(quantity>stock){
                     showAlert("No more Stock available to order");
            }
            else{
                quantityInput.value = quantity;
                document.getElementById("quantity-"+cartItemId).value=quantity;
                const price = parseInt(document.getElementById("quantity-" + cartItemId).getAttribute("data-price"));
                const totalCost = price * quantity;
                document.getElementById("price-" + cartItemId).innerText = totalCost;
                calculateTotal();
                updateQuantityInDB(cartItemId, quantity);
            }
        }
        function updateQuantityInDB(cartItemId, quantity) {
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "updateCartServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    console.log("Quantity updated successfully.");
                }
            };

            xhr.send("cart_id=" + cartItemId + "&quantity=" + quantity);
        }

        document.addEventListener("DOMContentLoaded", function () {
            const cartItemCheckboxes = document.querySelectorAll(".itemCheckbox");

            cartItemCheckboxes.forEach(function (checkbox) {
                checkbox.addEventListener("click", function () {
                    const stock = parseInt(checkbox.getAttribute("data-stock"));

                   if (stock === 0 && checkbox.checked) {
                        showAlert("This item is out of stock and cannot be selected.");
                        checkbox.checked = false;
                    }
                });
            });
        });

    </script>
</head>
<body>


   <div class="container1">
            <div class="cart-container">
              <div class="container2">
                <div class="cart-item">
                    <div class="cart-item-details">
                        <h3>Shopping Cart</h3>
                    </div>
                    <div class="selectall">
                        <input type="checkbox" id="selectAll" onclick="toggleSelectAll()"> Select All Products
                    </div>
                </div>
                <form action="orderServlet" method="post">
                    <%
                        User user = (User) session.getAttribute("user");
                        CartDAO cartDAO = new CartDAOImp();
                        List<Cart> cartItems = (List<Cart>) cartDAO.getUserCart(user);

                        if (cartItems == null || cartItems.isEmpty()) {
                    %>
                        <p>No products in Cart. Please add products to the cart.</p><br>
                        <p class="no-product" ><a href="home.jsp">Click here</a> to add products</p>

                    <%
                        } else {
                            for (Cart cartItem : cartItems) {
                                Product cart_product = cartItem.getProduct();
                    %>
                   <div class="cart-item">

                        <div class="select">
                            <input type="checkbox" class="itemCheckbox" name="selectedCartItems" onclick="toggleSelectAllState()"
                                    id="cartItem-<%= cartItem.getCart_id() %>"
                                    value="<%= cartItem.getCart_id() %>" data-quantity="<%= cartItem.getQuantity()%>"
                                    data-cart-item-id="<%= cartItem.getCart_id() %>" data-price="<%= cart_product.getPrice()%>"
                                    data-stock="<%= cartItem.getProduct().getStock() %>">
                        </div>
                        <a href="productDetails.jsp?id=<%= cart_product.getP_id() %>" style="width:25%;">
                            <img src="<%= cart_product.getImg_url() %>" alt="<%= cart_product.getName() %>">
                        </a>

                        <div class="cart-item-details">
                            <a href="productDetails.jsp?id=<%= cart_product.getP_id() %>" style="text-decoration: none;">
                                <h3 class="cart-item-name"><%= cart_product.getName() %></h3>
                            </a>
                            <p class="cart-item-brand"><%= cart_product.getBrand() %></p>

                            <p class="cart-item-price"> <i class="bi bi-currency-rupee"></i><%=(cart_product.getPrice()) %></p>
                            <%if(cart_product.getStock()==0){%>
                                <p>Out of Stock</p>
                            <%} else{%>
                             <div class="cart-item-quantity">
                                 <label for="quantity">Qty:</label>
                                 <div class="quant-input">
                                     <button type="button" onclick="updateQuant(<%=cartItem.getCart_id()%>,-1)">-</button>
                                     <input type="text" id="quantity-<%= cartItem.getCart_id() %>"
                                            name="quantity_<%= cartItem.getCart_id() %>" value="<%= cartItem.getQuantity() %>"
                                            min="1" data-price="<%= cart_product.getPrice() %>" onchange="calculateTotal()">
                                     <button type="button" onclick="updateQuant(<%=cartItem.getCart_id()%>,1)">+</button>
                                 </div>
                             </div>
                             <%}%>
                        </div>

                        <div class="cart-item-btn">
                               <button type="button" onclick="submitForm('removeCartServlet',<%= cart_product.getP_id() %>,<%= cartItem.getUser().getU_id()%>)" class="remove">Remove</button>
                               <p class="cart-item-price"> Total:
                               <i class="bi bi-currency-rupee"></i><span id="price-<%= cartItem.getCart_id()%>"><%=(cart_product.getPrice()*cartItem.getQuantity())%></span>
                               </p>

                        </div>
                   </div>
                    <%
                            }
                        }
                    %>
              </div>
                <div class="price-container">
                    <div class="price-items">
                        <h3>Price Details</h3><hr>
                        <p>No.of products:  <span id="selectedCount">0</span></p>
                        <p>Total Price: <span id="totalPrice">0</span></p>
                        <button type="submit" class="order-now">Place Order</button>
                    </div>
                </div>
            </form>
        </div>
   </div>
<script>
    function submitForm(actionUrl, productId, userId) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = actionUrl;

        const productIdInput = document.createElement('input');
        productIdInput.type = 'hidden';
        productIdInput.name = 'product_id';
        productIdInput.value = productId;
        form.appendChild(productIdInput);

        const userIdInput = document.createElement('input');
        userIdInput.type = 'hidden';
        userIdInput.name = 'user_id';
        userIdInput.value = userId;
        form.appendChild(userIdInput);

        document.body.appendChild(form);
        form.submit();
    }
</script>
  <!-- Footer -->
        <%@include file="footer.jsp"%>

</body>
</html>
<% } %>
