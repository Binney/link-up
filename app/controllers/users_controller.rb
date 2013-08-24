class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  # Only admins and mentors can actually see anyone's profiles - if a student
  # clicks to any profile, it just redirects them to their homepage.
  before_action :admin_user,     only: [:destroy, :show, :index]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @favourites = @user.events.paginate(page: params[:page]) # How to display these...
  end

  def new
    @user = User.new
  end
 
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver
      sign_in @user
      flash[:success] = "User created successfully - we've sent you a confirmation email. Welcome to Link Up!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def favourites
    @title = "Your events"
    @user = User.find(params[:id])
    @events = @user.events
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @entries = @user.diary_entries
    render 'show_favourite'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters (signed_in_user is now under sessions_helper)

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless (current_user.admin? || current_user.mentor?)
    end
end
