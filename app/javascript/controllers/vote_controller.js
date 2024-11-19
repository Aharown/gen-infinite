import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["upvoteCount", "downvoteCount", "upvoteButton", "downvoteButton"];

  upvote(event) {
    event.preventDefault();
    const button = event.currentTarget;

    // Check if the user has already upvoted
    const isUpvoted = button.classList.contains("active");

    button.classList.toggle("active");

    // Define the endpoint for the action
    const action = `/posts/${button.dataset.id}/upvote`;

    // Send the AJAX request
    this._sendRequest(action, "POST", button, "upvote", isUpvoted);
  }

  downvote(event) {
    event.preventDefault();
    const button = event.currentTarget;

    // Check if the user has already downvoted
    const isDownvoted = button.classList.contains("active");

    button.classList.toggle("active");
    
    // Define the endpoint for the action
    const action = `/posts/${button.dataset.id}/downvote`;

    // Send the AJAX request
    this._sendRequest(action, "POST", button, "downvote", isDownvoted);
  }

  _sendRequest(action, method, button, type, isActive) {
    fetch(action, {
      method: method,
      headers: { "X-CSRF-Token": document.querySelector("[name='csrf-token']").content },
    })
      .then(response => response.json())
      .then(data => {
        // Update the vote counts in the DOM
        this.upvoteCountTarget.textContent = data.upvotes;
        this.downvoteCountTarget.textContent = data.downvotes;

        // Update button states
        this._updateButtonState(button, type, isActive, data);
      });
  }

  _updateButtonState(button, type, isActive, data) {
    const isUpvote = type === "upvote";
    const otherButton = isUpvote ? this.downvoteButtonTarget : this.upvoteButtonTarget;

    // Handle the active state based on the current vote status
    if (isUpvote) {
      if (isActive) {
        // If upvote was already active, deactivate it
        button.classList.remove("active");
      } else {
        // Activate upvote and deactivate downvote
        button.classList.add("active");
        otherButton.classList.remove("active");
      }
    } else {
      if (isActive) {
        // If downvote was already active, deactivate it
        button.classList.remove("active");
      } else {
        // Activate downvote and deactivate upvote
        button.classList.add("active");
        otherButton.classList.remove("active");
      }
    }
  }
}
