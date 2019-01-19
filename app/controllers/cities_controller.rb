class CitiesController < ApplicationController
  before_action :set_city, only: [:edit, :update]

  def index
    @cities = City.egypt
    authorize @cities
  end
  def new
    @city = City.new
    authorize @city
  end
  def create
    @city = City.new(city_params)
    @city.country_id = Country.named_egypt.id
    authorize @city
    if @city.save
      redirect_to cities_path
    else
      render 'new'
    end
  end

  def edit
    authorize @city
  end

  def update
    authorize @city
    if @city.update(city_params)
      redirect_to cities_path
    else
      render 'edit'
    end
  end

  private
    def set_city
      @city = City.find(params[:id])
    end
    def city_params
      params.require(:city).permit(:name, :shipping_price)
    end
end
