class UserMailer < ActionMailer::Base
  default from: "do-not-reply@link-up.org.uk"

  def welcome_email(user)
    @user = user
    @url = signin_path
    mail(to: @user.email, subject: 'Your account with Link Up was created successfully!')
  end
end
