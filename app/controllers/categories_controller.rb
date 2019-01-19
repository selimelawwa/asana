class CategoriesController < ApplicationController
  def index
    @categories = Category.category
    authorize @categories
  end
  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    authorize @category
    if @category.save
      redirect_to categories_path
    else
      if @category.category?
        flash.now[:alert] = @category.errors.messages
        render 'new' 
      else
        flash[:alert] = @category.errors.messages
        redirect_to categories_path
      end
    end
  end

  private
  def category_params
    params.require(:category).permit(:name, :kind, :parent_id)
  end
end
