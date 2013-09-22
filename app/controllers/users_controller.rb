class UsersController < ApplicationController
  require 'will_paginate/array'
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  # Only admins and mentors can actually see anyone's profiles - if a student
  # clicks to any profile, it just redirects them to their homepage.
  before_action :admin_user,     only: :destroy

  def index
    if admin?
      @user_array = []
      @schools = Venue.select {|v| v.is_school }
      @schools.each { |school| @user_array.push [school.name, []] }
      @user_array.push(["Other", []])
      @users = User.simple_search(params[:name_search], params[:school_search]).order('school ASC').paginate(page: params[:page])
      @users.each do |user|
        done = false
        @schools.each_index do |n|
          if user.school == @schools[n].name
            @user_array[n][1].push(user)
            done = true
          end
        end
        @user_array.last[1].push(user) unless done==true
      end
    elsif current_user.role == 'teacher'
      @users = User.simple_search(params[:name_search], current_user.school).paginate(page: params[:page])
      @user_array = [[current_user.school, @users]]
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
    if current_user.mentorships.find_by(mentee_id: @user, confirmation_stage: 3) || admin?
      @favourites = @user.events.paginate(page: params[:page]) # How to display these...
    else
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end
 
  def create
    @user = User.new(user_params)
    if Venue.find_by(name: @user.school)
      @user.home_address = Venue.find_by(name: user_params[:school]).street_address if @user.home_address.blank?
      @user.home_postcode = Venue.find_by(name: user_params[:school]).postcode if @user.home_postcode.blank?
    else
      @user.home_address = "10 Downing Street" if @user.home_address.blank? && @user.home_postcode.blank? # As good a place as any.
    end
    if @user.save
      UserMailer.welcome_email(@user).deliver
      User.find(1).sent_messages.create!(subject: "You're in, #{@user.name}!", receiver_id: @user.id, message: "Welcome to Link Up! To get started with finding opportunities in your area, hit Find Events. For advice, visit Help at the top of the page. Good luck and have fun!")
      sign_in @user
      flash[:success] = "User created successfully - we've sent you a confirmation email. Welcome to Link Up!"
      redirect_to root_path
    else
      @schools = ["None", "Dagenham Park CoS", "Westminster Academy"]
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
    User.destroy(params[:id])
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def user_params # Ew ew ew ew ew ew ew no.
      params.require(:user).permit!#(:name, :email, :home_address, :home_postcode, :school, :password, :password_confirmation, :password_reset_token, :password_reset_sent_at, :mentor, :organiser, :admin)
    end

    # Before filters (signed_in_user is now under sessions_helper)

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || (admin? || current_user.mentor?)
    end

    def admin_user
      redirect_to(root_path) unless (admin? || current_user.mentor?)
    end
end
