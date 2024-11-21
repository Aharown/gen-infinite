import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "icon", "modeText" ]

  connect() {
    const theme = localStorage.getItem("theme");
    if (theme === "dark") {
      document.documentElement.classList.add("dark-mode");
      document.documentElement.classList.remove("light-mode");
      this.iconTarget.classList.add("fa-sun");
      this.iconTarget.classList.remove("fa-moon");
      this.modeTextTarget.textContent = "Light";
    } else {
      document.documentElement.classList.add("light-mode");
      document.documentElement.classList.remove("dark-mode");
      this.iconTarget.classList.add("fa-moon");
      this.iconTarget.classList.remove("fa-sun");
      this.modeTextTarget.textContent = "Dark";
    }
  }

  toggleDarkMode() {
    document.documentElement.classList.toggle("dark-mode");

    // Toggle the icon between moon and sun
    this.iconTarget.classList.toggle("fa-sun");
    this.iconTarget.classList.toggle("fa-moon");

    // Toggle the text between 'Light' and 'Dark'
    this.modeTextTarget.textContent = document.documentElement.classList.contains("dark-mode") ? "Light" : "Dark";

    // Save the user's theme preference in localStorage
    localStorage.setItem("theme", document.documentElement.classList.contains("dark-mode") ? "dark" : "light");
  }
}
