<%-- signup.jsp --%>

<!-- Header -->
<%@include file="header.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <style>
       body, html {
           margin: 0;
           padding: 0;
           font-family: Arial, sans-serif;
           background-color: #f1f3f6;
           min-height: 100vh;
           display: flex;
           flex-direction: column;
       }

       .content-wrapper {
           flex: 1;
           display: flex;
           flex-direction: column;
           justify-content: center;
           align-items: center;
           padding-top: 100px;
       }

        .signup-container {
            width: 400px;
            padding: 0px 30px;
            padding-bottom:15px;
            background-color: white;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            text-align: center;
        }

        .signup-container h2 {
            margin-bottom: 20px;
            color: #323232;
        }

        .signup-container input {
            width: 95%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .signup-container input[type="date"],
        .signup-container input[type="tel"] {
            color: #555;
        }

        /* Flex container for phone and date of birth */
        .flex-row {
            display: flex;
            justify-content: space-between;
            gap: 10px;
        }

        .flex-row input {
            width: 48%;
        }

        .signup-container button {
            width: 100%;
            padding: 10px;
            background-color: #DDD0C8;
            color: #323232;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .signup-container button:hover {
            background-color: #323232;
            color:#fff;
        }

        .signup-container a {
            display: block;
            margin-top: 10px;
            color: #323232;
            text-decoration: none;
            font-size: 14px;
        }

        .signup-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="content-wrapper">
    <div class="signup-container">
        <h2>Create Account</h2>
        <form action="signupservlet" method="POST">

            <input type="text" name="name" placeholder="Full Name"
            	 	value="${param.name}" required>
            <input type="email" name="email" placeholder="Email"
            		value="${param.email}" required>

            <c:if test="${not empty emailError}">
                <span style="color:red;">   ${emailError}  </span>
            </c:if>

            <!-- Phone and Date of Birth fields in the same row -->
            <div class="flex-row">
                <input type="date" name="dob" placeholder="Date of Birth"
                       value="${param.dob}" required>
                <input type="tel" name="phone" placeholder="Phone Number" pattern="[0-9]{10}" title="Enter a 10-digit phone number"
                       value="${param.phone}" required>
            </div>

            <c:if test="${not empty phoneError}">
                <span style="color:red;">   ${phoneError}  </span>
            </c:if>

            <input type="password" name="password" placeholder="Password" required>
            <input type="password" name="confirm_password" placeholder="Confirm Password" required>

            <span style="color:red;">
                <% if (request.getAttribute("error") != null) { %>
                    <%= request.getAttribute("error") %>
                <% } %>
            </span><br><br>
            <button type="submit">Next</button>
        </form>
        <a href="login.jsp">Already have an account? Login</a>
    </div>
  </div>

    <!-- Footer -->
    <%@include file="footer.jsp"%>

</body>
</html>
