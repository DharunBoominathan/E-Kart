<%-- popup.jsp --%>

<div id="successPopup" class="popup">
    <span id="closePopup" style="cursor: pointer; float: right;font-size: 25px;">&times;</span>
    <div class="radial">
        <span id="popupMessage"></span>
    </div>
</div>

<%-- Alert Popup --%>
<div id="alertPopup" class="popup alert-popup">
    <div>
        <span id="closeAlertPopup" style="cursor: pointer; float: right; font-size: 18px;">&times;</span>
        <span id="alertMessage"></span>
    </div>
</div>
<style>
    .popup {
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background-color: #fff;
        color: #333;
        border-radius: 12px;
        box-shadow: 0px 6px 10px rgba(0, 0, 0, 0.2);
        display: none;
        z-index: 1000;
        opacity: 0;
        transition: opacity 0.3s ease-in-out, transform 0.3s ease-in-out;
        width: 400px;
    }

    .popup.show {
        display: block;
        opacity: 1;
    }

    .radial {
        border: 10px solid;
        border-image: linear-gradient(45deg, turquoise, greenyellow) 1;
        padding: 15px; /* Internal padding inside the radial border */
        text-align: center; /* Center the text inside the popup */
    }

    #popupMessage {
        font-size: 18px; /* Increase font size for better readability */
        display: block;
        margin-top: 10px;
    }

    #closePopup {
        float: right;
        font-size: 20px;
        font-weight: bold;
    }

     .alert-popup {
        background-color: #f44336;
        color: white;
        padding: 15px;
        border: 2px solid #ff7961;
        text-align: center;
    }

    #alertMessage {
        font-size: 18px;
    }
</style>
<script>
    function showPopup(message) {
        const popup = document.getElementById('successPopup');
        const popupMessage = document.getElementById('popupMessage');
        popupMessage.textContent = message;
        popup.classList.add('show');

        document.getElementById('closePopup').onclick = () =>
            popup.classList.remove('show');


        setTimeout(() => popup.classList.remove('show'), 5000);
    }
     function showAlert(message) {
        const alertPopup = document.getElementById('alertPopup');
        const alertMessage = document.getElementById('alertMessage');
        alertMessage.textContent = message;
        alertPopup.classList.add('show');

        document.getElementById('closeAlertPopup').onclick = () =>
            alertPopup.classList.remove('show');

        // Auto-hide after 5 seconds
        setTimeout(() => alertPopup.classList.remove('show'), 5000);
    }
</script>
