class ProductsController < ApplicationController
  before_action :set_product, only: [:destroy, :edit, :update, :show]
  before_action :set_params, only: [:index]
  
  def index    
    if params[:category_id].blank?
      @products = Product.all
    else
      @category = Category.find(params[:category_id])
      @products = @category.products
    end
    if params.dig(:q,:variants_size_id_in).present?
      @products = @products.joins(:variants).where("variants.size_id IN (?) AND variants.stock > 0",params[:q][:variants_size_id_in])
    end
    @q = @products.ransack(params[:q])
    @products = @q.result(distinct: true).order(:created_at).paginate(:page => params[:page], :per_page => 25)
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
    authorize @products
    @q = @products.ransack(params[:q])
    @products = @q.result.order(:created_at).paginate(:page => params[:page], :per_page => 25)
    @custom_paginate_renderer = custom_paginate_renderer
  end

  def search
    index
    render :index
  end

  def show
    params[:color_id] ||= @product.main_color_id
    @colored_variant = @product.variants.main.where(color_id: params[:color_id]).first
    @related_products =  Product.joins(:tags).where(tags: {id: @product.tags.pluck(:id)}).where.not(products: {id: @product.id})&.shuffle&.first(4)
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
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
    authorize @product
    if @product.save
      redirect_to product_list_path
    else
      render 'new'
    end
  end

  def destroy
    authorize @product
    if @product.destroy
      redirect_to products_path
    else
      products_path
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :gender, :main_photo, :description, :price, :category_ids, 
            :fabric_details, :model_wearing, :sub_category_ids, color_ids: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def set_params
    params[:q] ||= HashWithIndifferentAccess.new
    params[:q][:s] ||= "created_at desc"   
    params[:q].delete(:variants_size_id_in) if params.dig(:q,:variants_size_id_in) == ""
    params[:q].delete(:variants_color_id_in) if params.dig(:q,:variants_color_id_in) == ""
    params[:q].delete(:tags_id_in) if params.dig(:q,:tags_id_in) == ""

    params[:q][:variants_size_id_in] =  params.dig(:q,:variants_size_id_in)&.reject { |c| c.empty? } 
    params[:q][:variants_color_id_in] =  params.dig(:q,:variants_color_id_in)&.reject { |c| c.empty? }
    params[:q][:tags_id_in] =  params.dig(:q,:tags_id_in)&.reject { |c| c.empty? }
  end

end
