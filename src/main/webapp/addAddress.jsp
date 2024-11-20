<%@page import="com.model.User"%>
<%@page import="com.model.Address"
        import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Header -->
<%@include file="header.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <title><%= (request.getAttribute("editAddress") != null) ? "Edit Address" : "Add Address" %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            min-height: 100vh;
            margin: 0;
        }
        .address-form {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: left;
            margin: auto;
            margin-top: 10%;
        }
        .address-form h2 {
            margin-top: 0;
            color: #323232;
            text-align: center;
            margin-bottom: 35px;
        }
        .address-form label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .address-form input[type="text"],
        .address-form input[type="tel"],
        .address-form select {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .address-form .flex-row {
            display: flex;
            justify-content: space-between;
            gap: 10px;

        }

       .flex-row > div {
           flex: 1;
           max-width: 48%;
       }

        .address-form .button-group {
            display: flex;
            justify-content: space-between;
        }
        .address-form button {
            padding: 10px;
            background-color: #DDD0C8;
            color: #323232;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            width: 48%;
        }
        .address-form button:hover {
            background-color: #323232;
            color: #fff;
        }
        .address-form .skip-button {
            background-color: #DDD0C8;
            color: #323232;
        }

    </style>
</head>
<body>

    <div class="address-form">
        <h2 id="formTitle"><%= (request.getAttribute("editAddress") != null) ? "Edit Address" : "Add New Address" %></h2>
        <form action="addAddressServlet" method="post">
            <%
                Address editAddress = (Address) request.getAttribute("editAddress");
                String fullName = (editAddress != null) ? editAddress.getFullName() : "";
                String phoneNumber = (editAddress != null) ? editAddress.getPhoneNumber() : "";
                String addressLine1 = (editAddress != null) ? editAddress.getAddressLine1() : "";
                String addressLine2 = (editAddress != null) ? editAddress.getAddressLine2() : "";
                String city = (editAddress != null) ? editAddress.getCity() : "";
                String state = (editAddress != null) ? editAddress.getState() : "";
                String pinCode = (editAddress != null) ? editAddress.getPinCode() : "";
                String src=request.getParameter("src");
            %>
            <input type="hidden" name="addressId" value="<%= (editAddress != null) ? editAddress.getAddr_id() : "" %>">
            <input type="hidden" name="src" value="<%= (src != null) ? src : "" %>">

            <!-- Name and Phone Number in the same row -->
            <div class="flex-row">
                <div>
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" value="<%= fullName %>" required>
                </div>
                <div>
                    <label for="phoneNumber">Phone Number</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" value="<%= phoneNumber %>" required pattern="[0-9]{10}" placeholder="Enter 10-digit number">
                </div>
            </div>

            <!-- Address Line 1 -->
            <label for="addressLine1">Address Line 1</label>
            <input type="text" id="addressLine1" name="addressLine1" value="<%= addressLine1 %>" required>

             <!-- Address Line 2 -->
            <!-- Address Line 2 and State in the same row -->
            <div class="flex-row">
                <div>
                    <label for="addressLine2">Address Line 2</label>
                    <input type="text" id="addressLine2" name="addressLine2" value="<%= addressLine2 %>">
                </div>
                <div>
                    <% List<String> states = new Address().states; %>
                     <option value="" disabled selected>Select</option>
                    <select id="state" name="state" required>
                        <option value="">select</option>
                        <% for (String s : states) { %>
                            <option value="<%= s %>"><%= s %></option>
                        <% } %>
                    </select>
                </div>
            </div>


            <!-- City and Pin Code in the same row -->
            <div class="flex-row">
                <div>
                    <label for="city">City</label>
                    <input type="text" id="city" name="city" value="<%= city %>" required>
                </div>
                <div>
                    <label for="pinCode">Pin Code</label>
                    <input type="text" id="pinCode" name="pinCode" value="<%= pinCode %>" required pattern="[0-9]{6}" placeholder="Enter 6-digit postal code">
                </div>
            </div>

            <div class="button-group">
                <button type="submit" id="submitBtn">
                    <%= (editAddress != null) ? "Save Changes" : (session.getAttribute("src") != null) ? "Save & Signup" : "Add" %>
                </button>

                <%
                    if ("signup".equals(session.getAttribute("src"))) {
                        session.setAttribute("successMessage", "Account created successfully! Please log in.");
                %>
                        <button type="button" class="skip-button" onclick="window.location.href='login.jsp'">Skip</button>
                <%
                    } else if (editAddress == null) {
                        if (session.getAttribute("selectedItems") != null) {
                %>
                            <button type="button" class="skip-button" onclick="window.location.href='order.jsp'">Cancel</button>
                <%
                        } else {
                %>
                            <button type="button" class="skip-button" onclick="window.location.href='manageAddress.jsp'">Cancel</button>
                <%
                        }
                    }
                %>

            </div>
        </form>
    </div>

    <!-- Footer -->

        <%@include file="footer.jsp"%>

</body>
</html>
