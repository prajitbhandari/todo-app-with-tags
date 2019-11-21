class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to @tag
      #   redirect_to tag_path(@tag)
      #   redirect_to tag_path(id: @tag.id)
      #   redirect_to "tag_path/#{@tag.id}"
    else
      redirect_to new_tag_path
    end
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      redirect_to tag_path
    else
      redirect_to edit_tag_path(@tag)
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tag_path
  end

  private
  def tag_params
    params.require(:tag).permit(:name)
  end

end
