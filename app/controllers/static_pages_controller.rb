class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: :my_events
  def home
    # Okay. Needs to process whether you're logged in and if so, how.
    # If you're not logged in, it just shows all venues.

    # If logged in with a student account, it plots all your favourites
    # in a different colour to other venues, and centres around your
    # saved Home address.
    @search = Event.search(params[:q])

    if signed_in?
      @events = current_user.events

      # Consolidate all your map markers into one json and plot:
      @evs = @events.to_gmaps4rails do |event, marker|
        marker.infowindow render_to_string(:partial => "/events/infowindow", :locals => { :event => event })
        marker.title "#{event.name}"
        str = event.tags[0] ? event.tags[0].name : "Other"
        marker.picture({:picture => view_context.image_path("tag_icons/small/#{str}.png"), :width => 35, :height => 48})
      end
      @house = current_user.to_gmaps4rails do |house, marker|
        marker.picture({:picture => view_context.image_path("l.jpg"), :width => 35, :height => 48})
      end
      @json = (JSON.parse(@evs) + JSON.parse(@house)).to_json
      @diary_entries = (current_user.diary_entries+current_user.favourites).shuffle
      @tags = Tag.all.shuffle
    else
      @venues = Venue.all :conditions => ["id != ?", 0] # Don't display venue(0) since it's a placeholder for events without a venue.
      @json = @venues.to_gmaps4rails do |venue, marker|
        marker.infowindow render_to_string(:partial => "/venues/infowindow", :locals => { :venue => venue})
        marker.title "#{venue.name}"
        marker.picture({:picture => view_context.image_path("tag_icons/small/Other.png"), :width => 35, :height => 48})
      end
      @todays_events = Timing.where(:day == Date.today.wday)[0..6]
      @tags = Tag.all.shuffle
    end
  end

  def my_events
    @title = "Your events"
    @favourites = current_user.events
    @favs = current_user.favourites
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @calendar_entries = current_user.diary_entries.order('start_time ASC')
    arr = []
    @favs.each do |f|
      (((params[:month] ? Date.parse(params[:month]) : Date.today).change(day: 1)..(params[:month] ? Date.parse(params[:month]) : Date.today).advance(months: 1).change(day: 1)).select {|d| d.wday == f.start_time.wday}).each do |date|
        @calendar_entries.push CalendarEntry.new(DateTime.new(date.year, date.month, date.day, f.start_time.hour, f.start_time.min), f.event_id) unless f.start_time.beginning_of_day>date
      end
    end

    @upcoming_events = current_user.diary_entries.select { |event| event.start_time > Date.today } + current_user.favourites
    @past_events = current_user.diary_entries.select { |event| event.start_time < Date.today } + current_user.favourites
  end

  def help
  end

  def about
  end

  def contact
  end

end
