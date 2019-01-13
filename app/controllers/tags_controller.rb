class TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy, :show]
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
    authorize @tag
  end

  def create
    @tag = Tag.new(tag_params)
    authorize @tag
    if @tag.save
      redirect_to tags_path
    else
      render 'new'
    end
  end

  def edit
    authorize @tag
  end

  def update
    authorize @tag
    if @tag.update(tag_params)
      redirect_to tags_path
    else
      render 'edit'
    end
  end
  
  private
  def tag_params
    params.require(:tag).permit(:name)
  end
  def set_tag
    @tag = Tag.find(params[:id])
  end
end
