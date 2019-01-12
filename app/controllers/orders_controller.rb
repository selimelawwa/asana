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
    if @variant.stock >= params[:quantity]&.to_i + line_item.quantity
      line_item.quantity += params[:quantity]&.to_i
      if line_item.save
        render json: { saved: 1 }
      else 
        render partial: 'products/add_to_cart_error_modal_partial' , locals: {error: 'max_5_already_set', current_quantity: line_item&.reload&.quantity}
      end
    else
      #no enough stock
      render partial: 'products/add_to_cart_error_modal_partial' , locals: {error: 'no_enough_stock', available_stock: @variant.reload.stock , current_quantity: line_item&.quantity}
    end
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
  end
end
