// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"


// Function to toggle between light and dark mode
function toggleDarkMode() {
  document.documentElement.classList.toggle("dark-mode");

  // Toggle the icon between moon and sun
  const icon = document.getElementById("theme-icon");
  if (document.documentElement.classList.contains("dark-mode")) {
    icon.classList.remove("fa-moon");
    icon.classList.add("fa-sun");
  } else {
    icon.classList.remove("fa-sun");
    icon.classList.add("fa-moon");
  }

  // Save the user's theme preference in localStorage
  localStorage.setItem("theme", document.documentElement.classList.contains("dark-mode") ? "dark" : "light");
}

// Set the theme based on localStorage when the page loads
document.addEventListener("turbo:load", () => {
  // Apply dark mode if the preference is saved as "dark"
  if (localStorage.getItem("theme") === "dark") {
    document.documentElement.classList.add("dark-mode");
    const icon = document.getElementById("theme-icon");
    icon.classList.remove("fa-moon");
    icon.classList.add("fa-sun");
  }

  // Add event listener for the theme toggle button
  const themeToggleButton = document.getElementById("theme-toggle-button");
  if (themeToggleButton) {
    themeToggleButton.addEventListener("click", toggleDarkMode);
  }
});
