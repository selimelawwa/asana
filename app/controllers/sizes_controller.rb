class SizesController < ApplicationController
  before_action :set_size, only: [:destroy, :edit, :update]
  
  def index
    @sizes = Size.all
  end

  def edit
  end

  def update
    if @size.update(size_params)
      redirect_to sizes_path
    else
      render 'edit'
    end
  end

  def new
    @size = Size.new
  end

  def create
    @size = Size.new(size_params)
    if @size.save
      redirect_to sizes_path
    else
      render 'new'
    end
  end

  def destroy
    if @size.destroy
      redirect_to sizes_path
    else
      sizes_path
    end
  end

  private
  def size_params
    params.require(:size).permit(:name)
  end

  def set_size
    @size = Size.find(params[:id])
  end
end
