import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "buttons", "textarea", "submitButton" ]

  connect() {
   console.log("hello")
   this.submitButtonTarget.addEventListener('click', (event) => {
    this.update(event);
   });
  }

  showButtons() {
    this.buttonsTarget.style.display = "block";
  }

  clearForm(event) {
    event.preventDefault();
    this.textareaTarget.value = "";
    this.buttonsTarget.style.display = "none";
  }

  submitComment(event) {
    event.preventDefault();

    const form = event.target;
    const url = form.action;
    const data = new FormData(form);

    fetch(url, {
      method: "POST",
      body: data,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        if (data.success) {
          const commentSection = document.getElementById("answers");

          // Create the new comment HTML
          const newComment = document.createElement("div");
          newComment.classList.add("answer");
          newComment.id = `answer-${data.id}`;
          newComment.setAttribute("data-is-current-user", data.is_current_user);

          newComment.innerHTML = `
            <div class="post-header-comments">
              <div class="user-profile-photo-show">
                ${data.profile_photo_url ? `<img src="${data.profile_photo_url}" alt="${data.username}'s profile photo">` : ""}
              </div>
              <p class="username"><strong>${data.username}</strong></p>
            </div>
            <div class="answer-content">
              <p>${data.content}</p>
            </div>

            <div class="answer-actions" data-comment-form-target="answerbuttons">
              <button class="btn-primary" data-action="click->comment#edit" data-comment-target="editButton">Edit</button>
              <form class="button_to" method="post" action="/posts/${data.post_id}/answers/${data.id}">
                <input type="hidden" name="_method" value="delete" autocomplete="off">
                <button class="btn-primary" data-action="click->comment#deleteComment" data-comment-id="${data.id}" data-url="/posts/${data.post_id}/answers/${data.id}" type="submit">
                  Delete
                </button>
                <input type="hidden" name="authenticity_token" value="BeuQhrfdziJwVpbpItF1go2PwYQ98gG8HXtkLmIEooKYQrYcK6dRuID7KkGOvfPjIOoucHhEl5tHUn1DP9IQGw" autocomplete="off">
              </form>
            </div>

            <div class="edit-answer-form" style="display: none;" data-comment-target="editForm">
              <form data-action="submit->comment#update" action="/posts/${data.post_id}/answers/${data.id}" accept-charset="UTF-8" method="post">
                <input type="hidden" name="_method" value="patch" autocomplete="off">
                <input type="hidden" name="authenticity_token" value="zLCoaJcdvMs8rIGvfQB00eEzB4cRpPcRGHzLhU6EsbT3iXGy21fZgAw5OvM70AWN4Wok9zJrfNuHWaJpEMZqWA" autocomplete="off">
                <div class="form-group">
                  <label for="answer_content">Edit your comment</label>
                  <textarea rows="1" class="form-control" name="answer[content]" id="answer_content">test</textarea>
                </div>
                <div class="form-buttons">
                  <input type="submit" name="commit" value="Update" class="btn-primary" data-action="click->comment#update" data-disable-with="Update">
                  <button type="button" class="btn-primary" data-action="click->comment#cancelEdit">Cancel</button>
                </div>
              </form>
            </div> `;

        commentSection.prepend(newComment);

        // Clear the input field
        this.textareaTarget.value = "";
      } else {
        alert("Failed to add comment.");
      }
    })
    .catch(() => alert("An error occurred during the comment submission."));
  }
}
