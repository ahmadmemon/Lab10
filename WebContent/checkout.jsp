<!DOCTYPE html>
<html>
<head>
    <title>GADA ELECTRONICS - Checkout</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f8f8;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1, h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .form-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .payment-section {
            display: none;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        .button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Checkout</h1>

    <form method="post" action="processOrder.jsp" onsubmit="return validateForm()">
        <!-- Checkout Option Selection -->
        <div class="form-section">
            <h2>Choose Checkout Option</h2>
            <div class="form-group">
                <label for="checkoutOption">Select Checkout Option:</label>
                <select name="checkoutOption" id="checkoutOption" onchange="toggleCheckoutOption()" required>
                    <option value="">Select an option</option>
                    <option value="customerId">Checkout by Customer ID</option>
                    <option value="paymentInfo">Checkout with Payment Info</option>
                </select>
            </div>
        </div>

        <!-- Customer ID Authentication -->
        <div id="customerIdSection" class="form-section checkout-option">
            <h2>Customer Information</h2>
            <div class="form-group">
                <label for="customerId">Customer ID:</label>
                <input type="text" name="customerId" id="customerId">
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" name="password" id="password">
            </div>
        </div>

        <!-- Payment Method Selection -->
        <div id="paymentInfoSection" class="form-section checkout-option">
            <h2>Payment Method</h2>
            <div class="form-group">
                <label for="paymentMethod">Select Payment Method:</label>
                <select name="paymentMethod" id="paymentMethod" onchange="togglePaymentDetails()">
                    <option value="">Select a payment method</option>
                    <option value="credit">Credit Card</option>
                    <option value="debit">Debit Card</option>
                </select>
            </div>

            <!-- Credit Card Details -->
            <div id="creditCardSection" class="payment-section">
                <h2>Card Details</h2>
                <div class="form-group">
                    <label for="cardNumber">Card Number:</label>
                    <input type="text" name="cardNumber" id="cardNumber" maxlength="16" placeholder="1234 5678 9012 3456">
                </div>
                <div class="form-group">
                    <label for="expiryDate">Expiry Date:</label>
                    <input type="text" name="expiryDate" id="expiryDate" placeholder="MM/YY" maxlength="5">
                </div>
                <div class="form-group">
                    <label for="cvv">CVV:</label>
                    <input type="text" name="cvv" id="cvv" maxlength="3">
                </div>
            </div>

            <!-- Shipping Information -->
            <h2>Shipping Information</h2>
            <div class="form-group">
                <label for="shipAddress">Address:</label>
                <input type="text" name="shipAddress" id="shipAddress">
            </div>
            <div class="form-group">
                <label for="shipCity">City:</label>
                <input type="text" name="shipCity" id="shipCity">
            </div>
            <div class="form-group">
                <label for="shipState">State/Province:</label>
                <input type="text" name="shipState" id="shipState">
            </div>
            <div class="form-group">
                <label for="shipPostal">Postal Code:</label>
                <input type="text" name="shipPostal" id="shipPostal">
            </div>
            <div class="form-group">
                <label for="shipCountry">Country:</label>
                <input type="text" name="shipCountry" id="shipCountry">
            </div>
        </div>

        <input type="submit" value="Place Order" class="button">
    </form>
</div>

<script>
function toggleCheckoutOption() {
    const checkoutOption = document.getElementById('checkoutOption').value;
    const customerIdSection = document.getElementById('customerIdSection');
    const paymentInfoSection = document.getElementById('paymentInfoSection');
    
    if (checkoutOption === 'customerId') {
        customerIdSection.style.display = 'block';
        paymentInfoSection.style.display = 'none';
    } else if (checkoutOption === 'paymentInfo') {
        customerIdSection.style.display = 'none';
        paymentInfoSection.style.display = 'block';
    } else {
        customerIdSection.style.display = 'none';
        paymentInfoSection.style.display = 'none';
    }
}

function togglePaymentDetails() {
    const paymentMethod = document.getElementById('paymentMethod').value;
    const creditCardSection = document.getElementById('creditCardSection');
    
    if (paymentMethod === 'credit' || paymentMethod === 'debit') {
        creditCardSection.style.display = 'block';
    } else {
        creditCardSection.style.display = 'none';
    }
}

function validateForm() {
    const checkoutOption = document.getElementById('checkoutOption').value;
    
    if (checkoutOption === 'paymentInfo') {
        const paymentMethod = document.getElementById('paymentMethod').value;
        
        if (paymentMethod === 'credit' || paymentMethod === 'debit') {
            const cardNumber = document.getElementById('cardNumber').value;
            if (!/^\d{16}$/.test(cardNumber)) {
                alert('Please enter a valid 16-digit card number');
                return false;
            }

            const expiryDate = document.getElementById('expiryDate').value;
            if (!/^(0[1-9]|1[0-2])\/([0-9]{2})$/.test(expiryDate)) {
                alert('Please enter a valid expiry date (MM/YY)');
                return false;
            }

            const cvv = document.getElementById('cvv').value;
            if (!/^\d{3}$/.test(cvv)) {
                alert('Please enter a valid 3-digit CVV');
                return false;
            }
        }
    }

    return true;
}
</script>

</body>
</html>

