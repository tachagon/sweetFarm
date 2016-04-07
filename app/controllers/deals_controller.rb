class DealsController < ApplicationController

  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @deals = Deal.all

    respond_to do |format|
      format.html
      format.json{render json: @deals}
      format.xml{render xml: @deals}
    end
  end

  def show
    @deal = Deal.find_by_id(params[:id])

    respond_to do |format|
      format.html
      format.json{render json: @deal}
      format.xml{render xml: @deal}
    end
  end

  def create

  end

  def destroy
    Deal.find_by_id(params[:id]).destroy
    flash[:success] = 'ลบข้อเสนอสำเร็จแล้ว'
    redirect_to admin_all_deals_path
  end

  private

    def deal_params
      params.require.permit(:amount, :price)
    end

    # Confirms the correct user.
    def correct_user
      @deal = Deal.find_by_id(params[:id])
      @user = @deal.user
      redirect_to(root_url) unless current_user?(@user)
    end

end
