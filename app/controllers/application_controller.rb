class ApplicationController < ActionController::Base
  include PaginationHelper
  include Pundit
  protect_from_forgery
end
