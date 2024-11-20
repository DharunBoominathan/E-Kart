<!DOCTYPE html>
<html>
<head>
    <title>Order Success</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            flex-direction: column;
            height: 100vh;
            margin: 0;
        }
        .success{
            flex:1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding-top: 100px;
        }

        .success-container{
            text-align: center;
            background: #ffffff;
            padding: 40px;
            box-shadow: 0 40px 80px #FBE4E0;
            border-radius: 14px;
        }
        .success-container img{
            width:25%;

        }
        .success-container h1 {
            font-size: 28px;
            color: #4CAF50;
        }
        .success-container p {
            font-size: 18px;
            color: #555;
            margin: 20px 0;
        }
        .row-flex{
            display:flex;
            justify-content: space-between;
        }
        .flex-row > button {
             flex: 1;
             max-width: 55%;
         }

       .btn-1, .btn-2{
           color: #fff;
           background: #e7e7e7;
           position: relative;
           overflow: hidden;
           border: none;
           border-radius: 5px;
           padding: 10px 20px;
           font-size: 16px;
           cursor: pointer;
       }

       .btn-1::before{
           content: '';
           position: absolute;
           top: 0;
           left: -10%;
           width: 120%;
           height: 100%;
           background: #000;
           z-index: 1;
           transform: skew(-30deg) translateX(-100%);
           transition: transform 0.5s cubic-bezier(0.3, 1, 0.8, 1);
       }
       .btn-2::before{
              content: '';
              position: absolute;
              top: 0;
              left: -10%;
              width: 120%;
              height: 100%;
              background: #000;
              z-index: 1;
              transform: skew(-30deg) translateX(-100%);
              transition: transform 0.5s cubic-bezier(0.3, 1, 0.8, 1);
       }

       .btn-1:hover::before {
           transform: skew(-30deg) translateX(0);

       }
       .btn-2:hover::before{
          transform: skew(-30deg) translateX(0);

      }

       button span {
           position: relative;
           mix-blend-mode: difference;
           z-index: 2;
       }


        #confetti {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

    </style>
    <script src="https://cdn.jsdelivr.net/npm/js-confetti@latest/dist/js-confetti.browser.js"></script>
     <script>
          document.addEventListener('DOMContentLoaded', () => {
                    const canvas = document.getElementById('confetti'); // Select the canvas element
                    const jsConfetti = new JSConfetti({ canvas }); // Initialize js-confetti with the canvas

                    // Trigger confetti animation on page load
                    jsConfetti.addConfetti({
                         confettiNumber: 500,
                    });
                });
            </script>
    </head>
<body>

    <!-- Header -->
           <%@include file="header.jsp"%>


    <canvas id="confetti"></canvas>
        <div class="success">
            <div class="success-container">
                <img src="images/gift.gif"></img>
                <h1>Thank You for Your Order!</h1>
                <p>Your order has been placed successfully.</p>
                <p>We hope you enjoy your purchase!</p>
                <div class="row-flex">
                    <button type="button" class="btn-1" onclick="window.location.href='orderHistory.jsp'"><span>View Orders</span></button>
                    <button type="button" class="btn-2" onclick="window.location.href='home.jsp'"><span>Continue Shopping</span></button>
                </div>
            </div>
        </div>
        <!-- Footer -->
               <%@include file="footer.jsp"%>

</body>
</html>
