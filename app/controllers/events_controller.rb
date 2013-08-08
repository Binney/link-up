class EventsController < ApplicationController

  before_action :organiser_account, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_or_admin,  only: [:edit, :update, :destroy]

  def index
    if params[:venue_id]==nil
      # Indexing from search so show all events
      @events = Event.paginate(page: params[:page])
    else # Indexing via venue so only show that venue's events
      @events = Venue.find(params[:venue_id]).events.paginate(page: params[:page])
      @number = Venue.find(params[:venue_id]).id
    end
  end

  def show
    @event = Event.find(params[:id])
    @tags = @event.tags.paginate(page: params[:page])
    @json = @event.venue.to_gmaps4rails do |venue, marker|
    marker.infowindow render_to_string(:partial => "/events/infowindow", :locals => { :event => @event})
    marker.title "#{venue.name}"
    marker.picture({:picture => "/assets/tag_icons/assassins.png", :width => 32, :height => 32})
    end
  end

  def create
    puts "#####################################"+params[:event][:venue_id].to_s
    @event = Venue.find(params[:event][:venue_id]).events.build(params[event_params])
    if @event.save
      flash[:success] = "Event created!"
      redirect_to @event
    else
      render 'shared/error_messages'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = "Event details updated"
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    @event.destroy
    redirect_to Venue.find(@event.venue_id)
  end

  def tagged
    @title = "Tags"
    @event = Event.find(params[:id])
    @tags = @event.tags.paginate(page: params[:page])
    render 'show_tags'
  end

  private

    def event_params
      params.require(:event).permit(:name, :description, :start_time, :end_time, :tags, :venue_id)
    end

    def correct_or_admin
      current_venue = Venue.find(params[:venue_id])
      redirect_to(root_path) unless signed_in? && ((current_venue.user_id == current_user.id) || current_user.admin?)
    end

end