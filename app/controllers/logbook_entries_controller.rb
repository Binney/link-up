class LogbookEntriesController < ApplicationController
  before_action :signed_in_user, only: [:create, :new, :index, :edit, :overview]
  before_action :admin_user, only: :overview

  def new
  	@logbook_entry = LogbookEntry.new
  	@events = Event.all # TODO with certain constraints!!
  end

  def create
  	@logbook_entry = current_user.logbook_entries.build(logbook_entry_params)
  	if @logbook_entry.save
  		flash[:success] = "Saved to logbook!"
  		redirect_to @logbook_entry
  	else
  		render @logbook_entry
  	end
  end

  def edit
  	@logbook_entry = LogbookEntry.find(params[:id])
  end

  def show
    @logbook_entry = LogbookEntry.find(params[:id])
  end

  def index
    @logbook_entries = current_user.logbook_entries#.paginate(params[:page])
  end

  def overview
  end

  private

    def logbook_entry_params
      params.require(:logbook_entry).permit(:mentor_meeting, :event_id, :content, :date)
    end

    def admin_user
      redirect_to(root_path) unless admin?
    end

end
