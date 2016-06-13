class UsersController < ApplicationController
  before_action :not_logged_in_user, only: [:new, :create]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :update_role]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :update_role]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])

    @announcements_sale = @user.announcements.role("sale").recent
    @announcements_purchase = @user.announcements.role("purchase").recent
    @reviews = @user.passive_reviews.recent

    unless @user
      flash[:danger] = t('controllers.users.show.danger')
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t('controllers.users.create.success')
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params.except!(:email))
      flash[:success] = t('controllers.users.update.success')
      redirect_to user_path(locale: I18n.locale)
    else
      render 'edit'
    end
  end

  def update_role
    @user = User.find_by_id(params[:user_id])
    if @user.update_attributes(user_role_params)
      flash[:success] = 'อัปเดทสำเร็จ'
      redirect_to users_path(locale: I18n.locale)
    else
      render 'index'
    end
  end

  def destroy

  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
    end

    def user_role_params
      params.permit(:role)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find_by_id(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
