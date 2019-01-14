class TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy, :show, :available_products, :assign_products]
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
    authorize @tag
  end

  def available_products
    authorize @tag
    @products =  Product.where.not(id: Product.joins(:tags).where(tags: {id: @tag.id}).pluck(:id))
                  .order(:created_at).paginate(:page => params[:page], :per_page => 25)
  end

  def assign_products
    authorize @tag
    products = Product.where(id: params[:product_ids])
    @tag.products << products
  end

  def create
    @tag = Tag.new(tag_params)
    authorize @tag
    if @tag.save
      redirect_to tags_path
    else
      render 'new'
    end
  end

  def edit
    authorize @tag
  end

  def update
    authorize @tag
    if @tag.update(tag_params)
      redirect_to tags_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @tag
    @tag.destroy
    redirect_to tags_path  
  end
  
  private
  def tag_params
    params.require(:tag).permit(:name)
  end
  def set_tag
    @tag = Tag.find_by(id: params[:id]) || Tag.find_by(id: params[:tag_id])
  end
end
