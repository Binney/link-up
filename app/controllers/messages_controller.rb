class MessagesController < ApplicationController
  before_action :correct_or_admin, only: [:show, :inbox] # Is that really it?!

  def new
    if admin?
      @users = User.all
    elsif current_user.role == "teacher"
      @users = (User.all.select {|m| m.school == current_user.school && m.id != current_user.id})+[User.find(1)]
    else
      @users = (current_user.mentorships.map {|m| m.mentee })+(current_user.reverse_mentorships.map {|m| m.mentor} )+[User.find(1)]
    end
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @message.unread = true
    if @message.save
      flash[:success] = "Message sent."
      redirect_to inbox_path
    else
      render 'new'
    end
  end

  def show
    @message = Message.find(params[:id])
    @message.unread = false
    @message.save!
  end

  def inbox
    @received_messages = Message.where(:receiver_id => current_user.id).paginate(:order => "created_at DESC", :page => params[:recd_page], :per_page => 5)
    @sent_messages = Message.where(:sender_id => current_user.id).order("created_at DESC").paginate(:page => params[:sent_page], :per_page => 5)
    @message = params[:id] ? Message.find(params[:id]) : @received_messages[0]

    if @message # Unless it's displaying "no messages in inbox", the shown message is marked as read.
      @message.read!
    end
  end

  def destroy
    @message.destroy
    redirect_to inbox_path
  end

  private

    def message_params
      params.require(:message).permit(:message, :receiver_id, :subject, :sender_id)
    end

    def correct_or_admin
      @message = params[:id] ? Message.find(params[:id]) : nil
      redirect_to(root_path) unless signed_in? && (admin? || @message.nil? || (@message.sender_id == current_user.id) || (@message.receiver_id == current_user.id))
    end

end
