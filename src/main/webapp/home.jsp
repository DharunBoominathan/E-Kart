<%-- home.jsp --%>
<%@page import="com.dao.ProductDAO"
        import="com.model.Product"
        import="com.daoimp.ProductDAOImp"
        import="com.dao.OrderItemDAO"
        import="com.daoimp.OrderItemDAOImp"
        import="java.util.List"
        import="java.util.Collections"%>


<!-- Header -->
   <%@include file="header.jsp"%>

<%@include file="popup.jsp"%>

<% String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) { %>
    <script>
         showPopup("<%= successMessage %>");
    </script>
<%session.removeAttribute("successMessage"); }	%>

<% String cartSuccess = (String) session.getAttribute("cartSuccess");
    if (cartSuccess != null) { %>
    <script>
         showPopup("<%= cartSuccess %>");
    </script>
<%session.removeAttribute("cartSuccess"); }	%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            padding-top:100px;
            background-color: #f1f3f6;
        }

        /* Carousel Styles */
       .carousel {
           position: relative;
           width: 100%;
           height: 450px;
           overflow: hidden;
           background-color: #ddd;
       }

       /* Carousel images */
       .carousel img {
           position: absolute;
           width: 100%;
           height: 100%;
           object-fit: cover;
           opacity: 0;
           transition: opacity 1s ease-in-out;
       }

      .carousel-image.active,
      .carousel-text-slide.active {
          opacity: 1;
          z-index:2;
      }

      .carousel-text-slide {
          position: absolute;
          width: 100%;
          height: 100%;
          background-color: #DDD0C8;
          color: #323232;
          text-align: left;
          padding-left:5%;
          opacity: 0;
          transition: opacity 0.5s ease;
          padding-top: 5%;
          padding-left: 18%;
      }

      .carousel-text-slide p {
          font-size: 1em;
          margin: 0;
      }

      .carousel-text-slide h3 {
          font-size: 4.5em;
          width:70%;
          margin: 10px 0px;
      }
      .carousel-text-slide button {
          color:#fff;
          background-color: #323232;
          border-radius:25px;
          padding:15px 25px;
          z-index: 10;
          cursor: pointer;
      }

       /* Arrow buttons */
       .carousel .arrow {
           position: absolute;
           top: 50%;
           transform: translateY(-50%);
           font-size: 2rem;
           color: #fff;
           background-color: rgba(0, 0, 0, 0.5);
           border: none;
           padding: 10px;
           cursor: pointer;
           z-index: 10;
       }

       .carousel .arrow.left {
           left: 20px;
       }

       .carousel .arrow.right {
           right: 20px;
       }

        /* Product Categories */

       .categories {
           display: flex;
           flex-wrap: wrap;
           padding: 2% 5%;
           justify-content: space-between;
       }

       .category-card {
           perspective: 1000px; /* Adds 3D perspective for the flip */
           width: 150px;
           height: 150px;
           border-radius: 50%; /* Makes the card circular */
           overflow: hidden;
       }

       .category-flip {
           position: relative;
           width: 100%;
           height: 100%;
           transform-style: preserve-3d;
           transition: transform 0.6s;
           border-radius: 50%;
       }

       .category-card:hover .category-flip {
           transform: rotateY(180deg);
       }

       .category-front, .category-back {
           position: absolute;
           width: 100%;
           height: 100%;
           backface-visibility: hidden;
           border-radius: 50%; /* Ensures both sides are circular */
           overflow: hidden;
       }

       .category-front img {
           width: 100%;
           height: 100%;
           object-fit: cover;
           border-radius: 50%;
       }

       .category-back {
           display: flex;
           justify-content: center;
           align-items: center;
           background-color: #DDD0C8; /* Background color for the back */
           color: #323232;
           font-size: 18px;
           transform: rotateY(180deg);
       }

       /*Grid box*/
       /* Container for the category section */

        .grid-section {
            display: grid;
            grid-template-columns: 1fr 2fr; /* Left column is smaller, right column is larger */
            gap: 20px;
            width: 90%;
            max-width: 1360px;
            margin: 0 auto;
            margin-top: 30px;
        }

        /* Left column styling with two rows */
        .left-column {
            display: grid;
            grid-template-rows: 1fr 1fr; /* Equal height for both rows */
            gap: 20px;
        }

        /* Right column styling */
        .right-column {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
        }

        /* Styling for each box in the left column */
        .small-box {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
        }

        /* Image styling */
        .grid-section img {
            width: 100%;
            height: 100%;
            object-fit: fill;
            border-radius: 15px;
        }
        .offer{
            position:absolute;
            z-index:1;
            left: 50%;
            bottom: 36%;
            width: 37%;
            height: 40%;
        }



        /* Featured Products */
        .p_title{
            margin-top: 70px;
            margin-bottom: 10px;
            text-align: center;
            font-size: 65px;

        }

        .products {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* Four columns */
            gap: 65px; /* Space between cards */
            margin:90px auto;
            width:90%;
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

        /* Hover Effects */
        .product-card:hover {
            box-shadow: 0 0 15px #333; /* Glowing effect on card */
        }

        .product-card img:hover  {
            transform: scale(1.1); /* Grow the image within the card */
        }
        .product-card h3 {
            font-size: 16px;
            margin-top: 8px;
            color: #333;
        }
        .product-card h3:hover{
            color:#1a7ac4;
        }

        .product-card p {
            color: #333;
            font-weight: bold;
            font-size: 18   px;
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
         .seller{
            width: 50% !important;
            position: absolute;
            top: -28%;
         }
         html {
             scroll-behavior: smooth;
         }
    </style>
</head>
<body>

    <!-- Carousel -->
    <div class="carousel" id="carousel">
        <!--<button class="arrow left" onclick="changeImage(-1)">&#9664;</button>
        <button class="arrow right" onclick="changeImage(1)">&#9654;</button>--!>

         <div class="carousel-text-slide">
            <p>Welcome to Our Store!</p>
            <h3>Brightening life with beautiful, durable products.</h3>
            <a href="cart.jsp"><button type="submit" onclick="window.location.href='cart.jsp'"> Shop now</button></a>
        </div>

           <a href="#products"> <img src="images/banner1.jpg" alt="Carousel Image 1" class="carousel-image active"></a>

      </div>

    <!-- Categories -->
    <div class="categories">
        <%
            Product p=new Product();
            List<String> categories=(List<String>) p.getAllowedCategories();
            String img_path="category_images/";
            for(String category:categories){
        %>
        <div class="category-card">
            <div class="category-flip">
                <div class="category-front">
                    <img src="<%=img_path+category%>.jpg" alt="<%=category%>">
                </div>
                <a href="searchResultsServlet?query=<%=category%>" style="text-decoration:none" class="category-back">
                   <h3><%=category%></h3></a>
                </a>
            </div>
        </div>
        <% } %>
    </div>


    <!--Grid--!>
    <div class="grid-section">
        <div class="left-column">
            <div class="small-box top">
                <a href="productDetails.jsp?id=1"> <img src="images/banner3.png" alt="phone"></a>
            </div>
            <div class="small-box bottom">
                <a href="productDetails.jsp?id=23"> <img src="images/banner2.jpg" alt="Furniture"></a>
            </div>
        </div>
        <div class="right-column">
            <a href="productDetails.jsp?id=4"> <img src="images/offer.jpg" alt="TV">
            <div class="offer"><img src="images/offerProduct.png" alt="Image 4"></div></a>
        </div>
    </div>



   <!-- Featured Products -->
    <h2 id="products" class="p_title">Products</h2>
   <div class="products">

       <%
           ProductDAO productDAO = new ProductDAOImp();
           List<Product> allProducts = (List<Product>) productDAO.getAllProducts();
           OrderItemDAO orderItemDAO=new OrderItemDAOImp();

           Collections.shuffle(allProducts);
           List<Product> productsToDisplay = allProducts.size() > 20 ? allProducts.subList(0, 20) : allProducts;

           if (productsToDisplay != null) {
               for (Product product : productsToDisplay) {
       %>


           <a href="productDetails.jsp?id=<%= product.getP_id() %>" class="product-card">
             <%if(orderItemDAO.getOrderCountOfProduct(product.getP_id())>0){%>
                  <img src="images/best.png" alt="best-seller" class="seller">
             <%}%>
               <img src="<%= product.getImg_url() %>" alt="<%= product.getName() %>">
               <h3><%= product.getName() %></h3>
               <%if(product.getStock()==0){%>
                  <img src="images/soldout.png" alt="out-of-stock" class="no-stock">
              <%}else if(product.getStock()<5){%>
                 <img src="images/limited.png" alt="limited-stock" class="stock">
              <%}%>
               <p><i class="bi bi-currency-rupee"></i><%= product.getPrice() %></p>
           </a>
       <%
               }
           }
       %>
   </div>


 <script>
        // JavaScript to handle carousel functionality
        let carouselIndex = 0;
        const carouselImages = document.querySelectorAll('.carousel-image,.carousel-text-slide');

        // Function to show image at the current index
        function showCarouselImage() {
            carouselImages.forEach((img, index) => {
                img.classList.remove('active');
                if (index === carouselIndex) img.classList.add('active');
            });
        }

        // Function to change the image
        function changeImage(direction) {
            carouselIndex = (carouselIndex + direction + carouselImages.length) % carouselImages.length;
            showCarouselImage();
        }

        // Auto change image every 5 seconds
        setInterval(() => changeImage(1), 5000);

        document.querySelector('a[href="#products"]').addEventListener('click', (e) => {
            e.preventDefault();
            document.getElementById('products').scrollIntoView({ behavior: 'smooth' });
        });
    </script>


<!-- Footer -->
<%@include file="footer.jsp"%>

</body>
</html>
