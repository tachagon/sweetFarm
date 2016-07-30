class DealsController < ApplicationController
  include DealsHelper
  include AnnouncementsHelper

  before_action :logged_in_user
  before_action :get_deal, only: [:show, :destroy, :update_status_decline_accepted, :update_status_paid, :update_status_shipped]
  before_action :get_announcement, only: [:create]
  before_action :can_show_deal, only: [:show]
  before_action :correct_user, only: [:edit, :update]
  before_action :owner_announcement, only: [:update_status_decline_accepted]
  before_action :admin_user, only: [:destroy]

  def index
    @deals = Deal.all

    respond_to do |format|
      format.html
      format.json{render json: @deals}
      format.xml{render xml: @deals}
    end
  end

  def admin_index
    @deals = Deal.recent.paginate(page: params[:page], per_page: 15)
  end

  def user_send_deals
    @user = User.find_by_id(params[:user_id])
    @deals = @user.deals.recent.recent.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html
      format.json{render json: @deals}
    end
  end

  def user_receive_deals
    @user = User.find_by_id(params[:user_id])
    @announcements = @user.announcements.recent

    @deals = @announcements.first.deals
    @announcements.each do |announcement|
      @deals += announcement.deals
    end

    @num_deals = @deals.count
    @deals = @deals.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.json{render json: @deals}
    end
  end

  def show
    @announcements = @deal.announcements
    @announcement = @announcements.first
    @announcements.each do |announcement|
      @announcement = announcement if announcement.user == @current_user
    end
    @messages = @deal.messages.recent
    respond_to do |format|
      format.html
      format.json{render json: @deal}
      format.xml{render xml: @deal}
    end
  end

  def create
    @deal = current_user.deals.build(deal_params)

    redirect_to announcement_path(@announcement) and return if @announcement.user == current_user || @announcement.expire < Time.now
    redirect_to announcement_path(@announcement) and return if params[:deal][:amount].to_f > @announcement.amount
    redirect_to announcement_path(@announcement) and return if accept_announcement?(@announcement)

    if @deal.save
      @deal.reload
      @attraction = Attraction.new(deal: @deal, announcement: @announcement)
      @attraction.save!
      flash[:success] = 'ยื่นข้อเสนอสำเร็จ'
      redirect_to announcement_path(@announcement)
    else
      flash[:danger] = 'ยื่นข้อเสนอไม่สำเร็จ'
      redirect_to announcement_path(@announcement)
    end
  end

  def destroy
    @deal.destroy
    flash[:success] = 'ลบข้อเสนอสำเร็จแล้ว'
    redirect_to deals_admin_path
  end

  def update_status_decline_accepted
    if @deal.expire >= Time.now && @deal.status == 'wait' && @deal.update_attributes(deal_status_params)
      @deal.reload
      if @deal.status == "accepted"
        flash[:success] = "รับข้อเสนอแล้ว"
        decline_others_deal(@deal.announcements, @deal.id)
      elsif @deal.status == "decline"
        flash[:success] = 'ปฏิเสธข้อเสนอแล้ว'
      end
      redirect_to deal_path(@deal)
    else
      flash[:danger] = 'ไม่สามารถดำเนินการได้'
      redirect_to deals_path
    end
  end

  def update_status_paid
    if @deal.status == "accepted" && is_purchaser?(@deal, @current_user) && @deal.update_attributes(deal_status_params)
      flash[:success] = "ชำระเงินสำเร็จแล้ว"
      redirect_to deal_path(@deal)
    else
      flash[:danger] = "ไม่สามารถดำเนินการได้"
      redirect_to deals_path
    end
  end

  def update_status_shipped
    if @deal.status == "paid" && is_purchaser?(@deal, @current_user) && @deal.update_attributes(deal_status_params)
      flash[:success] = "ได้รับสินค้าแล้ว"
      redirect_to deal_path(@deal)
    else
      flash[:danger] = "ไม่สามารถดำเนินการได้"
      redirect_to deals_path
    end
  end

  private

    def deal_params
      params.require(:deal).permit(:amount, :price)
    end

    def deal_status_params
      params.require(:deal).permit(:status)
    end

    def get_deal
      @deal = Deal.find_by_id(params[:id]) if params[:id]
      @deal = Deal.find_by_id(params[:deal_id]) if params[:deal_id]
      redirect_to deals_path if @deal.nil?
    end

    def get_announcement
      if params[:announcement_id]
        @announcement = Announcement.find_by_id(params[:announcement_id])
        redirect_to announcements_path and return if @announcement.nil?
      else
        redirect_to announcements_path
      end
    end

    def can_show_deal
      # if not owner of deal
      if @deal.user != current_user
        bool = false
        @deal.announcements.each do |announcement|
          bool = true if announcement.user == current_user
        end
        redirect_to deals_path if bool == false
      end
    end

    # Confirms the correct user.
    def correct_user
      @deal = Deal.find_by_id(params[:id]) if params[:id]
      @user = @deal.user
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms the owner annoument
    def owner_announcement
      @deal = Deal.find_by_id(params[:id]) if params[:id]
      @deal = Deal.find_by_id(params[:deal_id]) if params[:deal_id]

      owner = false
      @deal.announcements.each do |announcement|
        if announcement.user == current_user
          owner = true
          @announcement = announcement
        end
      end
      redirect_to root_path unless owner
    end

end
