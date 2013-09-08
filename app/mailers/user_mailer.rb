class UserMailer < ActionMailer::Base
  require 'mandrill'
  mandrill = Mandrill::API.new 'BWoU8sJtVOAoy0cEpLKpqg'
  default from: "do-not-reply@link-up.org.uk"

  def welcome_email(user)
    @user = user
    @url = signin_path
    mail(to: @user.email, subject: 'Your account with Link Up was created successfully!')
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Reset your Link Up password"
  end

end
