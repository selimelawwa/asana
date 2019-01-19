class SubcategoriesController < ApplicationController
  before_action :set_category
  before_action :set_sub_category, only: [:edit, :update]
  def index
    redirect_to root_path unless current_user.admin?
    @sub_categories = @category.sub_categories
  end

  def new
    @sub_category = Category.sub_category.new
    authorize @category
  end

  def create
    @sub_category = Category.sub_category.new(sub_category_params)
    authorize @category
    if @sub_category.save
      redirect_to category_subcategories_path(category_id: @category.id)
    else
      render 'new' 
    end
  end

  def edit
    authorize @category
  end

  def update
    authorize @category
    if @sub_category.update(sub_category_params)
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  private
  def sub_category_params
    params.require(:category).permit(:name, :kind, :parent_id)
  end
  def set_category
    @category = Category.find(params[:category_id])
  end
  def set_sub_category
    @sub_category = Category.find(params[:id])
  end
end
