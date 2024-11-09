import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["upvoteCount", "downvoteCount"];

  upvote(event) {
    event.preventDefault();
    const button = event.currentTarget;

    // Send AJAX request
    fetch(button.parentElement.getAttribute("action"), {
      method: "POST",
      headers: { "X-CSRF-Token": document.querySelector("[name='csrf-token']").content },
    })
      .then(response => response.json())
      .then(data => {
        // Update the count in the DOM
        this.upvoteCountTarget.textContent = data.upvotes;
      });
  }

  downvote() {
    event.preventDefault();
    const button = event.currentTarget;

    // Send AJAX request
    fetch(button.parentElement.getAttribute("action"), {
      method: "POST",
      headers: { "X-CSRF-Token": document.querySelector("[name='csrf-token']").content },
    })
      .then(response => response.json())
      .then(data => {
        // Update the count in the DOM
        this.downvoteCountTarget.textContent = data.downvotes;
      });
  }
}
