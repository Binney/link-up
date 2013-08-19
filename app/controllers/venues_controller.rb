class VenuesController < ApplicationController
  # Anyone can see index and profile for venues, even when not logged in. And Favourite is under User.
  before_action :organiser_account,  only: [:new, :create, :edit, :update, :destroy] # Only a certain kind of account can create venues.
  before_action :correct_user,   only: [:edit, :update, :destroy] # Only correct user or admin can edit it

# btw gonna need same checks as UserController for whether or not another user is trying to edit an event from html requests

  def index
    @venues = Venue.paginate(page: params[:page])
    @json = Venue.all.to_gmaps4rails do |venue, marker|
    marker.infowindow render_to_string(:partial => "/venues/infowindow", :locals => { :venue => venue})
    marker.title "#{venue.name}"
    marker.picture({:picture => "/assets/tag_icons/assassins.png", :width => 32, :height => 32})
    end
  end

  def index_my
    @venues = Venue.find_by(user_id: current_user.id).all
  end

  def show
    @venue = Venue.find(params[:id])
    @events = @venue.events.paginate(page: params[:page])
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    if correct_or_admin
      @event = @venue.events.build
    end
    @json = @venue.to_gmaps4rails do |venue, marker|
    marker.infowindow render_to_string(:partial => "/venues/infowindow", :locals => { :venue => venue})
    marker.title "#{venue.name}"
    marker.picture({:picture => "/assets/tag_icons/assassins.png", :width => 32, :height => 32})
    end
    # Here on Microposts there's a link to create a new post, but with Events instead need to
    # have event only created when you click the only-visible-when-correct-user link to view subform.
  end

  def new
    @venue = Venue.new
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
      params.require(:venue).permit(:name, :description, :street_address, :postcode) # Include all extra parameters here
    end

    def correct_user
      redirect_to(root_path) unless correct_or_admin
    end

    def correct_or_admin
      @venue = Venue.find(params[:id])
      signed_in? && ((@venue.user_id == current_user.id) || current_user.admin?)
    end

end
