import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "buttons", "textarea" ]

  connect() {
   console.log("hello")
  }

  showButtons() {
    this.buttonsTarget.style.display = "block";
  }

  clearForm(event) {
    event.preventDefault();
    this.textareaTarget.value = "";
    this.buttonsTarget.style.display = "none";
  }
}
