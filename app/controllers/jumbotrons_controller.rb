class JumbotronsController < ApplicationController
  before_action :set_jumbotron, only: [:edit, :update]
  
  def index
    @jumbotron = Jumbotron.first
    redirect_to edit_jumbotron_path(@jumbotron) if @jumbotron.presence
  end

  def new
    @jumbotron = Jumbotron.new
  end

  def create
    @jumbotron = Jumbotron.new(jumbotron_params)
    authorize @jumbotron
    if @jumbotron.save
      flash[:notice] = "Jumbotron succesfully created!"
      redirect_to edit_jumbotron_path(@jumbotron)
    else
      render 'new'
    end
  end

  def edit
    authorize @jumbotron
  end

  def update
    authorize @jumbotron
    if @jumbotron.update(jumbotron_params)
      redirect_to edit_jumbotron_path(@jumbotron)
    else
      render 'edit'
    end
  end

  private
  def set_jumbotron
    @jumbotron = Jumbotron.first
  end
  def jumbotron_params
    params.require(:jumbotron).permit(:description, :photo, :category_id_1, :category_id_2)
  end
end
