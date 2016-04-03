class AnnouncementsController < ApplicationController

  before_action :logged_in_user, except: [:index]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @announcements = Announcement.order('updated_at DESC')
    respond_to do |format|
      format.html
      format.json{render json: @announcements}
    end
  end

  def show
    @announcement = Announcement.find_by_id(params[:id])
  end

  def new
    @announcement = current_user.announcements.build
  end

  def create
    @announcement = current_user.announcements.build(announcement_params)
    if @announcement.save
      flash[:success] = 'ประกาศสำเร็จ'
      redirect_to announcement_path(@announcement)
    else
      render 'new'
    end
  end

  def edit
    @announcement = Announcement.find_by_id(params[:id])
  end

  def update
    @announcement = Announcement.find_by_id(params[:id])
    if @announcement.update_attributes(announcement_params)
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
