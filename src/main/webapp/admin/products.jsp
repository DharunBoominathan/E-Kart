<%@page import="com.dao.ProductDAO"
        import="com.model.Product"
        import="com.daoimp.ProductDAOImp"
        import="java.util.List"
        import="java.util.Collections"
        import="com.dao.OrderItemDAO"
        import="com.daoimp.OrderItemDAOImp"%>


<%@ page import="com.model.Product" %>
<%
    List<String> categories = Product.getAllowedCategories();
    List<String> brands = Product.getAllowedBrands();
%>

<%
    // Get the results list and pagination data
    List<Product> results = (List<Product>) request.getAttribute("results");
    int currentPage = (int) request.getAttribute("currentPage");
    int totalPages = (int) request.getAttribute("totalPages");
    int productsPerPage = 8; // Number of products to display per page
    String query=request.getParameter("query");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        .sidebar{
            min-width:250px;
        }
         /* top-section */
        .top-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px;
            padding: 0 20px;
        }

        .top-section button {
           background-color: #3b5998;
           color: #fff;
           cursor: pointer;
           font-weight: bold;
           transition: background-color 0.3s ease;
           padding: 10px;
           font-size: 14px;
           border: 1px solid #ccc;
           border-radius: 5px;
           width: 115px;
        }
        .top-section button:hover{
            background-color: #2d4373;
         }

        .top-section h2 {
            flex-grow: 1;
            text-align: center;
            margin: 0;
        }

        .search-bar {
            flex-grow: 1;
            position: relative;
            max-width: 400px;
            margin-left: auto;
        }

        .search-bar input {
            width: 100%;
            padding-right: 40px;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 25px;
        }

        .search-bar button {
            position: absolute;
            top: 50%;
            right: 10px;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
            color: #555;
        }

          #suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            width: calc(100% - 20px);
            margin-left: 10px;
            border-radius:15px;
            background: #fff;
            max-height: 200px;
            overflow-y: auto;
            display: none;
            z-index: 1000;
            scrollbar-width: none;
             -ms-overflow-style: none;
        }

        #suggestions div {
            padding: 10px;
            cursor: pointer;
            border-bottom: 2px solid #dadada;
        }

        #suggestions div:hover {
            background-color: #f2f2f2;
            border:1px solid #323232;
            border-radius:15px;
        }

        #suggestions::-webkit-scrollbar {
            display: none; /* For WebKit browsers */
        }

         /* Products*/
        .products {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* Four columns */
            gap: 50px; /* Space between cards */
            margin: 40px auto;
            width: 90%;
        }

        .product-card {
            width: 90%;
            background-color: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            text-decoration: none;
            transition: box-shadow 0.3s ease;
            position:relative;
        }

        .product-card img {
            width: 100%;
            height: 150px;
            object-fit: contain;
            transition: transform 0.3s ease;
        }

        .product-card:hover {
            box-shadow: 0 0 15px #333;
        }

        .product-card img:hover {
            transform: scale(1.1);
        }

        .product-card h3 {
            font-size: 16px;
            margin-top: 8px;
            color: #333;
        }

        .product-card h3:hover {
            color: #1a7ac4;
        }

        .product-card p {
            color: #333;
            font-weight: bold;
            font-size: 18px;
        }

        .pagination {
            text-align: center;
            margin: 20px auto;
        }

        .pagination button {
            text-decoration: none;
            color: #333;
            margin: 0 5px;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .pagination button:hover {
            background-color: #1a7ac4;
            color: white;
            cursor:pointer;
        }

        .pagination button.active {
            background-color: #1a7ac4;
            color: white;
            pointer-events: none;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        .modal-content {
             width: 35%; /* Reduced width of the popup */
             margin: 10% auto;
             background-color: #fff;
             padding: 20px;
             border-radius: 10px;
             box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .modal-footer {
             display: flex;
             justify-content: space-between;
        }

        .product-image-section {
             text-align: center;
             margin-bottom: 20px;
        }

        .image-container {
             position: relative;
             display: inline-block;
        }

        .product-image {
             width: 100px; /* Reduced image size */
             height: 100px;
             border-radius: 50%;
             object-fit: cover;
             transition: transform 0.3s ease;
        }

        .image-edit-overlay {
             position: absolute;
             top: 0;
             right: 0;
             bottom: 0;
             left: 0;
             display: flex;
             justify-content: center;
             align-items: center;
             opacity: 0;
             transition: opacity 0.3s ease;
        }

        .image-container:hover .product-image {
            transform: scale(1.1);
        }

        .image-container:hover .image-edit-overlay {
            opacity: 1;
        }

        .edit-icon {
             background: rgba(0, 0, 0, 0.5);
             padding: 5px;
             border-radius: 50%;
             color: white;
             cursor: pointer;
        }

        .editable-field {
            position: relative;
        }

        .editable-field i {
             position: absolute;
             top: 50%;
             right: 10px;
             transform: translateY(-50%);
             cursor: pointer;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .same-line {
             display: flex;
             justify-content: space-between;
        }

        .same-line .editable-field {
          width: 48%;
        }

        .same-line .form-group {
          width: 48%;
        }

        label {
             font-weight: bold;
             display: block;
             margin-bottom: 5px;
        }

        .modal-content input, textarea, select {
             width: 100%;
             padding: 8px;
             font-size: 16px;
             border: 1px solid #ddd;
             border-radius: 5px;
             box-sizing: border-box;
        }

        textarea {
             resize: vertical;
             min-height: 80px;
        }

        input[readonly], textarea[readonly] {
            background-color: #f9f9f9;
        }

        input[type="number"] {
            -moz-appearance: textfield;
        }

        input[type="number"]::-webkit-outer-spin-button,
        input[type="number"]::-webkit-inner-spin-button {
             -webkit-appearance: none;
             margin: 0;
        }

        .btn {
             padding: 10px 20px;
             border-radius: 5px;
             cursor: pointer;
        }

        .btn-primary {
             background-color: #007bff;
             color: white;
             border: none;
        }

        .btn-danger {
             background-color: #dc3545;
             color: white;
             border: none;
        }

        .btn-secondary {
             background-color: #6c757d;
             color: white;
             border: none;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .stock{
            width: 30% !important;
            position: absolute;
            top: 25%;
            left: 65%;
            transform: rotate(-30deg);
        }
        .no-stock{
             width: 30% !important;
             position: absolute;
             top: 25%;
             left: 65%;
        }


    </style>
</head>
<body>
    <div class="top-section">
        <button type="button" onclick="changePage('addProduct.jsp')">Add Product</button>
        <h2>Products</h2>
         <div class="search-bar">
            <input
                type="text"
                id="searchInput"
                placeholder="Search for products, brands, category..."
                onkeyup="fetchSuggestions(this.value)"
            />
            <button onclick="performSearch()">
                <i class="bi bi-search"></i>
            </button>
             <div id="suggestions" class="suggestions" style="display: none;"></div>
         </div>
    </div>

  <div class="products">
      <% OrderItemDAO orderItemDAO=new OrderItemDAOImp();
        for (Product product : results) { %>

        <a href="#"
           class="product-card"
            onclick="showProductPopup({
                  p_id:'<%= product.getP_id()%>',
                  brand: '<%= product.getBrand()%>',
                  category: '<%= product.getCategory() %>',
                  description: '<%= product.getDescription().replace("'", "\\'") %>',
                  img_url: '<%= request.getContextPath()%>/<%= product.getImg_url()%>',
                  name: '<%= product.getName().replace("'", "\\'") %>',
                  price: '<%= product.getPrice()%>',
                  stock: '<%= product.getStock() %>'
              })">
              <img src="../<%= product.getImg_url() %>" alt="<%= product.getName() %>">
              <%if(product.getStock()==0){%>
                    <img src="../images/soldout.png" alt="out-of-stock" class="no-stock">
                <%}else if(product.getStock()<5){%>
                   <img src="../images/limited.png" alt="limited-stock" class="stock">
                <%}%>
              <h3><%= product.getName() %></h3>
          </a>
      <% } %>
  </div>

       <!-- Pagination -->
       <div class="pagination">
             <% if (currentPage > 1) { %>
                     <button onclick="loadPage(<%= currentPage - 1 %>,<%=query%>)">Previous</button>
               <% } %>
               <%
               if(totalPages!=1){
               for (int i = 1; i <= totalPages; i++) { %>
                  <button onclick="loadPage(<%= i %>,<%=query%>)" class="<%= (i == currentPage) ? "active" : "" %>">
                      <%= i %>
                  </button>
               <% } }%>
               <% if (currentPage < totalPages) { %>
                 <button onclick="loadPage(<%= currentPage + 1 %>,<%=query%>)">Next</button>
               <% } %>
       </div>

       <!--popup--!>
        <div id="productModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeProductPopup()">&times;</span>
                <form id="productForm" enctype="multipart/form-data">
                    <input type="hidden" id="productId" name="productId">
                    <div class="product-image-section">
                        <div class="image-container">
                            <img id="productImageDisplay" src="" alt="Product Image" class="product-image">
                            <div class="image-edit-overlay">
                                <label for="productImage" class="edit-icon">
                                    <i class="bi bi-pencil-square"></i>
                                    <input type="file" id="productImage" name="productImage" accept="image/*" style="display: none;">
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="productName">Product Name:</label>
                        <div class="editable-field">
                            <input type="text" id="productName" name="productName" value="" readonly>
                            <i class="bi bi-pencil-square edit-icon" onclick="enableEdit('productName')"></i>
                        </div>
                    </div>
                    <div class="form-group same-line">
                        <div class="editable-field">
                            <label for="category">Category:</label>
                            <select id="productCategory" name="productCategory"  value=""  readonly>
                                <% for (String category : categories) { %>
                                    <option value="<%= category %>"><%= category %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="editable-field">
                         <label for="brand">Brand:</label>
                            <select id="productBrand"name="productBrand" readonly>
                                <% for (String brand : brands) { %>
                                    <option value="<%= brand %>"><%= brand %></option>
                                <% } %>
                        </select>
                     </div>
                    </div>
                    <div class="form-group same-line">
                        <div class="editable-field" style="top: 68%;">
                            <label for="productPrice">Price:</label>
                            <input type="number" id="productPrice" name="productPrice" readonly>
                            <i class="bi bi-pencil-square edit-icon" style="top: 68%;" onclick="enableEdit('productPrice')"></i>
                        </div>
                        <div class="editable-field">
                            <label for="productStock">Stock:</label>
                            <input type="number" id="productStock" name="productStock" readonly>
                            <i class="bi bi-pencil-square edit-icon" style="top: 68%;" onclick="enableEdit('productStock')"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="productDescription">Description:</label>
                        <div class="editable-field">
                            <textarea id="productDescription" name="productDescription" readonly></textarea>
                            <i class="bi bi-pencil-square edit-icon" onclick="enableEdit('productDescription')"></i>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary" onclick="submitForm2(event, 'update')">Update</button>
                        <button type="submit" class="btn btn-danger" onclick="submitForm2(event, 'delete')">Delete</button>
                        <button type="button" onclick="closeProductPopup()" class="btn btn-secondary">Cancel</button>
                    </div>
                </form>
            </div>
        </div>



   </body>
</html>