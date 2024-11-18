import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "content", "textarea"];

  connect() {
    console.log("EditComment controller connected");
  }

  toggleEditForm(event) {
    event.preventDefault();
    this.formTarget.style.display =
      this.formTarget.style.display === "none" ? "block" : "none";
    this.textareaTarget.value = this.contentTarget.textContent.trim();
  }

  cancelEdit(event) {
    event.preventDefault();
    this.formTarget.style.display = "none";
  }

  submitForm(event) {
    // Optionally add custom logic for submission here
    console.log("Form submitted");
  }
}
