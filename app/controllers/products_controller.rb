class ProductsController < ApplicationController
  def index
    @products = Product.all.paginate(:page => params[:page], :per_page => 4)
    @custom_paginate_renderer = custom_paginate_renderer
  end
  def new
    @product = Product.new
  end
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render 'new'
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :gender, :main_photo)
  end

end
