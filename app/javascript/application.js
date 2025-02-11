// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"

import { Application } from "@hotwired/stimulus";

import ProPaymentController from "./controllers/pro_payment_controller.js";

const application = Application.start();
application.register("pro-payment", ProPaymentController);
application.debug = false;
window.Stimulus = application;

// export { application };