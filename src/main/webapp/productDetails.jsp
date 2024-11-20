<%@ page import="com.dao.ProductDAO" %>
<%@ page import="com.daoimp.ProductDAOImp" %>
<%@ page import="com.model.Product" %>


<!-- Header -->
   <%@include file="header.jsp"%>

<%@include file="popup.jsp"%>


<% String cartInfo = (String) session.getAttribute("cartInfo");
    if (cartInfo != null) { %>
    <script>
        showPopup("<%= cartInfo %>");
    </script>
<%session.removeAttribute("cartInfo"); }	%>

<% String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) { %>
    <script>
        showPopup("<%= successMessage %>");
    </script>
<%session.removeAttribute("successMessage"); }	%>


<%
    int productId = Integer.parseInt(request.getParameter("id"));
    ProductDAO productDAO = new ProductDAOImp();
    Product product = productDAO.getProductById(productId);

    if (product != null) {
%>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= product.getName() %></title>
        <style>
            .main-header{
                background-color:#fff !important;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }
            body {
                font-family: Arial, sans-serif;
                background-color: #fff;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                min-height: 100vh;
                margin: 0;
            }

            .product-details {
                flex:1;
                display: flex;
                padding: 0% 5%;
                padding-top:110px;
            }
           .product-image {
               position: relative;
               width: 70%;
               max-height: 500px;
               overflow: hidden;
               cursor: crosshair;
               text-align: center;
           }

           .product-main-image {
               height: 100%;
               object-fit: contain;
           }

           .zoom-overlay {
               position: absolute;
               top: 0;
               left: 0;
               right: 0;
               bottom: 0;
               opacity: 0;
               background-repeat: no-repeat;
               background-position: center;
               transition: opacity 0.3s ease-in-out;
               z-index: -1;
               pointer-events: none;
           }


            .product-info {
              width: 35%;
              padding-left: 5%;

            }

            .product-info h1 {
                font-size: 45px;
                padding-right: 10px;
            }

            .amt{
                font-size: 40px;
                padding-top: 20px;
            }

            .button-container {
                display: flex;
                gap: 20px;
                margin-top: 20px;
            }
            .form-group {
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
            .button-container button {
                padding: 10px 20px;
                font-size: 16px;
                cursor: pointer;
                border: none;
                border-radius: 5px;
            }
            .add-to-cart {
                background-color: #e36767;
                color: white;
            }
            .add-to-cart:hover {
                 box-shadow: 5px 4px 5px #333;
            }
            .order-now {
                background-color: #545f55   ;
                color: white;
            }
            .order-now:hover {
               box-shadow: 5px 4px 5px #333;
            }
        </style>
    </head>
    <body>

        <div class="product-details">
           <div class="product-image" onmousemove="zoom(event)" onmouseleave="resetZoom()">
               <img src="<%= product.getImg_url() %>" alt="<%= product.getName() %>" class="product-main-image">
               <!-- Correct the style attribute to background-image -->
               <div class="zoom-overlay" style="background-image: url('<%= product.getImg_url() %>')"></div>
           </div>

            <div class="product-info">
                <div class="brand" style="display:flex;">
                    <h1><%= product.getName() %></h1>
                    <p style="align-content: center;"> <i class="bi bi-tags-fill"></i> <%= product.getBrand() %></p>
                </div>

                <p  style="margin-top: -20px;"> <%= product.getCategory() %></p>
                <p  class="amt"> <i class="bi bi-currency-rupee"></i><%= product.getPrice() %></p>
                <h3>Product Details:</h3>
                <p><%= product.getDescription() %></p>
                <%if(product.getStock()==0){%>
                    <p style="color:red;">Out of Stock</p>
                <%} else{%>
                 <div class="form-group">
                     <label for="quantity">Qty:</label>
                     <div class="quant-input">
                         <button type="button" onclick="updateQuant(-1)">-</button>
                         <input type="text" id="quantity" name="quantity" value="1" min="1" data-price="<%= product.getPrice() %>" onchange="calculateTotal()">
                         <button type="button" onclick="updateQuant(1)">+</button>
                     </div>
                 </div>
                 <p><strong>Total:</strong> <i class="bi bi-currency-rupee"></i><span id="total-cost"><%= product.getPrice() %></span></p>
                 <div class="button-container">
                    <!-- Add to Cart button -->
                    <form action="addToCartServlet" method="post" onsubmit="setOrderQuantity()">
                        <input type="hidden" name="productId" value="<%= product.getP_id() %>">
                        <input type="hidden" id="addToCartQuantity" name="quantity" value="1">
                        <button type="submit" class="add-to-cart">Add to Cart</button>
                    </form>


                     <!-- Order Now button -->
                    <form action="orderServlet" method="post" onsubmit="setOrderQuantity()">
                        <input type="hidden" name="productId" value="<%= product.getP_id() %>">
                         <input type="hidden" id="orderNowQuantity" name="quantity" value="1">
                        <button type="submit" class="order-now">Order Now</button>
                    </form>
                    <%}%>
                </div>
            </div>
        </div>

          <!-- Footer -->
               <%@include file="footer.jsp"%>


      <script>

         function setOrderQuantity() {
             const quantityValue = document.getElementById("quantity").value;
             document.getElementById("addToCartQuantity").value = quantityValue;
             document.getElementById("orderNowQuantity").value = quantityValue;
         }

        function updateQuant(change) {
            const quantityInput = document.getElementById("quantity");
            let quantity = parseInt(quantityInput.value);
            let stock=<%=product.getStock()%>

            if (isNaN(quantity)) {
                quantity = 1;

            }
            quantity += change;

            if (quantity < 1) {
                quantity = 1;
            }

            if(quantity>stock){
                 showAlert("No Stock available to add");
            }
            else{
                quantityInput.value = quantity;
                calculateTotal();
            }
        }


        function calculateTotal() {
            const quantity = parseInt(document.getElementById("quantity").value);
            const price = parseFloat(document.getElementById("quantity").getAttribute("data-price"));

            if (!isNaN(quantity) && !isNaN(price)) {
                const totalCost = quantity * price;
                document.getElementById("total-cost").innerText = totalCost.toFixed(2);
            }
        }

       function zoom(event) {
           const overlay = event.currentTarget.querySelector('.zoom-overlay');
           const img = event.currentTarget.querySelector('.product-main-image');

           // Get mouse position relative to the image container
           const offsetX = event.offsetX;
           const offsetY = event.offsetY;
           const width = event.currentTarget.offsetWidth;
           const height = event.currentTarget.offsetHeight;

           // Show the overlay and set the background image only if it's not already set
           overlay.style.opacity = "1";
           overlay.style.backgroundImage = "url('" + img.src + "')";
           overlay.style.backgroundSize = "200%"; // Set zoom level
           overlay.style.zIndex = "1";

           // Calculate position percentages and set background position
           const xPercent = (offsetX / width) * 100;
           const yPercent = (offsetY / height) * 100;
           overlay.style.backgroundPosition = xPercent + "% " + yPercent + "%";
       }

       function resetZoom() {
           const overlay = document.querySelector('.zoom-overlay');
           overlay.style.opacity = "0"; // Hide overlay when mouse leaves
           overlay.style.zIndex = "0";
       }

        </script>
      </script>
    </body>
    </html>

<% } else { %>
    <p>Product not found!</p>
<% } %>
