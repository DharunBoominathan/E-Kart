<%-- login.jsp --%>



<!-- Header -->
<%@include file="header.jsp"%>
<%@include file="popup.jsp"%>

<% String viewCartMessage = (String) session.getAttribute("view_cart");
   if (viewCartMessage != null) { %>
   <script> showPopup("<%= viewCartMessage %>");</script>
   <% session.removeAttribute("view_cart"); %>
<% } %>

<% String successMessage = (String) session.getAttribute("successMessage");
   if (successMessage != null) { %>
   <script> showPopup("<%= successMessage %>");</script>
   <% session.removeAttribute("successMessage");
      session.removeAttribute("src");
      session.removeAttribute("user");
   %>
<% } %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
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

        /* Container for content and footer */
        .content-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding-top: 100px;
        }

        .login-container {
            width: 350px;
            padding: 30px;
            background-color: white;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            text-align: center;
        }

        .login-container h2 {
            margin-bottom: 20px;
            color: #323232;
        }

        .login-container input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .login-container button {
            width: 100%;
            padding: 10px;
            background-color: #DDD0C8;
            color: #323232;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .login-container button:hover {
            background-color: #323232;
            color: #fff;
        }

        .login-container a {
            display: block;
            margin-top: 10px;
            color: #2874f0;
            text-decoration: none;
            font-size: 14px;
             color: #323232;
        }

        .login-container a:hover {
            text-decoration: underline;
        }


    </style>
</head>
<body>

<div class="content-wrapper">
    <div class="login-container">
        <h2>Login</h2>
        <form action="loginservlet" method="POST">
            <input type="text" name="username" placeholder="Email or Phone" value="${param.username}" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="hidden" name="p_id" value="<%= request.getAttribute("p_id")%>">

            <span style="color:red;">
                <% if (request.getAttribute("error") != null) { %>
                    <%= request.getAttribute("error") %>
                <% } %>
            </span><br><br>

            <button type="submit">Login</button>
        </form>
        <a href="#">Forgot Password?</a>
        <a href="signup.jsp">Don't have an account? Sign Up</a>
    </div>
</div>

<!-- Footer -->
<%@include file="footer.jsp"%>

</body>
</html>
