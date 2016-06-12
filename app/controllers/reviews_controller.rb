class ReviewsController < ApplicationController

  before_action :logged_in_user

  def create
    @user = User.find_by_id(params[:reviewed_id])
    @deal = Deal.find_by_id(params[:deal_id])

    @review = Review.new(
      reviewer: current_user,
      reviewed: @user,
      deal: @deal,
      rating: params[:rating],
      comment: params[:comment]
    )

    if @deal.reviews.count < 2
      if @review.save
        @deal.reload
        deal_completed(@deal) if @deal.reviews.count == 2
        redirect_to deal_path(@deal)
      else
        flash[:danger] = "รีวิวไม่สำเร็จ กรุณาให้ดาวและเขียนคำแนะนำ"
        redirect_to deal_path(@deal)
      end
    end

  end

  private

    def deal_completed(deal)
      deal.status = "completed"
      deal.save!
    end

end
