import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["upvoteCount", "downvoteCount", "upvoteButton", "downvoteButton"];

  upvote(event) {
    event.preventDefault();
    const button = event.currentTarget;

    const isUpvoted = button.classList.contains("active");

    button.classList.toggle("active");

    const action = `/posts/${button.dataset.id}/upvote`;

    this._sendRequest(action, "POST", button, "upvote", isUpvoted);
  }

  downvote(event) {
    event.preventDefault();
    const button = event.currentTarget;
    const isDownvoted = button.classList.contains("active");

    button.classList.toggle("active");

    const action = `/posts/${button.dataset.id}/downvote`;

    this._sendRequest(action, "POST", button, "downvote", isDownvoted);
  }

  _sendRequest(action, method, button, type, isActive) {
    fetch(action, {
      method: method,
      headers: { "X-CSRF-Token": document.querySelector("[name='csrf-token']").content },
    })
      .then(response => response.json())
      .then(data => {
        this.upvoteCountTarget.textContent = data.upvotes;
        this.downvoteCountTarget.textContent = data.downvotes;
        this._updateButtonState(button, type, isActive, data);
      });
  }

  _updateButtonState(button, type, isActive, data) {
    const isUpvote = type === "upvote";
    const otherButton = isUpvote ? this.downvoteButtonTarget : this.upvoteButtonTarget;

    if (isUpvote) {
      if (isActive) {
        button.classList.remove("active");
      } else {
        button.classList.add("active");
        otherButton.classList.remove("active");
      }
    } else {
      if (isActive) {
        button.classList.remove("active");
      } else {
        button.classList.add("active");
        otherButton.classList.remove("active");
      }
    }
  }
}
