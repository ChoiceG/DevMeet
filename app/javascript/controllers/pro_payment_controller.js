import { Controller } from "@hotwired/stimulus";

// ProPaymentController handles the interactions with Stripe's payment processing
export default class ProPaymentController extends Controller {
  // Define the targets that we will interact with in the HTML
  static targets = ["cardErrors", "stripeToken", "submitButton"];

  // This method is called when the controller is connected to the DOM
  connect() {
    console.log("ProPaymentController is connected");

    // Retrieve the Stripe publishable key from a meta tag in the HTML document
    const stripePublishableKey = document.querySelector('meta[name="stripe-key"]').getAttribute('content');
    // Initialize Stripe with the publishable key
    this.stripe = Stripe(stripePublishableKey);

    // Create an instance of Stripe Elements to securely handle card details
    const elements = this.stripe.elements();
    // Create a card element which will be mounted in the DOM
    this.cardElement = elements.create('card');
    // Mount the card element to the DOM inside the element with the ID 'card-element'
    this.cardElement.mount('#card-element');

    console.log("Card element mounted successfully");
  }

  // This method is triggered when the form is submitted
  submit(event) {
    // Prevent the default form submission behavior
    event.preventDefault();

    // Retrieve the submit button element
    const button = document.querySelector('button');
    // Disable the button and change its text to indicate processing
    this.toggleButtonState(true);

    // Create a token using the card information provided in the card element
    this.stripe.createToken(this.cardElement)
      .then((result) => {
        if (result.error) {
          // If there's an error creating the token, handle the error and re-enable the button
          this.handleStripeError(result.error);
          this.toggleButtonState(false); // Re-enable the button and reset its text
        } else {
          // If token creation is successful, pass the token to the handler
          this.stripeTokenHandler(result.token);
        }
      });
  }

  // This method handles the Stripe token and appends it to the form for submission
  // stripeTokenHandler(token) {
  //   console.log("Received token:", token);

  //   // Retrieve the form element
  //   const form = document.querySelector('form');
  //   // Create a hidden input element to store the Stripe token
  //   const tokenInput = document.createElement('input');
  //   tokenInput.setAttribute('type', 'hidden');
  //   tokenInput.setAttribute('name', 'stripeToken');
  //   tokenInput.setAttribute('value', token.id);
  //   // Append the token input to the form
  //   form.appendChild(tokenInput);

  //   // Submit the form with the Stripe token included
  //   form.submit();
  // }

  stripeTokenHandler(token) {
    console.log("Received token:", token);
  
    const form = document.querySelector('form');
  
    // Add plan ID as a hidden input field
    const planInput = document.createElement('input');
    planInput.setAttribute('type', 'hidden');
    planInput.setAttribute('name', 'plan');
    planInput.setAttribute('value', new URLSearchParams(window.location.search).get('plan'));
    form.appendChild(planInput);
  
    // Create a hidden input element to store the Stripe token
    const tokenInput = document.createElement('input');
    tokenInput.setAttribute('type', 'hidden');
    tokenInput.setAttribute('name', 'stripeToken');
    tokenInput.setAttribute('value', token.id);
    form.appendChild(tokenInput);
  
    // Submit the form with the Stripe token and plan ID included
    form.submit();
  }
  

  // This method handles any errors from Stripe
  handleStripeError(error) {
    // Default error message to show to the user
    let errorMessage = "An error occurred. Please check your card details and try again.";
    console.error("Stripe error details:", error);

    // You can add additional error handling logic here if needed
    // For example, showing a more specific error message depending on the error type

    // Re-enable the submit button and reset the text
    this.toggleButtonState(false);
    // Display the error message to the user
    alert(errorMessage);
  }

  // This method enables or disables the submit button based on whether processing is ongoing
  toggleButtonState(isProcessing) {
    if (isProcessing) {
      // Disable the submit button and change its text to "Processing..."
      this.submitButtonTarget.setAttribute('disabled', '');
      this.submitButtonTarget.value = "Processing...";
      console.log("Button text changed to:", this.submitButtonTarget.value);
    } else {
      // Re-enable the submit button and reset its text
      this.submitButtonTarget.removeAttribute('disabled');
      this.submitButtonTarget.value = "Sign Up and Pay";
      console.log("Button text changed to:", this.submitButtonTarget.value);
    }
  }
}
