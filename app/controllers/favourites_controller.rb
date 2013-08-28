class FavouritesController < ApplicationController
  before_action :signed_in_user

  def create
    @event = Event.find(params[:favourite][:event_id])
    current_user.favourite!(@event, params[:favourite][:day])
    respond_to do |format|
      format.html { redirect_to @event }
      format.js
    end
  end

  def destroy
    @fav = Favourite.find(params[:id])
    @event = @fav.event
    @fav.destroy
#    current_user.unfavourite!(@event.id, params[:day])
    redirect_to @event
  end
end
