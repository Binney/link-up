class DiaryEntriesController < ApplicationController
  before_action :signed_in_user
  skip_before_filter :verify_authenticity_token  

  def new
    @diary_entry = current_user.diary_entries.build
  end

  def create
    @diary_entry = current_user.diary_entries.create!(diary_entry_params)
    if @diary_entry.event_id>0
      @event = Event.find(@diary_entry.event_id)
      respond_to do |format|
        format.html { redirect_to @event }
        format.js
      end
    else
      redirect_to my_events_path
    end
  end

  def edit
    @diary_entry = current_user.diary_entries.find_by(id: params[:id])
  end

  def update
    @diary_entry = current_user.diary_entries.find_by(id: params[:id])
    @diary_entry.update(diary_entry_params)
    redirect_to my_events_path
  end

  def destroy
    @diary_entry = current_user.diary_entries.find_by(id: params[:id])
    if @diary_entry.event_id > 0
      redirect_to event_path(@diary_entry.event_id)
    else
      redirect_to my_events_path
    end
    @diary_entry.destroy
    #respond_to do |format|
    #  format.html { redirect_to it }
    #  format.js
    #end
  end

  private

    def diary_entry_params
      params.require(:diary_entry).permit(:event_id, :start_time, :name, :location)
    end
end
