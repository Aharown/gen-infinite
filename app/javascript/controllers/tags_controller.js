import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tagsContainer", "categorySelect"];

  connect() {
    // Check if the tagsContainer and categorySelect are available
    if (this.hasCategorySelectTarget) {
      this.loadTags();
    }
  }

  categoryChanged() {
    this.loadTags() // call loadTags when the category changes
  }

  loadTags() {
    const categoryId = this.categorySelectTarget.value;

    if (categoryId) {
      // Make an AJAX request to the server to get the tags for the selected category
      fetch(`/categories/${categoryId}/tags`, { headers: { Accept: "application/json" } })
        .then(response => response.json())
        .then(data => {
          // Render the tags in the tagsContainer
          this.tagsContainerTarget.innerHTML = data.tags_html;
        })
        .catch(error => {
          console.error("Error loading tags:", error);
        });
    } else {
      // Clear the tags if no category is selected
      this.tagsContainerTarget.innerHTML = "<p>Please select a category first to see the available tags.</p>";
    }
  }
}
