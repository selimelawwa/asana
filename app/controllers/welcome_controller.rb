class WelcomeController < ApplicationController
  def index
    @slides = Slide.first(5)
    @jumbotron = Jumbotron.first
    if @jumbotron.present?
      @category1_name = Category.find(@jumbotron.category_id_1)&.name
      @category2_name = Category.find(@jumbotron.category_id_2)&.name
    end
    @new_arrivals = Product.published.order(created_at: :desc).first(10).shuffle.first(4)
  end
end
