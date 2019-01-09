class OrdersController < ApplicationController
  def index
    if current_user.admin?
      @orders = Order.all
    else
      @orders = current_user.orders
    end
  end

  def add_to_cart
    product = Product.find(params[:product_id])
    @variant = product.variants.sized.where(color_id: params[:color_id], size_id: params[:size_id])&.first
    line_item = current_order.line_items.find_or_initialize_by(variant_id: @variant.id)
    if @variant.stock >= params[:quantity]&.to_i
      if line_item.quantity && line_item.quantity < 5
        line_item.quantity += params[:quantity]&.to_i
        line_item.save
        @variant.stock -= params[:quantity]&.to_i
        @variant.save
        render json: { saved: 1 }
      elsif !line_item.quantity
        line_item.quantity = params[:quantity]
        line_item.save
        @variant.stock -= params[:quantity]&.to_i
        @variant.save
        render json: { saved: 1 }
      else
        render json: { saved: 0, error: 0 }
      end
    else
      #out of stock
      render json: { saved: 0, error: 1 }
    end
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
  end
end
