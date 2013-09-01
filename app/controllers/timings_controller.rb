class TimingsController < ApplicationController

  def create
  end

  def destroy
  end

  private

    def timings_params
      params.require(:timing).permit!
    end

end
