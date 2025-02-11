// Ensure Stripe.js is loaded
const stripe = Stripe(ENV["stripe_publishable_key"]); // Replace with your actual Stripe public key

// Define your Stripe checkout options
const options = {
  name: 'DeevMatch', // The name of your service or app
  description: 'Pro plan subscription', // The description of the subscription you're offering
  amount: 1000, // Amount in cents for Pro plan (e.g., $10)
  panelLabel: 'Subscribe', // The button label that appears in the Stripe checkout
  token: function(token) {
    // This function is called when Stripe generates the token after the user submits payment details.
    
    // Get your registration form element (the one that will be submitted)
    var form = document.getElementById("registration-form"); // The form ID in your HTML
    
    // Create a hidden input field to store the Stripe token
    var stripeTokenField = document.createElement("input");
    stripeTokenField.type = "hidden";
    stripeTokenField.name = "stripeToken";
    stripeTokenField.value = token.id; // Store the token in the hidden input

    // Append the hidden input to the form so it gets submitted with the rest of the data
    form.appendChild(stripeTokenField);
    
    // Submit the form to your server
    form.submit(); // Submit the form to your server (handle the form on the server-side)
  }
};

// Open Stripe Checkout when the "Subscribe" button is clicked
const checkoutButton = document.getElementById('checkout-button'); // The button ID in your HTML
checkoutButton.addEventListener('click', function() {
  stripe.redirectToCheckout(options).then(function(result) {
    if (result.error) {
      alert(result.error.message); // Handle any errors that might occur during the checkout process
    }
  });
});
