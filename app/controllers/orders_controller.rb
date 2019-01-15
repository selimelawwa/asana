class OrdersController < ApplicationController
  before_action :set_order, only: [:select_address, :create_address, :assign_address, :confirm_details, :confirm_order]
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

  def remove_line_item
    line_item = current_order.line_items.find_by(id: params[:line_item_id])
    if line_item.destroy
      if current_order.reload.line_items.any?
        render partial: 'order_details_partial', locals: {line_items: current_order.reload.line_items}
      else
        redirect_to request.referrer
      end
    end
  end

  def update_line_item_quantity
    line_item = current_order.line_items.find_by(id: params[:line_item_id])
    if line_item.update(quantity: params[:quantity])
      render partial: 'order_details_partial', locals: {line_items: current_order.reload.line_items}
    else
    end
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
  end

  def select_address
    @addresses = current_user.addresses.where.not(id: nil)
    @address  = current_user.addresses.new
  end

  def assign_address
    @address = Address.find(params[:address_id])
    if @address && (@address.user_id == current_user.id)
      @order.update(address_id: @address.id)
      redirect_to order_confirm_details_path(order_id:  @order.id)
    else
      redirect_to select_address_path(order_id: @order.id)
    end
  end
  
  def create_address
    @addresses = current_user.addresses
    @address = current_user.addresses.new(address_params)
    if @address.save
      @order.update(address_id: @address.id)
      redirect_to order_confirm_details_path(order_id:  @order.id)
    else
      render 'select_address'
    end
  end

  def confirm_details
    if flash[:error]
      @error_msg = flash[:error]
      flash.discard(:error) 
    end
    @address = @order.address
    redirect_to order_select_address_path(order_id: @order.id) unless @address
    redirect_to order_path(@order) unless @order.has_line_items?
  end

  def confirm_order
    @address = @order.address
    if @order.finalize
    else
      flash[:error] = @order.errors[:out_of_stock_variants]&.first if @order.errors.any?
      redirect_to order_confirm_details_path(@order)
    end
  end

  private
  def address_params
    params.require(:address).permit(:city, :mobile, :telephone, :address, :default_addresses)
  end

  def set_order
    @order = current_order
  end
end
