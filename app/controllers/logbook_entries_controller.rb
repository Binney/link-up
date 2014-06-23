class LogbookEntriesController < ApplicationController
  before_action :signed_in_user, only: [:create, :new, :index, :edit, :overview, :destroy]
  before_action :teacher_account, only: :overview
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
    if me_admin?
      # Display all users, sorted by number of mentor meetings they've had (ascending)
      @users = User.simple_search(params[:search], nil).order('mentor_meetings ASC')#.paginate(page: params[:page], per_page: 1)
    elsif me_teacher?
      # Display all users from your school
      @users = User.simple_search(params[:search], current_user.school).order('mentor_meetings ASC')#.paginate(page: params[:page], per_page: 1)
    else
      # Display your mentee's logbook records.
      @users = current_user.mentees.simple_search(params[:search], current_user.school).order('mentor_meetings ASC')#.paginate(params[:page])
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

end
