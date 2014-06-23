class UsersController < ApplicationController
  require 'will_paginate/array'
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update, :logbook]
  before_action :admin_account,     only: [:destroy, :school_correct]

  def index
    if me_admin?
      @user_array = []
      @schools = School.all
      @schools.each { |school| @user_array.push [school.name, []] }
      @user_array.push(["Other", []])
      @users = User.simple_search(params[:name_search], params[:school_search]).order('school ASC, name ASC').paginate(page: params[:page])
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
      @users = User.simple_search(params[:name_search], School.find(current_user.school_id).name).paginate(page: params[:page])
      @user_array = [[School.find(current_user.school_id).name, @users]]
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
    teacher_school = find_school_by_teacher_code(user_params[:school])
    if user_params[:school]=="Link Up Teacher"
      @user.role = "teacher"
      @user.school_id = 1
    elsif teacher_school.id > 1
      @user.role = "teacher"
      @user.school_id = teacher_school.id
    else
      @user.school_id = find_school_by_student_code(user_params[:school]).id
    end
    @user.school = ""

    if @user.school_id != 0
      @user.home_address = Venue.find_by(name: user_params[:school]).street_address if @user.home_address.blank?
      @user.home_postcode = Venue.find_by(name: user_params[:school]).postcode if @user.home_postcode.blank?
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
  end

  def update
    @user = User.find(params[:id])
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
      School.find_by(teacher_code: code) || School.find(1)
    end

    def find_school_by_student_code(code)
      School.find_by(student_code: code) || School.find(1)
    end

end
