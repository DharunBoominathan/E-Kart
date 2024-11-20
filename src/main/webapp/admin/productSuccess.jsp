<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Added Successfully</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f1f3f6;
        }
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
            margin: auto;
            justify-items: center;
        }
        h2 {
            color: #612525;
            font-size: 24px;
            margin-bottom: 20px;
        }
        .img-container{
            width:50%;
        }
        .product-info {
            text-align: left;
            margin: 20px 0;
        }
        .product-info h3 {
            color: #333;
            margin: 10px 0;
            font-size: 18px;
        }
        .product-info p {
            color: #555;
            margin: 5px 0;
        }
        .product-img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .add-product-btn {
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background-color: #68988b;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .add-product-btn:hover{
            background-color: #3d5b53;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Product Added Successfully!</h2>
          <div class="img-container">
                      <img src="${pageContext.request.contextPath}/${img_url}" alt="Product Image" class="product-img">
           </div>

        <!-- Displaying product details with an image -->
        <div class="product-info">
                       <p><strong>Name:</strong> ${param.name} </p>
                       <p><strong>Price:</strong> ₹${param.price}</p>
                       <p><strong>Description:</strong> ${param.description}</p>
                       <p><strong>Stock:</strong> ${param.stock}</p>
                       <p><strong>Category:</strong> ${param.category}</p>
                       <p><strong>Brand:</strong> ${param.brand}</p>
        </div>

        <!-- Action buttons -->
           <button onclick="changePage('addProduct.jsp')" class="add-product-btn">Add Another Product</button>
    </div>
</body>
</html>
