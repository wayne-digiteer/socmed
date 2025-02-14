// app/javascript/controllers/debounce_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];
  static values = {
    delay: { type: Number, default: 500 },
  };

  connect() {
    console.log("Debounce controller connected");
  }

  initialize() {
    console.log("Debounce controller initialized");
    this.submit = this.debounce(this.submit.bind(this), this.delayValue);
  }

  search(event) {
    console.log("Search triggered", event.target.value);
    this.submit(event.target.form);
  }

  submit(form) {
    this.requestSubmit(form);
  }

  debounce(fn, delay) {
    console.log("debounce");
    let timeoutId;
    return (...args) => {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(() => fn.apply(this, args), delay);
    };
  }

  // Helper function to handle Safari compatibility
  requestSubmit(form) {
    if (typeof form.requestSubmit === "function") {
      form.requestSubmit();
    } else {
      form.submit();
    }
  }
}
