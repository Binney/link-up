class VenuesController < ApplicationController
  # Anyone can see index and profile for venues, even when not logged in.
  before_action :non_student_account,  only: [:new, :create] # Only a certain kind of account can create venues.
  before_action :correct_user,   only: [:edit, :update, :destroy] # Only correct user or admin can edit it
  before_action :correct_school, only: :show

  def index
    @venues = Venue.all.select { |v| (!(v.is_school) || v.id==current_user.school.venue_id) }#.paginate(page: params[:page])
    @json = Venue.all.to_gmaps4rails do |venue, marker|
    marker.infowindow render_to_string(:partial => "/venues/infowindow", :locals => { :venue => venue})
    marker.title "#{venue.name}"
    marker.picture({:picture => view_context.image_path("tag_icons/small/Other.png"), :width => 35, :height => 48})
    end
  end

  def show
    @venue = Venue.find(params[:id])
    @events = @venue.events.paginate(page: params[:page])
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    if me_admin? || me_organiser?(@venue)
      @event = Event.new(venue_id: @venue.id)
      @timing = @event.timings.build
    end
    @json = @venue.to_gmaps4rails do |venue, marker|
    marker.infowindow render_to_string(:partial => "/venues/infowindow", :locals => { :venue => venue})
    marker.title "#{venue.name}"
    marker.picture({:picture => view_context.image_path("tag_icons/small/Other.png"), :width => 35, :height => 48})
    end
  end

  def new
    @venue = Venue.new
  end

  def new_school
    @venue = Venue.new
    @venue.schools.build
    render 'new'
  end
 
  def create
    @venue = Venue.new(venue_params)
    @venue.user_id = current_user.id
    if @venue.save
      flash[:success] = "Venue created!"
      redirect_to @venue
    else
      render 'new'
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(venue_params)
      flash[:success] = "Venue details updated"
      redirect_to @venue
    else
      render 'edit'
    end
  end

  def destroy
    Venue.find(params[:id]).destroy
    flash[:success] = "Venue destroyed."
    redirect_to venues_url
  end

  private

    def venue_params
      params.require(:venue).permit!#(:name, :description, :street_address, :postcode, :is_school, :contact) #TODO ew
    end

    def correct_school
      current_venue = Venue.find(params[:id])
      if current_venue.is_school
        redirect_to(root_path) unless signed_in? && (current_venue.id==current_user.school.venue_id || me_admin?)
      end
    end

    def correct_user
      current_venue = Venue.find(params[:id])
      redirect_to(root_path) unless (me_admin? || me_organiser?(current_venue))
    end
end
