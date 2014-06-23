class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to new_session_url, :notice => "Done! Check your emails for a link to reset your password."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "That password &crarr; 
        reset has expired. Please try again."
    elsif @user.update_attributes(params.permit![:user])
      redirect_to root_url, :notice => "Success! Your password has been reset."
    else
      render :edit
    end
  end

end
