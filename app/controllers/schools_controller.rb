class SchoolsController < ApplicationController
  before_filter :admin_account

  def index
  	@schools = School.all
  end

  def new
    @venue = Venue.new
    @school = @venue.schools.build
    render 'venues/new'
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    if @school.update_attributes(school_params)
      flash[:success] = "Edit successful."
      redirect_to @school.venue
    else
      render 'edit'
    end
  end

  private

    def school_params
      params.require(:school).permit(:venue_id, :teacher_code, :student_code)
    end

end
