class MessagesController < ApplicationController
  before_action :correct_or_admin, only: [:show, :destroy, :inbox] # Is that really it?!

  def new
    @message = current_user.messages.build
  end

  def create
    @message = current_user.messages.build(message_params)
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
  end

  def inbox
    @received_messages = Message.where(:receiver_id => current_user.id).paginate(:order => "created_at DESC", :page => params[:recd_page], :per_page => 5)
    @sent_messages = Message.where(:sender_id => current_user.id).order("created_at DESC").paginate(:page => params[:sent_page], :per_page => 5)
    @message = params[:id] ? Message.find(params[:id]) : @received_messages[0]
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
      redirect_to(root_path) unless signed_in? && (current_user.admin? || @message.nil? || (@message.sender_id == current_user.id) || (@message.receiver_id == current_user.id))
    end

end
