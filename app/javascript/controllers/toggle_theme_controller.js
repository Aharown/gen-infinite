import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "icon" ]

  connect() {
    if (localStorage.getItem("theme") === "dark") {
      document.documentElement.classList.add("dark-mode");
      this.iconTarget.classList.remove("fa-moon");
      this.iconTarget.classList.add("fa-sun");
    }
  }

  // Function to toggle between light and dark mode
  toggleDarkMode() {
    document.documentElement.classList.toggle("dark-mode");

    // Toggle the icon between moon and sun
    this.iconTarget.classList.toggle("fa-moon");
    this.iconTarget.classList.toggle("fa-sun");

    // Save the user's theme preference in localStorage
    localStorage.setItem("theme", document.documentElement.classList.contains("dark-mode") ? "dark" : "light");
  }
}
