
<%
    if(session.getAttribute("user")==null){
        response.sendRedirect(request.getContextPath()+"/home.jsp");
    }
    else{
%>

<!-- Header -->
   <%@include file="header.jsp"%>

<%@include file="popup.jsp"%>


 <% String success = (String) session.getAttribute("success");
     if (success != null) { %>
     <script>
         showPopup("<%=success%>");
       </script>
  <% session.removeAttribute("success"); } %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Page</title>
    <style>
        .main-header{
            background-color:#fff !important;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        body {
             font-family: Arial, sans-serif;
             background-color: #fff !important;
             margin:0;
             padding:0;
             min-height: 100vh;
             display: flex;
             flex-direction: column;
        }
        .profile-container {
            flex:1;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
            justify-content: center;
            padding-top:120px;

        }
        .profile-box {
            width: calc(50% - 10px); /* 2 columns */
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            padding: 15px;
            cursor: pointer;
            transition: transform 0.3s;
            text-decoration: none;
            color: inherit;
        }
        .profile-box:hover {
            transform: scale(1.02);
        }
        .box-image {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 15px;
        }
        .box-content {
            flex: 1;
        }
        .box-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        .box-description {
            font-size: 14px;
            color: #777;
        }
    </style>
</head>
<body>

<div class="profile-container">
    <!-- User Details Box -->
    <a href="userDetails.jsp" class="profile-box">
        <img src="images/userdetails.png" alt="User Details" class="box-image">
        <div class="box-content">
            <div class="box-title">User Details</div>
            <div class="box-description">View and edit your personal details.</div>
        </div>
    </a>

    <!-- Address Management Box -->
    <a href="manageAddress.jsp" class="profile-box">
        <img src="images/address.png" alt="Address" class="box-image">
        <div class="box-content">
            <div class="box-title">Manage Address</div>
            <div class="box-description">Add, edit, or delete your addresses.</div>
        </div>
    </a>

    <!-- Orders Box -->
    <a href="orderHistory.jsp" class="profile-box">
        <img src="images/orders.png" alt="Orders" class="box-image">
        <div class="box-content">
            <div class="box-title">Orders</div>
            <div class="box-description">View your past orders and re-order items.</div>
        </div>
    </a>

    <!-- Cart Box -->
    <a href="cart.jsp" class="profile-box">
        <img src="images/cart.png" alt="Cart" class="box-image">
        <div class="box-content">
            <div class="box-title">Cart</div>
            <div class="box-description">Manage items in your shopping cart.</div>
        </div>
    </a>
</div>
    <!-- Footer -->
            <%@include file="footer.jsp"%>


</body>
</html>
<%}%>