class AnnouncementsController < ApplicationController

  before_action :logged_in_user, except: [:index]
  before_action :set_announcement_obj, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :correct_user_id, only: [:user_announcements, :user_announcements_role]
  before_action :admin_user, only: [:destroy, :purchase_index, :sale_index]

  def index
    @announcements = Announcement.show.not_expired.recent
    # @announcements = Announcement.other_user(current_user.id).recent
    @announcements = Announcement.recent.user(params[:user_id]) if params[:user_id]
    @announcements = Announcement.recent.user(params[:user_id]).role(params[:role]) if params[:user_id] && params[:role]
    @role = params[:role]
    respond_to do |format|
      format.html
      format.json{render json: @announcements}
      format.xml{render xml: @announcements}
    end
  end

  def purchase_index
    @announcements = Announcement.recent.role("purchase").paginate(page: params[:page], per_page: 15)
  end

  def sale_index
    @announcements = Announcement.recent.role("sale").paginate(page: params[:page], per_page: 15)
  end

  def user_announcements
    @announcements = Announcement.user(params[:user_id]).recent
    respond_to do |format|
      format.html
      format.json{render json: @announcements}
      format.xml{render xml: @announcements}
    end
  end

  def user_announcements_role
    @announcements = Announcement.user(params[:user_id]).role(params[:announcement_role]).recent.paginate(page: params[:page], per_page: 10)
    @role = params[:announcement_role]
    respond_to do |format|
      format.html
      format.json{render json: @announcements}
      format.xml{render xml: @announcements}
    end
  end

  def show
    @deal = current_user.deals.build
    @deals = @announcement.deals.best_price.best_amount.recent
    respond_to do |format|
      format.html
      format.json{render json: @announcement}
      format.xml{render xml: @announcement}
    end
  end

  def new
    if %w[sale purchase].include?(params[:role])
      @announcement = current_user.announcements.build
      @role = params[:role]
    else
      redirect_to announcements_path
    end
  end

  def create
    @announcement = current_user.announcements.build(announcement_params)
    if @announcement.save
      flash[:success] = 'ประกาศสำเร็จ'
      redirect_to announcement_path(@announcement)
    else
      @role = params[:announcement][:role]
      render 'new'
    end
  end

  def edit
    @role = @announcement.role
  end

  def update
    if @announcement.update_attributes(announcement_params)
      @announcement.expire = Time.now + 7.days
      @announcement.save!
      flash[:success] = 'แก้ไขข้อมูลสำเร็จแล้ว'
      redirect_to announcement_path(@announcement)
    else
      render 'edit'
    end
  end

  def destroy
    Announcement.find_by_id(params[:id]).destroy
    flash[:success] = 'ลบประกาศแล้ว'
    redirect_to :back
  end

  private

    def announcement_params
      params.require(:announcement).permit(:amount, :price, :role, :district_id, :cane_picture)
    end

    def set_announcement_obj
      @announcement = Announcement.find_by_id(params[:id])
      redirect_to announcements_path if @announcement.nil?
    end

    # Confirms the correct user.
    def correct_user
      @announcement = Announcement.find_by_id(params[:id])
      @user = @announcement.user
      redirect_to(root_url) unless current_user?(@user)
    end

    def correct_user_id
      @user = User.find_by_id(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
