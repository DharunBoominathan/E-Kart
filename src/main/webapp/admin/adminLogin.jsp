<%-- adminLogin.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f9;
        }

        .login-container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            padding: 30px;
            width: 350px;
            text-align: center;
        }

        .login-container h2 {
            color: #333333;
            margin-bottom: 20px;
        }

        .login-container label {
            display: block;
            font-size: 14px;
            color: #555555;
            margin-bottom: 5px;
            text-align: left;
        }

        .login-container input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #cccccc;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .login-container input:focus {
            border-color: #007bff;
            outline: none;
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

        .error-message {
            color: #ff4d4d;
            font-size: 14px;
            margin-bottom: 15px;
            text-align: left;
        }
    </style>
    <link rel="icon" type="image/png" href="../images/tabIcon.png">
</head>
<body>
    <div class="login-container">
        <img src="../images/logo.png" alt="logo" style="width:40%;">
        <h2>Admin Login</h2>

        <form action="${pageContext.request.contextPath}/adminLoginServlet" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>

            <span class="error-message">
                <% if (request.getAttribute("error") != null) { %>
                    <%= request.getAttribute("error") %>
                <% } %>
            </span>

            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
