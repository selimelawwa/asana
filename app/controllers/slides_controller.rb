class SlidesController < ApplicationController
  before_action :set_slide, only: [:destroy, :edit, :update]
  
  def index
    @slides = Slide.all
  end

  def new
    @slide = Slide.new
  end

  def create
    @slide = Slide.new(slide_params)
    authorize @slide
    if @slide.save
      redirect_to slides_path
    else
      render 'new'
    end
  end

  def edit
    authorize @slide
  end

  def update
    authorize @slide
    if @slide.update(slide_params)
      redirect_to edit_slide_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @slide
    if @slide.destroy
      redirect_to slides_path
    else
      slides_path
    end
  end

  private
  def set_slide
    @slide = Slide.find(params[:id])
  end
  def slide_params
    params.require(:slide).permit(:description, :photo)
  end
end
