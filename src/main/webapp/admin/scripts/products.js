export function initializePage() {
    console.log('Product page initialized');


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
     if (searchInput!=null && !searchInput.contains(e.target) && !suggestionsDiv.contains(e.target)) {
         suggestionsDiv.style.display = "none"; // Hide the dropdown
         searchInput.value = ""; // Clear the search input value
         currentFocus = -1; // Reset the focus
     }
 });
 window.onclick = function (event) {
     const modal = document.getElementById('productModal');
     if (event.target === modal) {
         closeProductPopup();
     }
 };


document.getElementById("productImage").addEventListener("change", function (event) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
            // Set the src of the image container to display the selected image
            document.getElementById("productImageDisplay").src = e.target.result;
        };
        reader.readAsDataURL(file);
    }
});


}
