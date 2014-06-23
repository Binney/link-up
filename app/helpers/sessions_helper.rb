module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def me_admin?
    signed_in? && current_user.role == "admin"
  end

  def me_organiser?(thing)
    if thing.class.name=="Venue"
      signed_in? && (current_user.role == "organiser" && thing.user_id == current_user.id) || (thing.is_school && my_school?(thing) && current_user.role=="teacher")
    else
      signed_in? && (current_user.role == "organiser" && (thing.user_id == current_user.id || thing.venue.user_id == current_user.id)) || (thing.venue.is_school? && my_school?(thing.venue) && current_user.role=="teacher")
    end
  end

  def me_teacher?
    signed_in? && current_user.role == "teacher"
  end

  def me_student?
    signed_in? && current_user.role == "student"
  end

  def me_wrote_article?(article)
    signed_in? && current_user.id == article.user_id
  end

  def my_school?(venue)
    signed_in? && current_user.school.eql?(venue.name)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def admin_account
    redirect_to root_path unless me_admin?
  end

  def non_student_account
    if me_student?
      redirect_to root_path
    end
  end

  def teacher_account 
    unless me_teacher? || me_admin?
      redirect_to root_path
    end
  end

  def correct_user
    user_id = params[:user_id] || current_user.id
    @user = User.find(user_id)
    redirect_to(root_path) unless current_user?(@user) || me_admin? || current_user.is_mentor?(@user) || current_user.teaches?(@user)
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

end
