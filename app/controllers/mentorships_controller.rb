class MentorshipsController < ApplicationController
  before_action :signed_in_user # Can't do anything without. These need to get replaced with cancan!

  def new
    @users = User.simple_search(params[:search], current_user.school)
  end

  def create
    @user = User.find(params[:mentorship][:mentee_id])
    if current_user.school == @user.school && @user.role == 'student'
      current_user.request_mentor!(@user)
      UserMailer.mentor_email(@user, current_user).deliver
      current_user.sent_messages.create!(receiver_id: @user.id, subject: "I'd like to be your mentor!", message: "Hi #{@user.name}! I'd like to be your mentor. I'd be able to see your events and diary and send you messages. To confirm, click 'Mentoring' in the top right corner.")
      redirect_to mentoring_path
    else
      flash[:error] = "You can only mentor students at your own school."
      redirect_to root_path
    end
  end

  def index
    if current_user.role == "admin"
      @pending_requests = Mentorship.select {|m| m.confirmation_stage < 2 }
      @pending_mentees = Mentorship.select {|m| m.confirmation_stage % 2 == 0 }
      @mentorships = Mentorship.select {|m| m.confirmation_stage == 3 }
      session[:mentor_notif] = @pending_requests.count

    elsif current_user.role == "teacher"
      @pending_requests = Mentorship.select {|m| m.confirmation_stage < 3 && User.find(m.mentee_id).school==current_user.school }
      @pending_mentees = Mentorship.select {|m| m.confirmation_stage % 2 == 0 && User.find(m.mentee_id).school==current_user.school }
      @mentorships = Mentorship.select {|m| m.confirmation_stage == 3 && User.find(m.mentee_id).school==current_user.school }
      session[:mentor_notif] = @pending_requests.count

    else
      @pending_mentor_requests = current_user.mentorships.select {|m| m.confirmation_stage < 3 }
      @pending_mentee_requests = current_user.reverse_mentorships.select {|m| m.confirmation_stage < 3 }
      @mentors = current_user.reverse_mentorships.select {|m| m.confirmation_stage == 3 }
      @mentees = current_user.mentorships.select {|m| m.confirmation_stage == 3 }
      session[:mentor_notif] = @pending_mentor_requests.count + @pending_mentee_requests.count
    end

  end

  def show
    @mentorship = Mentorship.find(params[:id])
    if @mentorship.mentor_id == current_user.id && @mentorship.confirmation_stage == 3
        redirect_to User.find(@mentorship.mentee_id) # Mentorship is up and running; show profile.
    else
      redirect_to mentoring_path
    end
  end

  def update
    @mentorship = Mentorship.find(params[:id])
    @mentorship.approve_by(current_user)
    redirect_to mentoring_path

  end

  def destroy
    @mentorship = Mentorship.find(params[:id])
    @mentorship.mentor.stop_mentoring!(@mentorship.mentee)
    redirect_to mentoring_path
  end

  private

    def mentorship_params
      params.require(:mentorship).permit(:mentor_id, :mentee_id, :confirmation)
    end

end
