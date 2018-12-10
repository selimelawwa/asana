class ApplicationController < ActionController::Base
  include PaginationHelper
  include Pundit
  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_global_search_variable

  def set_global_search_variable
    @q ||= Product.ransack(params[:q])
  end

  private

  def user_not_authorized
    flash[:danger] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
