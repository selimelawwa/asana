class PromosController < ApplicationController
  before_action :set_promo, only: [ :edit, :update]

  def index
    @promos = Promo.all
  end

  def new
    @promo = Promo.new
    authorize @promo
  end

  def create
    @promo = Promo.new(promo_params)
    authorize @promo
    if @promo.save
      flash[:success] = "#{@promo.code} is Succesfully Created"
      redirect_to promos_path
    else
      render 'new'
    end
  end

  def edit
    authorize @promo
  end

  def update
    authorize @promo
    if @promo.update(promo_params)
      flash[:success] = "#{@promo.code} is Succesfully Updated"
      redirect_to promos_path
    else
      render 'edit'
    end
  end

  private
  def set_promo
    @promo = Promo.find(params[:id])
  end
  def promo_params
    params.require(:promo).permit(:code, :owner_name, :discount_rate, :description, :active)
  end
end
