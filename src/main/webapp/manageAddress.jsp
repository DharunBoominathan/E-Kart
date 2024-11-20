<%@ page import="com.model.Address" %>
<%@ page import="com.daoimp.AddressDAOImp"
         import="com.dao.AddressDAO"
         import="com.model.User"
%>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Header -->
   <%@include file="header.jsp"%>

<%@include file="popup.jsp"%>

<%
    User user=(User)session.getAttribute("user");

    if(user==null){
        response.sendRedirect(request.getContextPath()+"/home.jsp");
    }
    else{
%>
<% String success = (String) session.getAttribute("success");
    if (success != null) { %>
    <script>
        showPopup("<%=success%>");
      </script>
 <% session.removeAttribute("success"); } %>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Addresses</title>
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
        .container{
            flex:1;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0;
            padding: 20px;
            padding-top: 120px;
        }
        .address-container {
            width: 60%;
            margin: 10px 0;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            position: relative;

        }
        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .address-menu {
            position: relative;
        }
        .menu-icon {
            font-size: 18px;
            cursor: pointer;
        }
        .menu-options {
            display: none;
            position: absolute;
            right: 0;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2);
            z-index: 1;
            opacity: 0;
        }
        .menu-options.show {
            display: block;
            opacity: 1;
        }

        .menu-options a {
            display: block;
            padding: 10px;
            text-decoration: none;
            color: #333;
            cursor: pointer;
        }
        .menu-options a:hover {
            background-color: #f0f0f0;
        }
        .address-details {
            margin-top: 10px;
        }
        .add-new-address {
            width: 60%;
            padding: 20px;
            margin-top: 20px;
            text-align: center;
            background-color: #3a3a3ab3;
            color: #fff;
            border: 2px dashed #fff;
            border-radius: 8px;
            cursor: pointer;
        }
        .add-new-address:hover{
             background-color: #b1b1b0;
             color: #333;
             border: 2px dashed #333;
        }
    </style>
    <script>
        function toggleMenu(id) {
            document.getElementById(id).style.display =
                document.getElementById(id).style.display === 'none' ? 'block' : 'none';
        }

        let menuTimeout;

        function showMenu(element) {
            clearTimeout(menuTimeout);

            const menu = element.querySelector(".menu-options");

            menuTimeout =  menu.classList.add("show");
        }

        function hideMenu(element) {

            const menu = element.querySelector(".menu-options");


            clearTimeout(menuTimeout);
            setTimeout(() => {
                menu.classList.remove("show");
            }, 1000);
        }

    </script>
</head>
<body>

    <div class="container">

    <h1>Manage Addresses</h1>

    <%-- Display each address in a container --%>
    <%
        AddressDAO addressDAO=new AddressDAOImp();
        List<Address> addresses =addressDAO.getUserAddresses(user);
        if (addresses != null && !addresses.isEmpty()) {
            for (Address address : addresses) {
    %>
                <div class="address-container">
                    <div class="address-header">
                        <div class="address-details">
                           <%=address.getFrmtAddress2()%>
                        </div>
                       <div class="address-menu" onmouseenter="showMenu(this)" onmouseleave="hideMenu(this)">
                           <span class="menu-icon">&#x22EE;</span>
                           <div class="menu-options" id="menu<%= address.getAddr_id() %>">
                               <a href="editAddressServlet?editAddressId=<%= address.getAddr_id() %>">Edit</a>
                               <a href="deleteAddressServlet?addressId=<%= address.getAddr_id() %>">Delete</a>
                           </div>
                       </div>

                    </div>
                </div>
    <%
            }
        } else {
    %>
        <p>No addresses found. Please add a new address.</p>
    <%
        }
    %>

          <%-- Add New Address Container --%>
         <div class="add-new-address" onclick="window.location.href='addAddress.jsp?src=manageAddress'">
            + Add New Address
        </div>
    </div>

    <!-- Footer -->
            <%@include file="footer.jsp"%>

</body>
</html>
<%}%>