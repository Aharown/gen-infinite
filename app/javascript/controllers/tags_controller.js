import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tagsContainer", "categorySelect"];

  static values = {vlad: String}
  connect() {
    console.log(this.vladValue)
    if (this.hasCategorySelectTarget) {
      this.loadTags();
    }
  }
  categoryChanged() {
    this.loadTags()
  }

  loadTags() {
    const categoryId = this.categorySelectTarget.value;

    if (categoryId) {
      let checkedTags=JSON.parse(document.querySelector("#tag-values").dataset.checks)
      console.log(checkedTags)

      fetch(`/categories/${categoryId}/tags`, { headers: { Accept: "application/json" } })
        .then(response => response.json())
        .then(data => {
          let tagsHTML = data.map(tag =>
            `<div class="form-check">
              <input class="form-check-input" type="checkbox" ${checkedTags.find(checkedTag => checkedTag.id === tag.id) ? "checked" : ""} value="${tag.id}" name="post[tag_ids][]" id="post_tag_ids_${tag.id}">
              <label class="form-check-label" for="post_tag_ids_${tag.id}">${tag.name}</label>
            </div>
          `).join("")

          this.tagsContainerTarget.innerHTML = tagsHTML
        })
        .catch(error => {
          console.error("Error loading tags:", error);
        });
    } else {
      this.tagsContainerTarget.innerHTML = "<p>Please select a category first to see the available tags.</p>";
    }
  }
}
