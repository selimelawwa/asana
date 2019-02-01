class ProductsController < ApplicationController
  include ProductSearchConcern
  before_action :set_product, only: [:destroy, :edit, :update, :show]
  before_action :set_params, only: [:index]

  def index
    handle_category_id
    handle_category_filter
    handle_new_arrival_and_sale

    if params.dig(:q,:variants_size_id_in).present?
      @products = @products.joins(:variants).where("variants.size_id IN (?) AND variants.stock > 0",params[:q][:variants_size_id_in])
    end
    @q = @products.ransack(params[:q])
    @products = @q.result(distinct: true).order(:created_at).paginate(:page => params[:page], :per_page => 24)
    @custom_paginate_renderer = custom_paginate_renderer
  end

  #list for admin
  def list
    if params[:show_hidden] == "1"
      @products = Product.hidden
    else
      @products = Product.published
    end
    authorize @products
    @search = @products.ransack(params[:q])
    @products = @search.result.order(:created_at).paginate(:page => params[:page], :per_page => 25)
    @custom_paginate_renderer = custom_paginate_renderer
  end

  def search
    index
    render :index
  end

  def show
    if @product.published?
      params[:color_id] ||= @product.main_color_id
      @colored_variant = @product.variants.main.where(color_id: params[:color_id]).first
      @related_products =  Product.joins(:tags).where(tags: {id: @product.tags.pluck(:id)}, products: {published: true}).where.not(products: {id: @product.id})&.shuffle&.first(4)
      @available_sizes = @colored_variant.sized_variants.joins(:size).where("variants.stock > 0")&.pluck(:size_id)
    else
      flash[:error] = "This Product is currently unavailable"
      redirect_to products_path
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      flash[:success] = "#{@product.name} is Succesfully Updated"
      show_hidden = @product.published? ? "0" : "1"
      redirect_to product_list_path(show_hidden: show_hidden)
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
      flash[:success] = "#{@product.name} is Succesfully Created"
      redirect_to product_list_path(show_hidden: "1")
    else
      render 'new'
    end
  end

  # destroy act as hide (published: false)
  def destroy
    authorize @product
    if @product.update(published: false)
      redirect_to products_path
    else
      products_path
    end
  end

  # TODO - handle fail
  def publish
    @product = Product.find(params[:product_id])
    authorize @product
    @product.published? ? @product.update(published: false) : @product.update(published: true)
    redirect_to product_list_path
  end

  private
  def product_params
    params.require(:product).permit(:name, :gender, :main_photo, :description, :price, :original_price, :category_ids, 
            :fabric_details, :model_wearing, :sub_category_ids,:new_arrival, :available_in, :on_sale, color_ids: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
