class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def add_to_cart
    @variant = Variant.find_by(id: params[:variant_id])
    line_item = current_order.line_items.find_or_initialize_by(variant_id: @variant.id)
    line_item.quantity += params[:quantity]
    line_item.save
  end

  def current_order
    return nil unless current_user
    current_user.orders.where(cart: true).first_or_create
  end
end
