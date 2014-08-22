class UsersController < ApplicationController
  require 'will_paginate/array'
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update, :logbook]
  before_action :admin_account,  only: :destroy

  def index
    if me_admin?
      @user_array = []
      @schools = School.all
      @schools.each { |school| @user_array.push [school.name, []] }
      @user_array.push(["Other", []])
      @users = User.search_by_school(params[:name_search], params[:school_search].to_i).paginate(page: params[:page])
      @users.each do |user|
        done = false
        @schools.each_index do |n|
          if user.school_id == @schools[n].id
            @user_array[n][1].push(user)
            done = true
          end
        end
        @user_array.last[1].push(user) unless done==true
      end
    elsif me_teacher?
      @users = User.search_by_school(params[:name_search], current_user.school_id).paginate(page: params[:page])
      @user_array = [[current_user.school_name, @users]]
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
    @favourites = @user.events.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end
 
  def create
    @user = User.new(user_params)

    @user.role = "student"
    user_school = find_school_by_student_code(user_params[:interests])
    if user_school
      @user.school_id = user_school.id
    else

      user_school = find_school_by_mentor_code(user_params[:interests])
      if user_school
        @user.role = "mentor"
        @user.school_id = user_school.id
      else
        user_school = find_school_by_teacher_code(user_params[:interests])
        if user_school
          @user.role = "teacher"
          @user.school_id = user_school.id
        else
          @user.school_id = 1
        end

      end

    end
    @user.interests = ""

    if user_school
      schlVenue = user_school.venue
      @user.home_address = schlVenue.street_address if @user.home_address.blank?
      @user.home_postcode = schlVenue.postcode if @user.home_postcode.blank?
    else
      @user.home_address = "10 Downing Street" if @user.home_address.blank? && @user.home_postcode.blank? # As good a place as any.
    end

    if @user.save
      UserMailer.welcome_email(@user).deliver
      User.find(1).sent_messages.create!(subject: "You're in, #{@user.name}!",
         receiver_id: @user.id, message: "Welcome to Link Up! To get started with 
         finding opportunities in your area, hit Find Events. For advice, visit Help 
         at the bottom of the page. Good luck and have fun!")
      sign_in @user
      flash[:success] = "User created successfully - we've sent you a 
        confirmation email. Welcome to Link Up!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    # TODO would be nice to refactor this and the identical New code into one block.
    @user.role = "student"
    user_school = find_school_by_student_code(params[:school_info])
    if user_school
      @user.school_id = user_school.id
    else

      user_school = find_school_by_mentor_code(params[:school_info])
      if user_school
        @user.role = "mentor"
        @user.school_id = user_school.id
      else
        user_school = find_school_by_teacher_code(params[:school_info])
        if user_school
          @user.role = "teacher"
          @user.school_id = user_school.id
        else
          @user.school_id = 1
        end

      end

    end
    params[:user].delete(:interests)

    if user_school
      schlVenue = user_school.venue
      @user.home_address = schlVenue.street_address if @user.home_address.blank?
      @user.home_postcode = schlVenue.postcode if @user.home_postcode.blank?
    else
      @user.home_address = "10 Downing Street" if @user.home_address.blank? && @user.home_postcode.blank? # As good a place as any.
    end

    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(user_params)
      flash[:success] = "Edit successful."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def logbook
    @user = User.find(params[:id])
    @logbook_entries = @user.logbook_entries
  end

  def destroy
    User.destroy(params[:id])
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def user_params # TODO Ew ew ew ew ew ew ew no.
      params.require(:user).permit!#(:name, :email, :home_address, :home_postcode, :school, :password, :password_confirmation, :password_reset_token, :password_reset_sent_at, :role)
    end

    def find_school_by_teacher_code(code)
      School.find_by(teacher_code: code)
    end

    def find_school_by_mentor_code(code)
      School.find_by(mentor_code: code)
    end

    def find_school_by_student_code(code)
      School.find_by(student_code: code)
    end

end
