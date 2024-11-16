import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["options"];

  toggleMenu() {
    this.optionsTarget.style.display =
      this.optionsTarget.style.display === "none" ? "block" : "none";
  }
}
