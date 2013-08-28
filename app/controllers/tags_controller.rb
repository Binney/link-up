class TagsController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy] # Any tag-related actions can only be carried out by an admin.

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    @events = @tag.events.all#.paginate(params[:page])
  end

  def new
    @tag = Tag.new
  end
 
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      flash[:success] = "Tag created!"
      redirect_to @tag
    else
      render 'new'
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(tag_params)
      flash[:success] = "Tag details updated"
      redirect_to @tag
    else
      render 'edit'
    end
  end

  def destroy
    Tag.find(params[:id]).destroy
    flash[:success] = "Tag destroyed."
    redirect_to tags_url
  end

  private

    def tag_params
      params.require(:tag).permit(:name, :relationships)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
