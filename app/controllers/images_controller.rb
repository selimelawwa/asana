class ImagesController < ApplicationController
  before_action :load_edit_data, except: :index
  before_action :set_image, only: [:destroy, :edit, :update, :show]

  def index
    @product = Product.includes(variants: [:size, :color]).find(params[:product_id])
    @images = @product.variants.main.map do |variant|
      variant.images
    end&.flatten&.uniq
  end
  def new
    @image = Image.new
  end
  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to product_images_path(@product.id)
    else
      render 'new'
    end
  end
  def edit
  end
  def update
    if @image.update(image_params)
      redirect_to product_images_path(@product.id)
    else
      render 'edit'
    end
  end

  def destroy
    if @image.destroy
      redirect_to product_images_path(id: params[:product_id])
    end
  end
  private
  def load_edit_data
    @product = Product.includes(variants: [:size, :color]).find(params[:product_id])
    @variants = @product.variants.main
  end
  def set_image
    @image = Image.find(params[:id])
  end
  def image_params
    params[:image][:variant_ids] = [params.dig(:image,:variant_ids)]
    params.require(:image).permit(:image,variant_ids: [])
  end
end
