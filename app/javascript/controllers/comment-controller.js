import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "content", "textarea", "commentsList", "editForm"];

  connect() {
    console.log("Comment controller connected");
  }

  create(event) {
    event.preventDefault();
    const url = this.formTarget.action;
    const data = new FormData(this.formTarget);

    fetch(url, {
      method: "POST",
      body: data,
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
    })
      .then((response) => response.text())
      .then((html) => {
        this.commentsListTarget.insertAdjacentHTML("beforeend", html);
        this.formTarget.reset();
      });
  }

  edit(event) {
    event.preventDefault();
    const editButton = event.target;
    const editForm = editButton.closest(".answer").querySelector(".edit-answer-form");
    const contentElement = editButton.closest(".answer").querySelector(".answer-content p");

    editForm.style.display = "block";
    editForm.querySelector("textarea").value = contentElement.textContent.trim();
  }

  cancelEdit(event) {
    event.preventDefault();
    const editForm = event.target.closest(".edit-answer-form");
    editForm.style.display = "none";
  }

  update(event) {
    event.preventDefault();
    const form = event.target;
    const url = form.action;
    const data = new FormData(form);

    fetch(url, {
      method: "PATCH",
      body: data,
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
    })
      .then((response) => response.text())
      .then((html) => {
        const answerElement = form.closest(".answer");
        answerElement.outerHTML = html;
      });
  }

  delete(event) {
    event.preventDefault();
    const url = event.target.getAttribute("href");

    fetch(url, {
      method: "DELETE",
      headers: { "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
    })
      .then(() => {
        const answerElement = event.target.closest(".answer");
        answerElement.remove();
      });
  }
}
