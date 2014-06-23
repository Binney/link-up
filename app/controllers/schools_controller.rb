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

  #def new
    #@venue = Venue.new
  	#@school = @venue.schools.build
  #end

  #def create
  	#@venue = Venue.find(params[:venue_id])
    #@school = @venue.schools.build(school_params)
  	#if @school.save
  	#  flash[:success] = "School successfully added to the Link Up scheme!"
  	#  redirect_to @school
  	#else
  	#  render 'new'
  	#end
  #end

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
