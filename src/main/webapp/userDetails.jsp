<%@page import="com.model.User"
        import="com.dao.UserDAO"
        import="com.daoimp.UserDAOImp"

%>
<%
    User user=(User)session.getAttribute("user");

    if(user==null){
        response.sendRedirect(request.getContextPath()+"/home.jsp");
    }
    else{
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
             background-color: #fff !important;
             margin:0;
             padding:0;
             min-height: 100vh;
             display: flex;
             flex-direction: column;

        }
        .container {
            flex:1;
            width:30%;
            margin: 0 auto;
            padding: 20px;
            padding-top:120px;
        }
        .user-detail-container {
            background: #ffffff;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.3s ease;
        }
        .user-detail-container:hover {
            background-color: #f9f9f9;
        }
        .detail-title {
            font-size: 16px;
            color: #333;
            flex: 1;
            padding-right: 10px;
        }
        .detail-value {
            font-size: 16px;
            color: #666;
            flex: 2;
        }
        .edit-input {
            font-size: 16px;
            padding: 5px;
            width: 70%;
            margin-right: 10px;
            display: none;
        }
        .edit-button, .save-button, .cancel-button {
            padding: 6px 12px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .edit-button { background-color: #5f9ea0; color: #fff; }
        .edit-button:hover  { box-shadow: 5px 4px 5px #333;}
        .save-button { background-color: #8d8a8a; color: #fff; display: none; margin-right: 10px; }
        .save-button:hover  { box-shadow: 5px 4px 5px #333;}
        .cancel-button { background-color: #e36767; color: #fff; display: none; }
        .cancel-button:hover  { box-shadow: 5px 4px 5px #333;}
        .actions {
            display:flex;
            gap:10px;
            text-align: center;
            margin-top: 20px;
        }
        .actions button {
            width: 50%;
            padding: 10px;
            background-color: #DDD0C8;
            color: #323232;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .actions button:hover {
            background-color: #323232;
            color:#fff;
        }

    </style>
    <script>
        function toggleEdit(id) {
            const container = document.getElementById(id);
            container.querySelector('.detail-value').style.display = 'none';
            container.querySelector('.edit-input').style.display = 'inline';
            container.querySelector('.edit-button').style.display = 'none';
            container.querySelector('.save-button').style.display = 'inline';
            container.querySelector('.cancel-button').style.display = 'inline';
        }

        function saveEdit(id) {
                const container = document.getElementById(id);
                const inputField = container.querySelector('.edit-input');
                const detailValue = container.querySelector('.detail-value');

                detailValue.textContent = inputField.value;

                inputField.style.display = 'none';
                detailValue.style.display = 'inline';
                container.querySelector('.edit-button').style.display = 'inline';
                container.querySelector('.save-button').style.display = 'none';
                container.querySelector('.cancel-button').style.display = 'none';
        }

        function cancelEdit(id) {
                const container = document.getElementById(id);
                const inputField = container.querySelector('.edit-input');
                const detailValue = container.querySelector('.detail-value');

                inputField.value = detailValue.textContent;

                inputField.style.display = 'none';
                detailValue.style.display = 'inline';
                container.querySelector('.edit-button').style.display = 'inline';
                container.querySelector('.save-button').style.display = 'none';
                container.querySelector('.cancel-button').style.display = 'none';
        }

        function saveChanges() {
            if (confirm('Are you sure you want to save changes?')) {
                const u_name = document.getElementById('nameContainer').querySelector('.detail-value').textContent;
                const u_email = document.getElementById('emailContainer').querySelector('.detail-value').textContent;
                const u_phone = document.getElementById('phoneContainer').querySelector('.detail-value').textContent;
                const u_pass = document.getElementById('passwordContainer').querySelector('.detail-value').textContent;


                document.getElementById('nameField').value = u_name;
                document.getElementById('emailField').value = u_email;
                document.getElementById('phoneField').value = u_phone;
                document.getElementById('passField').value = u_pass;

                document.getElementById('updateForm').submit();
            }
        }

        function goBack() {
            if (confirm('Are you sure you want to go back? Unsaved changes will be lost.')) {
                window.location.href = 'profile.jsp';
            }
        }
    </script>
</head>
<body>

  <!-- Header -->
       <%@include file="header.jsp"%>

<div class="container">
    <h1 style="text-align: center;">User Details</h1>

    <div id="nameContainer" class="user-detail-container">
        <span class="detail-title">Name:</span>
        <span class="detail-value"><%= user.getName()%></span>
        <input type="text" class="edit-input" value="<%= user.getName()%>">
        <button class="edit-button" onclick="toggleEdit('nameContainer')">Edit <i class="bi bi-pencil-square"></i></button>
        <button class="save-button" onclick="saveEdit('nameContainer')">Save</button>
        <button class="cancel-button" onclick="cancelEdit('nameContainer')">Cancel</button>
    </div>

    <div id="emailContainer" class="user-detail-container">
        <span class="detail-title">Email:</span>
        <span class="detail-value"><%= user.getEmail()%></span>
        <input type="email" class="edit-input" value="<%= user.getEmail()%>">
        <button class="edit-button" onclick="toggleEdit('emailContainer')">Edit <i class="bi bi-pencil-square"></i></button>
        <button class="save-button" onclick="saveEdit('emailContainer')">Save</button>
        <button class="cancel-button" onclick="cancelEdit('emailContainer')">Cancel</button>
    </div>

    <div id="phoneContainer" class="user-detail-container">
        <span class="detail-title">Phone:</span>
        <span class="detail-value"><%= user.getPhone()%></span>
        <input type="tel" class="edit-input" value="<%= user.getPhone()%>0">
        <button class="edit-button" onclick="toggleEdit('phoneContainer')">Edit <i class="bi bi-pencil-square"></i></button>
        <button class="save-button" onclick="saveEdit('phoneContainer')">Save</button>
        <button class="cancel-button" onclick="cancelEdit('phoneContainer')">Cancel</button>
    </div>

    <div id="passwordContainer" class="user-detail-container">
        <span class="detail-title">Password:</span>
        <span class="detail-value">********</span>
        <input type="password" class="edit-input" value="<%= user.getPhone()%>">
        <button class="edit-button" onclick="toggleEdit('passwordContainer')">Edit <i class="bi bi-pencil-square"></i></button>
        <button class="save-button" onclick="saveEdit('passwordContainer')">Save</button>
        <button class="cancel-button" onclick="cancelEdit('passwordContainer')">Cancel</button>
    </div>

    <div class="actions">
        <button class="save-changes" onclick="saveChanges()">Save Changes</button>
        <button class="back-button" onclick="goBack()">Back</button>
    </div>
</div>

    <form id="updateForm" action="updateUserServlet" method="post">
        <input type="hidden" id="nameField" name="name">
        <input type="hidden" id="emailField" name="email">
        <input type="hidden" id="phoneField" name="phone">
        <input type="hidden" id="passField" name="password">
    </form>

 <!-- Footer -->
            <%@include file="footer.jsp"%>

</body>
</html>
<%}%>