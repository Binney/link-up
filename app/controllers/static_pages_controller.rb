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
      session[:message_notif] = current_user.messages.where(unread: true).count
      @events = current_user.events

      # Consolidate all your map markers into one json and plot:
      @evs = @events.to_gmaps4rails do |event, marker|
        marker.infowindow render_to_string(:partial => "/events/infowindow", :locals => { :event => event })
        marker.title "#{event.name}"
        str = event.tags[0] ? event.tags[0].name : "Other"
        marker.picture({:picture => view_context.image_path("tag_icons/small/#{str}.png"), :width => 35, :height => 48})
      end
      @house = current_user.to_gmaps4rails do |house, marker|
        marker.infowindow render_to_string(:partial => "/users/infowindow", :locals => { :user => current_user })
        marker.picture({:picture => view_context.image_path("l.jpg"), :width => 35, :height => 48})
      end
      @json = (JSON.parse(@evs) + JSON.parse(@house)).to_json
      @diary_entries = ((current_user.diary_entries.select { |d| d.start_time > Date.today }) +current_user.favourites)[0,5]
      @tags = Tag.all.shuffle
    else
      @todays_events = (Timing.select { |t| t.day == Date.today.wday}).shuffle[0..6]
      #@venues = Venue.all :conditions => ["id != ?", 0] # Don't display venue(0) since it's a placeholder for events without a venue.
      @json = (@todays_events.map {|t| t.event}).to_gmaps4rails do |event, marker|
        marker.infowindow render_to_string(:partial => "/events/infowindow", :locals => { :event => event })
        marker.title "#{event.name}"
        image = event.tags.count<1 ? "Other" : event.tags[0].name
        marker.picture({:picture => view_context.image_path("tag_icons/small/#{image}.png"), :width => 35, :height => 48})
      end
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
