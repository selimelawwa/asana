class ColorsController < ApplicationController
  before_action :set_color, only: [:destroy, :edit, :update]
  
  def index
    @colors = Color.all
  end

  def edit
  end

  def update
    if @color.update(color_params)
      redirect_to colors_path
    else
      render 'edit'
    end
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)
    if @color.save
      redirect_to colors_path
    else
      render 'new'
    end
  end

  def destroy
    if @color.destroy
      redirect_to colors_path
    else
      colors_path
    end
  end

  private
  def color_params
    params.require(:color).permit(:name, :photo)
  end

  def set_color
    @color = Color.find(params[:id])
  end
end
