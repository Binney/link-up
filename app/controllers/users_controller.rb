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
      User.find(1).messages.build(subject: "You're in, #{@user.name}!", receiver_id: @user.id, message: "Welcome to Link Up! To get started with finding opportunities in your area, hit Find Events. For advice, visit #{help_path}. Good luck and have fun!")
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
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(user_params)
      flash[:success] = "Edit Successful."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def user_params
      if current_user.admin?
        params.require(:user).permit(:name, :email, :mentor, :organiser, :admin, :home_address, :home_postcode)
      else
        params.require(:user).permit(:name, :email, :home_address, :home_postcode)
      end
    end

    # Before filters (signed_in_user is now under sessions_helper)

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || (current_user.admin? || current_user.mentor?)
    end

    def admin_user
      redirect_to(root_path) unless (current_user.admin? || current_user.mentor?)
    end
end
