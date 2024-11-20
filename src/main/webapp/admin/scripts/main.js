document.addEventListener('DOMContentLoaded', () => {
    const sidebarLinks = document.querySelectorAll('.sidebar ul li a');
    const dynamicContent = document.getElementById('dynamic-content');
    const loadingSpinner = document.getElementById('loading-spinner'); // Spinner element

    // Function to toggle the spinner
    const toggleSpinner = (show) => {
        loadingSpinner.style.display = show ? 'block' : 'none';
        dynamicContent.classList.toggle('loading', show); // Optional: add visual feedback for the content area
    };

    // Function to load content dynamically
    const loadContent = (link) => {
        const contentKey = link.getAttribute('data-content');
        const url = link.getAttribute('data-url'); // URL to fetch HTML content
        const scriptPath = link.getAttribute('data-script'); // Path to the page-specific script

        toggleSpinner(true); // Show spinner

        // Fetch content dynamically
        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! Status: ${response.status}`);
                }
                return response.text();
            })
            .then(data => {
                // Load fetched content into the dynamic content area
                dynamicContent.innerHTML = data;

                // Dynamically load the page-specific script, if specified
                if (scriptPath) {
                    import(scriptPath)
                        .then((module) => {
                            if (typeof module.initializePage === 'function') {
                                module.initializePage(); // Call page-specific initialization function
                            }
                        });
                }
            })
            .catch(error => {
                console.error(`Error loading page: ${error}`);
                dynamicContent.innerHTML = `<p>Error loading content. Please try again later.</p>`;
            })
            .finally(() => {
                toggleSpinner(false); // Hide spinner
            });

        // Highlight active link
        sidebarLinks.forEach(link => link.classList.remove('active'));
        link.classList.add('active');
    };

    // Add event listener to sidebar links
    sidebarLinks.forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault();
            loadContent(link);
        });
    });

    // On load, set dashboard as active and load its content
    const defaultLink = document.querySelector('.sidebar ul li a[data-content="dashboard"]');
    if (defaultLink) {
        loadContent(defaultLink);
    }
});



 function changePage(url) {
         const dynamicContent = document.getElementById('dynamic-content');
         fetch(url)
             .then(response => {
                 if (!response.ok) {
                     throw new Error(`HTTP error! Status: ${response.status}`);
                 }
                 return response.text();
             })
             .then(data => {
                 dynamicContent.innerHTML = data;
                 const newUrl = window.location.origin + window.location.pathname;
                 history.pushState(null, '', newUrl);
             })
             .catch(err => {
                 console.error("Error loading page:", err);
             });

  }

  //orders

  function updateStatus(orderId, newStatus) {
      const xhr = new XMLHttpRequest();
      xhr.open("POST", "../updateOrderStatusServlet", true);
      xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

      xhr.onreadystatechange = function () {
          if (xhr.readyState === 4 && xhr.status === 200) {
              alert("status updated successfully.");
          }
      };

      xhr.send("order_id=" + orderId + "&status=" + newStatus);
  }
function loadPage2(page) {
    const params = new URLSearchParams({
        fromDate: document.getElementById('fromDate').value,
        toDate: document.getElementById('toDate').value,
        product: document.getElementById('product').value,
        user: document.getElementById('user').value,
        orderStatus: document.getElementById('orderStatus').value,
        page: page
    });

     const url = `../searchOrdersServlet?`+params.toString();
     const dynamicContent = document.getElementById('dynamic-content');

    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.text();
        })
        .then(data => {
            dynamicContent.innerHTML = data;
        })
        .catch(err => {
            console.error("Error loading page:", err);
        });
 }

function applyFilters() {
      const fromDate = document.getElementById('fromDate').value;
        const toDate = document.getElementById('toDate').value;
        const product = document.getElementById('product').value;
        const user = document.getElementById('user').value;
        const orderStatus = document.getElementById('orderStatus').value;
        let queryParams = `?fromDate=${fromDate}&toDate=${toDate}&product=${product}&user=${user}&status=${orderStatus}`;
        url=`../searchOrders`+queryParams;
        const dynamicContent = document.getElementById('dynamic-content');
        fetch(url)
           .then(response => {
               if (!response.ok) {
                   throw new Error(`HTTP error! Status: ${response.status}`);
               }
               return response.text();
           })
           .then(data => {
               dynamicContent.innerHTML = data;
           })
           .catch(err => {
               console.error("Error loading page:", err);
  });
}



  //product

  function loadPage(page,query) {
          const url =  query
                      ? `../searchResultsServlet?query=` + query + `&src=dashboard&page=` + page
                      : `../allProductsServlet?page=`+ page;
          const dynamicContent = document.getElementById('dynamic-content');


          fetch(url)
              .then(response => {
                  if (!response.ok) {
                      throw new Error(`HTTP error! Status: ${response.status}`);
                  }
                  return response.text();
              })
              .then(data => {
                  dynamicContent.innerHTML = data;
              })
              .catch(err => {
                  console.error("Error loading page:", err);
              });

   }
function submitForm(event) {
       event.preventDefault();
       const form = document.getElementById('add-product');
       const formData = new FormData(form);
       const dynamicContent = document.getElementById('dynamic-content');
       dynamicContent.innerHTML = '<p>Loading...</p>';

       fetch('../addProductServlet', {
           method: 'POST',
           body: formData
       })
         .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.text();
        })
        .then(data => {
            dynamicContent.innerHTML = data;
            const newUrl = window.location.origin + window.location.pathname;
            history.pushState(null, '', newUrl);
        })
        .catch(err => {
            console.error("Error loading page:", err);
        });

   }

let currentFocus = -1;
let debounceTimeout;

function fetchSuggestions(query) {
   const suggestionsDiv = document.getElementById('suggestions');
   if (query === "") {
       suggestionsDiv.style.display = "none";
       return;
   }

   fetch('../searchSuggestions?query=' + encodeURIComponent(query))
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
       url = `../searchResultsServlet?query=`+ query + `&src=1`;
       const dynamicContent = document.getElementById('dynamic-content');

       fetch(url)
           .then(response => {
               if (!response.ok) {
                   throw new Error(`HTTP error! Status: ${response.status}`);
               }
               return response.text();
           })
           .then(data => {
               dynamicContent.innerHTML = data;
           })
           .catch(err => {
               console.error("Error loading page:", err);
           });

    } else {
       alert("Please enter a search term."); // Notify the user to enter a search term
    }
}
function showProductPopup(product) {
    console.log("Product Details:", product);
    document.getElementById('productId').value = product.p_id;
    document.getElementById('productBrand').value = product.brand;
    document.getElementById('productCategory').value = product.category;
    document.getElementById('productDescription').value = product.description;
    document.getElementById('productImageDisplay').src = product.img_url;
    document.getElementById('productName').value = product.name;
    document.getElementById('productPrice').value = product.price;
    document.getElementById('productStock').value = product.stock;

    const modal = document.getElementById('productModal');
    modal.style.display = 'block';
}

function closeProductPopup() {
    const modal = document.getElementById('productModal');
    modal.style.display = 'none';
}

function enableEdit(fieldId) {
    const field = document.getElementById(fieldId);
    field.removeAttribute('readonly');
    field.focus();
}

function submitForm2(event, action) {
    event.preventDefault();
    const form = document.getElementById('productForm');
    const formData = new FormData(form);

    formData.append('action', action);

    fetch('../updateProductServlet', {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            closeProductPopup();
            if (data.status === 'success') {
                alert(data.message); // Show success alert
               fetchUpdatedProducts();
            } else {
                alert(`Error: ${data.message}`); // Show error alert
            }
        })
        .catch(err => {
            console.error("Error handling form submission:", err);
            alert("An unexpected error occurred. Please try again.");
        });
}
function fetchUpdatedProducts() {
    // Fetch the updated content
    scriptPath="/E-Kart/admin/scripts/products.js";
    fetch('../allProductsServlet')  // Your API to get updated content
        .then(response => response.text()) // assuming response is HTML
        .then(data => {
            document.getElementById('dynamic-content').innerHTML = data;
            import(scriptPath)
                .then((module) => {
                    if (typeof module.initializePage === 'function') {
                        module.initializePage();
                    }
                });
        })
        .catch(err => console.error("Error fetching updated products:", err));
}



//add new product
function updateStock(value) {
    const stockInput = document.getElementById("stock");
    const currentValue = parseInt(stockInput.value) || 0;
    const newValue = currentValue + value;

    stockInput.value = newValue < 0 ? 0 : newValue;
}


//users
function loadPage3(page) {
     const url = `../allUsersServlet?page=`+ page;
     const dynamicContent = document.getElementById('dynamic-content');

     fetch(url)
         .then(response => {
             if (!response.ok) {
                 throw new Error(`HTTP error! Status: ${response.status}`);
             }
             return response.text();
         })
         .then(data => {
             dynamicContent.innerHTML = data;
         })
         .catch(err => {
             console.error("Error loading page:", err);
         });
}

