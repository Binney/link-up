class TimingsController < ApplicationController

  def create
  end

  def destroy
  end

  private

    def timings_params
      params.require(:timing).permit(:start_time, :end_time, :day, :event_id)
    end

end
