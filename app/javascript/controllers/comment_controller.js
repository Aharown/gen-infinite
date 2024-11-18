import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editForm", "editButton", "commentsList", "answerbuttons"];

  // Trigger the display of the edit form and pre-populate the content
  edit(event) {
    event.preventDefault();
    const editButton = event.target;
    const answerElement = editButton.closest(".answer");
    const editForm = answerElement.querySelector(".edit-answer-form");
    const contentElement = answerElement.querySelector(".answer-content p");
    editForm.style.display = "block";
    editForm.querySelector("textarea").value = contentElement.textContent.trim();
  }

  // Handle canceling the edit
  cancelEdit(event) {
    event.preventDefault();
    const editForm = event.target.closest(".edit-answer-form");
    editForm.style.display = "none";
  }

  // Handle form submission (Update comment)
  update(event) {
    event.preventDefault();  // Prevent default form submission
    const form = event.target.closest('form');
    const url = form.action;
    const data = new FormData(form);


    fetch(url, {
      method: "PATCH",
      body: data,
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        const answerElement = form.closest(".answer");
        const contentElement = answerElement.querySelector(".answer-content p");
        const editForm = answerElement.querySelector(".edit-answer-form");
        const buttons = editForm.querySelector(".form-buttons");

        contentElement.textContent = data.content;  // Update content
        editForm.style.display = "none";  // Hide the edit form
        buttons.style.display = "none";  // Hide the buttons
      } else {
        alert("Failed to update the answer.");
      }
    })
    .catch(() => alert("An error occurred during the update request."));
  }

  deleteComment(event) {
    event.preventDefault();
    const button = event.currentTarget;
    const url = button.dataset.url;

    fetch(url, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    })
      .then(response => response.json())
      .then(data => {
        console.log(data);  // Log the response to ensure it contains the necessary data
        if (data.message) {
          document.getElementById(`answer-${button.dataset.commentId}`).remove();
        } else {
          alert("Failed to delete the comment.");
        }
      })
      .catch(() => alert("An error occurred during the delete request."));
  }
}
