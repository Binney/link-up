class UserMailer < ActionMailer::Base
  require 'mandrill'
  mandrill = Mandrill::API.new 'BWoU8sJtVOAoy0cEpLKpqg'
  default from: "do-not-reply@link-up.org.uk"

  def welcome_email(user)
    @user = user
    @url = root_url
    mail(to: @user.email, subject: 'Your account with Link Up was created successfully!')
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Reset your Link Up password"
  end

  def mentor_email(mentee, mentor)
    @mentee = mentee
    @mentor = mentor
    mail :to => mentee.email, :subject => "#{mentor.name} has requested to be your mentor on Link Up"
  end

end
