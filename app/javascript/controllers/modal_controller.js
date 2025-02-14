// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["background", "content"];

  connect() {
    // Prevent click events inside modal from bubbling to background
    this.contentTarget.addEventListener("click", (e) => e.stopPropagation());

    // Close modal when escape key is pressed
    document.addEventListener("keydown", this.handleKeydown.bind(this));
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown.bind(this));
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close();
    }
  }

  close() {
    this.element.remove();
  }
}
