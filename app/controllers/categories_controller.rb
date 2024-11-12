class CategoriesController < ApplicationController
  def tags
    @category = Category.find(params[:id])
    @tags = @category.tags

    respond_to do |format|
      format.json { render json: { tags_html: render_to_string(partial: "tags/form", locals: { tags: @tags }) } }
    end
  end
end
