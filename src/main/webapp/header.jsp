<%@page import="com.daoimp.CartDAOImp"
        import="com.model.User"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="images/tabIcon.png">
    <title>Grabbio</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>

        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .main-header{
            background-color: #DDD0C8;
            min-height:100px;
            align-content:center;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            width: 100%;
            z-index: 1000;
            transition: background-color 0.3s ease;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 90%;
            padding-left: 5%;

        }


        .logo {
            color: white;
            font-size: 26px;
            font-weight: bold;
            text-transform: uppercase;
            width: 10%;
        }

        /* Search Bar Styling */
        .search-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 100%;
            max-width: 400px;
        }

        .search-bar input {
            width: 100%;
            padding-right: 40px;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 25px;
        }
        .search-bar input:focus {
            outline: none;
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

        .nav-links{
            display:flex;
        }

        .nav-links a {
            color: #323232;
            margin-left: 25px;
            text-decoration: none;
            font-size: 18px;
            transition: color 0.3s, background-color 0.3s;
        }

        .nav-links a:hover {
            border-bottom: 2px solid  #323232;
        }

        .profile-header {
            display: flex;
            align-items: center;
            position: relative;
        }

        /* Hidden profile links container */
        .profile-links {
            display: flex;
            gap: 5px;
            position: relative;
            opacity: 0;
            transform: translateX(-10px);
            transition: all 0.4s ease;
        }

        /* Hover effect for profile links */
        .profile-header:hover .profile-links {
            opacity: 1;
            transform: translateX(0);
        }

        /* Individual profile link styling */
        .profile-links a {
            color: #323232;
            font-size: 18px;
            text-decoration: none;
            opacity: 0;
            transform: scale(0.8);
            animation: slideIn 0.3s forwards;
            animation-delay: 0.1s;
        }

        .profile-links a:nth-child(2) {
            animation-delay: 0.2s;
        }

        /* Keyframes for sliding in effect */
        @keyframes slideIn {
            0% {
                opacity: 0;
                transform: scale(0.8);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        .scrolled {
            background-color: #ffffff;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>

</head>
<body>

    <%
        int count = ( session.getAttribute("user") == null) ? 0 : new CartDAOImp().getCartItemCount((User) session.getAttribute("user"));
    %>

    <!-- Header -->
    <div class="main-header" id="header">
    <div class="header">
        <!-- Logo -->
        <a href="home.jsp" class="logo">
            <img src="images/logo.png" alt="logo" style="width: 150%;">
        </a>

        <!-- Search Bar -->
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

        <!-- Navigation Links -->
                <div class="nav-links">
                    <% if (session.getAttribute("user") != null) { %>
                        <!-- Profile Icon with Animated Links -->
                        <div class="profile-header">
                            <div class="profile-links">
                                <a href="profile.jsp">Profile</a>
                                <a href="logoutServlet">Logout</a>
                            </div>
                            <a href="#"><i class="bi bi-person-square"></i></a>
                        </div>
                    <% } else { %>
                         <a href="login.jsp"><i class="bi bi-box-arrow-in-right"> Login</i></a>
                    <% } %>

                <a href="cartServlet"><i class="bi bi-bag-heart"></i>Shopping Bag (<span class="cart-count"><%=count%></span>)</a>


            <% if (session.getAttribute("user") != null) { %>
                <a href="orderHistory.jsp">Orders</a>
            <% } else { %>
                <a href="orderHistoryServlet">Orders</a>
            <% } %>
        </div>
    </div>

    </div>

    <script>
        window.addEventListener("scroll", function() {
            const header = document.getElementById("header");
            if (window.scrollY > 50) {
                header.classList.add("scrolled");
            } else {
                header.classList.remove("scrolled");
            }
        });

        let currentFocus = -1;
        let debounceTimeout;

        document.getElementById('searchInput').addEventListener('input', function () {
            clearTimeout(debounceTimeout); // Clear previous debounce
            const query = this.value.trim();
            debounceTimeout = setTimeout(() => fetchSuggestions(query), 300); // Debounce fetchSuggestions
        });

        document.getElementById('searchInput').addEventListener('keydown', function (e) {
            const suggestionsDiv = document.getElementById('suggestions');
            const suggestions = suggestionsDiv.getElementsByTagName('div');

            if (!suggestions || suggestions.length === 0) return;

            if (e.key === "ArrowDown") {
                // Move focus down
                currentFocus++;
                if (currentFocus >= suggestions.length) currentFocus = 0; // Loop back to the top
                setActive(suggestions);
                e.preventDefault(); // Prevent default scrolling
            } else if (e.key === "ArrowUp") {
                // Move focus up
                currentFocus--;
                if (currentFocus < 0) currentFocus = suggestions.length - 1; // Loop to the bottom
                setActive(suggestions);
                e.preventDefault(); // Prevent default scrolling
            } else if (e.key === "Enter") {
                e.preventDefault(); // Prevent form submission
                if (currentFocus > -1 && suggestions[currentFocus]) {
                    // If a suggestion is focused, use it
                    selectSuggestion(suggestions[currentFocus].textContent.trim());
                } else {
                    // If no suggestion is focused, search directly
                    performSearch();
                }
            }
        });

        document.addEventListener("click", function (e) {
            const searchInput = document.getElementById('searchInput');
            const suggestionsDiv = document.getElementById('suggestions');

            // Check if the click is outside the search input and suggestions dropdown
            if (!searchInput.contains(e.target) && !suggestionsDiv.contains(e.target)) {
                suggestionsDiv.style.display = "none"; // Hide the dropdown
                searchInput.value = ""; // Clear the search input value
                currentFocus = -1; // Reset the focus
            }
        });


        function fetchSuggestions(query) {
            const suggestionsDiv = document.getElementById('suggestions');
            if (query === "") {
                suggestionsDiv.style.display = "none";
                return;
            }

            fetch('searchSuggestions?query=' + encodeURIComponent(query))
                .then(response => response.json())
                .then(suggestions => {
                    // Clear previous suggestions but preserve the current focus
                    const currentValue = currentFocus;
                    suggestionsDiv.innerHTML = "";
                    if (suggestions.length > 0) {
                        suggestions.forEach((item, index) => {
                            const suggestion = document.createElement('div');
                            suggestion.textContent = item;
                            suggestion.tabIndex = index;
                            suggestion.onclick = () => selectSuggestion(item);
                            suggestionsDiv.appendChild(suggestion);
                        });
                    } else {
                        const noResult = document.createElement('div');
                        noResult.textContent = "No suggestions found";
                        noResult.style.color = "#333";
                        suggestionsDiv.appendChild(noResult);
                    }
                    suggestionsDiv.style.display = "block";
                    currentFocus = currentValue; // Restore focus after rendering
                    setActive(suggestionsDiv.getElementsByTagName('div'));
                })
                .catch(err => {
                    console.error("Error fetching suggestions:", err);
                    suggestionsDiv.style.display = "none";
                });
        }

        function setActive(suggestions) {
            // Remove active state from all suggestions
            for (const suggestion of suggestions) {
                suggestion.style.backgroundColor = "";
            }
            if (currentFocus > -1 && suggestions[currentFocus]) {
                // Highlight the current focused suggestion
                suggestions[currentFocus].style.backgroundColor = "#f0f0f0";
                suggestions[currentFocus].style.border = "1px solid #333";
                suggestions[currentFocus].style.borderRadius = "15px";
                suggestions[currentFocus].scrollIntoView({ block: "nearest" });
            }
        }

        function selectSuggestion(item) {
            document.getElementById('searchInput').value = item; // Set the input field to the selected item
            document.getElementById('suggestions').style.display = "none"; // Hide suggestions list
            performSearch(); // Trigger search immediately
        }

        function performSearch() {
            const query = document.getElementById('searchInput').value.trim();
            if (query) {
                window.location.href = 'searchResultsServlet?query=' + encodeURIComponent(query);
            } else {
                alert("Please enter a search term."); // Notify the user to enter a search term
            }
        }

    </script>
</body>


</html>
