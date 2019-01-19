class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update]
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
      render 'new' 
    end
  end

  def edit
    authorize @category
  end

  def update
    authorize @category
    if @category.update(category_params)
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  private
  def category_params
    params.require(:category).permit(:name, :kind)
  end
  def set_category
    @category = Category.find(params[:id])
  end
end
