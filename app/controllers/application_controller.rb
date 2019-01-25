class ApplicationController < ActionController::Base
  include PaginationHelper
  include GuestsHelper
  include Pundit
  def pundit_user
    current_or_guest_user
  end
  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_global_search_variable
  before_action :set_navbar_categories

  def set_global_search_variable
    @q ||= Product.ransack(params[:q])
  end

  def current_order
    return nil unless current_or_guest_user
    current_or_guest_user.orders.where(cart: true).first_or_create
  end
  helper_method :current_order
  helper_method :current_or_guest_user

  protected  
    def after_sign_in_path_for(resource)
      sign_in_url = new_user_session_url
      if request.referer == sign_in_url
        super
      else
        stored_location_for(resource) || request.referer || root_path
      end
    end

  private

  def user_not_authorized
    flash[:danger] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def set_navbar_categories
    @navbar_categories = Rails.cache.fetch('cached_navbar_categories', expires_in: 10.minute) { Category.category.with_products.includes(:sub_categories).first(4) }
    @show_on_sale = Rails.cache.fetch('cached_show_on_sale', expires_in: 10.minute) { Product.where(on_sale: true).any? }
    @show_new_arrival = Rails.cache.fetch('cached_show_new_arrival', expires_in: 10.minute) { Product.where(new_arrival: true).any? }
  end
end
