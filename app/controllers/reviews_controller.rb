class ReviewsController < ApplicationController
  before_action :approval_needed, only: :approve

  def new
    @review = current_user.reviews.build
    if me_admin?
      @events = Event.all
    else
      @events = Event.all.select {|event| !(event.venue.is_school?) || event.venue.school.name==current_user.school}
    end
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "Review submitted for review. It'll appear online soon!"
      redirect_to Event.find(@review.event_id)
    else
      render Event.find(@review.event_id)
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    @review.update_attributes(review_params)
    redirect_to approve_reviews_path
  end

  def index
    @reviews = Review.all.where(approved: true)
  end

  def show
    @review = Review.find(params[:id])
    if @review.event_id > 0
      @subject = Event.find(@review.event_id)
    elsif @review.venue_id > 0
      @subject = Venue.find(@review.venue_id)
    else
      @subject = Venue.first
    end
  end

  def user_index
    # Find all reviews by user id and index them for editing/deleting/visiting said event.
    params[:user_id] ||= current_user.id
    @reviews = User.find(params[:user_id]).reviews
  end

  def approve
    if current_user.role=="teacher"
      @reviews = Review.where(approved: false).select {|r| User.find(r.user_id).school_id==current_user.school_id }
    elsif current_user.role=="organiser"
      @reviews = Review.where(approved: false).select {|r| Event.find(r.event_id).user_id==current_user.id }
      # TODO potentially in future also venues?
    else
      @reviews = Review.where(approved: false)
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.event_id > 0
      @subject = Event.find(@review.event_id)
    elsif @review.venue_id > 0
      @subject = Venue.find(@review.venue_id)
    else
      @subject = approve_reviews_path
    end
    @review.destroy
    redirect_to @subject
  end

  private

    def approval_needed
      redirect_to reviews_user_index_path(user_id: user_id) if current_user.role=="student"
    end

    def review_params
      params.require(:review).permit(:content, :event_id, :stars, :title, :approved)
    end

end
