class WelcomeController < ApplicationController
  def index
    @slides = Slide.first(5)
    @jumbotron = Jumbotron.first
    @new_arrivals = Product.published.order(created_at: :desc).first(10).shuffle.first(4)
  end
end
