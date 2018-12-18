class VariantsController < ApplicationController
  before_action :set_product
  before_action :set_variant, only: [:destroy, :edit, :update, :show]
  def index
    @variants = @product.variants.includes(variant_includes)
  end
  def new
    @variant = @product.variants.new
  end
  private
  def set_variant
    @variant = Variant.find(params[:id])
  end
  def set_product
    @product = Product.find(params[:product_id])
  end
  def variant_includes
    [:size, :color]
  end
end
