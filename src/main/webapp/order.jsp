<%@ page import="com.model.Address"%>
<%@ page import="com.model.Cart"%>
<%@ page import="com.model.User"%>
<%@ page import="com.dao.AddressDAO"%>
<%@ page import="com.daoimp.AddressDAOImp"%>
<%@ page import="java.util.List"%>
<%
    if(session.getAttribute("user")==null){
        response.sendRedirect(request.getContextPath()+"/home.jsp");
    }
    else{
%>

<!-- Header -->
   <%@include file="header.jsp"%>

<%@include file="popup.jsp"%>


<% String orderError = (String) session.getAttribute("orderError");
    if (orderError != null) { %>
    <script>
         showAlert("<%=orderError%>");
      </script>
 <% session.removeAttribute("orderError"); } %>

<% String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) { %>
    <script>
         showPopup("<%=successMessage%>");
      </script>
 <% session.removeAttribute("successMessage"); } %>



<%
User user = (User) session.getAttribute("user");
AddressDAO addressDAO = new AddressDAOImp();
List<Address> addresses = addressDAO.getUserAddresses(user);
List<Cart> selectedCartItems = (List<Cart>) session.getAttribute("selectedItems");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
            }
        .main{
            display:flex;
            padding: 2% 2% 0 5%;
            padding-top:125px;
        }
        .container {
            width: 60%
        }
        .section {
            background: #dadada4a;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 0 5px #333;
        }
        .section-content {
            display: none;
        }

        .section h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 15px;
         }
        .section .heading{
            display:flex;
            margin-top: 1%;
            margin-bottom:5%;
        }

        .section.open .section-content {
            display: block;
        }
        .section.open h2{
            color:#1a7ac4;
        }
        .heading h2{
            width:85%;
            margin:0;
        }

        .address-item, .cart-item, .payment-method {
            margin-bottom: 10px;
            margin-left: 20px;

         }
        .address-item input{
            margin-left: -20px;
        }
        .add-address a{
           color: #323232;
           text-decoration: none;
           cursor:pointer;

        }
        .add-address a:hover{
            border-bottom: 2px solid  #333;
            color: #333;
        }
        .heading button{
            background-color: #5f9ea0;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
         .heading button:hover{
            box-shadow: 5px 4px 5px #333;
         }
        #continue{
            width: 100%;
            padding: 10px;
            background-color: #8d8a8a;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top:15px;
        }
        #continue:hover{
            background-color: #323232;
            color: #fff;
            box-shadow: 5px 4px 5px #333;
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
            width: 65%;
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

        .tot-price{
            padding-top: 30px;
            text-align: center;
            font-weight:bold;
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
    </style>

    <script>

        let currentStep = 1;

        function toggleSection(step) {
            if (step == 1) {
                const section = document.getElementById("section-"+step);
                section.classList.toggle("open");
                document.getElementById("section-"+2).classList.remove("open");
                document.getElementById("section-"+3).classList.remove("open");
                document.querySelectorAll(".address-item").forEach(item => item.style.display = "block");
                document.getElementById("selected-address-display").style.display = "none";
            }
            else if (step == 2) {
                const section = document.getElementById("section-"+step);
                section.classList.toggle("open");
                document.getElementById("section-"+3).classList.remove("open");
            }
            else{
                const section = document.getElementById("section-"+step);
                section.classList.toggle("open");
            }

        }

        function completeStep(step) {
            let disp=1;
            if (step === 1) {
                const selectedAddress = document.querySelector('input[name="address"]:checked');
                if (!selectedAddress) {
                    showAlert("Please select a delivery address.");
                    return;
                }
                const selectedAddressId = selectedAddress.value;
                const selectedAddressText = document.querySelector("#addr-"+selectedAddressId).getAttribute("data-addr");
                document.getElementById("selected-address-display").innerText = selectedAddressText;
                document.querySelectorAll(".address-item").forEach(item => item.style.display = "none");
                document.getElementById("selected-address-display").style.display = "block";
            }
            if (step==2){
                document.querySelectorAll('.cart-item').forEach(item => {
                      const cartItemId = item.getAttribute("data-cart-item-id");
                      const quantity = document.getElementById("quantity-" + cartItemId).value;
                      let stock=parseInt(document.getElementById("cart-item-"+cartItemId).getAttribute("data-stock"));
                      let name=document.getElementById("cart-item-"+cartItemId).getAttribute("data-product-name");
                      if (quantity < 1) quantity = 1;
                      if(quantity>stock){
                           showAlert("Only "+stock+" Stocks available to order in "+name);
                           disp=0;
                      }
                 });
            }
            if (step === 3) {
                const selectedPaymentMethod= document.querySelector('input[name="payment_method"]:checked');
                if (!selectedPaymentMethod) {
                    showAlert("Please select a payment Method.");
                    disp=0;
                }
             }
            if(disp){
                document.getElementById("section-"+step).classList.remove("open");
                document.getElementById("section-"+step).classList.add("completed");
                document.getElementById("change-"+step).style.display="block";
                document.getElementById("section-"+(step + 1)).classList.add("open");
            }

        }

    function updateQuant(cartItemId, change) {
        const quantityInput = document.getElementById("quantity-" + cartItemId);
        let quantity = parseInt(quantityInput.value);
        let stock=parseInt(document.getElementById("cart-item-"+cartItemId).getAttribute("data-stock"));
        let name=document.getElementById("cart-item-"+cartItemId).getAttribute("data-product-name");
        if (isNaN(quantity)) quantity = 1;
        quantity += change;
        if (quantity < 1) quantity = 1;

        if(quantity>stock){
             showAlert("Only "+stock+" Stocks available to order in "+name);
        }
        else{
            quantityInput.value = quantity;
            document.getElementById("quantity-"+cartItemId).value=quantity;

            const price = parseInt(document.getElementById("quantity-" + cartItemId).getAttribute("data-price"));
            const totalCost = price * quantity;
            document.getElementById("price-" + cartItemId).innerText = totalCost;
            calculateTotal();
        }
    }

    function calculateTotal() {
        let totalPrice = 0;
        let selectedCount = 0;

        document.querySelectorAll(".cart-item").forEach(function (item) {
            const cartItemId = item.getAttribute("data-cart-item-id");
            const productPrice = parseFloat(document.getElementById("quantity-" + cartItemId).getAttribute("data-price"));
            const quantity = parseInt(document.getElementById("quantity-" + cartItemId).value);
            totalPrice += productPrice * quantity;
            selectedCount++;

        });
        document.getElementById("selectedCount").innerText = selectedCount;
        document.getElementById("totalPrice").innerText = totalPrice;
        document.getElementById("totalPrice").value = totalPrice;
    }

     document.addEventListener("DOMContentLoaded", calculateTotal);
     window.onload = function() {
         document.getElementById("section-1").classList.add("open");
     };

    </script>

</head>
<body>

    <div class="main">
        <div class="container">
         <form action="checkoutServlet" method="post" id="checkout-form">

            <input type="hidden" name="selectedAddressId" id="selectedAddressId">
            <input type="hidden" name="selectedPaymentMethod" id="selectedPaymentMethod">


            <!-- 1. Select Delivery Address -->
            <div class="section" id="section-1">
            <div class="heading">
                <h2><i class="bi bi-1-square-fill"></i> Select Delivery Address</h2>
                <button type="button" id="change-1" onclick="toggleSection(1)" style="display:none;">Edit <i class="bi bi-pencil-square"></i></button>
            </div>
              <div id="selected-address-display" style="display: none; margin-bottom: 10px;"></div>
                <div class="section-content">
                    <% if(addresses!=null){
                    for (Address address : addresses) { %>
                        <div class="address-item">
                            <input type="radio" name="address" value="<%= address.getAddr_id() %>"
                               onclick="updateSelectedAddress(<%= address.getAddr_id() %>)"/>
                            <span id="addr-<%= address.getAddr_id() %>"  data-addr="<%=address.getFullAddress()%>">
                                <%= address.getFrmtAddress2() %>
                            </span>

                        </div>
                    <% }} %>
                    <div class="add-address">
                        <a href="addAddress.jsp"><i class="bi bi-plus-circle"></i> Add New Address</a>
                    </div>
                    <button type="button" id="continue" onclick="completeStep(1)">Continue</button>
                </div>
            </div>

            <!-- 2. Confirm Order -->
            <div class="section" id="section-2">
                <div class="heading">
                    <h2><i class="bi bi-2-square-fill"></i> Confirm Order</h2>
                    <button type="button" id="change-2" onclick="toggleSection(2)" style="display:none;">Edit <i class="bi bi-pencil-square"></i></button>
                </div>
                <% if (selectedCartItems != null && !selectedCartItems.isEmpty()) { %>
                     <div class="section-content">
                        <% for (Cart cartItem : selectedCartItems) { %>
                            <div class="cart-item" data-quantity="<%= cartItem.getQuantity()%>"
                                                   data-product-name="<%= cartItem.getProduct().getName()%>"
                                                   data-cart-item-id="<%= cartItem.getCart_id() %>"
                                                   data-cart-product_id="<%= cartItem.getProduct().getP_id()%>"
                                                   data-price="<%= cartItem.getProduct().getPrice()%>"
                                                   id="cart-item-<%=cartItem.getCart_id()%>"
                                                   data-stock="<%= cartItem.getProduct().getStock()%>"
                                <a href="productDetails.jsp?id=<%= cartItem.getProduct().getP_id() %>" >
                                    <img src="<%= cartItem.getProduct().getImg_url() %>" alt="<%= cartItem.getProduct().getName() %>">
                                </a>
                                <div class="cart-item-details">
                                    <p class="cart-item-name"> <%= cartItem.getProduct().getName() %></p>
                                    <p class="cart-item-brand"> <%= cartItem.getProduct().getBrand() %></p>
                                    <p class="cart-item-price"><i class="bi bi-currency-rupee"></i><%= cartItem.getProduct().getPrice()%></p>


                                    <div class="cart-item-quantity">
                                         <label for="quantity">No. of Items:</label>
                                         <div class="quant-input">
                                             <button type="button" onclick="updateQuant(<%=cartItem.getCart_id()%>,-1)">-</button>
                                             <input type="text" id="quantity-<%= cartItem.getCart_id() %>"
                                                    name="quantity" value="<%= cartItem.getQuantity() %>"
                                                    min="1" data-price="<%= cartItem.getProduct().getPrice() %>" onchange="calculateTotal()">
                                             <button type="button" onclick="updateQuant(<%=cartItem.getCart_id()%>,1)">+</button>
                                         </div>
                                     </div>
                                </div>
                                <div class="cart-item-btn">
                                       <button type="button" onclick="removeFromDisplay(<%= cartItem.getCart_id() %>)" class="remove">Remove</button>
                                        <div class="tot-price">
                                        <i class="bi bi-currency-rupee"></i><span id="price-<%= cartItem.getCart_id()%>"><%=cartItem.getProduct().getPrice()%>
                                        </span>
                                        </div>
                                </div>
                            </div>
                        <% } %>
                        <button type="button" id="continue" onclick="completeStep(2)">Confirm Order</button>
                    </div>
                <% } else { %>
                    <p>No items selected for the order.</p>
                <% } %>
            </div>

            <!-- 3. Payment Details -->
            <div class="section" id="section-3">
                <div class="heading">
                    <h2><i class="bi bi-3-square-fill"> </i>Payment Details</h2>
                    <button type="button" id="change-3" onclick="toggleSection(3)" style="display:none;">Edit <i class="bi bi-pencil-square"></i></button>
                </div>

                <div class="section-content">
                    <div class="payment-method">
                        <input type="radio" name="payment_method" value="COD" onclick="updatePaymentMethod('COD')"> Cash on Delivery
                    </div>
                    <div class="payment-method">
                        <input type="radio" name="payment_method" value="CreditCard" onclick="updatePaymentMethod('CreditCard')"> Credit Card
                    </div>
                    <div class="payment-method">
                        <input type="radio" name="payment_method" value="UPI"  onclick="updatePaymentMethod('UPI')"> UPI Payment
                    </div>
                    <button type="submit" id="continue" onclick="prepareFormData()">Proceed to Payment</button>
                </div>
            </div>
           </form>
        </div>
        <div class="price-container">
            <div class="price-items">
                <h3>Price Details</h3><hr>
                <p>No.of products:  <span id="selectedCount">0</span></p>
                <p>Total Price: <span id="totalPrice" >0</span></p>
                </div>
        </div>
    </div>

     <!-- Footer -->
           <%@include file="footer.jsp"%>

     <script>
         let selectedAddressId = null;
         let selectedPaymentMethod = null;
         const removedItems = new Set();

         function updateSelectedAddress(addressId) {
             selectedAddressId = addressId;
             document.getElementById("selectedAddressId").value = selectedAddressId;
         }

         function updatePaymentMethod(method) {
             selectedPaymentMethod = method;
             document.getElementById("selectedPaymentMethod").value = selectedPaymentMethod;
         }


         function removeFromDisplay(cartItemId) {
               const cartItemElement = document.getElementById("cart-item-" + cartItemId);
               if (cartItemElement) {
                  cartItemElement.remove();
                  removedItems.add(cartItemId);
                  calculateTotal();
                  const remainingItems = document.querySelectorAll(".cart-item").length;
                  if (remainingItems === 0) {
                       showAlert("No items found in the cart.")
                        setTimeout(function() {
                              window.location.href = "cart.jsp";
                        }, 3000);
                  }
              }
         }

      document.addEventListener("DOMContentLoaded", function() {
           const form = document.getElementById("checkoutForm");

          form.addEventListener("submit", function(event) {
              const selectedAddress = document.querySelector('input[name="address"]:checked');
              const selectedPayment = document.querySelector('input[name="payment"]:checked');

               if (!selectedAddress) {
                  showAlert("Please select a delivery address.");
                  event.preventDefault();
                  return;
              }

              if (!selectedPayment) {
                  showAlert("Please select a payment method.");
                  event.preventDefault(); // Prevent form submission
                  return;
              }

              // If everything is selected, allow the form to be submitted
          });
      });


      function prepareFormData() {
          document.querySelectorAll('.cart-item').forEach(item => {
              const cartItemId = item.getAttribute("data-cart-item-id");
              const quantity = document.getElementById("quantity-" + cartItemId).value;

              if (!removedItems.has(cartItemId)) {
                  const itemInput = document.createElement("input");
                  itemInput.type = "hidden";
                  itemInput.name = "productIds";
                  itemInput.value = document.getElementById("cart-item-" + cartItemId).getAttribute("data-cart-product_id");
                  document.getElementById("checkout-form").appendChild(itemInput);

                  const quantityInput = document.createElement("input");
                  quantityInput.type = "hidden";
                  quantityInput.name = "quantities";
                  quantityInput.value = quantity;
                  document.getElementById("checkout-form").appendChild(quantityInput);
              }
              });
              const itemInput = document.createElement("input");
              itemInput.type = "hidden";
              itemInput.name = "totalPrice";
              itemInput.value = document.getElementById("totalPrice").value;
              document.getElementById("checkout-form").appendChild(itemInput);
      }
     </script>

</body>
</html>
<%}%>