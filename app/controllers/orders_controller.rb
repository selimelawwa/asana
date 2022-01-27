class OrdersController < ApplicationController
  before_action :set_order, only: [:select_address, :create_address, :assign_address, :confirm_details, :confirm_order]
  def index
    if current_user&.admin?
      @orders = Order.all.joins(:line_items).where(cart: false)
      @search = @orders.ransack(params[:q])
      @orders = @search.result(distinct: true).order(:confirmed_at).paginate(:page => params[:page], :per_page => 25)
    else
      @orders = current_user&.orders&.joins(:line_items).distinct.order(:created_at).paginate(:page => params[:page], :per_page => 25)
    end
    @custom_paginate_renderer = custom_paginate_renderer
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

  #TODO handle fail update cart quantity  
  def remove_line_item
    line_item = current_order.line_items.find_by(id: params[:line_item_id])
    if line_item.destroy
      if current_order.reload.line_items.any?
        order = current_order.reload
        new_order_details = render_to_string partial: 'order_details_partial', locals: {order: order, line_items: order.line_items}
        new_order_summary = render_to_string partial: 'order_summary', locals: {order: order}
        render json: {new_order_details: new_order_details, new_order_summary: new_order_summary}
      else
        redirect_to request.referrer
      end
    end
  end

  def update_line_item_quantity
    line_item = current_order.line_items.find_by(id: params[:line_item_id])
    if line_item.variant.stock >= params[:quantity]&.to_i
      if line_item.update(quantity: params[:quantity])
        saved = true
        error_modal = nil
      else
        saved = false
        error_modal = render_to_string partial: 'products/add_to_cart_error_modal_partial' , locals: {error: 'max_5_already_set', current_quantity: line_item&.reload&.quantity}
      end
    else
      #no enough stock
      saved = false
      error_modal = render_to_string partial: 'products/add_to_cart_error_modal_partial' , locals: {error: 'no_enough_stock', available_stock: line_item.variant.reload.stock , current_quantity: line_item&.quantity}
    end
    order = line_item.order.reload
    new_order_details = render_to_string partial: 'order_details_partial', locals: {order: order, line_items: order.line_items}
    new_order_summary = render_to_string partial: 'order_summary', locals: {order: order}
    render json: {saved: saved, new_order_details: new_order_details, new_order_summary: new_order_summary, error_modal: error_modal }
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
    @order.refresh_line_items if @order.cart?
  end

  def cart
    if current_user || current_or_guest_user.orders.any?
      @order = current_order
      authorize @order
      @order.refresh_line_items
    end
  end

  def select_address
    authorize @order
    if current_user
      @addresses = current_user.addresses.where.not(id: nil)
      @address  = current_user.addresses.new
    else
      redirect_to new_user_session_path(redirect_to: cart_path)
    end
  end

  def assign_address
    authorize @order
    @address = Address.find(params[:address_id])
    if @address && (@address.user_id == current_user.id)
      @order.update(address_id: @address.id)
      redirect_to order_confirm_details_path(order_id:  @order.id)
    else
      redirect_to select_address_path(order_id: @order.id)
    end
  end
  
  def create_address
    authorize @order
    @addresses = current_user.addresses
    @address = current_user.addresses.new(address_params)
    if @address.save
      @order.update(address_id: @address.id)
      redirect_to order_confirm_details_path(order_id:  @order.id)
    else
      @addresses = current_user.addresses.reload
      render 'select_address'
    end
  end

  def confirm_details
    authorize @order
    # have to be a signed up user
    redirect_to new_user_session_path(redirect_to: cart_path) unless current_user.presence
    redirect_to order_path(@order) if !@order.cart?
    if flash[:error]
      @error_msg = flash[:error]
      flash.discard(:error) 
    end
    @order.refresh_line_items
    @address = @order.address
    redirect_to order_select_address_path(order_id: @order.id) unless @address
    redirect_to order_path(@order) unless @order.has_line_items?
  end

  def apply_promo
    order = current_order
    promo = Promo.find_by(code: params[:promo_code])
    if promo.present?
      if order.update(promo_id: promo.id)
        new_order_summary = render_to_string partial: 'order_summary', locals: {order: order}
        new_apply_promo_form = render_to_string partial: 'apply_promo_form', locals: {order: order}
        render json: {promo_applied: 1, new_order_summary: new_order_summary, new_apply_promo_form: new_apply_promo_form}
      else
        errors = order.errors[:promo_inactive] + order.errors[:promo_used_before]
        render json: {promo_applied: 0, error_msg: errors}
      end
    else
      errors = "Promo not found."
      render json: {promo_applied: 0, error_msg: errors}
    end
  end

  def remove_promo
    order = current_order
    order.update(promo_id: nil)
    redirect_to request.referrer
  end

  #TODO if no line items
  def confirm_order
    authorize @order
    @address = @order.address    
    if @order.finalize
      UserMailer.confirm_order_admin_email(@current_user,@order).deliver
      UserMailer.confirm_order_user_email(@current_user).deliver
      flash[:success] = "Order Confirmed"
      redirect_to order_path(@order)
    else
      if @order.errors.any?
        errors = @order.errors.messages.values.reject {|e| e&.empty?}
        flash[:error] = errors.join(', ')
      end
      redirect_to order_confirm_details_path(@order)
    end
  end

  private
  def address_params
    params.require(:address).permit(:city_id, :mobile, :telephone, :address, :default_addresses)
  end

  def set_order
    @order = Order.find_by(id: params[:order_id]) || current_order
  end
end
