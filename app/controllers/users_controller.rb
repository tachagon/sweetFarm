class UsersController < ApplicationController
  before_action :not_logged_in_user, only: [:new, :create]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy]

  def index

  end

  def show
    @user = User.find_by_id(params[:id])
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
    if @user.update_attributes(user_params)
      flash[:success] = t('controllers.users.update.success')
      redirect_to user_path(locale: I18n.locale)
    else
      render 'edit'
    end
  end

  def destroy

  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t('please_login')
        redirect_to login_url
      end
    end

    def not_logged_in_user
      if logged_in?
        redirect_to root_path
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find_by_id(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
