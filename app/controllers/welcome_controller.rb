class WelcomeController < ApplicationController
  def index
    @slides = Slide.all
    @new_arrivals = Product.published.order(created_at: :desc).first(10).shuffle.first(4)
  end
end
