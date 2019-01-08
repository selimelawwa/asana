class ProductsController < ApplicationController
  before_action :set_product, only: [:destroy, :edit, :update, :show]
  
  def index
    if params[:category_id].blank?
      @products = Product.all
    else
      @category = Category.find(params[:category_id])
      @products = @category.products
    end
    @q = @products.ransack(params[:q])
    @products = @q.result(distinct: true).order(:created_at).paginate(:page => params[:page], :per_page => 3)
    @custom_paginate_renderer = custom_paginate_renderer
  end

  #list for admin
  def list
    if params[:category_id].blank?
      @products = Product.all
    else
      @category = Category.find( params[:category_id])
      @products = @category.products
    end
    @q = @products.ransack(params[:q])
    @products = @q.result.order(:created_at).paginate(:page => params[:page], :per_page => 3)
    @custom_paginate_renderer = custom_paginate_renderer
  end

  def search
    index
    render :index
  end

  def show
    params[:color_id] ||= @product.main_color_id
    @colored_variant = @product.variants.main.where(color_id: params[:color_id]).first
  end

  def edit
    authorize @product
  end

  def update
    if @product.update(product_params)
      redirect_to product_path
    else
      render 'edit'
    end
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to product_list_path
    else
      render 'new'
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path
    else
      products_path
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :gender, :main_photo, :description, :price, :category_ids, :sub_category_ids, color_ids: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end

end
