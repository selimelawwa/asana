class ProductsController < ApplicationController
  before_action :set_product, only: [:destroy, :edit, :update, :show]
  
  def index
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

  def show
  end

  def edit
    authorize @product
  end

  def update
    if @product.update(product_params)
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    binding.pry
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
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
    params.require(:product).permit(:name, :gender, :main_photo, :description, :price, :category_ids, :sub_category_ids)
  end

  def variant_params
    params.require(:product).permit(variants: [:size])
  end

  def set_product
    @product = Product.find(params[:id])
  end

end
