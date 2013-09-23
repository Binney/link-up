class ReviewsController < ApplicationController
  def new
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "Review posted!"
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
    redirect_to user_index_reviews_path
  end

  def user_index
    # Find all reviews by user id and index them for editing/deleting/visiting said event.
    params[:user_id] ||= current_user.id
    @reviews = User.find(params[:user_id]).reviews
  end

  def destroy
    @review = Review.find(params[:id])
    user_id = @review.user_id
    @review.destroy
    redirect_to reviews_user_index_path(user_id: user_id)
  end

  private

    def review_params
      params.require(:review).permit(:content, :event_id, :stars)
    end

end
