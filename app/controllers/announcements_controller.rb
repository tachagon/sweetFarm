class AnnouncementsController < ApplicationController

  before_action :logged_in_user, except: [:index]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @announcements = Announcement.show.not_expired.recent
    # @announcements = Announcement.other_user(current_user.id).recent
    @announcements = Announcement.recent.user(params[:user_id]) if params[:user_id]
    @announcements = Announcement.recent.user(params[:user_id]).role(params[:role]) if params[:user_id] && params[:role]
    respond_to do |format|
      format.html
      format.json{render json: @announcements}
      format.xml{render xml: @announcements}
    end
  end

  def show
    @announcement = Announcement.find_by_id(params[:id])
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
    @announcement = Announcement.find_by_id(params[:id])
  end

  def update
    @announcement = Announcement.find_by_id(params[:id])
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
    redirect_to admin_all_announcements_path
  end

  private

    def announcement_params
      params.require(:announcement).permit(:amount, :price, :role, :district_id)
    end

    # Confirms the correct user.
    def correct_user
      @announcement = Announcement.find_by_id(params[:id])
      @user = @announcement.user
      redirect_to(root_url) unless current_user?(@user)
    end

end
