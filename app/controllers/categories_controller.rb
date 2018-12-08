class CategoriesController < ApplicationController
  def index
    @categories = Category.category
  end
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      render 'new'
    end
  end

  private
  def category_params
    params.require(:category).permit(:name, :kind, :parent_id)
  end
end
