<%@ page import="java.util.List" %>
<%@ page import="com.model.Product" %>
<%
    List<String> categories = Product.getAllowedCategories();
    List<String> brands = Product.getAllowedBrands();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Product</title>
        <style>
                #dynamic-content{
                    display: flex;
                    justify-content: center;
                    box-shadow:none;
                }
                .form-container {
                    background-color: #fff;
                    padding: 25px;
                    width: 400px;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    text-align:center;
                }
                .form-container h2 {
                    text-align: center;
                    color: #333;
                    margin-bottom: 20px;
                }
                .form-group {
                    margin-bottom: 15px;
                }
                label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: bold;
                    color: #333;
                    text-align: left
                }
                .form-row {
                    display: flex;
                    justify-content: space-between;
                }
                .form-group {
                    margin-bottom: 15px;
                }
                input[type="text"],
                input[type="number"],
                input[type="file"],
                select,
                textarea {
                    width: 100%;
                    padding: 8px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    font-size: 14px;
                    box-sizing: border-box;
                }
                .stock-input {
                    display: flex;
                    align-items: center;
                }
                .stock-input button {
                    width: 30px;
                    height: 30px;
                    font-size: 16px;
                    font-weight: bold;
                    color: #fff;
                    background-color: #6a6a6a;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    margin: 0 5px;
                }
                button[type="submit"] {
                    padding: 10px 20px;
                    font-size: 16px;
                    color: #fff;
                    background-color: #68988b;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                }
                button[type="submit"]:hover{
                    background-color: #3d5b53;
                }
            </style>

</head>
<body>
	<% String errorMsg = (String) request.getAttribute("errorMsg");
    	if (errorMsg != null) { %>
    	<script>
        	alert("<%= errorMsg %>");
    	</script>
	<%session.removeAttribute("errorMsg"); }%>

    <div class="form-container">
        <h2>Add New Product</h2>
        <form id="add-product" onsubmit="submitForm(event)" enctype="multipart/form-data">
            <div class="form-group">
                <label for="name">Product Name:</label>
                <input type="text" id="name" name="name" value="${param.name}" required>
            </div>
            <!-- Row for Price and Stock -->
            <div class="form-row">
                <div class="form-group" style="flex: 1; margin-right: 10px;">
                    <label for="price">Price:</label>
                    <input type="number" id="price" name="price" value="${param.price}" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label for="stock">Stock:</label>
                    <div class="stock-input">
                        <button type="button" onclick="updateStock(-1)">-</button>
                        <input
                            type="text" id="stock" name="stock"
                            value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : 1 %>"
                            min="1">
                        <button type="button" onclick="updateStock(1)">+</button>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" maxlength="1000" value="${param.description}"></textarea>
            </div>
            <div class="form-group">
                <label for="img_file">Upload Image:</label>
                <input type="file" id="img_file" name="img_file" accept="image/*" required>
            </div>
            <!-- Row for Category and Brand -->
            <div class="form-row">
                <div class="form-group" style="flex: 1; margin-right: 10px;">
                    <label for="category">Category:</label>
                    <select id="category" name="category" required>
                        <% for (String category : categories) { %>
                            <option value="<%= category %>"><%= category %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label for="brand">Brand:</label>
                    <select id="brand" name="brand" required>
                        <% for (String brand : brands) { %>
                            <option value="<%= brand %>"><%= brand %></option>
                        <% } %>
                    </select>
                </div>
            </div>
            <br>
            <button type="submit">Add Product</button>
        </form>
    </div>

</body>
</html>
