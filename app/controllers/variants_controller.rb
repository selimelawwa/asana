class VariantsController < ApplicationController
  before_action :set_product
  before_action :set_variant, only: [:destroy, :edit, :update, :show]
  before_action :set_available_colors_sizes, only: %i[new]
  def index
    sort_order = ["XS","S", "M", "L", "XL", "2XL", "3XL"]
    @variants = @product.variants.sized.includes(variant_includes).order("colors.name , position(sizes.name in '#{sort_order.join(",")}') asc")
    authorize @variants
    @colors = @product.variants.main.map(&:color)
    @search = @variants.ransack(params[:q])
    @variants = @search.result
  end
  def new
    authorize @product
  end
  def create
    authorize @product
    # we create variant by update product and creating associated variants
    if @product.update(product_params)
      redirect_to product_variants_path
    else
      render 'new'
    end
  end

  def update_stock
    @variant =  Variant.find(params[:variant_id])
    authorize @variant
    if @variant.update(stock: params[:new_stock])
      updated_variant = @variant.reload
      render json: { new_stock: updated_variant.stock }
    end
  end
  
  private
  def set_variant
    @variant = Variant.find(params[:id])
  end
  def set_product
    @product = Product.find(params[:product_id])
  end
  def set_available_colors_sizes
    excluded_color_ids = @product.variants.main.map(&:color_id).uniq if @product.variants
    @colors = Color.where.not(id: excluded_color_ids)
  end
  def variant_includes
    [:size, :color]
  end
  def product_params
    params.require(:product).permit(color_ids: [])
  end
end
