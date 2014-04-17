class LogbookEntriesController < ApplicationController
  before_action :signed_in_user, only: [:create, :new, :index, :edit, :overview, :destroy]
  before_action :admin_or_teacher_user, only: :overview
  before_action :correct_user, only: [:index, :destroy]

  def new
  	@logbook_entry = LogbookEntry.new
  	@events = Event.all # TODO with certain constraints!!
  end

  def create
  	@logbook_entry = current_user.logbook_entries.build(logbook_entry_params)
  	if @logbook_entry.save
  		flash[:success] = "Saved to logbook!"
      current_user.count_mentor_meetings
  		redirect_to @logbook_entry
  	else
  		render 'new'
  	end
  end

  def edit
  	@logbook_entry = LogbookEntry.find(params[:id])
  end

  def update
    @logbook_entry = LogbookEntry.find(parms[:id])
    if @logbook_entry.update(logbook_entry_params)
      flash[:success] = "Logbook entry updated."
      current_user.count_mentor_meetings
      redirect_to @logbook_entry
    else
      render 'edit'
    end
  end

  def show
    @logbook_entry = LogbookEntry.find(params[:id])
  end

  def index
    @logbook_entries = @user.logbook_entries#.paginate(params[:page])
  end

  def overview
    if admin?
      # Display all users, sorted by number of mentor meetings they've had (ascending)
      @users = User.all.order('mentor_meetings ASC')#.paginate(page: params[:page], per_page: 1)
    elsif teacher?
      # Display all users from your school
      @users = User.simple_search(params[:name_search], current_user.school).order('mentor_meetings ASC')#.paginate(page: params[:page], per_page: 1)
    else
      # Display your mentee's logbook records.
      @users = current_user.mentees.order('mentor_meetings ASC')#.paginate(params[:page])
    end
  end

  def destroy
    @logbook_entry = LogbookEntry.find(params[:id])
    user_id = @logbook_entry.user_id
    if @logbook_entry.destroy
      flash[:success] = "Logbook entry destroyed."
      redirect_to logbook_path
    end
  end

  private

    def logbook_entry_params
      params.require(:logbook_entry).permit(:mentor_meeting, :event_id, :content, :date)
    end

    def admin_or_teacher_user
      redirect_to(root_path) unless (admin? || teacher?)
    end

    def correct_user
      user_id = params[:user_id] || current_user.id
      @user = User.find(user_id)
      redirect_to(root_path) unless (current_user?(@user) || admin? || current_user.teaches?(@user))
    end

end
